<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>试剂申领</span>
            <el-button @click.stop="reagentAppAdd" style="float: right; padding: 3px 10px" type="text">保存并提交</el-button>
            <el-button @click.stop="reagentAppAdd" style="float: right; padding: 3px 10px" type="text">保存</el-button>
          </div>
          <el-row>
            <el-col :span="12" style="text-align:center">申领用户：{{appInfo.userName}}</el-col>
            <el-col :span="12" style="text-align:center">申领时间：{{appInfo.appDatetime}}</el-col>
          </el-row>
          <el-divider></el-divider>
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
                width="70px">
              </el-table-column>
              <el-table-column
                prop="reagentNum"
                label="数量"
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
            <el-col>
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
                <el-input style="width:250px" placeholder="请输入试剂名称或试剂简码" v-model="searchInfo.searchReagent" size="small">
                  <el-button slot="append" icon="el-icon-search" @click="getStocksList"></el-button>
                </el-input>
              </div>
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
        appUserID: '1',
        userName: 'zhangsan',
        userRealName: '章三',
        appDatetime: '2019-6-26',
        hasDanger: 0
      },
      appDetail: [
        {
          appDetailID: 1,
          appID: 1,
          reagentID: 2,
          reagentName: '甲醇',
          reagentUnit: 'L',
          reagentSpec: '>=99.9%',
          reagentNum: 10,
          remark: ''
        },
        {
          appDetailID: 2,
          appID: 1,
          reagentID: 3,
          reagentName: '二苯肼标准溶液',
          reagentUnit: 'L',
          reagentSpec: '1000μg/ml',
          reagentNum: 8,
          remark: ''
        }
      ],
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
        this.reagentAppDetail.appDetail.splice(index, 1)
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
      console.log(row.appNum, row.remark)
    }
  },
  mounted: function () {
    let userInfo = this.$store.user.userInfo
    console.log(userInfo)
    this.appInfo.userName = userInfo.userName
    this.appInfo.userRealName = userInfo.userRealName
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
