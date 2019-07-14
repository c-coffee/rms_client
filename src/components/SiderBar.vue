<template>
<div>
    <el-menu
      router
      :unique-opened="true"
      :default-active="'1'"
      background-color="#E9EBFE"
      text-color="#606266"
      active-text-color="#409EFF"
      >
        <el-submenu index="1">
            <template slot="title">
              <i class="el-icon-location"></i>
              <span>基础设置</span>
            </template>
            <el-menu-item index="/DepartmentSet" >
              <i class="el-icon-bank-card"></i>
              <span slot="title">科室设置</span>
            </el-menu-item>
            <el-menu-item index="/ReagentTypeSet">
              <i class="el-icon-money"></i>
              <span slot="title">性状类型</span>
            </el-menu-item>
            <el-menu-item index="/DangerTypeSet">
              <i class="el-icon-warning-outline"></i>
              <span slot="title">危化类别</span>
            </el-menu-item>
            <el-menu-item index="/ModuleSet">
              <i class="el-icon-s-grid"></i>
              <span slot="title">模块管理</span>
            </el-menu-item>
        </el-submenu>
        <el-submenu index="2">
            <template slot="title">
                <i class="el-icon-location"></i>
                <span>数据管理</span>
            </template>
            <el-menu-item index="/SupplierManage">
              <i class="el-icon-truck"></i>
              <span slot="title">供应商</span>
            </el-menu-item>
            <el-menu-item index="/ReagentInfoManage">
              <i class="el-icon-folder-add"></i>
              <span slot="title">试剂管理</span>
            </el-menu-item>
            <el-menu-item index="2.3">
              <i class="el-icon-collection-tag"></i>
              <span slot="title">角色管理</span>
            </el-menu-item>
            <el-menu-item index="2.4">
              <i class="el-icon-user"></i>
              <span slot="title">用户管理</span>
            </el-menu-item>
        </el-submenu>
        <el-submenu index="3">
            <template slot="title">
                <i class="el-icon-location"></i>
                <span>检验科室</span>
            </template>
            <el-menu-item index="/ReagentApplication">
                <i class="el-icon-folder-add"></i>
                <span slot="title">试剂申领</span>
            </el-menu-item>
            <el-menu-item index="/ReagentReturnApp">
                <i class="el-icon-folder-remove"></i>
                <span slot="title">试剂退库</span>
            </el-menu-item>
            <el-menu-item index="/ReagentExpend">
                <i class="el-icon-folder-delete"></i>
                <span slot="title">试剂消耗</span>
            </el-menu-item>
            <el-menu-item index="/DangerApprove">
                <i class="el-icon-warning-outline"></i>
                <span slot="title">危化审核</span>
            </el-menu-item>
        </el-submenu>
        <el-submenu index="5">
            <template slot="title">
                <i class="el-icon-location"></i>
                <span>试剂管理</span>
            </template>
            <el-menu-item index="/ApplicationManage">
                <i class="el-icon-notebook-2"></i>
                <span slot="title">申领管理</span>
            </el-menu-item>
            <el-menu-item index="/OrderManage">
                <i class="el-icon-bank-card"></i>
                <span slot="title">试剂申购</span>
            </el-menu-item>
            <el-menu-item index="5.3">
                <i class="el-icon-shopping-cart-full"></i>
                <span slot="title">申购审核</span>
            </el-menu-item>
            <el-menu-item index="5.4">
                <i class="el-icon-coin"></i>
                <span slot="title">入库管理</span>
            </el-menu-item>
            <el-menu-item index="5.4">
                <i class="el-icon-coin"></i>
                <span slot="title">出库管理</span>
            </el-menu-item>
            <el-menu-item index="5.5">
                <i class="el-icon-document-delete"></i>
                <span slot="title">试剂报损</span>
            </el-menu-item>
            <el-menu-item index="5.5">
                <i class="el-icon-setting"></i>
                <span slot="title">库存盘点</span>
            </el-menu-item>
        </el-submenu>
        <el-submenu index="9">
            <template slot="title">
                <i class="el-icon-location"></i>
                <span>统计分析</span>
            </template>
            <el-menu-item index="9.1">
                <i class="el-icon-monitor"></i>
                <span slot="title"><router-link to="/" tag="span">科室库存</router-link></span>
            </el-menu-item>
            <el-menu-item index="9.2">
                <i class="el-icon-suitcase-1"></i>
                <span slot="title">试剂库存</span>
            </el-menu-item>
            <el-menu-item index="9.3">
                <i class="el-icon-connection"></i>
                <span slot="title">申领消耗</span>
            </el-menu-item>
        </el-submenu>
    </el-menu>
</div>
</template>

<script>
export default {
  name: 'SiderBar',
  data () {
    return {
    }
  }
}
</script>

<style scoped>
.el-menu-item{
  width:100%;
  padding-right:40px;
}
</style>
