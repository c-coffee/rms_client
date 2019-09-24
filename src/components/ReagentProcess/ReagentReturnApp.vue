<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>试剂退库管理</span>
            <el-button style="float: right; padding: 3px 0" type="text"><router-link to="/ReagentApplicationAdd" tag="span">添加</router-link></el-button>
          </div>
          <el-table
          :data="returnReagent"
          style="width: 100%"
          max-height="450"
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
                  {{ props.row.reagentSpec }}
                </el-col>
              </el-row>
              <el-row>
                <el-col :span="3" class="detailTitle">
                  单位：
                </el-col>
                <el-col :span="9">
                  {{ props.row.reagentUnit }}
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
                  退库时间：
                </el-col>
                <el-col :span="9">
                  {{ props.row.returnDate }}
                </el-col>
              </el-row>
              <el-row>
                <el-col :span="3" class="detailTitle">
                  退库原因：
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
              prop="returnID"
              label="序号"
              width="80"
              align="center">
          </el-table-column>
          <el-table-column
              prop="userName"
              label="申请人"
              align="center">
          </el-table-column>
          <el-table-column
              prop="reagentName"
              label="试剂名称"
              align="center">
          </el-table-column>
          <el-table-column
              prop="reagentNum"
              label="退库数量"
              align="center">
          </el-table-column>
          <el-table-column
              prop="returnDate"
              label="申请时间"
              align="center">
          </el-table-column>
          <el-table-column
              prop="returnState"
              label="当前步骤"
              align="center"
              :filters="[{text:'待处理',value:1},{text:'待审核',value:2},{text:'审核驳回',value:3},{text:'已受理',value:4}]"
              :filter-method="filterState"
              >
          </el-table-column>
          <el-table-column
            label="操作"
            width="250px"
            align="center">
              <template slot-scope="scope">
                <el-button
                size="mini"
                type="info"
                @click="handleEdit(scope.$index, scope.row)">修改</el-button>
                <el-button
                size="mini"
                type="danger"
                @click="handleDelete(scope.$index, scope.row)">删除</el-button>
                <el-button
                size="mini"
                type="primary"
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
export default {
  name: 'ReagentReturnApp',
  data () {
    return {
      // 初始试剂信息模拟数据
      returnReagent: [
        {
          returnID: 1,
          userID: 2,
          userName: '章三',
          reagentID: 2,
          reagentName: '硝酸银',
          reagentSpec: '>=99.9%',
          reagentUnit: 'L',
          reagentNum: 10,
          reagentDeptStore: 50, // 部门存量
          returnReason: '存量过多',
          returnDate: '2019-6-15',
          returnState: 1,
          receiverUserID: 3,
          receiverUserName: '管理员',
          rejectReason: ''
        },
        {
          returnID: 2,
          userID: 2,
          userName: '章三',
          reagentID: 2,
          reagentName: '硝酸银',
          reagentSpec: '>=99.9%',
          reagentUnit: 'L',
          reagentNum: 10,
          reagentDeptStore: 50, // 部门存量
          returnReason: '存量过多',
          returnDate: '2019-6-15',
          returnState: 1,
          receiverUserID: 3,
          receiverUserName: '管理员',
          rejectReason: ''
        },
        {
          returnID: 3,
          userID: 2,
          userName: '章三',
          reagentID: 2,
          reagentName: '硝酸银',
          reagentSpec: '>=99.9%',
          reagentUnit: 'L',
          reagentNum: 10,
          reagentDeptStore: 50, // 部门存量
          returnReason: '存量过多',
          returnDate: '2019-6-15',
          returnState: 1,
          receiverUserID: 3,
          receiverUserName: '管理员',
          rejectReason: ''
        }
      ]
    }
  },
  methods: {
    filterState: function (value, row) {
      return row.returnState === value
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
