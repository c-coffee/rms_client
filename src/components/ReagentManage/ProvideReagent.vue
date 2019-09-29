<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>试剂发放</span>
            <el-button @click.stop="provideReagent" style="float: right; padding: 3px 10px" type="text">发放</el-button>
            <el-button style="float: right; padding: 3px 10px" type="text"><router-link to="/ApplicationManage" tag="span">返回</router-link></el-button>
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
                prop="stockNum"
                label="库存量"
                align="center"
                width="70px">
              </el-table-column>
              <el-table-column
                prop="reagentNum"
                label="申领数量"
                align="center">
                <template slot-scope="scope">
                  <el-input-number style="width:110px" v-model="scope.row.reagentNum"  value=0 :precision="2" :step="1" :min="0" :max="10000" @change="changeEditInput" size="mini"></el-input-number>
                </template>
              </el-table-column>
              <el-table-column
                label="备注"
                align="center"
                prop="remark">
                <template slot-scope="scope">
                  <el-input v-model="scope.row.remark" placeholder="请输入备注" size="mini" style="width:150px"></el-input>
                </template>
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
        appID: 0,
        isSubmit: false,
        hasDanger: false
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
    // 界面初始化
    // 如果是由申请单管理页面点击修改调整过来，则读取申请单信息，初始化界面
    // 如果是点击添加按钮跳转过来，则直接初始化
    initAppInfo () {
      let appID = this.$route.query.appID
      if (typeof (appID) === 'undefined') {
        // 添加，初始数据项
      } else {
        // console.log(appID)
        this.appInfo.appID = appID
        axios({
          method: 'get',
          url: '/api/application/getAppReagentList',
          params: {
            appID: appID
          }
        })
          .then((res) => {
            this.appDetail = res.data
            // console.log(res)
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
    // 保存申领单
    provideReagent () {
      this.$confirm('您确定提交发放吗?  (提交之后无法修改)', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        // 先判断appDetail中是否有内容,其次判断是否包含易制毒试剂
        if (this.appDetail.length === 0) {
          this.$message({
            message: '请选择要申领的试剂！',
            type: 'info'
          })
          return
        }
        for (let i = 0; i < this.appDetail.length; i++) {
          if (this.appDetail[i].reagentDangerID !== 1) {
            this.appInfo.hasDanger = true
            break
          }
        }
        let urlAddr
        if (this.appInfo.appID === 0) {
          urlAddr = '/api/application/appSave'
        } else {
          urlAddr = '/api/application/appModify'
        }
        axios({
          method: 'post',
          url: urlAddr,
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
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消提交'
        })
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
        // 需要判断是否已经添加了该试剂，如果是，则将数量相加
        let flag = true
        for (let reagent of this.appDetail) {
          if (reagent.reagentID === row.reagentID) {
            reagent.reagentNum += row.appNum
            reagent.remark = row.remark
            flag = false
          }
        }

        if (flag) {
          this.appDetail.push({
            reagentID: row.reagentID,
            reagentName: row.reagentName,
            reagentUnit: row.reagentUnit,
            reagentSpec: row.reagentSpec,
            reagentNum: row.appNum,
            reagentDangerID: row.reagentDangerID,
            dangerName: row.dangerName,
            stockNum: row.stockNum,
            remark: row.remark
          })
        }
      }
    }
  },
  mounted: function () {
    // let userInfo = this.$store.state.user.userInfo
    // this.appInfo.userName = userInfo.userName
    // this.appInfo.userRealName = userInfo.userRealName
    this.initAppInfo()
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
