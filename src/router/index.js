import Vue from 'vue'
import Router from 'vue-router'
import MainBoard from '@/components/MainBoard'
import Login from '@/components/Login'
import QuickStart from '@/components/QuickStart'

import DepartmentSet from '@/components/BaseSets/DepartmentSet'
import ReagentTypeSet from '@/components/BaseSets/ReagentTypeSet'
import ReagentStateSet from '@/components/BaseSets/ReagentStateSet'
import DangerTypeSet from '@/components/BaseSets/DangerTypeSet'
import ModuleSet from '@/components/BaseSets/ModuleSet'
import PuritySet from '@/components/BaseSets/PuritySet'

import SupplierManage from '@/components/DataManage/SupplierManage'
import ReagentInfoManage from '@/components/DataManage/ReagentInfoManage'
import ReagentStockManage from '@/components/DataManage/ReagentStockManage'
import RoleManage from '@/components/DataManage/RoleManage'
import UserManage from '@/components/DataManage/UserManage'

import ReagentApplication from '@/components/ReagentProcess/ReagentApplication'
import ReagentApplicationAdd from '@/components/ReagentProcess/ReagentApplicationAdd'
import ReagentReceive from '@/components/ReagentProcess/ReagentReceive.vue'
import ReagentReceiveDetail from '@/components/ReagentProcess/ReagentReceiveDetail.vue'
import ReagentReturnApp from '@/components/ReagentProcess/ReagentReturnApp'
import ReagentExpend from '@/components/ReagentProcess/ReagentExpend'
import DangerApprove from '@/components/ReagentProcess/DangerApprove'

import OrderManage from '@/components/ReagentManage/OrderManage'
import DamageReagent from '@/components/ReagentManage/DamageReagent'
import OrderApprove from '@/components/ReagentManage/OrderApprove'
import ApplicationManage from '@/components/ReagentManage/ApplicationManage'
import ApplicationOrderManage from '@/components/ReagentManage/ApplicationOrderManage'
import ApplicationOrderAdd from '@/components/ReagentManage/ApplicationOrderAdd'
import ProvideReagent from '@/components/ReagentManage/ProvideReagent'
import OrderApplication from '@/components/ReagentManage/OrderApplication'
import OrderReagent from '@/components/ReagentManage/OrderReagent'

import ComStatistic from '@/components/Statistic/ComStatistic'
import ComStatisticDetail from '@/components/Statistic/ComStatisticDetail'
import DeptComStatistic from '@/components/Statistic/DeptComStatistic'
import DeptComStatisticDetail from '@/components/Statistic/DeptComStatisticDetail'
import ReportManage from '@/components/Statistic/ReportManage'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Login',
      component: Login
    },
    {
      path: '/MainBoard',
      component: MainBoard,
      children: [
        {
          path: '/',
          name: 'QuickStart',
          component: QuickStart
        },
        {
          path: '/DepartmentSet',
          component: DepartmentSet
        },
        {
          path: '/ReagentTypeSet',
          component: ReagentTypeSet
        },
        {
          path: '/ReagentStateSet',
          component: ReagentStateSet
        },
        {
          path: '/DangerTypeSet',
          component: DangerTypeSet
        },
        {
          path: '/ModuleSet',
          component: ModuleSet
        },
        {
          path: '/PuritySet',
          component: PuritySet
        },
        {
          path: '/SupplierManage',
          component: SupplierManage
        },
        {
          path: '/ReagentInfoManage',
          component: ReagentInfoManage
        },
        {
          path: '/ReagentStockManage',
          component: ReagentStockManage
        },
        {
          path: '/RoleManage',
          component: RoleManage
        },
        {
          path: '/UserManage',
          component: UserManage
        },
        {
          path: '/ReagentApplication',
          component: ReagentApplication
        },
        {
          path: '/ReagentApplicationAdd',
          component: ReagentApplicationAdd
        },
        {
          path: '/ReagentReceive',
          component: ReagentReceive
        },
        {
          path: '/ReagentReceiveDetail',
          component: ReagentReceiveDetail
        },
        {
          path: '/ReagentReturnApp',
          component: ReagentReturnApp
        },
        {
          path: '/ReagentExpend',
          component: ReagentExpend
        },
        {
          path: '/DangerApprove',
          component: DangerApprove
        },
        {
          path: '/ProvideReagent',
          component: ProvideReagent
        },
        {
          path: '/OrderApplication',
          component: OrderApplication
        },
        {
          path: '/ApplicationManage',
          component: ApplicationManage
        },
        {
          path: '/ApplicationOrderManage',
          component: ApplicationOrderManage
        },
        {
          path: '/ApplicationOrderAdd',
          component: ApplicationOrderAdd
        },
        {
          path: '/OrderManage',
          component: OrderManage
        },
        {
          path: '/OrderReagent',
          component: OrderReagent
        },
        {
          path: '/DamageReagent',
          component: DamageReagent
        },
        {
          path: '/OrderApprove',
          component: OrderApprove
        },
        {
          path: '/ComStatistic',
          component: ComStatistic
        },
        {
          path: '/ComStatisticDetail',
          component: ComStatisticDetail
        },
        {
          path: '/DeptComStatistic',
          component: DeptComStatistic
        },
        {
          path: '/DeptComStatisticDetail',
          component: DeptComStatisticDetail
        },
        {
          path: '/ReportManage',
          component: ReportManage
        }
      ]
    }
  ]
})
