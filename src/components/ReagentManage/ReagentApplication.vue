<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>试剂申领管理</span>
            <el-button style="float: right; padding: 3px 0" type="text"><router-link to="/ReagentApplicationAdd" tag="span">添加</router-link></el-button>
          </div>
          <el-table
          :data="reagentAppDetail"
          style="width: 100%"
          max-height="450"
          size="mini"
          row-key="appID"
          lazy
          @expand-change="loadDetail"
          :expand-row-keys="expands"
          >
          <el-table-column type="expand">
            <template slot-scope="props">
              <el-table
                :data="reagentList"
                border
                size="mini"
              >
              <el-table-column
                prop="appDetialID"
                label="序号"
                width="50px"
                align="center">
              </el-table-column>
              <el-table-column
                prop="reagentName"
                label="试剂名称"
                align="center">
              </el-table-column>
              <el-table-column
                prop="reagentUnit"
                label="单位"
                align="center">
              </el-table-column>
              <el-table-column
                prop="reagentSpec"
                label="规格"
                align="center">
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
              </el-table>
            </template>
          </el-table-column>
          <el-table-column
              prop="appID"
              label="序号"
              width="50"
              align="center">
          </el-table-column>
          <el-table-column
              prop="appDate"
              label="申请时间"
              align="center">
          </el-table-column>
          <el-table-column
              prop="dangerInfo"
              label="是否有危化"
              align="center">
          </el-table-column>
          <el-table-column
              prop="approverName"
              label="审核人"
              align="center">
          </el-table-column>
          <el-table-column
              prop="approveReason"
              label="驳回原因"
              align="center">
          </el-table-column>
          <el-table-column
              prop="stepName"
              label="当前流程"
              :filters="[{text:'待提交',value:'待提交'},{text:'待审核',value:'待审核'},{text:'已驳回',value:'已驳回'},{text:'待受理',value:'待受理'}]"
              :filter-method="filterState"
              >
          </el-table-column>
          <el-table-column
            label="操作"
            width="220px"
            align="center">
              <template slot-scope="scope">
                <el-button
                size="mini"
                type="info"
                :disabled="buttonChk(scope.row)"
                @click="handleEdit(scope.$index, scope.row)">修改</el-button>
                <el-button
                size="mini"
                type="danger"
                :disabled="buttonChk(scope.row)"
                @click="handleDelete(scope.$index, scope.row)">删除</el-button>
                <el-button
                size="mini"
                type="primary"
                :disabled="buttonChk(scope.row)"
                @click="handleSubmit(scope.$index, scope.row)">提交</el-button>
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
  name: 'ReagentApplication',
  data () {
    return {
      // 初始试剂信息模拟数据
      reagentAppDetail: [
        {
          appID: 1,
          appUserID: '1',
          userName: '章三',
          appDatetime: '2019-6-26',
          typeName: '有机',
          reagentStateID: 2,
          hasDanger: 0,
          approverID: '',
          approverDatetime: '',
          approveReason: '',
          applicationState: 1,
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
          ]
        },
        {
          appID: 2,
          appUserID: '1',
          appDatetime: '2019-6-26',
          userName: '小昭',
          typeName: '有机',
          reagentStateID: 2,
          hasDanger: 0,
          approverID: '',
          approverDatetime: '',
          approveReason: '',
          applicationState: 1,
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
          ]
        }
      ],
      reagentList: [],
      expands: [] // 表格中展开的行，对应表格中 :expand-row-keys 属性值，实现单行展开
    }
  },
  methods: {
    buttonChk: function (row) {
      if (row.stepName === '待提交' || row.stepName === '已驳回') {
        return false
      } else {
        return true
      }
    },
    loadDetail: function (row, expandedRows) {
      let that = this
      if (expandedRows.length) {
        that.expands = []
        if (row) {
          that.expands.push(row.appID)
        }
      } else {
        that.expands = []
      }
      axios({
        method: 'get',
        url: '/api/application/getAppReagentList',
        params: {
          appID: row.appID
        }
      })
        .then((res) => {
          this.reagentList = res.data
          // console.log(res)
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
      return row.stepName === value
    },
    showAddDialog: function () {
      this.addSupplierDialogVisible = true
    },
    handleDelete: function (index, row) {
      this.$confirm('您确定删除科室信息吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
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
      this.modifySupplierDialogVisible = true
    },
    handleSubmit: function (index, row) {
      axios({
        method: 'post',
        url: '/api/application/submitApp',
        data: {
          appId: row.appID,
          hasDanger: row.hasDanger
        }
      })
        .then((res) => {
          console.log(res)
          if (res.data.result === 1) {
            this.getApplicationList()
            this.$message({
              message: res.data.msg,
              type: 'success'
            })
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
    },
    getApplicationList () {
      axios({
        method: 'get',
        url: '/api/application/getApplicationList'
      })
        .then((res) => {
          this.reagentAppDetail = res.data
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
    this.getApplicationList()
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
