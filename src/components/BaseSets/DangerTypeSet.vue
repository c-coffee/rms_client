<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>危化类型设置</span>
            <el-button @click.stop="showAddDialog" style="float: right; padding: 3px 0" type="text">添加</el-button>
          </div>
          <el-table
          :data="dangerTypeData"
          style="width: 100%"
          max-height="450"
          >
          <el-table-column
              prop="dangerID"
              label="序号"
              width="180"
              align="center">
          </el-table-column>
          <el-table-column
              prop="dangerName"
              label="危化类型"
              align="center">
          </el-table-column>
          <el-table-column
            label="操作"
            width="250px"
            align="center">
              <template slot-scope="scope">
                  <el-button
                  size="mini"
                  type='info'
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
    <!-- 添加危化类型对话框 -->
    <el-dialog
    title="添加危化类型"
    :visible.sync="addDangerTypeDialogVisible"
    width="350px">
      <el-form :model="addForm">
        <el-form-item label="危化类型" label-width="100px">
          <el-input v-model="addForm.deptName" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addDangerTypeDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addDangerTypeDialogVisible = false">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 修改危化类型对话框 -->
    <el-dialog
    title="修改危化类型"
    :visible.sync="modifyDangerTypeDialogVisible"
    width="350px">
      <el-form :model="addForm">
        <el-form-item label="危化类型" label-width="100px">
          <el-input v-model="addForm.deptName" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="modifyDangerTypeDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="modifyDangerTypeDialogVisible = false">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 删除危化类型对话框采用 MessageBox弹框方式 -->
  </div>
</template>

<script>
export default {
  name: 'DepartmentSet',
  data () {
    return {
      // 初始危化类型模拟数据
      dangerTypeData: [
        {
          dangerID: 1,
          dangerName: '普通'
        },
        {
          dangerID: 2,
          dangerName: '易燃品'
        },
        {
          dangerID: 3,
          dangerName: '易爆品'
        },
        {
          dangerID: 4,
          dangerName: '有毒'
        }
      ],
      // 添加危化类型表单对应对象
      addForm: {
        deptName: ''
      },
      addDangerTypeDialogVisible: false, // 添加危化类型窗口控制标识
      modifyDangerTypeDialogVisible: false, // 修改危化类型窗口控制标识
      deleteDeptDialogVisible: true // 添加危化类型窗口控制标识
    }
  },
  methods: {
    showAddDialog: function () {
      this.addDangerTypeDialogVisible = true
    },
    handleDelete: function (index, row) {
      this.$confirm('您确定删除危化类型吗?', '提示', {
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
      this.modifyDangerTypeDialogVisible = true
    }
  }
}
</script>

<style scoped>
</style>
