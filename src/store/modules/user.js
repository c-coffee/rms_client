const User = {
  state: {
    userInfo: {}
  },
  mutations: {
    setUserInfo (state, userInfo) {
      state.userInfo = userInfo
    }
  },
  actions: {
    setUserInfo ({commit}, userInfo) {
      commit('setUserInfo', userInfo)
    }
  },
  getters: {

  }
}

export default User
