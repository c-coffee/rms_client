<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>角色设置</span>
            <el-button @click.stop="showAddDialog" style="float: right; padding: 3px 0" type="text">添加</el-button>
          </div>
          <el-table
          :data="roleData"
          style="width: 100%"
          max-height="450"
          >
          <el-table-column
              prop="roleID"
              label="序号"
              width="180"
              align="center">
          </el-table-column>
          <el-table-column
              prop="roleName"
              label="角色名称"
              align="center">
          </el-table-column>
          <el-table-column
            label="操作"
            width="250px"
            align="center">
              <template slot-scope="scope">
                  <el-button
                  size="mini"
                  @click="handleEdit(scope.$index, scope.row)">权限</el-button>
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
    <!-- 添加角色信息对话框 -->
    <el-dialog
    title="添加角色信息"
    :visible.sync="addDialogVisible"
    width="350px">
      <el-form :model="addForm" ref="addForm">
        <el-form-item
          label="角色名称"
          label-width="100px"
          :rules="[
            {required: true, message:'角色名称不能为空', trigger: 'blur'}
          ]"
          prop="roleName"
          >
          <el-input v-model="addForm.roleName" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addDepartment">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 修改角色信息对话框 -->
    <el-dialog
    title="修改角色信息"
    :close-on-click-modal="false"
    :visible.sync="modifyDialogVisible"
    width="350px">
      <el-form :model="editForm" ref="editForm">
        <el-form-item
          label="角色名称"
          prop="roleName"
          label-width="100px"
          :rules="[
            {required: true, message:'角色名称不能为空', trigger: 'blur'}
          ]"
          >
          <el-input v-model="editForm.roleName" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="modifyDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="editDepartment">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 权限设置对话框 -->
    <el-dialog
    title="角色权限信息"
    :close-on-click-modal="false"
    :visible.sync="rankDialogVisible"
    width="350px">
      <el-form :model="rankForm" ref="rankForm">
        <el-form-item
          label="角色名称"
          prop="roleName"
          label-width="100px"
          :rules="[
            {required: true, message:'角色名称不能为空', trigger: 'blur'}
          ]"
          >
          <el-input v-model="editForm.roleName" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="rankDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="showRank">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'RoleManage',
  data () {
    return {
      // 初始角色模拟数据
      roleData: [],
      // 添加角色信息表单对应对象
      addForm: {
        roleName: ''
      },
      editForm: {
        roleID: '',
        roleName: ''
      },
      rankForm: {},
      addDialogVisible: false, // 添加角色信息窗口控制标识
      modifyDialogVisible: false, // 修改角色信息窗口控制标识
      rankDialogVisible: false // 权限设置窗口控制标识
    }
  },
  methods: {
    getRoleList: function () {
      axios({
        method: 'get',
        url: '/api/role/getRoleList'
      })
        .then((res) => {
          this.roleData = res.data
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },

    // 添加部门
    addDepartment: function () {
      // todo 先判断在列表中是否存在相同的角色名称
      this.$refs['addForm'].validate((isPass, object) => {
        if (!isPass) {
          this.$message({
            message: '请输入完整信息！',
            type: 'error'
          })
        } else {
          let flag = true
          for (let i = 0; i < this.roleData.length; i++) {
            if (this.addForm.roleName === this.roleData[i].roleName) {
              flag = false
              break
            }
          }
          if (flag) {
            axios({
              method: 'post',
              url: '/api/role/addRole',
              data: {
                roleName: this.addForm.roleName
              }
            })
              .then((res) => {
                if (res.data.result === 1) {
                  // 成功则关闭窗口，不成功不关闭
                  this.$message({
                    message: res.data.msg,
                    type: 'success'
                  })
                  this.$refs['addForm'].resetFields()
                  this.addDialogVisible = false
                  this.getRoleList()
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
          } else {
            this.$message({
              type: 'error',
              message: '该角色名已存在!'
            })
          }
        }
      })
    },
    showAddDialog: function () {
      this.addDialogVisible = true
    },
    handleDelete: function (index, row) {
      this.$confirm('您确定删除角色信息吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        axios({
          method: 'post',
          url: '/api/role/deleteRole',
          data: {
            roleID: row.roleID
          }
        })
          .then((res) => {
            if (res.data.result === 1) {
              // 成功则关闭窗口，不成功不关闭
              this.$message({
                message: res.data.msg,
                type: 'success'
              })
              this.getRoleList()
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
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消删除'
        })
      })
    },
    handleEdit: function (index, row) {
      this.editForm.roleID = row.roleID
      this.editForm.roleName = row.roleName
      this.modifyDialogVisible = true
    },
    editDepartment: function () {
      this.$refs['editForm'].validate((isPass, object) => {
        if (isPass) {
          if (!isPass) {
            this.$message({
              message: '请输入完整信息！',
              type: 'error'
            })
          } else {
            let flag = true
            for (let i = 0; i < this.roleData.length; i++) {
              if (this.editForm.roleName === this.roleData[i].roleName) {
                flag = false
                break
              }
            }
            if (flag) {
              axios({
                method: 'post',
                url: '/api/role/editRoleInfo',
                data: {
                  roleInfo: this.editForm
                }
              })
                .then((res) => {
                  if (res.data.result === 1) {
                    // 成功则关闭窗口，不成功不关闭
                    this.$message({
                      message: res.data.msg,
                      type: 'success'
                    })
                    this.modifyDialogVisible = false
                    this.getRoleList()
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
            } else {
              this.$message({
                type: 'error',
                message: '该角色名已存在!'
              })
            }
          }
        }
      })
    },
    showRank: function () {
      this.rankDialogVisible = true
    }
  },
  mounted: function () {
    this.getRoleList()
  }
}
</script>

<style scoped>
</style>
