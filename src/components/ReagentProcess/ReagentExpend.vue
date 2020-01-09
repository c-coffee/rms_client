<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>试剂消耗管理</span>
          </div>
          <el-pagination
            @current-change="handleCurrentChange"
            layout="prev, pager, next"
            style="float:right"
            :page-size="this.pageSize"
            :current-page="this.currentPage"
            :total="this.pageCount">
          </el-pagination>
          <el-table
          :data="deptStockList"
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
                  {{ props.row.deptStockNum }}
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
              prop="deptStocksID"
              label="序号"
              width="80"
              align="center">
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
              prop="deptStockNum"
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
                @click="handleExpend(scope.$index, scope.row)">消耗</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>
      <el-dialog
      title="试剂消耗"
      :visible.sync="dialogExpendVisible"
      :close-on-click-modal="false"
      width="400px">
        <el-row>
         <el-col>
           <el-form ref="form" :model="expendForm" label-width="80px">
            <el-form-item label="消耗数量">
              <el-input-number v-model="expendForm.reagentNum" style="width:200px" :min="1" :max="expendForm.stockNum" :step="1" label="入库数量"></el-input-number>
            </el-form-item>
            <el-form-item label="用途描述">
              <el-input v-model="expendForm.reason" type="textarea" rows="3" autocomplete="off"></el-input>
            </el-form-item>
           </el-form>
         </el-col>
        </el-row>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogExpendVisible = false">取 消</el-button>
        <el-button type="primary" @click="saveExpend">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'ReagentExpend',
  data () {
    return {
      deptStockList: [],
      dialogExpendVisible: false,
      expendForm: {
        stockNum: 0,
        deptStocksID: 0,
        deptStocksSpec: '',
        deptStocksPurity: '',
        reagentNum: 1,
        reason: ''
      },
      currentPage: 1,
      pageSize: 8,
      pageCount: 0
    }
  },
  methods: {
    getDeptStockList: function () {
      axios({
        method: 'get',
        url: '/api/stocks/getDeptStockList'
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
          this.deptStockList = temp
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
    },
    saveExpend: function () {
      // console.log(this.expendForm)
      axios({
        method: 'post',
        url: '/api/stocks/deptExpend',
        data: {
          expendInfo: this.expendForm
        }
      })
        .then((res) => {
          this.dialogExpendVisible = false
          this.getDeptStockList()
          this.$message({
            type: 'success',
            message: res.data.msg
          })
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },
    handleExpend: function (index, row) {
      this.expendForm.stockNum = row.reagentNum
      this.expendForm.reagentID = row.reagentID
      this.expendForm.deptStocksID = row.deptStocksID
      this.expendForm.stocksID = row.stocksID
      this.dialogExpendVisible = true
    }
  },
  mounted: function () {
    this.getDeptStockList()
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
