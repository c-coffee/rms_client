<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>试剂申购单</span>
            <el-button style="float: right; padding: 3px 30px; margin-left:20px" type="info"><router-link to="/ApplicationOrderManage" tag="span">返 回</router-link></el-button>
            <el-button @click.stop="orderSaveAndSubmit" style="float: right; padding: 3px 10px" type="text">保存并提交</el-button>
            <el-button @click.stop="orderSaveNotSubmit" style="float: right; padding: 3px 10px" type="text">保存</el-button>
          </div>
          <el-table
            :data="orderDetail"
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
                label="名称"
                align="center">
              </el-table-column>
              <el-table-column
                prop="typeName"
                label="类型"
                align="center">
              </el-table-column>
              <el-table-column
                prop="orderSpec"
                label="规格"
                align="center">
              </el-table-column>
              <el-table-column
                prop="orderPurity"
                label="纯度"
                align="center"
                width="70px">
              </el-table-column>
              <el-table-column
                prop="orderNum"
                label="申购数量"
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
                查询&nbsp;&nbsp;&nbsp;<el-select v-model="searchInfo.searchReagentTypeID" placeholder="试剂类别" size="small" style="width:130px">
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
            :data="stockInfoData"
            border
            size="mini"
            ref="stockTable">
            <el-table-column type="expand">
              <template slot-scope="props">
                <div class="supplierDetail">
                <el-row>
                  <el-col :span="3" class="detailTitle">
                    名称：
                  </el-col>
                  <el-col :span="9">
                    {{ props.row.reagentName }}
                  </el-col>
                  <el-col :span="3" class="detailTitle">
                    短码：
                  </el-col>
                  <el-col :span="9">
                    {{ props.row.reagentShortCode }}
                  </el-col>
                </el-row>
                <el-row>
                  <el-col :span="3" class="detailTitle">
                    类型：
                  </el-col>
                  <el-col :span="9">
                    {{ props.row.typeName }}
                  </el-col>
                  <el-col :span="3" class="detailTitle">
                    CAS：
                  </el-col>
                  <el-col :span="9">
                    {{ props.row.CAS }}
                  </el-col>
                </el-row>
                <el-row>
                  <el-col :span="3" class="detailTitle">
                    规格：
                  </el-col>
                  <el-col :span="9">
                    {{ props.row.reagentSpec }}
                  </el-col>
                  <el-col :span="3" class="detailTitle">
                    单位：
                  </el-col>
                  <el-col :span="9">
                    {{ props.row.reagentUnit }}
                  </el-col>
                </el-row>
                <el-row>
                  <el-col :span="3" class="detailTitle">
                    危化类别：
                  </el-col>
                  <el-col :span="9">
                    {{ props.row.dangerName }}
                  </el-col>
                  <el-col :span="3" class="detailTitle">
                    制造商：
                  </el-col>
                  <el-col :span="9">
                    {{ props.row.reagentProduct }}
                  </el-col>
                </el-row>
                </div>
              </template>
            </el-table-column>
              <el-table-column
                type="index"
                label="序号"
                align="center"
                width="45px">
              </el-table-column>
              <el-table-column
                prop="reagentName"
                label="名称"
                align="center">
              </el-table-column>
              <el-table-column
                prop="typeName"
                label="类型"
                align="center"
                width="95px">
              </el-table-column>
              <el-table-column
                prop="reagentNum"
                label="库存"
                align="center"
                width="60px">
              </el-table-column>
              <el-table-column
                prop="reagentSpec"
                label="规格"
                align="center"
                width="120px">
                <template slot-scope="scope">
                  <el-select size="mini" v-model="scope.row.choiceSpec" @change="getStock(scope.row, scope.$index)">
                    <el-option
                      v-for="(item,index) in scope.row.specList"
                      :key="index"
                      :label="item"
                      :value="item">
                    </el-option>
                  </el-select>
                </template>
              </el-table-column>
              <el-table-column
                prop="reagentPurity"
                label="纯度"
                align="center"
                width="138px">
                <template slot-scope="scope">
                  <el-select :disabled="scope.row.purityDisabled" size="mini" v-model="scope.row.orderPurity" @visible-change="$forceUpdate()" @change="getStock(scope.row, scope.$index)">
                    <el-option
                      v-for="item in reagentPurity"
                      :key="item.purityID"
                      :label="item.purityName"
                      :value="item.purityName"
                    >
                    </el-option>
                  </el-select>
                </template>
              </el-table-column>
              <el-table-column
                prop="orderNum"
                label="申购数量"
                align="center"
                width="125px">
                <template slot-scope="scope">
                  <el-input-number style="width:100px" v-model="scope.row.orderNum"  value=0 :precision="2" :step="1" :min="0" :max="10000" @change="changeEditInput" size="mini"></el-input-number>
                </template>
              </el-table-column>
              <el-table-column
                label="备注"
                align="center"
                prop="remark"
                width="125px">
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
  name: 'ApplicationOrderAdd',
  data () {
    return {
      // 通过试剂名称或简码进行搜索
      searchInfo: {
        searchReagentTypeID: '',
        searchReagentDangerID: '',
        searchReagent: ''
      },
      // 初始试剂信息模拟数据
      orderInfo: {
        orderID: 0,
        isSubmit: false,
        hasDanger: false
      },
      orderDetail: [],
      stockInfoData: [],
      reagentDanger: [],
      reagentState: [],
      reagentPurity: [],
      reagentType: [],
      currentPage: 1,
      pageSize: 5,
      pageCount: 0
    }
  },
  methods: {
    // 选择纯度和规格后，获得库存数量
    getStock (rowInfo, rowIndex) {
      if (rowInfo.reagentTypeID === 1 || rowInfo.reagentTypeID === 4) {
        if (rowInfo.choiceSpec === '' || rowInfo.orderPurity === '') {
          // 试剂和易制毒 需要选择了规格和纯度才能统一查询
          rowInfo.reagentName += ' ' // 用以解决屏幕不刷新bug
          return
        }
      }
      let stockInfo = {
        reagentID: rowInfo.reagentID,
        stockSpec: rowInfo.choiceSpec,
        stockPurity: rowInfo.orderPurity,
        reagentTypeID: rowInfo.reagentTypeID
      }
      axios({
        method: 'get',
        url: '/api/stocks/getStock',
        params: {
          stockInfo
        }
      })
        .then((res) => {
          rowInfo.reagentNum = res.data.countNum
          rowInfo.reagentName += ' '
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
      let orderID = this.$route.query.orderID
      if (typeof (orderID) === 'undefined') {
        // 添加，初始数据项
      } else {
        this.orderInfo.orderID = orderID
        axios({
          method: 'get',
          url: '/api/order/getOrderDetail',
          params: {
            orderID: orderID
          }
        })
          .then((res) => {
            this.orderDetail = res.data
            // console.log(res.data)
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
    // 保存并提交申领单
    orderSaveAndSubmit () {
      this.$confirm('您确定提交申请单吗?  (提交之后无法修改)', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.orderInfo.isSubmit = true
        this.orderSave()
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消提交'
        })
      })
    },
    // 保存申领单不提交
    orderSaveNotSubmit () {
      this.orderInfo.isSubmit = false
      this.orderSave()
    },
    // 保存申领单
    orderSave () {
      // 先判断appDetail中是否有内容,其次判断是否包含易制毒试剂
      if (this.orderDetail.length === 0) {
        this.$message({
          message: '请选择要申领的试剂！',
          type: 'info'
        })
        return
      }

      let urlAddr
      if (this.orderInfo.orderID === 0) {
        urlAddr = '/api/order/orderSave'
      } else {
        urlAddr = '/api/order/orderModify'
      }
      axios({
        method: 'post',
        url: urlAddr,
        data: {
          orderDetail: this.orderDetail,
          orderInfo: this.orderInfo
        }
      })
        .then((res) => {
          if (res.data.result === 1) {
            // 如果成功，则跳转到申请单列表界面
            this.$message({
              message: res.data.msg,
              type: 'success'
            })
            this.$router.push({path: '/ApplicationOrderManage'})
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
          let tempData = res.data.data
          this.stockInfoData = res.data.data
          for (let i = 0; i < tempData.length; i++) {
            tempData[i].specList = tempData[i].reagentSpec.split(',')
            tempData[i].orderPurity = ''
            tempData[i].choiceSpec = ''
            switch (tempData[i].reagentTypeID) {
              case 1:
                // 试剂，纯度可选
                tempData.purityDisabled = false
                tempData.orderPurity = ''
                break
              case 2:
                // 耗材，纯度不可选
                tempData.purityDisabled = true
                tempData.orderPurity = '/'
                break
              case 3:
                // 标准物质，纯度不可选
                tempData.purityDisabled = true
                tempData.orderPurity = '/'
                break
              case 4:
                // 易制毒，纯度可选
                tempData.purityDisabled = false
                tempData.orderPurity = ''
                break
            }
          }
          this.stockInfoData = tempData
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
    handleDelete: function (index, row) {
      this.$confirm('您确定删除所选试剂吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.orderDetail.splice(index, 1)
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
      console.log(row)
      if (row.choiceSpec === '') {
        this.$message({
          type: 'error',
          message: '请选择试剂规格!'
        })
        return
      }
      if (row.orderPurity === '') {
        this.$message({
          type: 'error',
          message: '请选择试剂纯度!'
        })
        return
      }
      if (row.orderNum === 0 || isNaN(row.orderNum)) {
        // 提示请输入有效申购数量
        this.$message({
          type: 'error',
          message: '请输入有效申购数量!'
        })
      } else {
        // 需要判断是否已经添加了该试剂，如果是，则将数量相加
        // console.log(row)
        // console.log(this.appDetail)
        let flag = true
        for (let reagent of this.orderDetail) {
          if (reagent.reagentID === row.reagentID && reagent.orderSpec === row.choiceSpec && reagent.orderPurity === row.orderPurity) {
            reagent.orderNum += row.orderNum
            if (reagent.remark !== '') {
              reagent.remark = row.remark
            }
            flag = false
          }
        }

        if (flag) {
          this.orderDetail.push({
            reagentID: row.reagentID,
            reagentName: row.reagentName,
            typeName: row.typeName,
            reagentUnit: row.reagentUnit,
            orderSpec: row.choiceSpec,
            orderPurity: row.orderPurity,
            orderNum: row.orderNum,
            reagentDangerID: row.reagentDangerID,
            dangerName: row.dangerName,
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
