<template>
<div>
    <el-menu
      router
      :unique-opened="true"
      :default-active="'1'"
      background-color="#D9ECFF"
      text-color="#606266"
      active-text-color="#409EFF"
      >
        <el-submenu index="1" v-show="checkRank('BaseSet')">
            <template slot="title" >
              <i class="el-icon-location"></i>
              <span>基础设置</span>
            </template>
            <el-menu-item index="/DepartmentSet" v-show="checkRank('DepartmentSet')">
              <i class="el-icon-bank-card"></i>
              <span slot="title">科室设置</span>
            </el-menu-item>
            <el-menu-item index="/ReagentTypeSet" v-show="checkRank('ReagentTypeSet')">
              <i class="el-icon-picture-outline"></i>
              <span slot="title">类型设置</span>
            </el-menu-item>
            <el-menu-item index="/ReagentStateSet" v-show="checkRank('ReagentStateSet')">
              <i class="el-icon-money"></i>
              <span slot="title">性状设置</span>
            </el-menu-item>
            <el-menu-item index="/PuritySet" v-show="checkRank('PuritySet')">
              <i class="el-icon-money"></i>
              <span slot="title">纯度设置</span>
            </el-menu-item>
            <el-menu-item index="/DangerTypeSet" v-show="checkRank('DangerTypeSet')">
              <i class="el-icon-warning-outline"></i>
              <span slot="title">危化类别</span>
            </el-menu-item>
            <el-menu-item index="/ModuleSet" v-show="checkRank('ModuleSet')">
              <i class="el-icon-s-grid"></i>
              <span slot="title">模块管理</span>
            </el-menu-item>
        </el-submenu>
        <el-submenu index="2" v-show="checkRank('DataManage')">
            <template slot="title" >
                <i class="el-icon-location"></i>
                <span>数据管理</span>
            </template>
            <el-menu-item index="/SupplierManage" v-show="checkRank('SupplierManage')">
              <i class="el-icon-truck"></i>
              <span slot="title">供应商</span>
            </el-menu-item>
            <el-menu-item index="/ReagentInfoManage" v-show="checkRank('ReagentInfoManage')">
              <i class="el-icon-folder-add"></i>
              <span slot="title">试剂管理</span>
            </el-menu-item>
            <el-menu-item index="/ReagentStockManage" v-show="checkRank('ReagentStockManage')">
              <i class="el-icon-folder-add"></i>
              <span slot="title">库存管理</span>
            </el-menu-item>
            <el-menu-item index="/RoleManage" v-show="checkRank('RoleManage')">
              <i class="el-icon-collection-tag"></i>
              <span slot="title">角色管理</span>
            </el-menu-item>
            <el-menu-item index="/UserManage" v-show="checkRank('UserManage')">
              <i class="el-icon-user"></i>
              <span slot="title">用户管理</span>
            </el-menu-item>
        </el-submenu>
        <el-submenu index="3" v-show="checkRank('ReagentProcess')">
            <template slot="title">
              <i class="el-icon-location"></i>
              <span>试剂流程</span>
            </template>
            <el-menu-item index="/ReagentApplication" v-show="checkRank('ReagentApplication')">
              <i class="el-icon-folder-add"></i>
              <span slot="title">试剂申请</span>
            </el-menu-item>
            <el-menu-item index="/ReagentReceive" v-show="checkRank('ReagentReceive')">
              <i class="el-icon-folder-add"></i>
              <span slot="title">试剂领取</span>
              <el-badge :value="1" style="float:right" type="primary">
              </el-badge>
            </el-menu-item>
            <el-menu-item index="/ReagentExpend" v-show="checkRank('ReagentExpend')">
              <i class="el-icon-folder-delete"></i>
              <span slot="title">试剂消耗</span>
            </el-menu-item>
            <el-menu-item index="/DangerApprove" v-show="checkRank('DangerApprove')">
              <i class="el-icon-warning-outline"></i>
              <span slot="title">申领审核</span>
              <el-badge :value="6" style="float:right" type="primary">
              </el-badge>
            </el-menu-item>
        </el-submenu>
        <el-submenu index="5" v-show="checkRank('ReagentManage')">
            <template slot="title">
              <i class="el-icon-location"></i>
              <span>试剂管理</span>
            </template>
            <el-menu-item index="/ApplicationManage" v-show="checkRank('ApplicationManage')">
              <i class="el-icon-notebook-2"></i>
              <span slot="title">申领管理</span>
            </el-menu-item>
            <el-menu-item index="/ApplicationOrderManage" v-show="checkRank('ApplicationOrderManage')">
              <i class="el-icon-notebook-2"></i>
              <span slot="title">申购管理</span>
            </el-menu-item>
            <el-menu-item index="/OrderManage" v-show="checkRank('OrderManage')">
              <i class="el-icon-bank-card"></i>
              <span slot="title">试剂采购</span>
            </el-menu-item>
            <el-menu-item index="/OrderApprove" v-show="checkRank('OrderApprove')">
              <i class="el-icon-shopping-cart-full"></i>
              <span slot="title">采购审核</span>
            </el-menu-item>
            <el-menu-item index="/DamageReagent" v-show="checkRank('DamageReagent')">
              <i class="el-icon-document-delete"></i>
              <span slot="title">试剂报损</span>
            </el-menu-item>
        </el-submenu>
        <el-submenu index="9" v-show="checkRank('Statistic')">
            <template slot="title">
              <i class="el-icon-location"></i>
              <span>统计分析</span>
            </template>
            <el-menu-item index="/ComStatistic" v-show="checkRank('ComStatistic')">
              <i class="el-icon-suitcase-1"></i>
              <span slot="title">试剂库存</span>
            </el-menu-item>
            <el-menu-item index="/DeptComStatistic" v-show="checkRank('DeptComStatistic')">
              <i class="el-icon-monitor"></i>
              <span slot="title">科室库存</span>
            </el-menu-item>
            <el-menu-item index="/ReportManage" v-show="checkRank('ReportManage')">
              <i class="el-icon-setting"></i>
              <span slot="title">报表管理</span>
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
      moduleList: []
    }
  },
  methods: {
    getModuleList: function () {
      // 1.读取localStorage获取模块权限列表，如果不能获取，则退回登录界面
      let userStr = localStorage.getItem('rms_userInfo')
      if (userStr.length > 0) {
        let userInfo = JSON.parse(userStr)
        this.moduleList = userInfo.userModules
      } else {
        this.$router.push({path: '/'})
      }
    },
    checkRank: function (info) {
      let flag
      flag = this.moduleList.some(function (el, i, array) {
        if (el.moduleInfo === info) return true
      })
      return flag
    }
  },
  beforeMount: function () {
    this.getModuleList()
  },
  mounted: function () {
    // this.getModuleList()
  }
}
</script>

<style scoped>
.el-menu-item{
  width:100%;
  padding-right:40px;
}
</style>
