<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>申购管理</span>
            <el-button style="float: right; padding: 3px 0" type="text"><router-link to="/ApplicationOrderAdd" tag="span">新建申购</router-link></el-button>
          </div>
          <el-table
          :data="orderList"
          ref="orderTable"
          style="width: 100%"
          max-height="650"
          size="mini"
          row-key="orderID"
          lazy
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
                  prop="reagentUnit"
                  label="单位"
                  align="center">
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
                  prop="reagentNum"
                  label="库存"
                  align="center">
                </el-table-column>
                <el-table-column
                  prop="orderNum"
                  label="申购数量"
                  align="center">
                </el-table-column>
                <el-table-column
                  prop="supplierName"
                  label="供应商"
                  align="center">
                </el-table-column>
                <el-table-column
                  label="选择"
                  align="center">
                  <template slot-scope="scope">
                    <el-button
                    size="mini"
                    type="warning"
                    round
                    :disabled="scope.row.disableChoice"
                    @click="handleChoice(scope.row)">选择</el-button>
                  </template>
                </el-table-column>
              </el-table>
            </template>
          </el-table-column>
          <el-table-column
              prop="orderID"
              label="序号"
              width="80"
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
              :filter-method="filterState">
              <template slot-scope="scope">
                <el-tooltip :disabled="scope.row.showRejectInfo" class="item" effect="dark" :content="scope.row.applyRejectReason" placement="top-start">
                  <el-tag :type="scope.row.tagType">{{scope.row.stepName}}</el-tag>
                </el-tooltip>
              </template>
          </el-table-column>
          <el-table-column
            label="操作"
            width="350px"
            align="center">
              <template slot-scope="scope">
                <el-button
                size="mini"
                type="success"
                :disabled="scope.row.disableModify"
                @click="handleEdit(scope.$index, scope.row)">修改</el-button>
                <el-button
                size="mini"
                type="danger"
                :disabled="scope.row.disableModify"
                @click="handleDelete(scope.$index, scope.row)">删除</el-button>
                <el-button
                size="mini"
                type="primary"
                :disabled="scope.row.disableModify"
                @click="handleSubmit(scope.$index, scope.row)">提交</el-button>
                <el-button
                size="mini"
                type="warning"
                :disabled="scope.row.disableInStock"
                @click="handleStockIn(scope.row)">入库</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>
    <el-dialog
      title="入库"
      :visible.sync="dialogStockInVisible"
      :close-on-click-modal="false">
      <el-card class="box-card">
        <el-row>
          <el-col :span="4">名称：</el-col>
          <el-col :span="8">{{stockInInfo.reagentName}}</el-col>
          <el-col :span="4">单位：</el-col>
          <el-col :span="8">{{stockInInfo.reagentUnit}}</el-col>
        </el-row>
        <el-row class="center-row">
          <el-col :span="4">申购数量：</el-col>
          <el-col :span="8">{{stockInInfo.orderNum}}</el-col>
          <el-col :span="4">供应商：</el-col>
          <el-col :span="8">{{stockInInfo.supplierName}}</el-col>
        </el-row>
        <el-row>
          <el-col :span="4">申购规格：</el-col>
          <el-col :span="8">{{stockInInfo.orderSpec}}</el-col>
          <el-col :span="4">申购纯度：</el-col>
          <el-col :span="8">{{stockInInfo.orderPurity}}</el-col>
        </el-row>
        <el-row>
          <el-col><el-divider></el-divider></el-col>
        </el-row>
        <el-row>
         <el-col>
           <el-form ref="form" :model="stockInForm" label-width="80px">
            <el-form-item label="入库数量">
              <el-input-number v-model="stockInForm.reagentNum" style="width:200px" :min="1" :max="10000" :step="1" label="入库数量"></el-input-number>
            </el-form-item>
            <el-form-item label="入库纯度" class="formItem">
              <el-select v-model="stockInForm.orderPurity" placeholder="请选择入库纯度" style="width:200px">
                <el-option
                  v-for="item in purityData"
                  :key="item.purityID"
                  :label="item.purityName"
                  :value="item.purityName">
                </el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="入库规格"  class="formItem">
              <el-select
              v-model="stockInForm.orderSpec"
              placeholder="请选择入库规格"
              style="width:200px">
                <el-option
                  v-for="(item,index) in stockInInfo.specList"
                  :key="index"
                  :label="item"
                  :value="item">
                </el-option>
              </el-select>
            </el-form-item>
           </el-form>
         </el-col>
        </el-row>
        <el-row><el-col></el-col></el-row>
      </el-card>
      <span slot="footer" class="dialog-footer">
        <el-checkbox v-model="stockInForm.hasFinished" style="float:left">完成采购</el-checkbox>
        <el-button @click="dialogStockInVisible = false">取 消</el-button>
        <el-button type="primary" @click="saveStockIn">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'ApplicationOrderManage',
  data () {
    return {
      dialogStockInVisible: false, // 入库窗口显示标志
      stockInInfo: {},
      stockInForm: {
        orderSpec: '',
        orderPurity: '',
        hasFinished: true,
        reagentNum: 0
      },
      orderList: [],
      purityData: [],
      orderDetail: [],
      expands: [] // 表格中展开的行，对应表格中 :expand-row-keys 属性值，实现单行展开
    }
  },
  methods: {
    saveStockIn: function () {
      // 商品入库
      axios({
        method: 'post',
        url: '/api/order/saveStockIn',
        data: {
          stockInInfo: this.stockInForm
        }
      })
        .then((res) => {
          this.dialogStockInVisible = false
          if (res.data.result === 1) {
            // 入库操作成功
            this.loadDetail(this.stockInForm, [this.stockInForm])
            this.$message({
              message: res.data.msg,
              type: 'success'
            })
          }
          if (res.data.result === 2) {
            // 入库操作成功，订单已完成
            this.getOrderList()
            this.$message({
              message: res.data.msg,
              type: 'success'
            })
          }
          if (res.data.result === 3) {
            // 部分入库成功
            this.$message({
              message: res.data.msg,
              type: 'success'
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
    getPurityList: function () {
      axios({
        method: 'get',
        url: '/api/puritySet/getPurityList'
      })
        .then((res) => {
          this.purityData = res.data
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
      // console.log(row)
      this.stockInInfo = row
      for (let i = 0; i < this.orderDetail.length; i++) {
        if (this.orderDetail[i].orderDetailID === row.orderDetailID) {
          this.stockInInfo.specList = this.orderDetail[i].reagentSpec.split(',')
          break
        }
      }

      this.stockInForm.reagentNum = row.orderNum
      this.stockInForm.reagentID = row.reagentID
      this.stockInForm.orderPurity = row.orderPurity
      this.stockInForm.orderSpec = row.orderSpec
      this.stockInForm.orderDetailID = row.orderDetailID
      this.stockInForm.orderID = row.orderID

      this.dialogStockInVisible = true
    },
    handleStockIn: function (row) {
      // 入库处理
      if (this.$refs['orderTable'].expandRowKeys.length === 0) {
        this.loadDetail(row, [row])
      } else {
        this.loadDetail(row, [])
      }
    },
    getOrderList: function () {
      axios({
        method: 'get',
        url: '/api/order/getOrderList',
        params: {
          stepInfo: 'ApplicationOrderManage'
        }
      })
        .then((res) => {
          this.orderList = res.data
          // 修改，删除，提交按钮状态，只有在当前申购单处于待提交状态时，可以使用
          // 待提交状态值为 10 ,申购驳回状态值为 14,参见 stepList 表
          for (let i = 0; i < this.orderList.length; i++) {
            this.orderList[i].tagType = 'info'
            if (this.orderList[i].stepID === 10) {
              // 待提交
              this.orderList[i].disableModify = false // 控制是否显示修改，删除，提交按钮
              this.orderList[i].tagType = 'success' // 设置当前步骤所用模版
            } else {
              this.orderList[i].disableModify = true
            }
            if (this.orderList[i].stepID === 16) {
              // 入库
              this.orderList[i].disableInStock = false // 控制是否显示入库按钮
            } else {
              this.orderList[i].disableInStock = true
            }
            if (this.orderList[i].stepID === 14) {
              // 申购驳回
              this.orderList[i].tagType = 'danger' // 设置当前步骤所用模版
              this.orderList[i].disableModify = false // 控制是否显示修改，删除，提交按钮
              this.orderList[i].showRejectInfo = false // 控制是否显示 驳回信息提示
            } else {
              this.orderList[i].showRejectInfo = true
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
    handleDelete: function (index, row) {
      this.$confirm('您确定删除申购单吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'error'
      }).then(() => {
        axios({
          method: 'get',
          url: '/api/order/deleteOrderApp',
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
          message: '已取消删除'
        })
      })
    },
    handleSubmit: function (index, row) {
      this.$confirm('您确定提交申购单吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'info'
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
    handleEdit: function (index, row) {
      // 路由跳转带参数
      this.$router.push({path: '/ApplicationOrderAdd', query: {orderID: row.orderID}})
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
            if (this.orderDetail[i].state === 1) {
              this.orderDetail[i].disableChoice = true
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
    this.getOrderList()
    this.getPurityList()
  }
}
</script>

<style scoped>
  .box-card{
    margin-top:-10px
  }
  .center-row{
    margin: 10px 0
  }
  .formItem{
    margin-top: -10px;
  }
</style>
