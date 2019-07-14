<template>
    <el-menu
      background-color="#545c64"
      mode="horizontal"
      :default-active="'2'"
      text-color="#fff"
      active-text-color="#ffd04b">
        <el-menu-item index="1"><img src="./../assets/reagent.png" width="30px"> <span style="font-size:16px">&nbsp;试剂管理系统</span></el-menu-item>
    </el-menu>
</template>

<script>
export default {
  name: 'HeaderBar',
  data () {
    return {

    }
  }
}
</script>

<style scoped>
</style>
