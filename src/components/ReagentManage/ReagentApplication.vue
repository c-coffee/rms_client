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
    <!-- 添加部门信息对话框 -->
    <el-dialog
    title="添加供应商信息"
    :visible.sync="addSupplierDialogVisible"
    width="600px">
      <el-form :model="addForm" style="margin-right:30px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="名称" label-width="100px">
              <el-input v-model="addForm.deptName" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="等级" label-width="100px">
              <el-select v-model="value" placeholder="请选择">
                <el-option
                  v-for="item in options"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="联系人" label-width="100px">
              <el-input v-model="addForm.deptName" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="联系电话" label-width="100px">
              <el-input v-model="addForm.deptName" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="地址" label-width="100px">
          <el-input v-model="addForm.deptName" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="备注" label-width="100px">
          <el-input v-model="addForm.deptName" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addSupplierDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addSupplierDialogVisible = false">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 修改部门信息对话框 -->
    <el-dialog
    title="修改科室信息"
    :visible.sync="modifySupplierDialogVisible"
    width="350px">
      <el-form :model="addForm">
        <el-form-item label="科室名称" label-width="100px">
          <el-input v-model="addForm.deptName" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="modifyDeptDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="modifyDeptDialogVisible = false">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 删除部门信息对话框采用 MessageBox弹框方式 -->
  </div>
</template>

<script>
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
      // 添加科室信息表单对应对象
      addForm: {
        deptName: ''
      },
      addSupplierDialogVisible: false, // 添加科室信息窗口控制标识
      modifySupplierDialogVisible: false, // 修改科室信息窗口控制标识
      deleteSupplierDialogVisible: true // 添加科室信息窗口控制标识
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
