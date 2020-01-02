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
            :default-expand-all="false"
            >
              <el-table-column type="expand">
                <template slot-scope="props">
                  <el-table
                    :data="props.row.provideDetail"
                    border
                    size="mini">
                    <el-table-column
                      type="index"
                      label="序号"
                      align="center"
                      width="50px">
                    </el-table-column>
                    <el-table-column
                      prop="reagentName"
                      label="发放试剂"
                      align="center">
                    </el-table-column>
                    <el-table-column
                      prop="stockBatchNo"
                      label="批号"
                      align="center">
                    </el-table-column>
                    <el-table-column
                      prop="stockRecordNo"
                      label="备案号"
                      align="center">
                    </el-table-column>
                    <el-table-column
                      prop="stockPurity"
                      label="纯度"
                      align="center">
                    </el-table-column>
                    <el-table-column
                      prop="stockSpec"
                      label="规格"
                      align="center">
                    </el-table-column>
                    <el-table-column
                      prop="composition"
                      label="含量"
                      align="center">
                    </el-table-column>
                    <el-table-column
                      prop="stockBrand"
                      label="来源"
                      align="center">
                    </el-table-column>
                    <el-table-column
                      prop="expiryDate"
                      label="保质期"
                      align="center">
                    </el-table-column>
                    <el-table-column
                      prop="reagentNum"
                      label="数量"
                      align="center"
                      width="60px">
                    </el-table-column>
                    <el-table-column
                      label="操作"
                      align="center"
                      width="80px">
                      <template slot-scope="scope">
                        <el-button
                        :disabled="scope.row.OPdisabled"
                        size="mini"
                        @click="rollbackReagent(scope.row)"
                        type="danger">撤回</el-button>
                      </template>
                    </el-table-column>
                  </el-table>
                </template>
              </el-table-column>
              <el-table-column
                prop="appDetailID"
                label="编号"
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
                align="center"
                width="80px">
              </el-table-column>
              <el-table-column
                prop="appPurity"
                label="申领纯度"
                align="center"
                width="70px">
              </el-table-column>
              <el-table-column
                prop="appNum"
                label="申领量"
                align="center"
                width="60px">
              </el-table-column>
              <el-table-column
                label="库存试剂"
                align="center"
                width="310px">
                <template slot-scope="scope">
                  <el-select
                    v-model="scope.row.choiceIndex"
                    :disabled="scope.row.disabledProvide"
                    size="mini"
                    style="width:280px">
                    <el-option
                      v-for="(item, index) in scope.row.stockItems"
                      :key="index"
                      :label="item.text"
                      :value="item.value"
                    >
                    </el-option>
                  </el-select>
                </template>
              </el-table-column>
              <el-table-column
                prop="providerNum"
                label="发放数量"
                align="center"
                width="135px">
                <template slot-scope="scope">
                  <el-input-number :disabled="scope.row.disabledProvide" style="width:110px" v-model="scope.row.providerNum"  :precision="2" :step="1" :min="0" :max="10000" @change="changeEditInput" size="mini"></el-input-number>
                </template>
              </el-table-column>
              <el-table-column
                prop="currentState"
                label="状态"
                align="center"
                width="60px">
              </el-table-column>
              <el-table-column
              label="操作"
              width="160px"
              align="center"
              prop="state">
                <template slot-scope="scope">
                  <el-button
                  :disabled="scope.row.disabledProvide"
                  size="mini"
                  @click="provideReagent(scope.row)"
                  type="primary">发放</el-button>
                  <el-button
                  :disabled="scope.row.disabledProvide"
                  size="mini"
                  @click="provideFinish(scope.row)"
                  type="success">完成</el-button>
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
  name: 'ProvideReagent',
  data () {
    return {
      appID: 0,
      // 初始试剂信息模拟数据
      appInfo: {},
      appDetail: [],
      stockInfoData: [],
      provideDetail: [],
      appDetailList: '' // 当前申领单中申领项目id列表，检测是否全部发放完成
    }
  },
  methods: {
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
            let temData = res.data
            for (let i = 0; i < temData.length; i++) {
              temData[i].stockItems = []
              this.appDetailList += temData[i].appDetailID + ','
              // 生成库存试剂下拉菜单数据
              for (let m = 0; m < temData[i].stocksList.length; m++) {
                let temp = temData[i].stocksList[m]
                let text = '名称:' + temp.reagentName + ' 库存量:' + temp.reagentNum + ' 规格:' + temp.stockSpec + ' 纯度:' + temp.stockPurity + ' 品牌:' + temp.stockBrand + ' 保质期:' + new Date(temp.expiryDate).toLocaleDateString()
                let value = m
                temData[i].stockItems.push({'text': text, 'value': value})
              }
              // 整理已发放列表信息
              for (let j = 0; j < temData[i].provideDetail.length; j++) {
                temData[i].provideDetail[j].expiryDate = new Date(temData[i].provideDetail[j].expiryDate).toLocaleDateString()
                // 如果发放的试剂已经被领取，则不允许撤回
                if (temData[i].provideDetail[j].state === 2 || temData[i].appDetailState === 1) {
                  temData[i].provideDetail[j].OPdisabled = true
                } else {
                  temData[i].provideDetail[j].OPdisabled = false
                }
              }
              // 管理发放状态
              if (temData[i].appDetailState === 1) {
                temData[i].disabledProvide = true
              } else {
                temData[i].disabledProvide = false
              }
              temData[i].choiceIndex = ''
              temData[i].providerNum = temData[i].appNum
              temData[i].providerSpec = temData[i].appSpec
              temData[i].specList = temData[i].reagentSpec.split(',')
              switch (temData[i].appDetailState) {
                case 0:
                  temData[i].currentState = '未发放'
                  break
                case 1:
                  temData[i].currentState = '已发放'
                  temData[i].readonly = true
                  break
                case 2:
                  temData[i].currentState = '已收取'
                  temData[i].readonly = true
                  temData[i].disabled = true
                  break
                case 3:
                  temData[i].currentState = '已退回'
                  break
              }
            }
            this.appDetailList = this.appDetailList.substring(0, this.appDetailList.length - 1)
            this.appDetail = temData
            console.log(this.appDetail)
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
    // 撤回发放试剂
    rollbackReagent: function (row) {
      console.log(row)
      this.$confirm('您确定撤回发放的试剂吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        let stocksInfo = {
          stocksID: row.stocksID,
          reagentNum: row.reagentNum,
          sdID: row.sdID,
          opID: row.opID
        }
        axios({
          method: 'post',
          url: '/api/application/rollbackProvider',
          data: {
            stocksInfo
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
          }).catch(() => {
            this.$message({
              type: 'info',
              message: '发放撤回失败，数据库错误！'
            })
          })
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消操作'
        })
      })
    },
    // 发放试剂
    provideReagent (row) {
      // 1. 判断是否选中了库存试剂，没有则给出提示 并结束。
      // 2. 判断发放数量是否大于0，没有则给出提示，并结束。
      // 3. 判断发放数量是否小于等于库存数量，没有则给出提示，并结束。
      // 4. 完成发放，传送发放数据给服务器。(stockID, )
      if (row.choiceIndex === '') {
        this.$message({
          message: '请选择要发放的库存试剂！',
          type: 'error'
        })
        return
      }
      if (row.providerNum === 0) {
        this.$message({
          message: '发放数量必须大于零！',
          type: 'error'
        })
        return
      }
      if (row.providerNum > row.stocksList[row.choiceIndex].reagentNum) {
        this.$message({
          message: '发放数量大于库存数量！',
          type: 'error'
        })
        return
      }
      let stockInfo = {
        stocksID: row.stocksList[row.choiceIndex].stocksID,
        reagentNum: row.providerNum,
        appDetailID: row.appDetailID
      }
      axios({
        method: 'post',
        url: '/api/application/providerReagent',
        data: {
          stockInfo
        }
      })
        .then((res) => {
          if (res.data.result === 1) {
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
        }).catch(() => {
          this.$message({
            type: 'info',
            message: '已取消提交'
          })
        })
    },
    // 试剂发放完成
    provideFinish (row) {
      console.log(this.appDetailList)
      let str = '确定发放完成吗?'
      let state = 1
      if (row.provideDetail.length === 0) {
        str = '尚未发放任何试剂，确定完成发放吗?'
        state = 2
      }
      this.$confirm(str, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })
        .then(() => {
          // 完成发放，改变当前申领试剂状态
          let info = {
            appDetailID: row.appDetailID,
            appID: row.appID,
            appDetailList: this.appDetailList,
            state: state
          }
          axios({
            method: 'post',
            url: '/api/application/finishProvider',
            data: {
              info
            }
          })
            .then((res) => {
              this.$message({
                message: res.data.msg,
                type: 'success'
              })
              this.initAppInfo()
            })
            .catch((err) => {
              console.log(err)
              this.$message({
                message: '服务器错误！',
                type: 'error'
              })
            })
        })
        .catch(() => {
          this.$message({
            type: 'info',
            message: '操作取消'
          })
        })
    },
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
