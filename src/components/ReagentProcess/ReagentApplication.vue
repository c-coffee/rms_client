<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>试剂申请</span>
            <el-button style="float: right; padding: 3px 0" type="text"><router-link to="/ReagentApplicationAdd" tag="span">添加</router-link></el-button>
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
              prop="userRealName"
              label="审核人"
              align="center">
          </el-table-column>
          <el-table-column
              prop="approveReason"
              label="驳回原因"
              align="center">
          </el-table-column>
          <el-table-column
          prop="stepName"
          label="当前流程"
          :filters="[{text:'待提交',value:'待提交'},{text:'待审核',value:'待审核'},{text:'已驳回',value:'已驳回'},{text:'待受理',value:'待受理'}]"
          :filter-method="filterState"
          >
            <template slot-scope="scope">
              <el-tooltip :disabled="scope.row.disabledRejectInfo" class="item" effect="dark" :content="scope.row.approveReason" placement="top-start">
                <el-tag :type="scope.row.tagType">{{scope.row.stepName}}</el-tag>
              </el-tooltip>
            </template>
          </el-table-column>
          <el-table-column
            label="操作"
            width="220px"
            align="center">
              <template slot-scope="scope">
                <el-button
                size="mini"
                type="info"
                :disabled="buttonChk(scope.row)"
                @click="handleEdit(scope.$index, scope.row)">修改</el-button>
                <el-button
                size="mini"
                type="danger"
                :disabled="buttonChk(scope.row)"
                @click="handleDelete(scope.$index, scope.row)">删除</el-button>
                <el-button
                size="mini"
                type="primary"
                :disabled="buttonChk(scope.row)"
                @click="handleSubmit(scope.$index, scope.row)">提交</el-button>
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
  name: 'ReagentApplication',
  data () {
    return {
      // 初始试剂信息模拟数据
      reagentAppDetail: [],
      reagentList: [],
      expands: [] // 表格中展开的行，对应表格中 :expand-row-keys 属性值，实现单行展开
    }
  },
  methods: {
    // 用以判断按钮的禁用状态
    buttonChk: function (row) {
      if (row.stepName === '待提交' || row.stepName === '已驳回') {
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
          // console.log(res)
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
    showAddDialog: function () {
      this.addSupplierDialogVisible = true
    },
    handleDelete: function (index, row) {
      this.$confirm('您确定删除申请信息吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        // 通知数据库进行删除
        axios({
          method: 'post',
          url: '/api/application/deleteApplication',
          data: {
            appID: row.appID
          }
        })
          .then((res) => {
            // 获得反馈信息，给出提示，重新读取列表
            if (res.data.result === 1) {
              this.getApplicationList()
              this.$message({
                type: 'success',
                message: res.data.msg
              })
            } else {
              this.$message({
                type: 'error',
                message: res.data.msg
              })
            }
          })
          .catch((err) => {
            console.log(err)
            this.$message({
              message: '服务器错误！',
              type: 'error'
            })
          })
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消删除'
        })
      })
    },
    handleEdit: function (index, row) {
      // 路由跳转带参数
      this.$router.push({path: '/ReagentApplicationAdd', query: {appID: row.appID}})
    },
    handleSubmit: function (index, row) {
      axios({
        method: 'post',
        url: '/api/application/submitApp',
        data: {
          appId: row.appID,
          hasDanger: row.hasDanger
        }
      })
        .then((res) => {
          // console.log(res)
          if (res.data.result === 1) {
            this.getApplicationList()
            this.$message({
              message: res.data.msg,
              type: 'success'
            })
          } else {
            this.$message({
              message: res.data.msg,
              type: 'error'
            })
          }
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },
    getApplicationList () {
      axios({
        method: 'get',
        url: '/api/application/getApplicationList'
      })
        .then((res) => {
          this.reagentAppDetail = res.data
          for (let i = 0; i < this.reagentAppDetail.length; i++) {
            if (this.reagentAppDetail[i].stepID === 3) {
              this.reagentAppDetail[i].tagType = 'danger' // 设置当前步骤所用模版
              this.reagentAppDetail[i].disabledRejectInfo = false
            } else {
              this.reagentAppDetail[i].disabledRejectInfo = true
            }
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
    this.getApplicationList()
  }
}
</script>

<style scoped>
  .supplierDetail .el-row{
    margin-bottom: 10px;
  }
  .detailTitle{
    color: #99a9bf;
    text-align: right;
  }
</style>
