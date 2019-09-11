<template>
    <el-container>
        <el-header>
            <header-bar>
            </header-bar>
        </el-header>
        <el-container>
            <el-aside width="210px" id="mainSider">
              <sider-bar></sider-bar>
            </el-aside>
            <el-main>
              <router-view/>
            </el-main>
        </el-container>
    </el-container>
</template>

<script>
import HeaderBar from './HeaderBar'
import SiderBar from './SiderBar'

export default {
  name: 'MainBoard',
  components: {
    HeaderBar, SiderBar
  },
  data () {
    return {
    }
  }
}
</script>

<style scoped>
  .el-header{
    line-height: 60px;
    background-color: #545c64
  }
  .el-aside {
    height: 90vh;
    background-color: #D9ECFF;
  }
  .el-container{
    background-color: #D9ECFF;
  }
</style>
