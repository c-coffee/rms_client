<template>
    <el-menu
      background-color="#545c64"
      mode="horizontal"
      :default-active="'1'"
      text-color="#fff"
      active-text-color="#ffd04b">
        <el-menu-item index="1"><router-link to="/MainBoard" tag="span"><img src="./../assets/reagent.png" width="30px"> <span style="font-size:16px">&nbsp;试剂管理系统</span></router-link></el-menu-item>
        <el-menu-item index="3" style="float:right" title="下次将无法自动登录" @click="logOutPage"><i class="el-icon-switch-button"></i>注销</el-menu-item>
        <el-menu-item index="4" style="float:right"><i class="el-icon-user-solid"></i>{{userName}}，您好！</el-menu-item>
    </el-menu>
</template>

<script>
import axios from 'axios'
export default {
  name: 'HeaderBar',
  data () {
    return {
      userName: ''
    }
  },
  methods: {
    logOutPage: function () {
      axios({
        method: 'get',
        url: '/api/login/logOut'
      })
        .then((res) => {
          let userStr = localStorage.getItem('rms_userInfo')
          if (userStr.length > 0) {
            let userInfo = JSON.parse(userStr)
            userInfo.autoLogin = false
            localStorage.setItem('rms_userInfo', JSON.stringify(userInfo))
          }
          this.$router.push({path: '/'})
        })
    },
    checkUserLogin: function () {
      setTimeout(this.checkUserLogin, 1000 * 60 * 30)
      // console.log(this.num)
      let userStr = localStorage.getItem('rms_userInfo')
      let userInfo
      if (userStr.length === 0) {
        this.$router.push({path: '/'})
      } else {
        userInfo = JSON.parse(userStr)
        // console.log(userInfo)
        this.userName = userInfo.userRealName
      }
      axios({
        method: 'post',
        url: '/api/login/checkUserLogin',
        data: {
          userID: userInfo.userID
        }
      })
        .then((res) => {
          if (res.data.result === -1) {
            userInfo.autoLogin = false
            localStorage.setItem('rms_userInfo', JSON.stringify(userInfo))
            this.$router.push({path: '/'})
          }
        })
    }
  },
  mounted: function () {
    // 30分钟检测一次是否登出
    this.checkUserLogin()
    // this.checkUserLogin()
  }
}
</script>

<style scoped>
</style>
