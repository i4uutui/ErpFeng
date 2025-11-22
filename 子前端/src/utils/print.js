import { addFont } from '@/utils/font/sourcehan-normal'
import { jsPDF } from 'jspdf'
import { autoTable } from 'jspdf-autotable'

const setPrint = (head, body, data, indexs) => {
  const pdf = new jsPDF({
    orientation: 'landscape', // 横向
    unit: 'mm',
    format: 'a4',
  });

  addFont(pdf)

  autoTable(pdf, {
    theme: 'grid',
    margin: { top: 30, left: 10, right: 10 },
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
    head,
    body,
    foot: [
      [
        { content: '核准：', colSpan: indexs[0], rowSpan: 2, styles: { halign : 'left', fillColor: '#FFFFFF',textColor: '#333333', fontSize: 12, lineWidth: { left: 0, right: 0, bottom: 0, top: 0.5 } } }, 
        { content: '审查：', colSpan: indexs[1], rowSpan: 2, styles: { halign : 'center', fillColor: '#FFFFFF',textColor: '#333333', fontSize: 12, lineWidth: { left: 0, right: 0, bottom: 0, top: 0.5 } } }, 
        { content: `制表：${data.userName}`, colSpan: indexs[2], rowSpan: 2, styles: { halign : 'center', fillColor: '#FFFFFF',textColor: '#333333', fontSize: 12, lineWidth: { left: 0, right: 0, bottom: 0, top: 0.5 } } }, 
        { content: `日期：${data.date}`, colSpan: indexs[3], rowSpan: 2, styles: { halign : 'right', fillColor: '#FFFFFF',textColor: '#333333', fontSize: 12, lineWidth: { left: 0, right: 0, bottom: 0, top: 0.5 } } }, 
      ]
    ],
    // 页面开始绘制PDF之前调用
    willDrawPage: function () {
      pdf.setFontSize(36)
      var pageWidth = pdf.internal.pageSize.getWidth();
      const buyText = data.name
      var textWidth = pdf.getTextWidth(buyText, { fontSize: 36 });
      const x = (pageWidth - textWidth) / 2;
      pdf.text(buyText, x, 22)
      pdf.setFontSize(16)
      pdf.text(`编码：${data.no}`, pageWidth - 70, 20)
    },
  })
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