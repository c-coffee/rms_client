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
    setUserInfo (context, userInfo) {
      context.commit('setUserInfo', userInfo)
    }
  },
  getters: {

  }
}

export default User
