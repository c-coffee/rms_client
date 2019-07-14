<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>试剂采购管理</span>
            <el-button style="float: right; padding: 3px 0" type="text"><router-link to="/ReagentApplicationAdd" tag="span">新建采购</router-link></el-button>
          </div>
          <el-table
          :data="reagentOrder"
          style="width: 100%"
          max-height="450"
          >
          <el-table-column type="expand">
            <template slot-scope="props">
              <el-table
                :data="props.row.appDetail"
                border
              >
              <el-table-column
                prop="appDetailID"
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
                prop="reagentUnit"
                label="单位"
                align="center"
                width="50px">
              </el-table-column>
              <el-table-column
                prop="reagentSpec"
                label="规格"
                align="center">
              </el-table-column>
              <el-table-column
                prop="reagentNum"
                label="数量"
                align="center"
                width="80px">
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
              width="180"
              align="center">
          </el-table-column>
          <el-table-column
              prop="userName"
              label="申请人"
              align="center">
          </el-table-column>
          <el-table-column
              prop="appDatetime"
              label="申请时间"
              align="center">
          </el-table-column>
          <el-table-column
              prop="hasDanger"
              label="是否有危化"
              align="center">
          </el-table-column>
          <el-table-column
              prop="applicationState"
              label="当前步骤"
              align="center"
              :filters="[{text:'待处理',value:1},{text:'待审核',value:2},{text:'审核驳回',value:3},{text:'已受理',value:4}]"
              :filter-method="filterState"
              >
          </el-table-column>
          <el-table-column
            label="操作"
            width="300px"
            align="center">
              <template slot-scope="scope">
                <el-button
                size="mini"
                type="success"
                @click="handleEdit(scope.$index, scope.row)">采购管理</el-button>
                <el-button
                size="mini"
                type="primary"
                @click="handleEdit(scope.$index, scope.row)">提交审核</el-button>
                <el-button
                size="mini"
                type="danger"
                @click="handleDelete(scope.$index, scope.row)">驳回</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'OrderApprove',
  data () {
    return {
      // 初始试剂信息模拟数据
      reagentOrder: [
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
      ]
    }
  },
  methods: {
    filterState: function (value, row) {
      return row.applicationState === value
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
    }
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
