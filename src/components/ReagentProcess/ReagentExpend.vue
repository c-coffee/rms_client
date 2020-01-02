<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>试剂消耗管理</span>
          </div>
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
                <el-col :span="9">
                  {{ props.row.reagentName }}
                </el-col>
                <el-col :span="3" class="detailTitle">
                  规格：
                </el-col>
                <el-col :span="9">
                  {{ props.row.stockSpec }}
                </el-col>
              </el-row>
              <el-row>
                <el-col :span="3" class="detailTitle">
                  单位：
                </el-col>
                <el-col :span="9">
                  {{ props.row.stockUnit }}
                </el-col>
                <el-col :span="3" class="detailTitle">
                  数量：
                </el-col>
                <el-col :span="9">
                  {{ props.row.reagentNum }}
                </el-col>
              </el-row>
              <el-row>
                <el-col :span="3" class="detailTitle">
                  当前存量：
                </el-col>
                <el-col :span="9">
                  {{ props.row.reagentDeptStore }}
                </el-col>
                <el-col :span="3" class="detailTitle">
                  使用时间：
                </el-col>
                <el-col :span="9">
                  {{ props.row.returnDate }}
                </el-col>
              </el-row>
              <el-row>
                <el-col :span="3" class="detailTitle">
                  使用用途：
                </el-col>
                <el-col :span="21">
                  {{ props.row.returnReason }}
                </el-col>
              </el-row>
              <el-row>
                <el-col :span="3" class="detailTitle">
                  受理人：
                </el-col>
                <el-col :span="9">
                  {{ props.row.receiverUserName }}
                </el-col>
                <el-col :span="3" class="detailTitle">
                  拒绝原因：
                </el-col>
                <el-col :span="9">
                  {{ props.row.rejectReason }}
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
      }
    }
  },
  methods: {
    getDeptStockList: function () {
      axios({
        method: 'get',
        url: '/api/stocks/getDeptStockList'
      })
        .then((res) => {
          console.log(res.data)
          this.deptStockList = res.data
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
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
