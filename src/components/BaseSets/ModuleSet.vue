<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>模块设置</span>
            <el-button @click.stop="showAddDialog" style="float: right; padding: 3px 0" type="text">添加</el-button>
          </div>
          <el-tree
          :data="moduleData"
          show-checkbox
          node-key="id"
          default-expand-all
          :expand-on-click-node="false">
            <span class="custom-tree-node" slot-scope="{ node, data }">
              <span>{{ node.label }}</span>
              <span>
                <el-button
                  type="text"
                  size="mini"
                  @click="() => append(data)">
                  Append
                </el-button>
                <el-button
                  type="text"
                  size="mini"
                  @click="() => remove(node, data)">
                  Delete
                </el-button>
              </span>
            </span>
          </el-tree>
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
  name: 'ModuleSet',
  data () {
    return {
      // 模块设置 模拟数据
      moduleData: [
        {
          id: 1,
          label: '基础设置',
          children: [
            {
              id: 4,
              label: '科室设置'
            },
            {
              id: 9,
              label: '性状类型'
            },
            {
              id: 10,
              label: '危化类别'
            }
          ]
        },
        {
          id: 2,
          label: '数据管理',
          children: [{
            id: 5,
            label: '供应商'
          }, {
            id: 6,
            label: '试剂管理'
          }, {
            id: 7,
            label: '角色管理'
          }, {
            id: 8,
            label: '用户管理'
          }
          ]
        },
        {
          id: 3,
          label: '检验科室',
          children: [{
            id: 12,
            label: '试剂申领'
          }, {
            id: 13,
            label: '试剂退库'
          }]
        }],
      addDeptDialogVisible: false, // 添加科室信息窗口控制标识
      modifyDeptDialogVisible: false, // 修改科室信息窗口控制标识
      deleteDeptDialogVisible: true // 添加科室信息窗口控制标识
    }
  },
  methods: {
    addForm: function () {

    },
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
  .custom-tree-node {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-size: 14px;
    padding-right: 8px;
  }
</style>
