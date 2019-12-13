<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>采购管理</span>
          </div>
          <el-table
          :data="orderList"
          style="width: 100%"
          max-height="450"
          size="mini"
          row-key="orderID"
          lazy
          ref="orderTable"
          @expand-change="loadDetail"
          :expand-row-keys="expands"
          >
          <el-table-column type="expand">
            <template>
              <el-table
                :data="orderDetail"
                border
                size="mini"
              >
                <el-table-column
                  prop="orderDetailID"
                  label="序号"
                  align="center"
                  width="50px">
                </el-table-column>
                <el-table-column
                  prop="reagentName"
                  label="试剂名称"
                  align="center">
                </el-table-column>
                <el-table-column
                  prop="typeName"
                  label="类型"
                  align="center"
                  width="100px">
                </el-table-column>
                <el-table-column
                  prop="orderPurity"
                  label="纯度"
                  align="center">
                </el-table-column>
                <el-table-column
                  prop="orderSpec"
                  label="规格"
                  align="center">
                </el-table-column>
                <el-table-column
                  prop="orderNum"
                  label="申购数"
                  align="center"
                  width="60px">
                </el-table-column>
                <el-table-column
                  prop="supplierName"
                  label="供应商"
                  align="center">
                </el-table-column>
                <el-table-column
                  label="操作"
                  align="center">
                  <template slot-scope="scope">
                    <el-button
                    size="mini"
                    type="text"
                    round
                    :disabled="scope.row.disableModify"
                    @click="handleChoice(scope.row)">库存</el-button>
                    <el-button
                    size="mini"
                    type="primary"
                    round
                    :disabled="scope.row.disableModify"
                    @click="handleChoice(scope.row)">供应商</el-button>
                  </template>
                </el-table-column>
              </el-table>
            </template>
          </el-table-column>
          <el-table-column
              prop="orderID"
              label="序号"
              width="180"
              align="center">
          </el-table-column>
          <el-table-column
              prop="userRealName"
              label="申请人"
              align="center">
          </el-table-column>
          <el-table-column
              prop="applyDate"
              label="申请时间"
              align="center">
          </el-table-column>
          <el-table-column
              prop="stepName"
              label="当前步骤"
              align="center"
              :filters="[{text:'待提交',value:10},{text:'待处理',value:11},{text:'询价中',value:12},{text:'待审核',value:13},{text:'申购驳回',value:14},{text:'采购驳回',value:15},{text:'采购中',value:16},{text:'已完成',value:17}]"
              :filter-method="filterState"
              >
          </el-table-column>
          <el-table-column
            label="操作"
            width="300px"
            align="center">
              <template slot-scope="scope">
                <el-button
                size="mini"
                type="danger"
                :disabled="scope.row.disableModify"
                @click="handleReject(scope.$index, scope.row)">驳回</el-button>
                <el-button
                size="mini"
                type="success"
                :disabled="scope.row.disableModify"
                @click="handleEnquiry(scope.row)">管理</el-button>
                <el-button
                size="mini"
                type="primary"
                :disabled="scope.row.disableModify"
                @click="handleSubmit(scope.$index, scope.row)">提交审核</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>
    <el-dialog
      title="驳回原因"
      :visible.sync="dialogRejectVisible"
      width="350px"
      :close-on-click-modal="false">
      <el-form :model="rejectForm">
        <el-form-item>
          <el-input v-model="rejectForm.reason" type="textarea" rows="4" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogRejectVisible = false">取 消</el-button>
        <el-button type="primary" @click="saveReject">确 定</el-button>
      </div>
    </el-dialog>
    <el-dialog
      title="选择供应商"
      :visible.sync="dialogChoiceSupplierVisible"
      :close-on-click-modal="false">
        <el-table
        border
        :data="supplierList">
          <el-table-column
            prop="supplierID"
            label="序号"
            width="50"
            align="center">
          </el-table-column>
          <el-table-column
            prop="supplierName"
            label="名称"
            align="center">
          </el-table-column>
          <el-table-column
            prop="supplierContact"
            label="联系人"
            align="center">
          </el-table-column>
          <el-table-column
            prop="supplierContactPhone"
            label="电话"
            align="center">
          </el-table-column>
          <el-table-column
            prop="supplierLevel"
            label="等级"
            width="50"
            align="center">
          </el-table-column>
          <el-table-column
            label="操作"
            align="center">
            <template slot-scope="scope">
              <el-button
              size="mini"
              type="success"
              :disabled="scope.row.disableModify"
              @click="handleChoiceSupplier(scope.row)">选择</el-button>
            </template>
          </el-table-column>
        </el-table>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'OrderManage',
  data () {
    return {
      supplierList: [], // 供应商信息
      orderList: [],
      orderDetail: [],
      expands: [], // 表格中展开的行，对应表格中 :expand-row-keys 属性值，实现单行展开
      dialogRejectVisible: false, // 驳回窗口控制标志
      dialogChoiceSupplierVisible: false, // 选择供应商窗口标志
      rejectForm: {
        orderID: 0,
        reason: ''
      },
      choiceInfo: {
        orderDetailID: 0,
        supplierID: 0,
        supplierName: '',
        orderRow: ''
      }
    }
  },
  methods: {
    handleChoiceSupplier: function (row) {
      this.choiceInfo.supplierID = row.supplierID
      axios({
        method: 'post',
        url: '/api/order/setOrderSupplier',
        data: {
          choiceInfo: {
            supplierID: this.choiceInfo.supplierID,
            orderDetailID: this.choiceInfo.orderDetailID
          }
        }
      })
        .then((res) => {
          if (res.data.result === 1) {
            // 设置成功
            this.dialogChoiceSupplierVisible = false
            this.loadDetail(this.choiceInfo.orderRow, [this.choiceInfo.orderRow])
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
    getSupplierList: function () {
      // 获取供应商列表
      // 是否需要做分页，待定
      axios({
        method: 'get',
        url: '/api/supplier/getSupplierList'
      })
        .then((res) => {
          this.supplierList = res.data
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },
    handleChoice: function (row) {
      this.choiceInfo.orderDetailID = row.orderDetailID
      this.choiceInfo.orderRow = row
      this.dialogChoiceSupplierVisible = true
    },
    getOrderList: function () {
      axios({
        method: 'get',
        url: '/api/order/getOrderList',
        params: {
          stepInfo: 'orderManage'
        }
      })
        .then((res) => {
          this.orderList = res.data
          // 修改，删除，提交按钮状态，只有在当前申购单处于待提交状态时，可以使用
          // 待提交状态值为 11 ,参见 stepList 表
          for (let i = 0; i < this.orderList.length; i++) {
            if (this.orderList[i].stepID === 11 || this.orderList[i].stepID === 15 || this.orderList[i].stepID === 12) {
              this.orderList[i].disableModify = false
            } else {
              this.orderList[i].disableModify = true
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
    },
    filterState: function (value, row) {
      return row.stepID === value
    },
    handleReject: function (value, row) {
      this.rejectForm.orderID = row.orderID
      this.dialogRejectVisible = true
    },
    handleSubmit: function (index, row) {
      // 服务器端验证是否全部供应商已经选择
      this.$confirm('您确定提交申购单吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        axios({
          method: 'get',
          url: '/api/order/submitOrderApp',
          params: {
            orderID: row.orderID
          }
        })
          .then((res) => {
            // 获得反馈信息，给出提示，重新读取列表
            if (res.data.result === 1) {
              this.getOrderList()
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
          message: '已取消提交'
        })
      })
    },
    loadDetail: function (row, expandedRows) {
      let that = this
      if (expandedRows.length) {
        that.expands = []
        if (row) {
          that.expands.push(row.orderID)
        }
      } else {
        that.expands = []
      }
      axios({
        method: 'get',
        url: '/api/order/getOrderDetail',
        params: {
          orderID: row.orderID
        }
      })
        .then((res) => {
          this.orderDetail = res.data
          for (let i = 0; i < this.orderDetail.length; i++) {
            if (this.orderDetail[i].reagentNum === null) {
              this.orderDetail[i].reagentNum = 0
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
    },
    handleEnquiry: function (row) {
      if (this.$refs['orderTable'].expandRowKeys.length === 0) {
        this.loadDetail(row, [row])
      } else {
        this.loadDetail(row, [])
      }
    },
    saveReject: function () {
      // 保存驳回理由，改变申购单状态
      axios({
        method: 'post',
        url: '/api/order/saveAppReject',
        data: {
          rejectInfo: this.rejectForm
        }
      })
        .then((res) => {
          this.dialogRejectVisible = false
          this.getOrderList()
          this.$message({
            type: 'success',
            message: res.data.msg
          })
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
    this.getOrderList()
    this.getSupplierList()
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
