<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>申领审核</span>
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
              label="序号"
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
          </el-table-column>
          <el-table-column
            label="操作"
            width="220px"
            align="center">
              <template slot-scope="scope">
                <el-button
                size="mini"
                type="danger"
                @click="showRejectDlg(scope.$index, scope.row)">审核驳回</el-button>
                <el-button
                size="mini"
                type="success"
                @click="passApp(scope.$index, scope.row)">审核通过</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>
    <el-dialog
    title="审核驳回"
    :close-on-click-modal="false"
    :visible.sync="rejectDialogVisible"
    width="350px">
      <el-form :model="rejectForm" ref="rejectForm">
        <el-form-item
        label="驳回原因"
        label-width="100px"
        prop="approveReason"
        :rules="[
            {required: true, message:'驳回原因不能为空', trigger: 'blur'}
        ]">
          <el-input v-model="rejectForm.approveReason" type="textarea" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="rejectDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="rejectApp">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'ReagentApplication',
  data () {
    return {
      rejectForm: {}, // 驳回信息输入表单
      currentAppId: 0, // 当前处理的appId
      rejectDialogVisible: false, // 驳回理由输入窗口
      reagentAppDetail: [], // 初始试剂信息模拟数据
      reagentList: [],
      expands: [] // 表格中展开的行，对应表格中 :expand-row-keys 属性值，实现单行展开
    }
  },
  methods: {
    // 显示驳回窗口
    showRejectDlg: function (index, row) {
      this.currentAppId = row.appID
      this.rejectDialogVisible = true
    },
    rejectApp: function () {
      axios({
        method: 'post',
        url: '/api/application/appRject',
        data: {
          appId: this.currentAppId,
          approveReason: this.rejectForm.approveReason
        }
      })
        .then((res) => {
          // 获得反馈信息，给出提示，重新读取列表
          if (res.data.result === 1) {
            this.getApplicationList()
            this.rejectDialogVisible = false
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
    passApp: function (index, row) {
      this.$confirm('您确定通过审核吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        // 通知数据库进行审核操作
        axios({
          method: 'post',
          url: '/api/application/appApprove',
          data: {
            appId: row.appID
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
          console.log(res)
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
        url: '/api/application/getDangerAppList'
      })
        .then((res) => {
          this.reagentAppDetail = res.data
          console.log(res.data)
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
