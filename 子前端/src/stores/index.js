import { defineStore } from 'pinia'

export const useStore = defineStore('useStore', {
  state: () => {
    return{
      pdfUrl: '',
    }
  },
  actions: {
    setPdfUrl(data) {
      this.pdfUrl = data;
    },
  }
})
