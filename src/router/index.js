import Vue from 'vue'
import Router from 'vue-router'
import MainBoard from '@/components/MainBoard'
import Login from '@/components/Login'
import DepartmentSet from '@/components/BaseSets/DepartmentSet'
import ReagentTypeSet from '@/components/BaseSets/ReagentTypeSet'
import ReagentStateSet from '@/components/BaseSets/ReagentStateSet'
import DangerTypeSet from '@/components/BaseSets/DangerTypeSet'
import ModuleSet from '@/components/BaseSets/ModuleSet'

import SupplierManage from '@/components/DataManage/SupplierManage'
import ReagentInfoManage from '@/components/DataManage/ReagentInfoManage'
import ReagentStockManage from '@/components/DataManage/ReagentStockManage'
import RoleManage from '@/components/DataManage/RoleManage'
import UserManage from '@/components/DataManage/UserManage'

import ReagentApplication from '@/components/ReagentProcess/ReagentApplication'
import ReagentApplicationAdd from '@/components/ReagentProcess/ReagentApplicationAdd'
import ReagentReceive from '@/components/ReagentProcess/ReagentReceive.vue'
import ReagentReturnApp from '@/components/ReagentProcess/ReagentReturnApp'
import ReagentExpend from '@/components/ReagentProcess/ReagentExpend'
import DangerApprove from '@/components/ReagentProcess/DangerApprove'

import OrderManage from '@/components/ReagentManage/OrderManage'
import OrderApprove from '@/components/ReagentManage/OrderApprove'
import ApplicationManage from '@/components/ReagentManage/ApplicationManage'

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
      name: 'MainBoard',
      component: MainBoard,
      children: [
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
          path: '/ApplicationManage',
          component: ApplicationManage
        },
        {
          path: '/OrderManage',
          component: OrderManage
        },
        {
          path: '/OrderApprove',
          component: OrderApprove
        }
      ]
    }
  ]
})
