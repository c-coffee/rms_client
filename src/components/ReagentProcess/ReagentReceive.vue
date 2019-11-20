<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>试剂领取管理</span>
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
                :row-class-name="tableRowClassName"
              >
              <el-table-column
                prop="appDetialID"
                label="序号"
                width="45px"
                align="center">
              </el-table-column>
              <el-table-column
                prop="reagentName"
                label="试剂名称"
                align="center">
              </el-table-column>
              <el-table-column
                prop="reagentUnit"
                label="单位"
                align="center"
                width="45px">
              </el-table-column>
              <el-table-column
                prop="appPurity"
                label="纯度"
                align="center">
              </el-table-column>
              <el-table-column
                prop="appSpec"
                label="申请规格"
                align="center">
              </el-table-column>
              <el-table-column
                prop="appNum"
                label="申请数量"
                align="center">
              </el-table-column>
              <el-table-column
                prop="providerSpec"
                label="发放规格"
                align="center">
              </el-table-column>
              <el-table-column
                prop="providerNum"
                label="发放数量"
                align="center">
              </el-table-column>
              <el-table-column
                prop="currentState"
                label="状态"
                align="center">
              </el-table-column>
              <el-table-column
                prop="remark"
                label="操作"
                align="center"
                width="160px">
                <template slot-scope="scope">
                  <el-button
                  size="mini"
                  type="primary"
                  @click="receiveReagent(scope.row)"
                  :disabled="scope.row.disabled">收取</el-button>
                  <el-button
                  size="mini"
                  type="danger"
                  @click="returnReagent(scope.row)"
                  :disabled="scope.row.disabled">退回</el-button>
                </template>
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
              prop="approverName"
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
              :filters="[{text:'待受理',value:'待受理'},{text:'待收取',value:'待收取'},{text:'申购中',value:'申购中'},{text:'已完成',value:'已完成'}]"
              :filter-method="filterState"
              >
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
    // 收取试剂
    receiveReagent (row) {
      console.log(row)
      this.$confirm('您确定收取吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        axios({
          method: 'post',
          url: '/api/receiveProcess/receiveReagent',
          data: {
            reagentInfo: {
              appDetialID: row.appDetialID,
              reagentID: row.reagentID,
              providerNum: row.providerNum,
              providerSpec: row.providerSpec,
              appPurity: row.appPurity,
              appID: row.appID
            }
          }
        })
          .then((res) => {
            if (res.data.result === 1) {
              // 如果成功，则跳转到申请单列表界面
              row.appDetailState = 2
              row.currentState = '已收取'
              row.disabled = true
              this.$message({
                message: res.data.msg,
                type: 'success'
              })
              this.getApplicationList()
            } else {
              this.$message({
                message: res.data.msg,
                type: 'error'
              })
            }
          })
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消收取'
        })
      })
    },
    // 退回试剂
    returnReagent (row) {
      console.log(row)
      this.$confirm('您确定退回吗? ', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        axios({
          method: 'post',
          url: '/api/receiveProcess/returnReagent',
          data: {
            reagentInfo: {
              appID: row.appID,
              reagentID: row.reagentID,
              appDetialID: row.appDetialID,
              providerNum: row.providerNum,
              providerSpec: row.providerSpec,
              providerPurity: row.stockPurity,
              stockID: row.stocksID,
              state: row.state
            }
          }
        })
          .then((res) => {
            if (res.data.result === 1) {
              // 如果成功，则跳转到申请单列表界面
              row.appDetailState = 3
              row.currentState = '已退回'
              row.disabled = true
              this.$message({
                message: res.data.msg,
                type: 'success'
              })
              this.getApplicationList()
            } else {
              this.$message({
                message: res.data.msg,
                type: 'error'
              })
            }
          })
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消收取'
        })
      })
    },
    // 行颜色控制
    tableRowClassName ({row, rowIndex}) {
      if (row.appDetailState === 1) {
        return 'wrow1'
      }
      if (row.appDetailState === 2) {
        return 'srow1'
      }
      return ''
    },
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
          this.reagentList = res.data
          for (let i = 0; i < this.reagentList.length; i++) {
            switch (this.reagentList[i].appDetailState) {
              case 0:
                this.reagentList[i].currentState = '未发放'
                this.reagentList[i].disabled = true
                break
              case 1:
                this.reagentList[i].currentState = '已发放'
                break
              case 2:
                this.reagentList[i].currentState = '已收取'
                this.reagentList[i].disabled = true
                break
              case 3:
                this.reagentList[i].currentState = '已退回'
                this.reagentList[i].disabled = true
                break
            }
          }
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
    getApplicationList () {
      axios({
        method: 'get',
        url: '/api/application/getReceiveList'
      })
        .then((res) => {
          console.log(res)
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
  .srow1{
    background:  #C0C4CC !important;
  }
  .wrow1{
    background: rgb(218, 240, 207) !important;
  }
  .supplierDetail .el-row{
    margin-bottom: 10px;
  }
  .detailTitle{
    color: #99a9bf;
    text-align: right;
  }
</style>
