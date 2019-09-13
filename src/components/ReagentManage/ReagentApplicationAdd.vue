<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>试剂申领</span>
            <el-button @click.stop="appSaveAndSubmit" style="float: right; padding: 3px 10px" type="text">保存并提交</el-button>
            <el-button @click.stop="appSaveNotSubmit" style="float: right; padding: 3px 10px" type="text">保存</el-button>
          </div>
          <el-table
            :data="appDetail"
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
                label="试剂名称"
                align="center">
              </el-table-column>
              <el-table-column
                prop="reagentSpec"
                label="规格"
                align="center">
              </el-table-column>
              <el-table-column
                prop="reagentUnit"
                label="单位"
                align="center"
                width="55px">
              </el-table-column>
              <el-table-column
                prop="dangerName"
                label="易制毒"
                align="center"
                width="70px">
              </el-table-column>
              <el-table-column
                prop="appNum"
                label="申领数量"
                align="center">
              </el-table-column>
              <el-table-column
                prop="remark"
                label="备注"
                align="center">
              </el-table-column>
              <el-table-column
            label="操作"
            width="90px"
            align="center">
              <template slot-scope="scope">
                <el-button
                size="mini"
                type="danger"
                @click="handleDelete(scope.$index, scope.row)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
          <el-divider></el-divider>
          <el-row>
            <el-col :span="18">
              <div>
                搜索&nbsp;&nbsp;&nbsp;<el-select v-model="searchInfo.searchReagentTypeID" placeholder="试剂类别" size="small" style="width:100px">
                <el-option
                  v-for="item in reagentType"
                  :key="item.typeID"
                  :label="item.typeName"
                  :value="item.typeID">
                </el-option>
                </el-select>
                <el-select v-model="searchInfo.searchReagentDangerID" placeholder="危化类别"  size="small" style="width:100px">
                <el-option
                  v-for="item in reagentDanger"
                  :key="item.dangerID"
                  :label="item.dangerName"
                  :value="item.dangerID">
                </el-option>
              </el-select>
              <el-select v-model="searchInfo.searchReagentStateID" placeholder="性状类别" size="small" style="width:100px">
                <el-option
                  v-for="item in reagentState"
                  :key="item.stateID"
                  :label="item.stateName"
                  :value="item.stateID">
                </el-option>
              </el-select>
                <el-input style="width:200px" placeholder="请输入试剂名称或试剂简码" v-model="searchInfo.searchReagent" size="small">
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
            :data="stockInfoData"
            border
            size="mini">
              <el-table-column
                prop="reagentID"
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
                prop="reagentSpec"
                label="规格"
                align="center">
              </el-table-column>
              <el-table-column
                prop="reagentUnit"
                label="单位"
                align="center"
                width="60px">
              </el-table-column>
              <el-table-column
                prop="initialNum"
                label="库存量"
                align="center"
                width="70px">
              </el-table-column>
              <el-table-column
                prop="appNum"
                label="申领数量"
                align="center">
                <template slot-scope="scope">
                  <el-input-number style="width:110px" v-model="scope.row.appNum"  value=0 :precision="2" :step="1" :min="0" :max="10000" @change="changeEditInput" size="mini"></el-input-number>
                </template>
              </el-table-column>
              <el-table-column
                label="备注"
                align="center"
                prop="remark">
                <template slot-scope="scope">
                  <el-input v-model="scope.row.remark" placeholder="请输入备注" size="mini" style="width:100px"></el-input>
                </template>
              </el-table-column>
              <el-table-column
                label="操作"
                width="90px"
                align="center">
              <template slot-scope="scope">
                <el-button
                size="mini"
                type="primary"
                @click="handleAdd(scope.$index, scope.row)">添加</el-button>
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
  name: 'ReagentApplicationAdd',
  data () {
    return {
      // 通过试剂名称或简码进行搜索
      searchInfo: {
        searchReagentTypeID: '',
        searchReagentDangerID: '',
        searchReagentStateID: '',
        searchReagent: ''
      },
      // 初始试剂信息模拟数据
      appInfo: {
        isSubmit: false,
        hasDanger: 0
      },
      appDetail: [],
      stockInfoData: [],
      reagentDanger: [],
      reagentState: [],
      reagentType: [],
      currentPage: 1,
      pageSize: 5,
      pageCount: 0
    }
  },
  methods: {
    // 保存并提交申领单
    appSaveAndSubmit () {
      this.$confirm('您确定提交申请单吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.appInfo.isSubmit = true
        this.appSave()
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消提交'
        })
      })
    },
    // 保存申领单不提交
    appSaveNotSubmit () {
      this.appInfo.isSubmit = false
      this.appSave()
    },
    // 保存申领单
    appSave () {
      // 先判断appDetail中是否有内容,其次判断是否包含易制毒试剂
      for (let i = 0; i < this.appDetail.length; i++) {
        if (this.appDetail[i].reagentDangerID !== 1) {
          this.appInfo.hasDanger = true
          break
        }
      }
      axios({
        method: 'post',
        url: '/api/application/appSave',
        data: {
          appDetail: this.appDetail,
          appInfo: this.appInfo
        }
      })
        .then((res) => {
          if (res.data.result === 1) {
            // 如果成功，则跳转到申请单列表界面
            this.$message({
              message: res.data.msg,
              type: 'success'
            })
            this.$router.push({path: '/ReagentApplication'})
          } else {
            this.$message({
              message: res.data.msg,
              type: 'error'
            })
          }
        })
    },
    handleCurrentChange (currentPage) {
      this.currentPage = currentPage
      this.getStocksList()
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
          this.reagentDanger.unshift({dangerID: 0, dangerName: '全部', state: 1})
          this.reagentState.unshift({stateID: 0, stateName: '全部', state: 1})
          this.reagentType.unshift({typeID: 0, typeName: '全部', state: 1})
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
          // console.log(res)
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
    },
    filterState: function (value, row) {
      return row.applicationState === value
    },
    handleDelete: function (index, row) {
      this.$confirm('您确定删除所选试剂吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.appDetail.splice(index, 1)
        this.$message({
          type: 'success',
          message: '删除成功!'
        })
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消删除'
        })
      })
    },
    handleEdit: function (index, row) {
    },
    handleAdd: function (index, row) {
      // console.log(row.appNum, row.remark)
      console.log(row)
      if (row.appNum === 0 || isNaN(row.appNum)) {
        // 提示请输入有效申购数量
        this.$message({
          type: 'error',
          message: '请输入有效申购数量!'
        })
      } else {
        this.appDetail.push({
          reagentID: row.reagentID,
          reagentName: row.reagentName,
          reagentUnit: row.reagentUnit,
          reagentSpec: row.reagentSpec,
          appNum: row.appNum,
          reagentDangerID: row.reagentDangerID,
          dangerName: row.dangerName,
          remark: row.remark
        })
      }
    }
  },
  mounted: function () {
    // let userInfo = this.$store.state.user.userInfo
    // this.appInfo.userName = userInfo.userName
    // this.appInfo.userRealName = userInfo.userRealName
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
