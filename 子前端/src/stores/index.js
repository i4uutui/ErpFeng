import { defineStore } from 'pinia'

export const useStore = defineStore('useStore', {
  state: () => {
    return{
      token: '',
      printNo: '',
    }
  },
  actions: {
    setToken(data) {
      this.token = data
    },
    setPrintNo(data) {
      this.printNo = data;
    },
  }
})
