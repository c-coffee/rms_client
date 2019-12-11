<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>试剂发放</span>
            <el-button style="float: right; padding: 3px 10px" type="text"><router-link to="/ApplicationManage" tag="span">返回</router-link></el-button>
          </div>

          <el-row class="appInfo">
            <el-col :span="2">申领单号：</el-col>
            <el-col :span="4">{{this.appInfo.appID}}</el-col>
            <el-col :span="2">申领人：</el-col>
            <el-col :span="4">{{this.appInfo.userRealName}}</el-col>
            <el-col :span="2">申领时间：</el-col>
            <el-col :span="4">{{this.appInfo.appDate}}</el-col>
            <el-col :span="3">是否有危化：</el-col>
            <el-col :span="3">{{this.appInfo.dangerInfo}}</el-col>
          </el-row>
          <el-divider></el-divider>
          <el-table
            ref="providerTable"
            :data="appDetail"
            border
            size="mini"
            :row-class-name="tableRowClassName"
            >
              <el-table-column
                type="index"
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
                prop="appSpec"
                label="申领规格"
                align="center">
              </el-table-column>
              <el-table-column
                prop="appPurity"
                label="纯度"
                align="center">
              </el-table-column>
              <el-table-column
                prop="appNum"
                label="申领数量"
                align="center"
                width="70px">
              </el-table-column>
              <el-table-column
                prop="reagentUnit"
                label="单位"
                align="center"
                width="55px">
              </el-table-column>
              <el-table-column
                prop="reagentNum"
                label="库存量"
                align="center"
                width="70px">
              </el-table-column>
              <el-table-column
                prop="reagentSpec"
                label="发放规格"
                align="center"
                width="120px">
                <template slot-scope="scope">
                  <el-select
                  :disabled="scope.row.readonly"
                    v-model="scope.row.providerSpec"
                    size="mini"
                    @change="getStock(scope.row, scope.$index)">
                    <el-option
                      v-for="(item,index) in scope.row.specList"
                      :key="index"
                      :label="item"
                      :value="item"
                    >
                    </el-option>
                  </el-select>
                </template>
              </el-table-column>
              <el-table-column
                prop="providerNum"
                label="发放数量"
                align="center">
                <template slot-scope="scope">
                  <el-input-number :disabled="scope.row.readonly" style="width:110px" v-model="scope.row.providerNum"  value=0 :precision="2" :step="1" :min="0" :max="10000" @change="changeEditInput" size="mini"></el-input-number>
                </template>
              </el-table-column>
              <el-table-column
                prop="currentState"
                label="状态"
                align="center"
                width="70px">
              </el-table-column>
              <el-table-column
              label="操作"
              width="80px"
              align="center"
              prop="state">
                <template slot-scope="scope">
                  <el-button
                  :disabled="scope.row.disabled"
                  size="mini"
                  @click="provideReagent(scope.row)"
                  type="primary">{{opText(scope.row.appDetailState)}}</el-button>
                  <!-- <el-checkbox v-model="scope.row.checked" :disabled="scope.row.disabled" ></el-checkbox> -->
                </template>
              </el-table-column>
          </el-table>
          <el-divider></el-divider>
         </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'ReagentApplicationAdd',
  data () {
    return {
      appID: 0,
      // 初始试剂信息模拟数据
      appInfo: {},
      appDetail: [],
      stockInfoData: []
    }
  },
  methods: {
    opText (state) {
      if (state === 1) {
        return '撤回'
      }
      if (state === 2) {
        return '完成'
      }
      if (state === 0 || state === 3) {
        return '发放'
      }
    },
    // 判断试剂是否已经发放或者领取
    tableRowClassName ({row, rowIndex}) {
      if (row.appDetailState === 1) {
        return 'wrow'
      }
      if (row.appDetailState === 2) {
        return 'srow'
      }
      return ''
    },
    getStock (rowInfo, rowIndex) {
      let stockInfo = {
        reagentID: rowInfo.reagentID,
        stockSpec: rowInfo.providerSpec,
        stockPurity: rowInfo.appPurity
      }
      axios({
        method: 'get',
        url: '/api/stocks/getStock',
        params: {
          stockInfo
        }
      })
        .then((res) => {
          let tempNum
          if (res.data.results.length === 0) {
            tempNum = 0
            rowInfo.reagentUnit = rowInfo.reagentUnit + ' '
          } else {
            tempNum = res.data.results[0].reagentNum
            rowInfo.reagentUnit = rowInfo.reagentUnit + ' '
          }
          rowInfo.reagentNum = tempNum
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },
    // 界面初始化
    // 如果是由申请单管理页面点击修改调整过来，则读取申请单信息，初始化界面
    // 如果是点击添加按钮跳转过来，则直接初始化
    initAppInfo () {
      this.appInfo = this.$route.query.appInfo
      if (typeof (this.appInfo.appID) === 'undefined' || this.appInfo.appID === 0) {
        // 返回申领管理页面
        this.$router.push({path: '/ApplicationManage'})
      } else {
        axios({
          method: 'get',
          url: '/api/application/getAppReagentList',
          params: {
            appID: this.appInfo.appID
          }
        })
          .then((res) => {
            this.appDetail = res.data
            for (let i = 0; i < this.appDetail.length; i++) {
              if (this.appDetail[i].reagentNum === null) {
                this.appDetail[i].reagentNum = 0
              }
              this.appDetail[i].providerNum = this.appDetail[i].appNum
              this.appDetail[i].providerSpec = this.appDetail[i].appSpec
              this.appDetail[i].specList = this.appDetail[i].reagentSpec.split(',')
              switch (this.appDetail[i].appDetailState) {
                case 0:
                  this.appDetail[i].currentState = '未发放'
                  break
                case 1:
                  this.appDetail[i].currentState = '已发放'
                  this.appDetail[i].readonly = true
                  break
                case 2:
                  this.appDetail[i].currentState = '已收取'
                  this.appDetail[i].readonly = true
                  this.appDetail[i].disabled = true
                  break
                case 3:
                  this.appDetail[i].currentState = '已退回'
                  break
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
    // 发放试剂
    provideReagent (row) {
      // todo: 加入判断，如果当前状态为已经发送，点击撤销则回到待发送状态
      let urlAddr
      // 发放试剂
      if (row.appDetailState === 0 || row.appDetailState === 3) {
        urlAddr = '/api/application/providerReagent'

        if (row.reagentNum < row.providerNum) {
          this.$message({
            message: '库存数量不够，无法发放！',
            type: 'error'
          })
          return
        }
      }
      // 已发放状态,撤回试剂
      if (row.appDetailState === 1) {
        urlAddr = '/api/application/rollbackProvider'
      }

      this.$confirm('您确定撤回发放吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        // 未发放和已退回状态
        // console.log(row)
        // 判断库存量是否足够发放
        let providerInfo = {
          appID: row.appID,
          reagentID: row.reagentID,
          appDetialID: row.appDetialID,
          providerNum: row.providerNum,
          providerSpec: row.providerSpec,
          providerPurity: row.appPurity,
          state: row.state
        }
        axios({
          method: 'post',
          url: urlAddr,
          data: {
            provider: providerInfo
          }
        })
          .then((res) => {
            if (res.data.result === 1) {
              // 如果成功，则跳转到申请单列表界面
              this.$message({
                message: res.data.msg,
                type: 'success'
              })
              this.initAppInfo()
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
          message: '已取消提交'
        })
      })
    },
    // handleCurrentChange (currentPage) {
    //   this.currentPage = currentPage
    //   this.getStocksList()
    // },
    changeEditInput () {
      this.$forceUpdate()
    },
    getStocksList: function () {
      axios({
        method: 'get',
        url: '/api/stocks/getStocksList',
        params: {
          searchInfo: this.searchInfo,
          pageInfo: {
            pageSize: this.pageSize,
            currentPage: this.currentPage
          }
        }
      })
        .then((res) => {
          this.stockInfoData = res.data.data
          this.pageCount = res.data.count
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    }
    // filterState: function (value, row) {
    //   return row.applicationState === value
    // },
  },
  mounted: function () {
    this.initAppInfo()
    // this.getBaseInfoList()
  }
}
</script>

<style scope>
  .srow{
    background:  #C0C4CC !important;
  }
  .wrow{
    background: rgb(218, 240, 207) !important;
  }
  .appInfo{
    font-size: 14px
  }
  .supplierDetail .el-row{
    margin-bottom: 10px;
  }
  .detailTitle{
    color: #99a9bf;
    text-align: right;
  }
</style>
