<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>试剂收取</span>
            <el-button style="float: right; padding: 3px 10px" type="text"><router-link to="/ReagentReceive" tag="span">返回</router-link></el-button>
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
            :default-expand-all="true"
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
                        @click="receiveReagent(scope.row, props.row.appDetailState)"
                        type="success">收取</el-button>
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
                align="center">
              </el-table-column>
              <el-table-column
                prop="appPurity"
                label="申领纯度"
                align="center">
              </el-table-column>
              <el-table-column
                prop="appNum"
                label="申领量"
                align="center">
              </el-table-column>
              <el-table-column
                prop="currentState"
                label="状态"
                align="center">
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
  name: 'ReagentReceiveDetail',
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
    receiveReagent (row, appDetailState) {
      // 1. 科室库存增加，科室库存详情记录
      // 2. 发放库存信息更新为已收取，并查看当前申领项目状态是否为已发放，如果是已发放，并且所有项目都已经领取，则当前申领项目状态改为已收取。
      // 3. 查看申领单状态，如果申领单状态为待收取，并且其每个申领项目状态都是已收取，则将申领单流转至已完成。
      this.$confirm('请核对发放信息，确定收取吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        let info = {
          stocksID: row.stocksID,
          sdID: row.sdID,
          appID: this.appInfo.appID,
          appDetailID: row.opID,
          reagentNum: row.reagentNum,
          appDetailState: appDetailState
        }
        axios({
          method: 'post',
          url: '/api/receiveProcess/receiveReagent',
          data: {
            info
          }
        })
          .then((res) => {
            if (res.data.result === 1) {
              // 成功则关闭窗口，不成功不关闭
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
    // 界面初始化
    // 如果是由申请单管理页面点击修改调整过来，则读取申请单信息，初始化界面
    // 如果是点击添加按钮跳转过来，则直接初始化
    initAppInfo () {
      this.appInfo = this.$route.query.appInfo
      if (typeof (this.appInfo.appID) === 'undefined' || this.appInfo.appID === 0) {
        // 返回申领管理页面
        this.$router.push({path: '/ReagentReceive'})
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
              // 整理已发放列表信息
              for (let j = 0; j < temData[i].provideDetail.length; j++) {
                temData[i].provideDetail[j].expiryDate = new Date(temData[i].provideDetail[j].expiryDate).toLocaleDateString()
                // 如果发放的试剂已经被领取，则不允许撤回
                if (temData[i].provideDetail[j].state === 2) {
                  temData[i].provideDetail[j].OPdisabled = true
                } else {
                  temData[i].provideDetail[j].OPdisabled = false
                }
              }
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
    }
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
