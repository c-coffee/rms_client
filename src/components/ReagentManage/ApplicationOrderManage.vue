<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>申购管理</span>
            <el-button style="float: right; padding: 3px 0" type="text"><router-link to="/ApplicationOrderAdd" tag="span">新建申购</router-link></el-button>
          </div>
          <el-table
          :data="orderList"
          ref="orderTable"
          style="width: 100%"
          max-height="650"
          size="mini"
          row-key="orderID"
          lazy
          @expand-change="loadDetail"
          :expand-row-keys="expands">
          <el-table-column type="expand">
            <template>
              <el-table
                :data="orderDetail"
                border
                size="mini">
                <el-table-column
                  prop="orderDetailID"
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
                  prop="orderPurity"
                  label="纯度"
                  align="center">
                </el-table-column>
                <el-table-column
                  prop="orderSpec"
                  label="规格"
                  align="center">
                </el-table-column>
                <el-table-column
                  prop="reagentNum"
                  label="库存"
                  align="center">
                </el-table-column>
                <el-table-column
                  prop="orderNum"
                  label="申购数量"
                  align="center">
                </el-table-column>
                <el-table-column
                  prop="supplierName"
                  label="供应商"
                  align="center">
                </el-table-column>
                <el-table-column
                  label="选择"
                  align="center">
                  <template slot-scope="scope">
                    <el-button
                    size="mini"
                    type="warning"
                    round
                    :disabled="scope.row.disableChoice"
                    @click="handleChoice(scope.row)">选择</el-button>
                  </template>
                </el-table-column>
              </el-table>
            </template>
          </el-table-column>
          <el-table-column
              prop="orderID"
              label="序号"
              width="80"
              align="center">
          </el-table-column>
          <el-table-column
              prop="userRealName"
              label="申请人"
              align="center">
          </el-table-column>
          <el-table-column
              prop="applyDate"
              label="申请时间"
              align="center">
          </el-table-column>
          <el-table-column
              prop="stepName"
              label="当前步骤"
              align="center"
              :filters="[{text:'待提交',value:10},{text:'待处理',value:11},{text:'询价中',value:12},{text:'待审核',value:13},{text:'申购驳回',value:14},{text:'采购驳回',value:15},{text:'采购中',value:16},{text:'已完成',value:17}]"
              :filter-method="filterState">
              <template slot-scope="scope">
                <el-tooltip :disabled="scope.row.showRejectInfo" class="item" effect="dark" :content="scope.row.applyRejectReason" placement="top-start">
                  <el-tag :type="scope.row.tagType">{{scope.row.stepName}} <span v-if="!scope.row.showRejectInfo" class="el-icon-warning-outline"></span></el-tag>
                </el-tooltip>
              </template>
          </el-table-column>
          <el-table-column
            label="操作"
            width="350px"
            align="center">
              <template slot-scope="scope">
                <el-button
                size="mini"
                type="success"
                :disabled="scope.row.disableModify"
                @click="handleEdit(scope.$index, scope.row)">修改</el-button>
                <el-button
                size="mini"
                type="danger"
                :disabled="scope.row.disableModify"
                @click="handleDelete(scope.$index, scope.row)">删除</el-button>
                <el-button
                size="mini"
                type="primary"
                :disabled="scope.row.disableModify"
                @click="handleSubmit(scope.$index, scope.row)">提交</el-button>
                <el-button
                size="mini"
                type="warning"
                :disabled="scope.row.disableInStock"
                @click="handleStockIn(scope.row)">入库</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>
    <el-dialog
      @close="closeDialog"
      title="入库"
      :visible.sync="dialogStockInVisible"
      :close-on-click-modal="false">
      <el-card class="box-card">
        <el-row >
          <el-col style="margin-top:-15px">
            <el-divider>申 购 信 息</el-divider>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="4" align="right">名称：</el-col>
          <el-col :span="4">{{stockInInfo.reagentName}}</el-col>
          <el-col align="right" :span="4">类型：</el-col>
          <el-col :span="4">{{stockInInfo.typeName}}</el-col>
          <el-col align="right" :span="4">供应商：</el-col>
          <el-col :span="4">{{stockInInfo.supplierName}}</el-col>
        </el-row>
        <el-row class="center-row">
          <el-col align="right" :span="4">数量：</el-col>
          <el-col :span="4">{{stockInInfo.orderNum}}</el-col>
          <el-col align="right" :span="4">规格：</el-col>
          <el-col :span="4">{{stockInInfo.orderSpec}}</el-col>
          <el-col align="right" :span="4">纯度：</el-col>
          <el-col :span="4">{{stockInInfo.orderPurity}}</el-col>
        </el-row>
        <el-row >
          <el-col style="margin-top:5px"><el-divider>入 库 信 息</el-divider></el-col>
        </el-row>
        <el-form ref="stockInForm" :inline="true" :model="stockInForm" label-width="80px">
          <el-row>
            <el-col :span="18" class="form-item">
              <el-form-item label="名称" prop="reagentName">
                <el-input v-model="stockInForm.reagentName" readonly="readonly" size="mini" style="width:150px" label="名称"></el-input>
              </el-form-item>
              <el-link type="primary" @click="showReagentInfo" style="margin-top:10px">更改</el-link>
              <el-link type="primary" @click="showAddReagent" style="margin-top:10px">新建</el-link>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12" class="form-item">
              <el-form-item
                label="批号"
                prop="stockBatchNo">
                <el-autocomplete
                  v-model="stockInForm.stockBatchNo"
                  :fetch-suggestions="getRecordList"
                  @select="handleSelect"
                  size="mini"
                  style="width:150px"
                  label="批号">
                </el-autocomplete>
              </el-form-item>
            </el-col>
            <el-col :span="12" class="form-item">
              <el-form-item label="数量" prop="reagentNum">
                <el-input-number size="mini" v-model="stockInForm.reagentNum" style="width:150px" :min="1" :max="10000" :step="1" label="入库数量"></el-input-number>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row class="form-row">
            <el-col :span="12"  class="form-item">
              <el-form-item label="纯度" class="formItem" prop="orderPurity">
              <el-select v-model="stockInForm.orderPurity" placeholder="请选择入库纯度" size="mini" style="width:150px">
                <el-option
                  v-for="item in purityData"
                  :key="item.purityID"
                  :label="item.purityName"
                  :value="item.purityName">
                </el-option>
              </el-select>
            </el-form-item>
            </el-col>
            <el-col :span="12" class="form-item">
            <el-form-item label="规格" class="formItem" prop="orderSpec">
              <el-select
              v-model="stockInForm.orderSpec"
              placeholder="请选择入库规格"
              style="width:150px" size="mini">
                <el-option
                  v-for="(item,index) in stockInInfo.specList"
                  :key="index"
                  :label="item"
                  :value="item">
                </el-option>
              </el-select>
            </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12" class="form-item">
              <el-form-item label="单位" prop="stockUnit">
                <el-input v-model="stockInForm.stockUnit" size="mini" style="width:150px" :min="1" :max="10000" :step="1" label="单位"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="12" class="form-item">
              <el-form-item label="含量" prop="composition">
                <el-input v-model="stockInForm.composition" size="mini" style="width:150px" label="含量"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12" class="form-item">
              <el-form-item label="来源" prop="stockBrand">
                <el-input v-model="stockInForm.stockBrand" size="mini" style="width:150px" :min="1" :max="10000" :step="1" label="品牌"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="12" class="form-item">
              <el-form-item label="有效期" prop="expiryDate">
                <el-date-picker
                  v-model="stockInForm.expiryDate"
                  type="date"
                  value-format="yyyy-M-d"
                  placeholder="选择日期"
                  size="mini"
                  style="width:150px">
                </el-date-picker>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12" class="form-item">
              <el-form-item label="备案号" prop="stockRecordNo">
                <el-input :disabled="stockInForm.disabledRecord" v-model="stockInForm.stockRecordNo" size="mini" style="width:150px" :min="1" :max="10000" :step="1" label="品牌"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="12" class="form-item">
              <el-form-item label="标准号" prop="standardNo">
                <el-input :disabled="stockInForm.disabledStandard" v-model="stockInForm.standardNo" size="mini" style="width:150px" :min="1" :max="10000" :step="1" label="品牌"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </el-card>
      <span slot="footer" class="dialog-footer">
        <el-checkbox v-model="stockInForm.hasFinished" style="float:left">完成采购</el-checkbox>
        <el-button @click="dialogStockInVisible = false">取 消</el-button>
        <el-button type="primary" @click="saveStockIn">确 定</el-button>
      </span>
    </el-dialog>
    <el-dialog
      title="查询试剂"
      :visible.sync="dialogReagentSearch"
      width="800px"
      :close-on-click-modal="false">
      <el-card class="box-card">
        <el-row>
            <el-col :span="18">
              <div>
                查询&nbsp;&nbsp;&nbsp;<el-select v-model="searchInfo.searchReagentTypeID" placeholder="试剂类别" size="small" style="width:120px">
                <el-option
                  v-for="item in reagentType"
                  :key="item.typeID"
                  :label="item.typeName"
                  :value="item.typeID">
                </el-option>
                </el-select>
                <el-input style="width:200px" placeholder="名称,CAS或简码" v-model="searchInfo.searchReagent" size="small">
                  <el-button slot="append" icon="el-icon-search" @click="getReagentInfoList"></el-button>
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
          :data="reagentInfoData"
          style="width: 100%"
          max-height="450"
          size="mini"
          >
          <el-table-column type="expand">
            <template slot-scope="props">
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
                  危化类别：
                </el-col>
                <el-col :span="9">
                  {{ props.row.dangerName }}
                </el-col>
              </el-row>
              <el-row>
                <el-col :span="3" class="detailTitle">
                  关键字：
                </el-col>
                <el-col :span="21">
                  {{ props.row.keywords }}
                </el-col>
              </el-row>
            </template>
          </el-table-column>
          <el-table-column
            prop="reagentID"
            label="序号"
            width="50"
            align="center">
          </el-table-column>
          <el-table-column
            prop="reagentName"
            label="试剂名称"
            align="center">
          </el-table-column>
          <el-table-column
            prop="typeName"
            label="类别"
            align="center">
          </el-table-column>
          <el-table-column
            prop="CAS"
            label="CAS"
            align="center">
          </el-table-column>
          <el-table-column
            label="操作"
            width="150px"
            align="center">
              <template slot-scope="scope">
                <el-button
                size="mini"
                type="primary"
                @click="choiceReagent(scope.row)">更改</el-button>
              </template>
              </el-table-column>
          </el-table>
      </el-card>
    </el-dialog>
      <!-- 添加试剂信息对话框 -->
    <el-dialog
    title="添加试剂信息"
    :visible.sync="addDialogVisible"
    :close-on-click-modal="false"
    width="600px">
      <el-form
      :model="addForm"
      style="margin-right:30px"
      ref="addForm"
      >
        <el-row>
          <el-col :span="12">
            <el-form-item
            label="名称"
            label-width="100px"
            prop="reagentName"
            :rules="[
            {required: true, message:'试剂名称不能为空', trigger: 'blur'}
            ]"
            >
              <el-input @change="changeName($event, addForm)" v-model="addForm.reagentName" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item
            label="关键字"
            label-width="100px"
            prop="keywords">
              <el-input v-model="addForm.keywords" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item
            label="拼音短码"
            label-width="100px"
            prop="reagentShortCode"
            :rules="[
            {required: true, message:'拼音短码不能为空', trigger: 'blur'}
            ]">
              <el-input v-model="addForm.reagentShortCode" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item
            label="类型"
            label-width="100px"
            prop="reagentTypeID"
            :rules="[
            {required: true, message:'试剂类型不能为空', trigger: 'blur'}
            ]">
              <el-select v-model="addForm.reagentTypeID" placeholder="请选择" @change="changeType">
                <el-option
                  v-for="item in reagentType"
                  :key="item.typeID"
                  :label="item.typeName"
                  :value="item.typeID">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
         <el-row>
          <el-col :span="12">
            <el-form-item
            label="CAS"
            label-width="100px"
            prop="CAS"
            >
              <el-input v-model="addForm.CAS" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item
            label="危化类别"
            label-width="100px"
            prop="reagentDangerID"
            :rules="[
            {required: true, message:'危化类别不能为空', trigger: 'blur'}
            ]">
              <el-select v-model="addForm.reagentDangerID" placeholder="请选择" :disabled="addDangerDisable">
                <el-option
                  v-for="item in reagentDanger"
                  :key="item.dangerID"
                  :label="item.dangerName"
                  :value="item.dangerID">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item
            label="规格"
            label-width="100px"
            prop="reagentSpec"
            :rules="[
            {required: true, message:'规格不能为空', trigger: 'blur'}
            ]">
              <el-input v-model="addForm.reagentSpec" autocomplete="off" placeholder="多规格请用逗号分隔"></el-input>
              <span>{{specList}}</span>
            </el-form-item>
          </el-col>
          <el-col :span="12">
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addReagentInfo">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'ApplicationOrderManage',
  data () {
    return {
      reagentInfoData: [], // 试剂信息
      reagentDanger: [],
      reagentType: [],
      recordList: [], // 批号可选列表
      currentOrder: {}, // 当前正在处理的订单
      dialogStockInVisible: false, // 入库窗口显示标志
      dialogReagentSearch: false, // 更改试剂窗口
      addDialogVisible: false,
      addDangerDisable: false, // 用于新增试剂窗口
      stockInInfo: {},
      addForm: {
        reagentSpec: '',
        reagentDangerID: 0,
        CAS: '',
        keywords: ''
      },
      stockInForm: {
        orderSpec: '',
        orderPurity: '',
        hasFinished: true,
        reagentNum: 0,
        stockBatchNo: '', // 批号
        stockRecordNo: '', // 备案号
        stockUnit: '', // 试剂单位
        stockBrand: '', // 试剂品牌
        composition: '', // 含量
        expiryDate: '', // 过期日期
        standardNo: '',
        reagentName: '',
        reagentID: 0,
        test: ''
      },
      orderList: [],
      purityData: [],
      orderDetail: [],
      expands: [], // 表格中展开的行，对应表格中 :expand-row-keys 属性值，实现单行展开
      // 入库查询窗口
      searchInfo: {
        searchReagentTypeID: '',
        searchReagentDangerID: '',
        searchReagent: ''
      }, // 用于入库时重新选择试剂
      currentPage: 1,
      pageSize: 5,
      pageCount: 0
    }
  },
  methods: {
    addReagentInfo: function () {
      // todo 先判断在列表中是否存在相同的供应商名称
      this.$refs['addForm'].validate((isPass, object) => {
        if (!isPass) {
          this.$message({
            message: '请输入完整信息！',
            type: 'error'
          })
        } else {
          axios({
            method: 'post',
            url: '/api/reagentInfo/addReagentInfo',
            data: {
              reagentinfo: this.addForm
            }
          })
            .then((res) => {
              if (res.data.result === 1) {
                // 成功则关闭窗口，不成功不关闭
                this.$message({
                  message: res.data.msg,
                  type: 'success'
                })
                this.$refs['addForm'].resetFields()
                this.stockInForm.reagentName = this.addForm.reagentName
                this.stockInForm.reagentID = res.data.id
                this.getBatchNoList(res.data.id)
                this.addDialogVisible = false
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
        }
      })
    },
    changeType (value) {
      // 当用户选择了易制毒（爆） value===4 时，危化类别的其它选项才可选，否则为 /
      if (value === 4) {
        this.addDangerDisable = false
        this.addForm.reagentDangerID = 0
      } else {
        this.addDangerDisable = true
        this.addForm.reagentDangerID = 1
      }

      if (value === 2) {
        this.addForm.CAS = '/'
      }
    },
    showAddReagent: function () {
      this.addDialogVisible = true
    },
    choiceReagent: function (row) {
      this.stockInForm.reagentName = row.reagentName
      this.stockInForm.reagentID = row.reagentID
      this.getBatchNoList(row.reagentID)
      this.dialogReagentSearch = false
    },
    showReagentInfo: function () {
      this.dialogReagentSearch = true
    },
    handleCurrentChange (currentPage) {
      this.currentPage = currentPage
      this.getReagentInfoList()
    },
    // 用于入库时，查询更改试剂信息
    getReagentInfoList: function () {
      axios({
        method: 'get',
        url: '/api/reagentInfo/getreagentInfoList',
        params: {
          searchInfo: this.searchInfo,
          pageInfo: {
            pageSize: this.pageSize,
            currentPage: this.currentPage
          }
        }
      })
        .then((res) => {
          this.reagentInfoData = res.data.data
          this.pageCount = res.data.count
          // this.getBaseFullName()
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },
    getBaseInfoList () {
      axios({
        method: 'get',
        url: '/api/reagentInfo/getBaseInfo'
      })
        .then((res) => {
          this.reagentType = res.data.reagentType
          this.reagentDanger = res.data.reagentDanger
          this.reagentType.unshift({typeID: 0, typeName: '全部', state: 1})
          this.reagentDanger.unshift({dangerID: 0, dangerName: '请选择', state: 1})
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },
    // 入库窗口关闭时，窗口内容初始化
    closeDialog: function () {
      this.$refs['stockInForm'].resetFields()
    },
    // 获取批号列表
    getRecordList: function (queryString, cb) {
      var results = queryString ? this.recordList.filter(this.createFilter(queryString)) : this.recordList
      // 调用 callback 返回建议列表的数据
      cb(results)
    },
    // 批号筛选函数
    createFilter (queryString) {
      return (record) => {
        return (record.value.toLowerCase().indexOf(queryString.toLowerCase()) === 0)
      }
    },
    // 批号选中之后的处理
    handleSelect: function (item) {
      this.stockInForm.orderSpec = item.stockSpec
      this.stockInForm.orderPurity = item.stockPurity
      this.stockInForm.stockUnit = item.stockUnit
      this.stockInForm.stockBrand = item.stockBrand
      this.stockInForm.composition = item.composition
      this.stockInForm.expiryDate = item.expiryDate
      this.stockInForm.stockRecordNo = item.stockRecordNo
    },
    saveStockIn: function () {
      this.$confirm('您确定提交吗?（空白项目自动补上"/"）', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        // 没有输入的项目，自动补上 '/'
        if (this.stockInForm.orderSpec === '') this.stockInForm.orderSpec = '/'
        if (this.stockInForm.orderPurity === '') this.stockInForm.orderPurity = '/'
        if (this.stockInForm.stockUnit === '') this.stockInForm.stockUnit = '/'
        if (this.stockInForm.stockBrand === '') this.stockInForm.stockBrand = '/'
        if (this.stockInForm.composition === '') this.stockInForm.composition = '/'
        if (this.stockInForm.stockRecordNo === '') this.stockInForm.stockRecordNo = '/'
        if (this.stockInForm.stockBatchNo === '') this.stockInForm.stockBatchNo = '/'
        if (this.stockInForm.standardNo === '') this.stockInForm.standardNo = '/'

        // 商品入库
        axios({
          method: 'post',
          url: '/api/order/saveStockIn',
          data: {
            stockInInfo: this.stockInForm
          }
        })
          .then((res) => {
            this.dialogStockInVisible = false
            if (res.data.result === 1) {
              // 入库操作成功
              this.loadDetail(this.currentOrder, [this.currentOrder])
              this.$message({
                message: res.data.msg,
                type: 'success'
              })
            }
            if (res.data.result === 2) {
              // 入库操作成功，订单已完成
              this.getOrderList()
              this.$message({
                message: res.data.msg,
                type: 'success'
              })
            }
            if (res.data.result === 3) {
              // 部分入库成功
              this.$message({
                message: res.data.msg,
                type: 'success'
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
    getPurityList: function () {
      axios({
        method: 'get',
        url: '/api/puritySet/getPurityList'
      })
        .then((res) => {
          this.purityData = res.data
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },
    handleChoice: function (row) {
      this.stockInInfo = row
      for (let i = 0; i < this.orderDetail.length; i++) {
        if (this.orderDetail[i].orderDetailID === row.orderDetailID) {
          this.stockInInfo.specList = this.orderDetail[i].reagentSpec.split(',')
          break
        }
      }
      this.stockInForm.orderSpec = ''
      this.stockInForm.orderPurity = ''
      this.stockInForm.stockUnit = ''
      this.stockInForm.stockBrand = ''
      this.stockInForm.composition = ''
      this.stockInForm.expiryDate = ''
      this.stockInForm.stockRecordNo = ''
      this.stockInForm.standardNo = ''
      this.stockInForm.reagentID = row.reagentID
      this.stockInForm.orderDetailID = row.orderDetailID
      this.stockInForm.orderID = row.orderID
      this.stockInForm.reagentName = row.reagentName

      this.stockInForm.disabledRecord = true
      this.stockInForm.stockRecordNo = '/'

      this.stockInForm.disabledStandard = true
      this.stockInForm.standardNo = '/'

      switch (this.stockInInfo.reagentTypeID) {
        case 3:
          this.stockInForm.disabledStandard = false
          this.stockInForm.standardNo = ''
          break
        case 4:
          this.stockInForm.stockRecordNo = ''
          this.stockInForm.disabledRecord = false
          break
      }
      this.getBatchNoList(row.reagentID)
      this.dialogStockInVisible = true
    },
    // 获取批号列表
    getBatchNoList: function (reagentID) {
      axios({
        method: 'get',
        url: '/api/stocks/getStocksByReagentID',
        params: {
          reagentID: reagentID
        }
      })
        .then((res) => {
          // todo: 获得列表，保存
          this.recordList = res.data
          for (let i = 0; i < this.recordList.length; i++) {
            this.recordList[i].value = this.recordList[i].stockBatchNo
          }
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },
    handleStockIn: function (row) {
      // 入库处理
      this.currentOrder = row
      if (this.$refs['orderTable'].expandRowKeys.length === 0) {
        this.loadDetail(row, [row])
      } else {
        this.loadDetail(row, [])
      }
    },
    getOrderList: function () {
      axios({
        method: 'get',
        url: '/api/order/getOrderList',
        params: {
          stepInfo: 'ApplicationOrderManage'
        }
      })
        .then((res) => {
          this.orderList = res.data
          // 修改，删除，提交按钮状态，只有在当前申购单处于待提交状态时，可以使用
          // 待提交状态值为 10 ,申购驳回状态值为 14,参见 stepList 表
          for (let i = 0; i < this.orderList.length; i++) {
            this.orderList[i].tagType = 'info'
            if (this.orderList[i].stepID === 10) {
              // 待提交
              this.orderList[i].disableModify = false // 控制是否显示修改，删除，提交按钮
              this.orderList[i].tagType = 'success' // 设置当前步骤所用模版
            } else {
              this.orderList[i].disableModify = true
            }
            if (this.orderList[i].stepID === 16) {
              // 入库
              this.orderList[i].disableInStock = false // 控制是否显示入库按钮
            } else {
              this.orderList[i].disableInStock = true
            }
            if (this.orderList[i].stepID === 14) {
              // 申购驳回
              this.orderList[i].tagType = 'danger' // 设置当前步骤所用模版
              this.orderList[i].disableModify = false // 控制是否显示修改，删除，提交按钮
              this.orderList[i].showRejectInfo = false // 控制是否显示 驳回信息提示
            } else {
              this.orderList[i].showRejectInfo = true
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
    },
    filterState: function (value, row) {
      return row.stepID === value
    },
    handleDelete: function (index, row) {
      this.$confirm('您确定删除申购单吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'error'
      }).then(() => {
        axios({
          method: 'get',
          url: '/api/order/deleteOrderApp',
          params: {
            orderID: row.orderID
          }
        })
          .then((res) => {
            // 获得反馈信息，给出提示，重新读取列表
            if (res.data.result === 1) {
              this.getOrderList()
              this.$message({
                type: 'success',
                message: res.data.msg
              })
            } else {
              this.$message({
                type: 'error',
                message: res.data.msg
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
    handleSubmit: function (index, row) {
      this.$confirm('您确定提交申购单吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'info'
      }).then(() => {
        axios({
          method: 'get',
          url: '/api/order/submitOrderApp',
          params: {
            orderID: row.orderID
          }
        })
          .then((res) => {
            // 获得反馈信息，给出提示，重新读取列表
            if (res.data.result === 1) {
              this.getOrderList()
              this.$message({
                type: 'success',
                message: res.data.msg
              })
            } else {
              this.$message({
                type: 'error',
                message: res.data.msg
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
          message: '已取消提交'
        })
      })
    },
    handleEdit: function (index, row) {
      // 路由跳转带参数
      this.$router.push({path: '/ApplicationOrderAdd', query: {orderID: row.orderID}})
    },
    loadDetail: function (row, expandedRows) {
      let that = this
      if (expandedRows.length) {
        that.expands = []
        if (row) {
          that.expands.push(row.orderID)
        }
      } else {
        that.expands = []
      }
      axios({
        method: 'get',
        url: '/api/order/getOrderDetail',
        params: {
          orderID: row.orderID
        }
      })
        .then((res) => {
          this.orderDetail = res.data
          for (let i = 0; i < this.orderDetail.length; i++) {
            if (this.orderDetail[i].reagentNum === null) {
              this.orderDetail[i].reagentNum = 0
            }
            if (this.orderDetail[i].state === 0 && row.stepID === 16) {
              this.orderDetail[i].disableChoice = false
            } else {
              this.orderDetail[i].disableChoice = true
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
  computed: {
    specList: function () {
      let tempStr = ''
      if (this.addForm.reagentSpec.length === 0) {
        return tempStr
      }
      let tempAry = this.addForm.reagentSpec.split(',')
      for (let i = 0; i < tempAry.length; i++) {
        tempStr += '★ ' + tempAry[i] + '             '
      }
      return tempStr
    },
    editSpecList: function () {
      let tempStr = ''
      if (this.editForm.reagentSpec.length === 0) {
        return tempStr
      }
      let tempAry = this.editForm.reagentSpec.split(',')
      for (let i = 0; i < tempAry.length; i++) {
        tempStr += '★ ' + tempAry[i] + '             '
      }
      return tempStr
    }
  },
  mounted: function () {
    this.getBaseInfoList()
    this.getOrderList()
    this.getPurityList()
  }
}
</script>

<style scoped>
  .box-card{
    margin-top:-10px
  }
  .center-row{
    margin: 10px 0 -10px 0
  }
  .form-item{
    height:35px
  }
  .title{
    background-color:darkgray
  }
</style>
