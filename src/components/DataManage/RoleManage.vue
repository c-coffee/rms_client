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
                  @click="showRank(scope.$index, scope.row)">权限</el-button>
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
        <el-button type="primary" @click="addRole">确 定</el-button>
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
        <el-button type="primary" @click="editRole">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 权限设置对话框 -->
    <el-dialog
    title="角色权限信息"
    :close-on-click-modal="false"
    :visible.sync="rankDialogVisible"
    width="650px">
        <el-table
          :data="moduleData"
          style="width: 100%;margin-bottom: 20px;"
          row-key="moduleID"
          border
          default-expand-all
          ref="moduleTable"
          :tree-props="{children: 'children', hasChildren: 'hasChildren'}">
          <el-table-column
            prop="moduleID"
            label="ID"
            width="80">
          </el-table-column>
          <el-table-column
            prop="label"
            label="模块名称"
            width="220">
          </el-table-column>
          <el-table-column
            label="权限">
            <template slot-scope="scope">
                <el-checkbox-button label="增" :ref="'I' + scope.row.moduleID" v-model="rankArray[1][scope.$index]">增</el-checkbox-button>
                <el-checkbox-button label="删" :ref="'D' + scope.row.moduleID" v-model="rankArray[2][scope.$index]">删</el-checkbox-button>
                <el-checkbox-button label="改" :ref="'M' + scope.row.moduleID" v-model="rankArray[3][scope.$index]">改</el-checkbox-button>
                <el-checkbox-button label="查" :ref="'S' + scope.row.moduleID" v-model="rankArray[4][scope.$index]">查</el-checkbox-button>
            </template>
          </el-table-column>
        </el-table>
      <div slot="footer" class="dialog-footer">
        <el-button @click="rankDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="modifyRank">确 定</el-button>
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
      // 初始权限数组
      rankArray: [[], [], [], [], []],
      // 当前角色ID
      currentRole: {
        roleID: 1,
        roleRank: []
      },
      // 权限数组
      ranks: [
        {
          name: '增',
          key: 'I'
        },
        {
          name: '删',
          key: 'D'
        },
        {
          name: '改',
          key: 'M'
        },
        {
          name: '查',
          key: 'S'
        }
      ],
      // 初始角色模拟数据
      roleData: [],
      // 模块数据
      moduleData: [],
      originMoudleData: [], // 原始模块数据
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
    // 获取角色信息列表
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
    // 获取模块信息列表，为设置角色权限准备
    getModuleList: function () {
      axios({
        method: 'get',
        url: '/api/moduleSet/getModuleList'
      })
        .then((res) => {
          this.originMoudleData = res.data
          for (let m = 0; m < this.originMoudleData.length; m++) {
            // 权限数组初始化
            // todo 这种获取id和实际界面不一致
            // this.rankArray[0][m] = this.originMoudleData[m].moduleID
            this.rankArray[1][m] = false
            this.rankArray[2][m] = false
            this.rankArray[3][m] = false
            this.rankArray[4][m] = false
          }
          // 获得数据后要筛选整理
          let tempData = res.data.filter(function (item) {
            return item.parent_moduleID === 0
          })
          for (let i = 0; i < tempData.length; i++) {
            tempData[i].children = res.data.filter(function (item) {
              return item.parent_moduleID === tempData[i].moduleID
            })
          }
          // 通过num 控制下标移动
          let num = 0
          for (let m = 0; m < tempData.length; m++) {
            this.rankArray[0][num] = tempData[m].moduleID
            num++
            for (let n = 0; n < tempData[m].children.length; n++) {
              this.rankArray[0][num] = tempData[m].children[n].moduleID
              num++
            }
          }
          this.moduleData = tempData
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },
    // 添加角色
    addRole: function () {
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
    modifyRank: function () {
      console.log(this.rankArray)
      this.currentRole.roleRank.length = 0
      let accessStr = ''
      for (let i = 0; i < this.rankArray[0].length; i++) {
        accessStr = ''
        if (this.rankArray[1][i]) {
          accessStr += 'I'
        }
        if (this.rankArray[2][i]) {
          accessStr += 'D'
        }
        if (this.rankArray[3][i]) {
          accessStr += 'M'
        }
        if (this.rankArray[4][i]) {
          accessStr += 'S'
        }
        if (accessStr.length > 0) {
          this.currentRole.roleRank.push([this.currentRole.roleID, this.rankArray[0][i], accessStr])
          console.log(i, this.rankArray[0][i])
        }
      }
      // 获取了当前角色所选择的权限信息
      // todo: 存入数据库(将旧权限信息删除，加入新的权限信息)
      // 发往数据库
      // console.log(this.currentRole)
      if (this.currentRole.roleRank.length > 0) {
        axios({
          method: 'post',
          url: '/api/role/setRoleRank',
          data: {
            roleRankInfo: this.currentRole
          }
        })
          .then((res) => {
            if (res.data.result === 1) {
              // 成功则关闭窗口，不成功不关闭
              this.$message({
                message: res.data.msg,
                type: 'success'
              })
              this.rankDialogVisible = false
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
          message: '请选择角色权限',
          type: 'warning'
        })
      }
    },
    editRole: function () {
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
    showRank: function (index, row) {
      this.currentRole.roleID = row.roleID
      for (let m = 0; m < this.originMoudleData.length; m++) {
        // 权限数组初始化
        this.rankArray[1][m] = false
        this.rankArray[2][m] = false
        this.rankArray[3][m] = false
        this.rankArray[4][m] = false
      }
      // 获取当前角色的权限列表
      axios({
        method: 'get',
        url: '/api/role/getRoleRankList',
        params: {
          roleID: this.currentRole.roleID
        }
      })
        .then((res) => {
          // 将原有权限信息显示到界面
          this.showRankInfo(res.data)
          this.rankDialogVisible = true
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },
    showRankInfo: function (data) {
      // 界面初始化
      let tempArray = []
      for (let i = 0; i < data.length; i++) {
        tempArray = data[i].accessRight.split('')
        for (let m = 0; m < this.rankArray[0].length; m++) {
          // rankArray数组第0行保存moduleID
          if (this.rankArray[0][m] === data[i].moduleID) {
            for (let n = 0; n < tempArray.length; n++) {
              switch (tempArray[n]) {
                case 'I':
                  this.rankArray[1][m] = true
                  break
                case 'D':
                  this.rankArray[2][m] = true
                  break
                case 'M':
                  this.rankArray[3][m] = true
                  break
                case 'S':
                  this.rankArray[4][m] = true
                  break
              }
            }
          }
        }
      }
    }
  },
  mounted: function () {
    this.getRoleList()
    this.getModuleList()
  }
}
</script>

<style scoped>
</style>
