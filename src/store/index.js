import Vue from 'vue'
import Vuex from 'vuex'
import ReagentStoreManage from './DataManage/ReagentStoreManage'

Vue.use(Vuex)

export default new Vuex.Store({
  modules: {
    ReagentStoreManage
  }
})
