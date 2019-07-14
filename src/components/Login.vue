<template>
    <div>
        <el-container style="margin-top:180px">
        <el-card style="margin:0 auto" shadow="always" >
            <div slot="header" style="text-align:center">
                <el-row>
                    <el-col :span="8"><img style="padding-top:7px" src="./../assets/reagent.png" width="30px"></el-col>
                    <el-col :span="16" style="text-align:left"><p class="loginTitle">试剂管理系统</p></el-col>
                </el-row>
            </div>
            <el-form ref="loginForm" :model="loginForm" label-position="left">
                <el-form-item >
                    <el-input v-model="loginForm.userName" placeholder="用户名"></el-input>
                </el-form-item>
                <el-form-item >
                    <el-input v-model="loginForm.userPwd" show-password placeholder="密码"></el-input>
                </el-form-item>
            </el-form>
            <div class="bottom clearfix" style="text-align:center">
                <el-button type="text" class="button" @click="submitForm">登录</el-button>
                <el-button type="text" class="button">重置</el-button>
            </div>
        </el-card>
        </el-container>
    </div>
</template>

<script>
export default {
  name: 'Login',
  components: {
  },
  data () {
    return {
      loginForm: {
        userName: '',
        userPwd: ''
      }
    }
  },
  methods: {
    initBgColor: function () {
      // document.getElementById('app').parentNode.style.backgroundColor = '#909399'
      // document.getElementById('app').style.backgroundColor = '#909399'
    },
    submitForm: function () {
      this.$router.push({path: '/MainBoard'})
    }
  },
  mounted: function () {
    this.initBgColor()
  }
}
</script>

<style scoped>
.loginTitle{
    color:#409EFF
}
</style>
