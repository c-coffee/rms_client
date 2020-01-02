<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>出入库详情</span>
            <el-button style="float: right; padding: 3px 10px" type="text"><router-link to="/DeptComStatistic" tag="span">返回</router-link></el-button>
          </div>
          <div style="font-size:14px" class="detailInfo">
            <el-row>
              <el-col :span="3" class="detailTitle">
                试剂：
              </el-col>
              <el-col :span="5">
                {{ this.stockInfo.reagentName }}
              </el-col>
              <el-col :span="3" class="detailTitle">
                类型：
              </el-col>
              <el-col :span="5">
                {{ this.stockInfo.typeName }}
              </el-col>
              <el-col :span="3" class="detailTitle">
                库存：
              </el-col>
              <el-col :span="5">
                {{ this.stockInfo.reagentNum }}
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="3" class="detailTitle">
                规格：
              </el-col>
              <el-col :span="5">
                {{ this.stockInfo.stockSpec }}
              </el-col>
              <el-col :span="3" class="detailTitle">
                纯度：
              </el-col>
              <el-col :span="5">
                {{ this.stockInfo.stockPurity }}
              </el-col>
              <el-col :span="3" class="detailTitle">
                含量：
              </el-col>
              <el-col :span="5">
                {{ this.stockInfo.composition }}
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="3" class="detailTitle">
                单位：
              </el-col>
              <el-col :span="5">
                {{ this.stockInfo.stockUnit }}
              </el-col>
              <el-col :span="3" class="detailTitle">
                批号：
              </el-col>
              <el-col :span="5">
                {{ this.stockInfo.stockBatchNo }}
              </el-col>
              <el-col :span="3" class="detailTitle">
                受控号：
              </el-col>
              <el-col :span="5">
                {{ this.stockInfo.stockRecordNo }}
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="3" class="detailTitle">
                过期日期：
              </el-col>
              <el-col :span="5">
                {{ this.stockInfo.expiryDate }}
              </el-col>
              <el-col :span="3" class="detailTitle">
                CAS：
              </el-col>
              <el-col :span="5">
                {{ this.stockInfo.CAS }}
              </el-col>
              <el-col :span="3" class="detailTitle">
                标准号：
              </el-col>
              <el-col :span="5">
                {{ this.stockInfo.standardNo }}
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="3" class="detailTitle">
                入库数：
              </el-col>
              <el-col :span="5">
                {{ this.stockInfo.inNum }}
              </el-col>
              <el-col :span="3" class="detailTitle">
                出库数：
              </el-col>
              <el-col :span="5">
                {{ this.stockInfo.outNum }}
              </el-col>
              <el-col :span="3" class="detailTitle">
                出入库差：
              </el-col>
              <el-col :span="5">
                {{ this.stockInfo.balanceNum }}
              </el-col>
            </el-row>
          </div>
          <el-divider></el-divider>
          <el-row>
            <el-col>
              <el-pagination
                @current-change="handleCurrentChange"
                layout="prev, pager, next"
                style="float:right"
                :page-size="this.pageSize"
                :current-page="this.currentPage"
                :total="this.pageCount">
              </el-pagination>
            </el-col>
          </el-row>
          <el-table
            ref="providerTable"
            :data="stocksDetailList"
            border
            show-summary
            size="mini">
              <el-table-column
                type="index"
                label="序号"
                align="center"
                width="50px">
                <template slot-scope="scope">
                  <span>{{scope.$index+(currentPage - 1) * pageSize + 1}}</span>
                </template>
              </el-table-column>
              <el-table-column
                prop="remark"
                label="操作"
                align="center">
              </el-table-column>
              <el-table-column
                prop="reagentNum"
                label="数量"
                align="center">
              </el-table-column>
              <el-table-column
                prop="opDatetime"
                label="执行时间"
                align="center">
              </el-table-column>
              <el-table-column
                prop="userRealName"
                label="执行人"
                align="center">
              </el-table-column>
              <el-table-column
                :filters="[{text:'入库',value:'入库'},{text:'出库',value:'出库'}]"
                :filter-method="filterState"
                prop="recordState"
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
  name: 'ComStatisticDetail',
  data () {
    return {
      stockInfo: {},
      stocksDetailList: [],
      currentPage: 1,
      pageSize: 6,
      pageCount: 0
    }
  },
  methods: {
    filterState: function (value, row) {
      return row.recordState === value
    },
    handleCurrentChange: function (currentPage) {
      this.currentPage = currentPage
      this.initAppInfo()
    },
    initAppInfo () {
      if (typeof (this.stockInfo.stocksID) === 'undefined' || this.stockInfo.stocksID === 0) {
        // 返回申领管理页面
        this.$router.push({path: '/DeptComStatistic'})
      } else {
        axios({
          method: 'get',
          url: '/api/stocks/getDeptStockDetail',
          params: {
            deptStocksID: this.stockInfo.deptStocksID,
            pageInfo: {
              pageSize: this.pageSize,
              currentPage: this.currentPage
            }
          }
        })
          .then((res) => {
            let temp = res.data.data
            for (let i = 0; i < temp.length; i++) {
              // temp[i].opDatetime = new Date(temp[i].opDatetime).toLocaleDateString
              if (temp[i].direction === 'in') {
                temp[i].recordState = '入库'
              } else if (temp[i].direction === 'out') {
                temp[i].recordState = '出库'
                temp[i].reagentNum = -temp[i].reagentNum
              }
            }
            console.log(temp)
            this.stocksDetailList = temp
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
    },
    getStockNum: function () {
      axios({
        method: 'get',
        url: '/api/stocks/getDeptStockNumByID',
        params: {
          deptStocksID: this.stockInfo.deptStocksID
        }
      })
        .then((res) => {
          console.log(res)
          if (!res.data.stockNum.in) {
            res.data.stockNum.in = 0
          }
          this.stockInfo.inNum = res.data.stockNum.in
          if (!res.data.stockNum.out) {
            res.data.stockNum.out = 0
          }
          this.stockInfo.outNum = res.data.stockNum.out
          this.stockInfo.balanceNum = this.stockInfo.inNum - this.stockInfo.outNum
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
    this.stockInfo = JSON.parse(this.$route.query.stockInfo)
    this.getStockNum()
    this.initAppInfo()
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
  .detailInfo .el-row{
    margin-top:7px
  }
</style>
