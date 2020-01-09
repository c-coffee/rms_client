<template>
  <el-container>
    <el-card class="box-card" style="width:300px" v-for="module in this.moduleInfo" :key='module.moduleID'>
      <div slot="header" class="moduleItem" align="center" >
        <span>{{module.moduleName}}</span>
      </div>
      <div v-for="child in module.children" :key="child.moduleID" align="center">
        <el-badge :value="child.count" class="item" type="primary">
          <el-button @click="linkPage(child.moduleInfo)" type="primary" round plain class="childItem">{{child.moduleName}}</el-button>
        </el-badge>
      </div>
    </el-card>
  </el-container>
</template>

<script>
import axios from 'axios'
export default {
  name: 'QuickStart',
  data () {
    return {
      moduleInfo: []
    }
  },
  methods: {
    linkPage: function (address) {
      this.$router.push({ path: '/' + address })
    },
    init: function () {
      let processArray = []
      let userInfo = JSON.parse(localStorage.getItem('rms_userInfo'))

      processArray = userInfo.userModules.filter(function (module, index) {
        return module.parent_moduleID === 14 || module.parent_moduleID === 15
      })

      axios({
        method: 'post',
        url: '/api/login/checkTaskNum',
        data: {
          processArray
        }
      })
        .then((res) => {
          if (res.data.result === -2) {
            this.$message({
              message: res.data.msg,
              type: 'error'
            })
          } else {
            this.moduleInfo = userInfo.userModules.filter(function (module, index) {
              return module.parent_moduleID === 0
            })
            for (let j = 0; j < this.moduleInfo.length; j++) {
              this.moduleInfo[j].children = []
              let temp = this.moduleInfo[j]
              this.moduleInfo[j].children = userInfo.userModules.filter(function (module, index) {
                return module.parent_moduleID === temp.moduleID
              })
            }
            let temp = res.data.data
            let tempModule = this.moduleInfo
            for (let j = 0; j < temp.length; j++) {
              if (temp[j].count > 0) {
                for (let i = 0; i < tempModule.length; i++) {
                  for (let m = 0; m < tempModule[i].children.length; m++) {
                    if (temp[j].moduleID === tempModule[i].children[m].moduleID) {
                      tempModule[i].children[m].count = temp[j].count
                      break
                    }
                  }
                }
              }
            }
            this.moduleInfo = tempModule
            // console.log(this.moduleInfo)
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
  },
  mounted: function () {
    this.init()
  }
}
</script>

<style scoped>
.box-card{
  margin: 15px;
  font-size: 22px
}
.childItem{
  margin-bottom: 20px;
  width: 180px;
}
</style>
