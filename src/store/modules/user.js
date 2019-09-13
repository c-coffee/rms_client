const User = {
  state: {
    userInfo: {}
  },
  mutations: {
    setUserInfo (state, userInfo) {
      state.userInfo = userInfo
      console.log(userInfo)
      console.log(state.userInfo)
    }
  },
  actions: {
    setUserInfo (context, userInfo) {
      console.log(userInfo)
      context.commit('setUserInfo', userInfo)
    }
  },
  getters: {

  }
}

export default User
