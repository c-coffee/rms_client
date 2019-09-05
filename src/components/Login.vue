<template>
    <div class='bgInfo' :style='bgInfo'>
        <el-container style="padding-top:180px">
        <el-card style="margin:0 auto; width: 400px; opacity:0.7;" shadow="always" body-style="padding:0 30px 60px 30px">
            <div slot="header" style="text-align:center">
                <el-row>
                    <el-col :span="8"><img style="padding-top:7px" src="./../assets/reagent.png" width="60px"></el-col>
                    <el-col :span="16" style="text-align:left"><p class="loginTitle">试剂管理系统</p></el-col>
                </el-row>
            </div>
            <el-form ref="loginForm" :model="loginForm" label-position="left">
                <el-form-item
                  prop="userName"
                  :rules="[{required: true, message:'用户名不能为空', trigger: 'blur'}]"
                >
                    <el-input autofocus prefix-icon="el-icon-user" v-model="loginForm.userName" placeholder="用户名"></el-input>
                </el-form-item>
                <el-form-item
                  prop="userPwd"
                  :rules="[{required: true, message:'密码不能为空', trigger: 'blur'}]"
                >
                    <el-input maxlength="8" prefix-icon="el-icon-menu" v-model="loginForm.userPwd" show-password placeholder="密码"></el-input>
                </el-form-item>
            </el-form>
            <div class="bottom clearfix" style="text-align:center">
                <el-checkbox label="7天自动登录" v-model="autoLogin" style="float:left"></el-checkbox>
                <el-button type="primary" size="small" style="float:right" plain @click="submitForm">登录</el-button>
                <el-button type="text" size="small" style="float:right;margin-right:10px" @click="resetForm">重置</el-button>
            </div>
        </el-card>
        </el-container>
    </div>
</template>

<script>
import md5 from 'js-md5'
import axios from 'axios'

export default {
  name: 'Login',
  components: {
  },
  data () {
    return {
      autoLogin: true,
      loginForm: {
        userName: '',
        userPwd: ''
      },
      bgInfo: {
        backgroundImage: 'url(' + require('./../assets/bg.png'),
        backgroundRepeat: 'no-repeat',
        backgroundPosition: 'center',
        backgroundSize: '100% 100%',
        height: '100vh'
      }
    }
  },
  methods: {
    submitForm: function () {
      this.$refs['loginForm'].validate((isPass, object) => {
        if (!isPass) {
          this.$message({
            message: '请输入完整信息！',
            type: 'error'
          })
        } else {
          this.loginForm.userPwd = md5(this.loginForm.userPwd)
          // console.log(this.loginForm)
          axios({
            method: 'post',
            url: '/api/login/userCheck',
            data: {
              loginInfo: this.loginForm
            }
          })
            .then((res) => {
              if (res.data.result === -1 || res.data.result === -2) {
                this.$message({
                  message: res.data.msg,
                  type: 'error'
                })
              }
              if (res.data.result === 1) {
                this.$message({
                  message: res.data.msg,
                  type: 'success'
                })
                // 根据用户选择是否保留密码，将userInfo写入localStorage
                let userInfo = res.data.userInfo
                if (this.autoLogin) {
                  userInfo.autoLogin = true
                } else {
                  userInfo.autoLogin = false
                }
                localStorage.setItem('rms_userInfo', JSON.stringify(userInfo))
                this.$router.push({path: '/MainBoard'})
              }
            })
            .catch((err) => {
              console.log(err)
              this.$message({
                message: '服务器错误！',
                type: 'error'
              })
            })
        }
      })
    },
    resetForm: function () {
      this.$refs['loginForm'].resetFields()
    },
    getInitUserInfo: function () {
      let userStr = localStorage.getItem('rms_userInfo')
      if (userStr.length > 0) {
        let userInfo = JSON.parse(userStr)
        if (!userInfo.autoLogin) {
          this.loginForm.userName = userInfo.userName
          return
        }
        // 计算时间差天数
        let nowDate = Date.now()
        let days = Math.floor((nowDate - userInfo.loginDate) / (24 * 3600 * 1000))
        this.loginForm.userName = userInfo.userName
        if (days > 7) {
          this.loginForm.userPwd = ''
        } else {
          this.loginForm.userPwd = userInfo.userPwd
          axios({
            method: 'post',
            url: '/api/login/userCheck',
            data: {
              loginInfo: this.loginForm
            }
          })
            .then((res) => {
              if (res.data.result === -1 || res.data.result === -2) {
                this.$message({
                  message: res.data.msg,
                  type: 'error'
                })
              }
              if (res.data.result === 1) {
                // 根据用户选择是否保留密码，将userInfo写入localStorage
                let uInfo = res.data.userInfo
                if (this.autoLogin) {
                  uInfo.autoLogin = true
                } else {
                  uInfo.autoLogin = false
                }
                localStorage.setItem('rms_userInfo', JSON.stringify(uInfo))
                this.$router.push({path: '/MainBoard'})
              }
            })
            .catch((err) => {
              console.log(err)
              this.$message({
                message: '服务器错误！',
                type: 'error'
              })
            })
        }
      }
    }
  },
  mounted: function () {
    this.getInitUserInfo()
    document.querySelector('body').setAttribute('style', this.bgInfo.backgroundImage)
  }
}
</script>

<style scoped>
.loginTitle{
    color:#409EFF;
    font-size: 30px
}
</style>
