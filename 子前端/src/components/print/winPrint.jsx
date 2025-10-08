import { defineComponent, ref } from 'vue';
import { VuePDF, usePDF } from '@tato30/vue-pdf';
import '@tato30/vue-pdf/style.css';
import request from '@/utils/request';
import { ElMessage, ElSelect, ElOption, ElButton } from 'element-plus'; // 显式导入组件

export default defineComponent({
  props: {
    url: {
      type: String,
      default: ''
    },
    printList: {
      type: Array,
      default: () => []
    }
  },
  emits: ['close'],
  setup(props, { emit }) {
    let totalPages = ref(0); // 总页数

    const { pdf, pages } = usePDF(props.url);
    const pdfFile = ref(pdf);
    
    const printName = ref('');
    const isLoading = ref(true); // 加载状态


    // 处理打印提交（多页PDF无需特殊处理，文件本身包含所有页）
    const handleSubmit = async () => {
      if (!printName.value) {
        return ElMessage.error('请选择打印机');
      }

      // 多页PDF的blob包含所有页面，直接上传即可
      const response = await fetch(props.url);
      const blob = await response.blob();

      const formData = new FormData();
      formData.append('printerName', printName.value);
      formData.append('file', blob, 'print-file.pdf'); // 文件名可自定义

      const res = await request.post('/api/printers', formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        },
        timeout: 15000
      });
      
      if (res.data.code === 200) {
        ElMessage.success('打印请求已发送');
      } else {
        ElMessage.error(res.data.msg || '打印失败');
      }
    };

    const handleClose = () => {
      emit('close');
    };

    return () => (
      <>
        <div class="flex mb20">
          <div>请选择打印机：</div>
          <ElSelect v-model={printName.value} placeholder="请选择打印机" style="width: 240px" >
            {props.printList.map((e, index) => ( <ElOption key={index} label={e.name} value={e.name} /> ))}
          </ElSelect>
          <div style={{ marginLeft: '20px' }}>
            <ElButton type="primary" onClick={handleSubmit}>打印</ElButton>
            <ElButton onClick={handleClose}>取消</ElButton>
          </div>
        </div>

        <div style={{ border: '1px solid #b5b5b5', maxHeight: '500px', overflow: 'auto' }} data-page={ pages.value }>
          {{
            default: () => {
              const number = Number(pages.value)
              if(number > 0){
                let dom = []
                for(let i = 0; i < number; i++){
                  const str = <div style={{ margin: '20px auto', maxWidth: '800px' }}>
                    <VuePDF pdf={pdfFile.value} page={i + 1} text-layer annotation-layer width={ 800 } />
                  </div>
                  dom.push(str)
                  if(i < number - 1){
                    const str = <div style={{ borderBottom: '1px dashed #eee', margin: '10px 0' }} />
                    dom.push(str)
                  }
                }
                return dom
              }
            }
          }}
        </div>
      </>
    );
  }
});
