<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>试剂申请管理</span>
          </div>
          <el-table
          :data="reagentAppDetail"
          style="width: 100%"
          max-height="450"
          size="mini"
          row-key="appID"
          lazy
          @expand-change="loadDetail"
          :expand-row-keys="expands"
          >
          <el-table-column type="expand">
            <template>
              <el-table
                :data="reagentList"
                border
                size="mini"
                :row-class-name="checkStock"
              >
              <el-table-column
                prop="appDetialID"
                label="序号"
                width="50px"
                align="center">
              </el-table-column>
              <el-table-column
                prop="reagentName"
                label="试剂名称"
                align="center">
              </el-table-column>
              <el-table-column
                prop="typeName"
                label="类型"
                align="center">
              </el-table-column>
              <el-table-column
                prop="appSpec"
                label="规格"
                align="center">
              </el-table-column>
              <el-table-column
                prop="appPurity"
                label="纯度"
                align="center">
              </el-table-column>
              <el-table-column
                prop="appNum"
                label="数量"
                align="center">
              </el-table-column>
              <el-table-column
                prop="remark"
                label="备注"
                align="center">
              </el-table-column>
              </el-table>
            </template>
          </el-table-column>
          <el-table-column
              prop="appID"
              label="单号"
              width="50"
              align="center">
          </el-table-column>
          <el-table-column
              prop="userRealName"
              label="申请人"
              align="center">
          </el-table-column>
          <el-table-column
              prop="appDate"
              label="申请时间"
              align="center">
          </el-table-column>
          <el-table-column
              prop="dangerInfo"
              label="是否有危化"
              align="center">
          </el-table-column>
          <el-table-column
              prop="approverName"
              label="审核人"
              align="center">
          </el-table-column>
          <el-table-column
              prop="stepName"
              label="当前流程"
              :filters="[{text:'待提交',value:'待提交'},{text:'待审核',value:'待审核'},{text:'已驳回',value:'已驳回'},{text:'待受理',value:'待受理'}]"
              :filter-method="filterState"
              >
          </el-table-column>
          <el-table-column
            label="操作"
            width="170px"
            align="center">
              <template slot-scope="scope">
                <el-button
                size="mini"
                type="primary"
                :disabled="buttonChk(scope.row)"
                @click="handleProvide(scope.$index, scope.row)">发放</el-button>
                <el-button
                size="mini"
                type="success"
                :disabled="buttonChk(scope.row)"
                @click="orderApp(scope.$index, scope.row)">申请采购</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'ApplicationManage',
  data () {
    return {
      // 初始试剂信息模拟数据
      reagentAppDetail: [],
      reagentList: [],
      expands: [] // 表格中展开的行，对应表格中 :expand-row-keys 属性值，实现单行展开
    }
  },
  methods: {
    // 设置行的背景色
    checkStock: function (rowInfo) {
      // return 'lackStock'
      // console.log(rowInfo.row.stockNum, rowInfo.row.reagentNum)
      if (rowInfo.row.stockNum < rowInfo.row.reagentNum) {
        return 'lackStock'
      } else {
        return ''
      }
    },
    // 用以判断按钮的禁用状态
    buttonChk: function (row) {
      if (row.stepID === 4) {
        return false
      } else {
        return true
      }
    },
    // 点开详情懒加载申购试剂数据
    loadDetail: function (row, expandedRows) {
      let that = this
      if (expandedRows.length) {
        that.expands = []
        if (row) {
          that.expands.push(row.appID)
        }
      } else {
        that.expands = []
      }
      axios({
        method: 'get',
        url: '/api/application/getAppReagentList',
        params: {
          appID: row.appID
        }
      })
        .then((res) => {
          this.reagentList = res.data
          // console.log(res)
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },
    filterState: function (value, row) {
      return row.stepName === value
    },
    handleProvide: function (index, row) {
      // 路由跳转带参数
      this.$router.push({path: '/ProvideReagent', query: {appInfo: row}})
    },
    orderApp: function (index, row) {
      // 申请采购
      this.$router.push({path: '/orderApplication', query: {appInfo: row}})
    },
    getApplicationList () {
      axios({
        method: 'get',
        url: '/api/application/getSubmitAppList'
      })
        .then((res) => {
          this.reagentAppDetail = res.data
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
    this.getApplicationList()
  }
}
</script>

<style>
  .el-table .lackStock{
    background: oldlace
  }
</style>
