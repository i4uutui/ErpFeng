import { addFont } from "@/utils/font/sourcehan-normal";
import { jsPDF } from "jspdf";
import { autoTable } from "jspdf-autotable";

// 配置项：每行显示的图片数量
const IMAGES_PER_ROW = 8;
// 配置项：每个图片的高度
const IMAGE_HEIGHT = 20;
// 配置项：每个图片的高度
const IMAGE_WIDTH = 20;
// 配置项：图片之间的垂直间距
const IMAGE_VERTICAL_SPACING = 0;
// 配置项：图片之间的水平间距
const IMAGE_HORIZONTAL_SPACING = 5;
// 配置项：图片下方文字的高度
const TEXT_HEIGHT = 6; 
// 配置项：图片与下方文字的间距
const IMAGE_TEXT_SPACING = 2;

const setPrint = (head, body) => {
	const pdf = new jsPDF({
		orientation: "landscape", // 横向
		unit: "mm",
		format: "a4",
	});
	addFont(pdf);

	const columns = [
		{ title: "部件编码", dataKey: "part_code" },
		{ title: "部件名称", dataKey: "part_name" },
		{ title: "生产数量", dataKey: "out_number" },
		{ title: "派工二维码", dataKey: "images" },
	];

	const columnStyles = {
		part_code: { minCellWidth: 20 },
		part_name: { minCellWidth: 20 },
		out_number: { minCellWidth: 15 },
		images: { minCellWidth: 200 }, // 可以适当加宽图片列以容纳更多图片
	};

	Promise.all(body.flatMap(item => item.images.map(imgObj => loadImageToBase64(imgObj.url))))
		.then(() => {
			autoTable(pdf, {
				theme: "grid",
				margin: { top: 38, left: 10, right: 10 },
				rowPageBreak: "avoid",
				columns: columns,
				body,
				columnStyles: columnStyles,
				headStyles: {
					//头部样式
					font: "sourcehan",
					fontStyle: "normal",
					halign: "center",
					fillColor: "#E3E3E3",
					textColor: "#333",
					minCellHeight: 5,
				},
				head: [["部件编码", "部件名称", "生产数量", "派工二维码"]],
				styles: {
					cellPadding: 3,
					fontSize: 12,
					font: "sourcehan",
					fontStyle: "normal",
					halign: "center",
					// 垂直居中，对于多行图片单元格，这个设置依然有效
					valign: "middle",
				},
				willDrawPage: function () {
					pdf.setFontSize(36);
					var pageWidth = pdf.internal.pageSize.getWidth();
					const buyText = "派工单";
					var textWidth = pdf.getTextWidth(buyText, { fontSize: 36 });
					const x = (pageWidth - textWidth) / 2;
					pdf.text(buyText, x, 22);

					// 绘制五个指定文字，字号14，两端分散对齐
					const texts = head;
					pdf.setFontSize(12);

					// 计算每个文字的宽度和间距
					const totalTextWidth = texts.reduce((sum, text) => sum + pdf.getTextWidth(text, { fontSize: 12 }), 0);
					const spacing = (pageWidth - 20 - totalTextWidth) / (texts.length - 1); // 减去左右边距20

					let currentX = 10; // 左边距
					const y = 35; // 位于“派工单”下方，表格上方

					texts.forEach(text => {
						pdf.text(text, currentX, y);
						currentX += pdf.getTextWidth(text, { fontSize: 12 }) + spacing;
					});
				},
				didParseCell: function (data) {
					const cell = data.cell;
					const value = cell.raw;
					if (data.column.dataKey === "images" && data.row.section === "body") {
						cell.text = [];
						if (Array.isArray(value) && value.length > 0) {
							// 将所有需要绘制的图片Base64数组附加到cell上
							cell.imagesToDraw = value.map(item => ({
								base64: getCachedImageBase64(item.url),
								title: item.title, // 存储标题
							}));
						}
						const images = data.cell.raw || []; // 增加空数组判断，防止出错
            const numRows = Math.ceil(images.length / IMAGES_PER_ROW);

            const singleRowHeight = IMAGE_HEIGHT + IMAGE_TEXT_SPACING + TEXT_HEIGHT;

            const requiredHeight = numRows > 0 ? (singleRowHeight + IMAGE_VERTICAL_SPACING) * numRows - IMAGE_VERTICAL_SPACING : 0;

            data.cell.styles.minCellHeight = requiredHeight;
					}
				},
				didDrawCell: function (data) {
					const cell = data.cell;
					// 仅处理图片列且有图片需要绘制
					if (data.column.dataKey === "images" && cell.imagesToDraw && cell.imagesToDraw.length > 0) {
						const images = cell.imagesToDraw;
						const totalImages = images.length;

						const numRows = Math.ceil(totalImages / IMAGES_PER_ROW);

						// Y坐标起始点
						let currentY = cell.y + 2;

						for (let i = 0; i < numRows; i++) {
							for (let j = 0; j < IMAGES_PER_ROW; j++) {
								const imageIndex = i * IMAGES_PER_ROW + j;
								if (imageIndex >= totalImages) break;

								const imageData = images[imageIndex];
								if (imageData.base64) {
									// --- 绘制图片 ---
									const x = cell.x + 2 + j * (IMAGE_WIDTH + IMAGE_HORIZONTAL_SPACING);
									pdf.addImage(imageData.base64, "PNG", x, currentY, IMAGE_WIDTH, IMAGE_HEIGHT);

									// --- 绘制文字 ---
									// 1. 设置文字样式（字体、大小、对齐方式）
									pdf.setFontSize(8); // 设置一个较小的字体
									pdf.setTextColor(0); // 设置文字颜色为黑色

									// 2. 计算文字的X坐标，使其在图片下方居中
									const text = imageData.title || ""; // 获取标题，默认空字符串
									const textWidth = pdf.getTextWidth(text);
									const textX = x + (IMAGE_WIDTH - textWidth) / 2;

									// 3. 计算文字的Y坐标，使其在图片下方，并留出间距
									const textY = currentY + IMAGE_HEIGHT + IMAGE_TEXT_SPACING + 1;

									// 4. 绘制文字
									pdf.text(text, textX, textY);
								}
							}
							// --- 更新Y坐标 ---
							// 移动的距离是“图片+文字+间距”的总高度
							currentY += IMAGE_HEIGHT + IMAGE_TEXT_SPACING + TEXT_HEIGHT + IMAGE_VERTICAL_SPACING;
						}
					}
				},
			});
			// pdf.save("表格含图片（自动换行）.pdf");
			const pdfBlob = pdf.output('blob'); // 生成 Blob 流
			const pdfUrl = URL.createObjectURL(pdfBlob);
			
			const iframe = document.createElement('iframe');
			iframe.style.display = 'none';
			document.body.appendChild(iframe);
			iframe.src = pdfUrl;
			setTimeout(() => {
				iframe.contentWindow.print();
			}, 100);
		})
		.catch(error => {
			console.error("图片加载失败：", error);
		});
};

// 图片缓存和加载函数保持不变
const imageCache = new Map();
function loadImageToBase64(url) {
	if (imageCache.has(url)) {
		return Promise.resolve(imageCache.get(url));
	}
	return new Promise((resolve, reject) => {
		const img = new Image();
		img.crossOrigin = "Anonymous";
		img.onload = function () {
			const canvas = document.createElement("canvas");
			canvas.width = img.width;
			canvas.height = img.height;
			const ctx = canvas.getContext("2d");
			ctx.drawImage(img, 0, 0);
			const base64 = canvas.toDataURL("image/png");
			imageCache.set(url, base64);
			resolve(base64);
		};
		img.onerror = () => reject(new Error(`图片加载失败：${url}`));
		img.src = url;
	});
}
function getCachedImageBase64(url) {
	return imageCache.get(url) || null;
}

export { setPrint };
