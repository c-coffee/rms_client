<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>科室设置</span>
            <el-button @click.stop="showAddDialog" style="float: right; padding: 3px 0" type="text">添加</el-button>
          </div>
          <el-table
          :data="deptData"
          style="width: 100%"
          max-height="450"
          >
          <el-table-column
              prop="deptId"
              label="序号"
              width="180"
              align="center">
          </el-table-column>
          <el-table-column
              prop="deptName"
              label="科室名称"
              align="center">
          </el-table-column>
          <el-table-column
            label="操作"
            width="250px"
            align="center">
              <template slot-scope="scope">
                  <el-button
                  size="mini"
                  @click="handleEdit(scope.$index, scope.row)">修改</el-button>
                  <el-button
                  size="mini"
                  type="danger"
                  @click="handleDelete(scope.$index, scope.row)">删除</el-button>
              </template>
              </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>
    <!-- 添加部门信息对话框 -->
    <el-dialog
    title="添加科室信息"
    :visible.sync="addDeptDialogVisible"
    width="350px">
      <el-form :model="addForm">
        <el-form-item label="科室名称" label-width="100px">
          <el-input v-model="addForm.deptName" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addDeptDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addDeptDialogVisible = false">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 修改部门信息对话框 -->
    <el-dialog
    title="修改科室信息"
    :visible.sync="modifyDeptDialogVisible"
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
  name: 'DepartmentSet',
  data () {
    return {
      // 初始部门模拟数据
      deptData: [
        {
          deptId: 1,
          deptName: '检验一室'
        },
        {
          deptId: 2,
          deptName: '检验二室'
        },
        {
          deptId: 3,
          deptName: '检验三室'
        }
      ],
      // 添加科室信息表单对应对象
      addForm: {
        deptName: ''
      },
      addDeptDialogVisible: false, // 添加科室信息窗口控制标识
      modifyDeptDialogVisible: false, // 修改科室信息窗口控制标识
      deleteDeptDialogVisible: true // 添加科室信息窗口控制标识
    }
  },
  methods: {
    showAddDialog: function () {
      this.addDeptDialogVisible = true
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
      this.modifyDeptDialogVisible = true
    }
  }
}
</script>

<style scoped>
</style>
