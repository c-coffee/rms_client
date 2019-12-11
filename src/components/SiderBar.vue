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
        <el-submenu index="1">
            <template slot="title" v-if="checkRank('BaseSet')">
              <i class="el-icon-location"></i>
              <span>基础设置</span>
            </template>
            <el-menu-item index="/DepartmentSet" v-if="checkRank('DepartmentSet')">
              <i class="el-icon-bank-card"></i>
              <span slot="title">科室设置</span>
            </el-menu-item>
            <el-menu-item index="/ReagentTypeSet" v-if="checkRank('ReagentTypeSet')">
              <i class="el-icon-picture-outline"></i>
              <span slot="title">类型设置</span>
            </el-menu-item>
            <el-menu-item index="/ReagentStateSet" v-if="checkRank('ReagentStateSet')">
              <i class="el-icon-money"></i>
              <span slot="title">性状设置</span>
            </el-menu-item>
            <el-menu-item index="/PuritySet" v-if="checkRank('PuritySet')">
              <i class="el-icon-money"></i>
              <span slot="title">纯度设置</span>
            </el-menu-item>
            <el-menu-item index="/DangerTypeSet" v-if="checkRank('DangerTypeSet')">
              <i class="el-icon-warning-outline"></i>
              <span slot="title">危化类别</span>
            </el-menu-item>
            <el-menu-item index="/ModuleSet" v-if="checkRank('ModuleSet')">
              <i class="el-icon-s-grid"></i>
              <span slot="title">模块管理</span>
            </el-menu-item>
        </el-submenu>
        <el-submenu index="2">
            <template slot="title" v-if="checkRank('DataManage')">
                <i class="el-icon-location"></i>
                <span>数据管理</span>
            </template>
            <el-menu-item index="/SupplierManage" v-if="checkRank('SupplierManage')">
              <i class="el-icon-truck"></i>
              <span slot="title">供应商</span>
            </el-menu-item>
            <el-menu-item index="/ReagentInfoManage" v-if="checkRank('ReagentInfoManage')">
              <i class="el-icon-folder-add"></i>
              <span slot="title">试剂管理</span>
            </el-menu-item>
            <el-menu-item index="/ReagentStockManage" v-if="checkRank('ReagentStockManage')">
              <i class="el-icon-folder-add"></i>
              <span slot="title">库存管理</span>
            </el-menu-item>
            <el-menu-item index="/RoleManage" v-if="checkRank('RoleManage')">
              <i class="el-icon-collection-tag"></i>
              <span slot="title">角色管理</span>
            </el-menu-item>
            <el-menu-item index="/UserManage" v-if="checkRank('UserManage')">
              <i class="el-icon-user"></i>
              <span slot="title">用户管理</span>
            </el-menu-item>
        </el-submenu>
        <el-submenu index="3">
            <template slot="title" v-if="checkRank('BaseSet')">
              <i class="el-icon-location"></i>
              <span>试剂流程</span>
            </template>
            <el-menu-item index="/ReagentApplication" v-if="checkRank('BaseSet')">
              <i class="el-icon-folder-add"></i>
              <span slot="title">试剂申请</span>
            </el-menu-item>
            <el-menu-item index="/ReagentReceive" v-if="checkRank('BaseSet')">
              <i class="el-icon-folder-add"></i>
              <span slot="title">试剂领取</span>
              <el-badge :value="1" style="float:right" type="primary">
              </el-badge>
            </el-menu-item>
            <!-- <el-menu-item index="/ReagentReturnApp" v-if="checkRank('BaseSet')">
              <i class="el-icon-folder-remove"></i>
              <span slot="title">试剂退库</span>
            </el-menu-item> -->
            <el-menu-item index="/ReagentExpend" v-if="checkRank('BaseSet')">
              <i class="el-icon-folder-delete"></i>
              <span slot="title">试剂消耗</span>
            </el-menu-item>
            <el-menu-item index="/DangerApprove" v-if="checkRank('BaseSet')">
              <i class="el-icon-warning-outline"></i>
              <span slot="title">危化审核</span>
              <el-badge :value="6" style="float:right" type="primary">
              </el-badge>
            </el-menu-item>
        </el-submenu>
        <el-submenu index="5">
            <template slot="title" v-if="checkRank('BaseSet')">
              <i class="el-icon-location"></i>
              <span>试剂管理</span>
            </template>
            <el-menu-item index="/ApplicationManage" v-if="checkRank('BaseSet')">
              <i class="el-icon-notebook-2"></i>
              <span slot="title">申领管理</span>
            </el-menu-item>
            <el-menu-item index="/ApplicationOrderManage" v-if="checkRank('BaseSet')">
              <i class="el-icon-notebook-2"></i>
              <span slot="title">申购管理</span>
            </el-menu-item>
            <el-menu-item index="/OrderManage" v-if="checkRank('BaseSet')">
              <i class="el-icon-bank-card"></i>
              <span slot="title">试剂采购</span>
            </el-menu-item>
            <el-menu-item index="/OrderApprove" v-if="checkRank('BaseSet')">
              <i class="el-icon-shopping-cart-full"></i>
              <span slot="title">采购审核</span>
            </el-menu-item>
            <el-menu-item index="/DamageReagent" v-if="checkRank('BaseSet')">
              <i class="el-icon-document-delete"></i>
              <span slot="title">试剂报损</span>
            </el-menu-item>
        </el-submenu>
        <el-submenu index="9">
            <el-menu-item index="/ComStatistic" v-if="checkRank('BaseSet')">
              <i class="el-icon-suitcase-1"></i>
              <span slot="title">试剂库存</span>
            </el-menu-item>
            <template slot="title" v-if="checkRank('BaseSet')">
              <i class="el-icon-location"></i>
              <span>统计分析</span>
            </template>
            <el-menu-item index="9.1" v-if="checkRank('BaseSet')">
              <i class="el-icon-monitor"></i>
              <span slot="title"><router-link to="/" tag="span">科室库存</router-link></span>
            </el-menu-item>
            <el-menu-item index="9.3" v-if="checkRank('BaseSet')">
              <i class="el-icon-setting"></i>
              <span slot="title">库存盘点</span>
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
    setModuleList: function () {
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
      // console.log(this.moduleList)
      return this.moduleList.some(function (el, i, array) {
        if (el.moduleInfo === info) return true
      })
    }
  },
  mounted: function () {
    this.setModuleList()
  }
}
</script>

<style scoped>
.el-menu-item{
  width:100%;
  padding-right:40px;
}
</style>
