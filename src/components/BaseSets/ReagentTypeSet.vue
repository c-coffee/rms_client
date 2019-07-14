<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>试剂 性状类型</span>
            <el-button @click.stop="showAddDialog" style="float: right; padding: 3px 0" type="text">添加</el-button>
          </div>
          <el-table
          :data="typeData"
          style="width: 100%"
          max-height="450"
          >
          <el-table-column
              prop="typeId"
              label="序号"
              width="180"
              align="center">
          </el-table-column>
          <el-table-column
              prop="typeName"
              label="类型名称"
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
    <!-- 添加试剂类型信息对话框 -->
    <el-dialog
    title="添加试剂类型"
    :visible.sync="addDeptDialogVisible"
    width="350px">
      <el-form :model="addForm">
        <el-form-item label="类型名称" label-width="100px">
          <el-input v-model="addForm.reagentType" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addRgtDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addRgtDialogVisible = false">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 修改部门信息对话框 -->
    <el-dialog
    title="修改试剂类型"
    :visible.sync="modifyRgtDialogVisible"
    width="350px">
      <el-form :model="addForm">
        <el-form-item label="试剂类型名称" label-width="100px">
          <el-input v-model="addForm.deptName" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="modifyRgtDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="modifyRgtDialogVisible = false">确 定</el-button>
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
      typeData: [
        {
          typeId: 1,
          typeName: '固体'
        },
        {
          typeId: 2,
          typeName: '液体'
        },
        {
          typeId: 3,
          typeName: '气体'
        }
      ],
      // 添加科室信息表单对应对象
      addForm: {
        reagentTypeName: ''
      },
      addRgtDialogVisible: false, // 添加试剂类型窗口控制标识
      modifyRgtDialogVisible: false, // 修改试剂类型窗口控制标识
      deleteRgtDialogVisible: true // 添加试剂类型窗口控制标识
    }
  },
  methods: {
    showAddDialog: function () {
      this.addRgtDialogVisible = true
    },
    handleDelete: function (index, row) {
      this.$confirm('您确定删除试剂类型吗?', '提示', {
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
      this.modifyRgtDialogVisible = true
    }
  }
}
</script>

<style scoped>
</style>
