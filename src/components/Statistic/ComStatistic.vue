<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>库存统计</span>
          </div>
          <el-row>
            <el-col :span="18">
              <div>
                查询&nbsp;&nbsp;&nbsp;<el-select v-model="searchInfo.searchReagentTypeID" placeholder="试剂类别" size="small" style="width:100px">
                <el-option
                  v-for="item in reagentType"
                  :key="item.typeID"
                  :label="item.typeName"
                  :value="item.typeID">
                </el-option>
                </el-select>
                <el-input style="width:300px" placeholder="请输入试剂名称,CAS或试剂简码" v-model="searchInfo.searchReagent" size="small">
                  <el-button slot="append" icon="el-icon-search" @click="getStocksList"></el-button>
                </el-input>
              </div>
            </el-col>
            <el-col :span="6">
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
          <el-divider></el-divider>
          <el-table
          :data="stocksList"
          style="width: 100%"
          max-height="450"
          size="mini"
          >
          <el-table-column type="expand">
            <template slot-scope="props">
              <div class="supplierDetail">
              <el-row>
                <el-col :span="3" class="detailTitle">
                  试剂：
                </el-col>
                <el-col :span="5">
                  {{ props.row.reagentName }}
                </el-col>
                <el-col :span="3" class="detailTitle">
                  类型：
                </el-col>
                <el-col :span="5">
                  {{ props.row.typeName }}
                </el-col>
                <el-col :span="3" class="detailTitle">
                  库存：
                </el-col>
                <el-col :span="5">
                  {{ props.row.reagentNum }}
                </el-col>
              </el-row>
              <el-row>
                <el-col :span="3" class="detailTitle">
                  规格：
                </el-col>
                <el-col :span="5">
                  {{ props.row.stockSpec }}
                </el-col>
                <el-col :span="3" class="detailTitle">
                  纯度：
                </el-col>
                <el-col :span="5">
                  {{ props.row.stockPurity }}
                </el-col>
                <el-col :span="3" class="detailTitle">
                  含量：
                </el-col>
                <el-col :span="5">
                  {{ props.row.composition }}
                </el-col>
              </el-row>
              <el-row>
                <el-col :span="3" class="detailTitle">
                  单位：
                </el-col>
                <el-col :span="5">
                  {{ props.row.stockUnit }}
                </el-col>
                <el-col :span="3" class="detailTitle">
                  批号：
                </el-col>
                <el-col :span="5">
                  {{ props.row.stockBatchNo }}
                </el-col>
                <el-col :span="3" class="detailTitle">
                  受控号：
                </el-col>
                <el-col :span="5">
                  {{ props.row.stockRecordNo }}
                </el-col>
              </el-row>
              <el-row>
                <el-col :span="3" class="detailTitle">
                  过期日期：
                </el-col>
                <el-col :span="5">
                  {{ props.row.expiryDate }}
                </el-col>
                <el-col :span="3" class="detailTitle">
                  CAS：
                </el-col>
                <el-col :span="5">
                  {{ props.row.CAS }}
                </el-col>
                <el-col :span="3" class="detailTitle">
                  标准号：
                </el-col>
                <el-col :span="5">
                  {{ props.row.standardNo }}
                </el-col>
              </el-row>
              </div>
            </template>
          </el-table-column>
          <el-table-column
              prop="stocksID"
              label="序号"
              width="60"
              align="center">
          </el-table-column>
          <el-table-column
              prop="typeName"
              label="类型"
              align="center">
          </el-table-column>
          <el-table-column
              prop="reagentName"
              label="名称"
              align="center">
          </el-table-column>
          <el-table-column
              prop="reagentNum"
              label="库存量"
              align="center">
          </el-table-column>
          <el-table-column
              prop="stockSpec"
              label="规格"
              align="center">
          </el-table-column>
          <el-table-column
              prop="stockPurity"
              label="纯度"
              align="center">
          </el-table-column>
          <el-table-column
              prop="stockBatchNo"
              label="批号"
              align="center">
          </el-table-column>
          <el-table-column
            label="操作"
            width="250px"
            align="center">
              <template slot-scope="scope">
                <el-button
                size="mini"
                type="primary"
                @click="handleDetail(scope.row)">使用明细</el-button>
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
  name: 'ComStatistic',
  data () {
    return {
      reagentDanger: [],
      reagentState: [],
      reagentPurity: [],
      reagentType: [],
      searchInfo: {
        searchReagentTypeID: '',
        searchReagentDangerID: '',
        searchReagent: ''
      },
      stocksList: [],
      currentPage: 1,
      pageSize: 8,
      pageCount: 0
    }
  },
  methods: {
    handleDetail (row) {
      console.log(row)
      this.$router.push({path: '/ComStatisticDetail', query: {stockInfo: JSON.stringify(row)}})
    },
    getBaseInfoList () {
      axios({
        method: 'get',
        url: '/api/reagentInfo/getBaseInfo'
      })
        .then((res) => {
          this.reagentDanger = res.data.reagentDanger
          this.reagentState = res.data.reagentState
          this.reagentType = res.data.reagentType
          this.reagentPurity = res.data.reagentPurity
          this.reagentDanger.unshift({dangerID: 0, dangerName: '全部', state: 1})
          this.reagentState.unshift({stateID: 0, stateName: '全部', state: 1})
          this.reagentType.unshift({typeID: 0, typeName: '全部', state: 1})
          // this.reagentPurity.unshift({purityID: 0, purityName: '请选择', state: 1})
          // this.getStocksList()
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },
    getStocksList: function () {
      axios({
        method: 'get',
        url: '/api/stocks/getListStock',
        params: {
          searchInfo: this.searchInfo,
          pageInfo: {
            pageSize: this.pageSize,
            currentPage: this.currentPage
          }
        }
      })
        .then((res) => {
          let temp = res.data.data
          for (let i = 0; i < temp.length; i++) {
            if (!temp[i].CAS) {
              temp[i].CAS = '/'
            }
            if (!temp[i].standardNo) {
              temp[i].standardNo = '/'
            }
          }
          this.stocksList = res.data.data
          this.pageCount = res.data.count
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },
    handleCurrentChange: function (currentPage) {
      this.currentPage = currentPage
      this.getStocksList()
    }
  },
  mounted: function () {
    this.getStocksList()
    this.getBaseInfoList()
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
