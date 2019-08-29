<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>用户管理</span>
            <el-button @click.stop="showAddDialog" style="float: right; padding: 3px 0" type="text">添加</el-button>
          </div>
          <el-table
          :data="userData"
          style="width: 100%"
          max-height="450"
          >
          <el-table-column
              prop="userID"
              label="序号"
              width="80"
              align="center">
          </el-table-column>
          <el-table-column
              prop="userName"
              label="用户名"
              align="center">
          </el-table-column>
          <el-table-column
              prop="userRealName"
              label="姓名"
              align="center">
          </el-table-column>
          <el-table-column
              prop="deptName"
              label="所属部门"
              align="center">
          </el-table-column>
          <el-table-column
              prop="userPhone"
              label="电话"
              align="center">
          </el-table-column>
          <el-table-column
            label="操作"
            width="350px"
            align="center">
              <template slot-scope="scope">
                <el-button
                size="mini"
                type="info"
                @click="resetPwd(scope.$index, scope.row)">密码重置</el-button>
                <el-button
                size="mini"
                type="warning"
                @click="handleRole(scope.$index, scope.row)">角色</el-button>
                <el-button
                size="mini"
                type="primary"
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
    <!-- 添加用户信息对话框 -->
    <el-dialog
    title="添加用户信息"
    :visible.sync="addDialogVisible"
    width="600px">
      <el-form
      :model="addForm"
      style="margin-right:30px"
      ref="addForm"
      >
        <el-row>
          <el-col :span="12">
            <el-form-item
            label="用户名"
            label-width="100px"
            prop="userName"
            :rules="[
            {required: true, message:'用户名名称不能为空', trigger: 'blur'}
            ]"
            >
              <el-input v-model="addForm.userName" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item
            label="姓名"
            label-width="100px"
            prop="userRealName"
            :rules="[
            {required: true, message:'姓名不能为空', trigger: 'blur'}
            ]"
            >
              <el-input v-model="addForm.userRealName" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item
            label="所属部门"
            label-width="100px"
            prop="userDptID"
            :rules="[
            {required: true, message:'所属部门不能为空', trigger: 'blur'}
            ]">
              <el-select v-model="addForm.userDptID" placeholder="请选择">
                <el-option
                  v-for="item in deptList"
                  :key="item.deptID"
                  :label="item.deptName"
                  :value="item.deptID">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item
            label="联系电话"
            label-width="100px"
            prop="userPhone"
            :rules="[
            {required: true, message:'联系电话不能为空', trigger: 'blur'}
            ]">
              <el-input v-model="addForm.userPhone" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addUser">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 修改用户信息对话框 -->
    <el-dialog
    title="修改用户信息"
    :visible.sync="modifyDialogVisible"
    width="600px">
      <el-form
      :model="editForm"
      style="margin-right:30px"
      ref="editForm"
      >
        <el-row>
          <el-col :span="12">
            <el-form-item
            label="用户名"
            label-width="100px"
            prop="userName"
            :rules="[
            {required: true, message:'用户名名称不能为空', trigger: 'blur'}
            ]"
            >
              <el-input v-model="editForm.userName" readonly="readonly" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item
            label="姓名"
            label-width="100px"
            prop="userRealName"
            :rules="[
            {required: true, message:'姓名不能为空', trigger: 'blur'}
            ]"
            >
              <el-input v-model="editForm.userRealName" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item
            label="所属部门"
            label-width="100px"
            prop="userDptID"
            :rules="[
            {required: true, message:'所属部门不能为空', trigger: 'blur'}
            ]">
              <el-select v-model="editForm.userDptID" placeholder="请选择">
                <el-option
                  v-for="item in deptList"
                  :key="item.deptID"
                  :label="item.deptName"
                  :value="item.deptID">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item
            label="联系电话"
            label-width="100px"
            prop="userPhone"
            :rules="[
            {required: true, message:'联系电话不能为空', trigger: 'blur'}
            ]">
              <el-input v-model="editForm.userPhone" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="modifyDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="editUser">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 设置用户角色对话框 -->
    <el-dialog
    title="设置用户角色"
    :visible.sync="setRoleDialogVisible"
    width="600px">
      <el-form
      :model="userRoleForm"
      style="margin-right:30px"
      ref="userRoleForm"
      >
        <el-row>
          <el-col :span="12">
            <el-form-item
            label="用户名"
            label-width="100px"
            prop="userName"
            :rules="[
            {required: true, message:'用户名名称不能为空', trigger: 'blur'}
            ]"
            >
              <el-input v-model="userRoleForm.userName" readonly="readonly" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item
            label="姓名"
            label-width="100px"
            prop="userRealName"
            :rules="[
            {required: true, message:'姓名不能为空', trigger: 'blur'}
            ]"
            >
              <el-input v-model="userRoleForm.userRealName" readonly="readonly" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item
            label="所属角色"
            label-width="100px"
            prop="userRoleList"
            :rules="[
            {required: true, message:'角色不能为空', trigger: 'blur'}
            ]">
              <el-checkbox-group v-model="userRoleForm.userRoleList">
                <el-checkbox v-for="role in roleList" :label="role.roleID" :key="role.roleID">{{role.roleName}}</el-checkbox>
              </el-checkbox-group>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="setRoleDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="setRoleList">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 删除部门信息对话框采用 MessageBox弹框方式 -->
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'UserManage',
  data () {
    return {
      roleList: [],
      deptList: [],
      // 初始供应商模拟数据
      userData: [],
      // 添加科室信息表单对应对象
      addForm: {},
      editForm: {},
      userRoleForm: {
        userID: '',
        userName: '',
        userRealName: '',
        userRoleList: []
      },
      addDialogVisible: false, // 添加用户信息窗口控制标识
      setRoleDialogVisible: false, // 设置角色信息窗口控制标识
      modifyDialogVisible: false // 修改用户信息窗口控制标识
    }
  },
  methods: {
    addUser: function () {
      // todo 先判断在列表中是否存在相同的供应商名称
      this.$refs['addForm'].validate((isPass, object) => {
        if (!isPass) {
          this.$message({
            message: '请输入完整信息！',
            type: 'error'
          })
        } else {
          let flag = true
          for (let i = 0; i < this.userData.length; i++) {
            if (this.addForm.userName === this.userData[i].userName) {
              flag = false
              break
            }
          }
          if (flag) {
            console.log(this.addForm)
            axios({
              method: 'post',
              url: '/api/user/addUser',
              data: {
                userInfo: this.addForm
              }
            })
              .then((res) => {
                if (res.data.result === 1) {
                  // 成功则关闭窗口，不成功不关闭
                  this.$message({
                    message: res.data.msg,
                    type: 'success'
                  })
                  // console.log(this.$refs)
                  this.$refs['addForm'].resetFields()
                  this.addDialogVisible = false
                  this.getUserList()
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
              message: '该用户已存在!'
            })
          }
        }
      })
    },
    editUser: function () {
      // todo 先判断在列表中是否存在相同的供应商名称
      this.$refs['editForm'].validate((isPass, object) => {
        if (!isPass) {
          this.$message({
            message: '请输入完整信息！',
            type: 'error'
          })
        } else {
          let flag = true
          for (let i = 0; i < this.userData.length; i++) {
            if (this.editForm.userName === this.userData[i].userName && this.editForm.userID !== this.userData[i].userID) {
              flag = false
              break
            }
          }
          if (flag) {
            axios({
              method: 'post',
              url: '/api/user/editUser',
              data: {
                userInfo: this.editForm
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
                  this.getUserList()
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
              message: '该供应商已存在!'
            })
          }
        }
      })
    },
    getUserList: function () {
      axios({
        method: 'get',
        url: '/api/user/getUserList'
      })
        .then((res) => {
          this.userData = res.data
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },
    showAddDialog: function () {
      this.addDialogVisible = true
    },
    handleDelete: function (index, row) {
      this.$confirm('您确定删除该用户吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        axios({
          method: 'post',
          url: '/api/user/deleteUser',
          data: {
            userID: row.userID
          }
        })
          .then((res) => {
            if (res.data.result === 1) {
              // 成功则关闭窗口，不成功不关闭
              this.$message({
                message: res.data.msg,
                type: 'success'
              })
              this.getUserList()
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
      this.editForm = row
      this.modifyDialogVisible = true
    },
    handleRole: function (index, row) {
      // 获取当前用户所设角色列表
      axios({
        method: 'post',
        url: '/api/user/getUserRoleList',
        data: {
          userID: row.userID
        }
      })
        .then((res) => {
          this.userRoleForm.userID = row.userID
          this.userRoleForm.userName = row.userName
          this.userRoleForm.userRealName = row.userRealName
          this.userRoleForm.userRoleList = []
          for (let i = 0; i < res.data.length; i++) {
            this.userRoleForm.userRoleList.push(res.data[i].roleID)
          }
          this.setRoleDialogVisible = true
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },
    getDeptList: function () {
      axios({
        method: 'get',
        url: '/api/department/getDeptList'
      })
        .then((res) => {
          this.deptList = res.data
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },
    getRoleList: function () {
      axios({
        method: 'get',
        url: '/api/role/getRoleList'
      })
        .then((res) => {
          this.roleList = res.data
          console.log(this.roleList)
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },
    resetPwd: function (index, row) {
      this.$confirm('您确定重置该用户密码吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        axios({
          method: 'post',
          url: '/api/user/resetUserPwd',
          data: {
            userID: row.userID
          }
        })
          .then((res) => {
            if (res.data.result === 1) {
              // 成功则关闭窗口，不成功不关闭
              this.$message({
                message: res.data.msg,
                type: 'success'
              })
              // this.getUserList()
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
          message: '已取消重置操作'
        })
      })
    },
    setRoleList: function () {
      this.$refs['userRoleForm'].validate((isPass, object) => {
        if (!isPass) {
          this.$message({
            message: '请输入完整信息！',
            type: 'error'
          })
        } else {
          let userRoleInfo = {
            userID: this.userRoleForm.userID,
            userRole: []
          }
          for (let i = 0; i < this.userRoleForm.userRoleList.length; i++) {
            userRoleInfo.userRole.push([this.userRoleForm.userID, this.userRoleForm.userRoleList[i]])
          }
          console.log(userRoleInfo)
          axios({
            method: 'post',
            url: '/api/user/setUserRole',
            data: {
              userRoleInfo
            }
          })
            .then((res) => {
              if (res.data.result === 1) {
                // 成功则关闭窗口，不成功不关闭
                this.$message({
                  message: res.data.msg,
                  type: 'success'
                })
                this.setRoleDialogVisible = false
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
        }
      })
    }
  },
  mounted: function () {
    this.getDeptList()
    this.getRoleList()
    this.getUserList()
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
