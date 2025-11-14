import { defineComponent, ref } from 'vue'
import { VxeTable, VxeColumn } from 'vxe-table'

export default defineComponent({
  setup(){

const tableRef = ref()
const tableData = ref([
  { id: 10001, name: 'Test1', flag: true },
  { id: 10002, name: 'Test2', flag: false }
])
const insertEvent = async () => {
  const $table = tableRef.value
  if ($table) {
    const record = {
      flag: false
    }
    const { row: newRow } = await $table.insert(record)
    $table.setEditRow(newRow)
  }
}
const saveEvent = () => {
  const $table = tableRef.value
  if ($table) {
    const { insertRecords, removeRecords, updateRecords } = $table.getRecordset()
    if (insertRecords.length || removeRecords.length || updateRecords.length) {
      ElMessageBox.alert(`insertRecords=${insertRecords.length}; removeRecords=${removeRecords.length}; updateRecords=${updateRecords.length}`)
    } else {
      ElMessageBox.alert('数据未改动！')
    }
  }
}

    return () => (
      <>
        <ElCard>
          <VxeTable border show-overflow keep-source ref="tableRef" edit-config={{ trigger: 'click', mode: 'row'}} data={ tableData.value }>
            <VxeColumn type="checkbox" width="60"></VxeColumn>
            <VxeColumn type="seq" title="Number" width="80"></VxeColumn>
            <VxeColumn title="Name" field="name" min-width="140"></VxeColumn>
            <VxeColumn field="flag" width="200">
              {{
                default: ({ row }) => <ElSwitch v-model={ row.flag } />
              }}
            </VxeColumn>
          </VxeTable>
        </ElCard>
      </>
    )
  }
})