import { defineStore } from 'pinia'

export const useStore = defineStore('useStore', {
  state: () => {
    return{
      printNo: '',
    }
  },
  actions: {
    setPrintNo(data) {
      this.printNo = data;
    },
  }
})
