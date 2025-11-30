import { jsPDF } from 'jspdf'
import { autoTable } from 'jspdf-autotable'
import { getFontModule } from './preload-font';

const setPrint = async (head, head2, body, data, foot) => {
  const pdf = new jsPDF({
    orientation: 'landscape', // 横向
    unit: 'mm',
    format: 'a4',
  });

  const { addFont } = await getFontModule()
  addFont(pdf);

  const setTable = {
    theme: 'grid',
    margin: { top: 38, left: 10, right: 10 },
    headStyles: { //头部样式
      fillColor: '#E3E3E3',
      textColor: '#333',
    },
    styles: {
      cellPadding: 3,
      fontSize: 12,
      font: 'sourcehan',
      fontStyle: 'normal',
      halign: 'center',
    },
    tableWidth: 'auto',
    columnWidth: 'auto',
    head: head2,
    body,
    // 页面开始绘制PDF之前调用
    willDrawPage: function () {
      pdf.setFontSize(36)
      var pageWidth = pdf.internal.pageSize.getWidth();
      const buyText = data.name
      var textWidth = pdf.getTextWidth(buyText, { fontSize: 36 });
      const x = (pageWidth - textWidth) / 2;
      pdf.text(buyText, x, 22)
      if(data.no){
        pdf.setFontSize(16)
        pdf.text(`编码：${data.no}`, pageWidth - 70, 20)
      }

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

      // 新增：绘制表格下方的核准、审查、制表、日期
      const bottomTexts = foot;
      const bottomY = pdf.internal.pageSize.getHeight() - 20; // 距离底部20mm
      const bottomTotalWidth = bottomTexts.reduce((sum, text) => sum + pdf.getTextWidth(text, { fontSize: 12 }), 0);
      const bottomSpacing = (pageWidth - 40 - bottomTotalWidth) / (bottomTexts.length - 1); // 左右边距各20mm
      
      let bottomX = 20;
      bottomTexts.forEach(text => {
        pdf.text(text, bottomX, bottomY);
        bottomX += pdf.getTextWidth(text, { fontSize: 12 }) + bottomSpacing;
      });
    },
    // didDrawPage: function(data){
    //   if (typeof pdf.putTotalPages === 'function') {
    //     const pageWidth = pdf.internal.pageSize.getWidth();
    //     const bottomTexts = foot;
    //     pdf.setFontSize(12); // 保持与上方文字大小一致
    //     const textY = data.cursor.y + 6;

    //     // 计算文本之间的间距以实现两端对齐
    //     const totalTextWidth = bottomTexts.reduce((sum, text) => sum + pdf.getTextWidth(text), 0);
    //     // 左右边距与表格保持一致（10mm）
    //     const spacing = (pageWidth - 20 - totalTextWidth) / (bottomTexts.length - 1);

    //     let currentX = 10; // 左边距
    //     bottomTexts.forEach(text => {
    //       pdf.text(text, currentX, textY);
    //       currentX += pdf.getTextWidth(text) + spacing;
    //     });
    //   }
    // }
  }
  autoTable(pdf, setTable)
  // pdf.save('table.pdf')
  const pdfBlob = pdf.output('blob'); // 生成 Blob 流
  const pdfUrl = URL.createObjectURL(pdfBlob);
  
  const iframe = document.createElement('iframe');
  iframe.style.display = 'none';
  document.body.appendChild(iframe);
  iframe.src = pdfUrl;
  setTimeout(() => {
    iframe.contentWindow.print();
  }, 100);
}

export {
  setPrint
}