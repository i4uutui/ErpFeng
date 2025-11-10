import pdfMake from "pdfmake/build/pdfmake";
import pdfFonts from "pdfmake/build/vfs_fonts";
import htmlToPdfmake from "html-to-pdfmake";

// 初始化 pdfmake 字体（必须）
pdfMake.vfs = pdfFonts.default;
const exportPDF = async tableDom => {
	if (!tableDom) {
		alert("未找到表格DOM，请检查id是否正确");
		return;
	}
	// 3. 关键：将 Vue 渲染的 HTML 表格转换为 pdfmake 配置
	const html = htmlToPdfmake(tableDom, {
    preserveStyles: true, // 保留 JSX 中的内联样式和 class 样式
    tableLayout: 'fixed', // 固定表格布局，避免列宽错乱
    tableAutoSize: true,
    imagesByReference:true
  });
	// 4. 构造 pdfmake 文档配置（核心：处理复杂表头分页重复）
	const docDefinition = {
		pageSize: "A4",
		pageOrientation: "landscape", // 纵向（如果表格太宽，可改为 'landscape' 横向）
		margin: 15, // 页边距（避免内容贴边）
    ...html,
		// content: [
		// 	// 转换后的表格配置 + 表头重复关键设置
		// 	{
		// 		...pdfContent[0], // 继承转换后的表格结构（含合并单元格、样式）
		// 		table: {
		// 			...pdfContent[0].table,
		// 			headerRows: 3, // 关键！你的表头共3行（标题行+头部信息行+核心表头行），所以设为3
		// 			widths: ["25%", "25%", "20%", "30%"], // 自定义列宽（适配你的4列表格）
		// 			layout: {
		// 				// 表格样式优化（可选，根据你的需求调整）
		// 				fillColor: rowIndex => {
		// 					// 表头行（前3行）背景色：匹配你的 .table-header 样式
		// 					if (rowIndex < 3) return "#f5f5f5";
		// 					// 数据行交替背景色（可选）
		// 					return rowIndex % 2 === 0 ? "#fff" : "#fafafa";
		// 				},
		// 				hLineWidth: () => 1, // 水平线宽度
		// 				vLineWidth: () => 1, // 垂直线宽度
		// 				hLineColor: () => "#ccc", // 边框颜色
		// 				vLineColor: () => "#ccc",
		// 				paddingLeft: () => 8, // 单元格内边距
		// 				paddingRight: () => 8,
		// 				paddingTop: () => 8,
		// 				paddingBottom: () => 8,
		// 			},
		// 		},
		// 		// 禁止表格行拆分（避免二维码、数据被截断）
		// 		pageBreak: "avoid",
		// 	},
		// ],
		// 全局样式（适配你的字体、字号）
		defaultStyle: {
			font: "arial", // 支持中文（pdfmake 内置字体，无需额外引入）
			fontSize: 12,
		},
	};

	// 5. 生成并下载 PDF
	var pdfDocGenerator = pdfMake.createPdf(docDefinition).open()

  // pdfDocGenerator.getBuffer(function(buffer) {
  //   console.log(buffer)
  // });
};

export {
  exportPDF
}