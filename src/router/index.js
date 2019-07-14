import Vue from 'vue'
import Router from 'vue-router'
import MainBoard from '@/components/MainBoard'
import Login from '@/components/Login'
import DepartmentSet from '@/components/BaseSets/DepartmentSet'
import ReagentTypeSet from '@/components/BaseSets/ReagentTypeSet'
import DangerTypeSet from '@/components/BaseSets/DangerTypeSet'
import ModuleSet from '@/components/BaseSets/ModuleSet'

import SupplierManage from '@/components/DataManage/SupplierManage'
import ReagentInfoManage from '@/components/DataManage/ReagentInfoManage'

import ReagentApplication from '@/components/ReagentManage/ReagentApplication'
import ReagentApplicationAdd from '@/components/ReagentManage/ReagentApplicationAdd'
import ReagentReturnApp from '@/components/ReagentManage/ReagentReturnApp'
import ReagentExpend from '@/components/ReagentManage/ReagentExpend'
import DangerApprove from '@/components/ReagentManage/DangerApprove'
import ApplicationManage from '@/components/ReagentProcess/ApplicationManage'
import OrderManage from '@/components/ReagentProcess/OrderManage'
import OrderApprove from '@/components/ReagentProcess/OrderApprove'

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
          path: '/ReagentApplication',
          component: ReagentApplication
        },
        {
          path: '/ReagentApplicationAdd',
          component: ReagentApplicationAdd
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
