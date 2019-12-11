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
          node-key="moduleId"
          default-expand-all
          :expand-on-click-node="false">
            <span class="custom-tree-node" slot-scope="{ node }">
              <span>{{ node.label }}</span>
              <span>
                <el-button
                  type="text"
                  size="mini"
                  @click="showEditModuleSet(node)">
                  修改
                </el-button>
                <el-button
                  type="text"
                  size="mini"
                  @click="deleteModuleSet(node)">
                  删除
                </el-button>
              </span>
            </span>
          </el-tree>
        </el-card>
      </el-col>
    </el-row>
    <!-- 添加模块信息对话框 -->
    <el-dialog
    title="添加模块信息"
    :visible.sync="addDialogVisible"
    :close-on-click-modal="false"
    width="350px">
      <el-dialog
        width="30%"
        title="请选择父模块"
        :visible.sync="innerAddDialogVisible"
        append-to-body>
        <el-tree
          :data="moduleData"
          node-key="id"
          ref="innerAddTree"
          default-expand-all
          @node-click="addSelectNode"
          :expand-on-click-node="false">
        </el-tree>
        <div slot="footer" class="dialog-footer">
        <el-button @click="innerAddDialogVisible = false">取 消</el-button>
      </div>
      </el-dialog>
      <el-form :model="addForm" ref="addForm">
        <el-form-item
          label="模块名称"
          label-width="100px"
          prop="moduleName"
          :rules="[
          {required: true, message:'模块名称不能为空', trigger: 'blur'}
          ]">
          <el-input v-model="addForm.moduleName" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item
          label="模块代码"
          label-width="100px"
          prop="moduleInfo"
          :rules="[
          {required: true, message:'模块代码不能为空', trigger: 'blur'}
          ]">
          <el-input v-model="addForm.moduleInfo" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item
          label="父模块"
          label-width="100px"
          prop="parent_moduleName"
          :rules="[
          {required: true, message:'父节点不能为空', trigger: 'blur'}
          ]">
          <el-input readonly="readonly" v-model="addForm.parent_moduleName" autocomplete="off">
            <el-button slot="append" @click="innerAddDialogVisible=true">请选择</el-button>
          </el-input>
        </el-form-item>
         <el-form-item
          label="父模块ID"
          label-width="100px"
          prop="parent_moduleID"
          :rules="[
          {required: true, message:'父模块ID不能为空', trigger: 'blur'}
          ]">
          <el-input readonly="readonly" v-model="addForm.parent_moduleID" autocomplete="off"></el-input>
          <el-checkbox v-model="isRoot" @change="setAddRootNode">根节点</el-checkbox>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addModuleSet">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 修改模块信息对话框 -->
    <el-dialog
    title="修改模块信息"
    :visible.sync="modifyDialogVisible"
    :close-on-click-modal="false"
    width="350px">
      <el-dialog
        width="30%"
        title="请选择父模块"
        :visible.sync="innerModifyDialogVisible"
        append-to-body>
        <el-tree
          :data="moduleData"
          node-key="id"
          ref="innerModifyTree"
          default-expand-all
          @node-click="addModifySelectNode"
          :expand-on-click-node="false">
        </el-tree>
        <div slot="footer" class="dialog-footer">
        <el-button @click="innerAddDialogVisible = false">取 消</el-button>
      </div>
      </el-dialog>
      <el-form :model="editForm" ref="editForm">
        <el-form-item
          label="模块名称"
          label-width="100px"
          prop="moduleName"
          :rules="[
          {required: true, message:'模块名称不能为空', trigger: 'blur'}
          ]">
          <el-input v-model="editForm.moduleName" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item
          label="模块代码"
          label-width="100px"
          prop="moduleInfo"
          :rules="[
          {required: true, message:'模块代码不能为空', trigger: 'blur'}
          ]">
          <el-input v-model="editForm.moduleInfo" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item
          label="父模块"
          label-width="100px"
          prop="parent_moduleName"
          :rules="[
          {required: true, message:'父节点不能为空', trigger: 'blur'}
          ]">
          <el-input readonly="readonly" v-model="editForm.parent_moduleName" autocomplete="off">
            <el-button slot="append" @click="innerModifyDialogVisible=true">请选择</el-button>
          </el-input>
        </el-form-item>
         <el-form-item
          label="父模块ID"
          label-width="100px"
          prop="parent_moduleID"
          :rules="[
          {required: true, message:'父模块ID不能为空', trigger: 'blur'}
          ]">
          <el-input readonly="readonly" v-model="editForm.parent_moduleID" autocomplete="off"></el-input>
          <el-checkbox v-model="isModifyRoot" @change="setModifyRootNode">根节点</el-checkbox>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="modifyDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="modifyModuleSet">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 删除部门信息对话框采用 MessageBox弹框方式 -->
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'ModuleSet',
  data () {
    return {
      isRoot: false, // 添加模块时选项，用来判断是否是根节点
      isModifyRoot: false,
      addForm: {},
      editForm: {
        moduleName: '',
        moduleInfo: ''
      },
      // 模块设置 模拟数据
      moduleData: [
        {
          moduleId: 1,
          label: '基础设置',
          children: [
            {
              moduleId: 4,
              label: '科室设置'
            },
            {
              moduleId: 9,
              label: '性状类型'
            },
            {
              moduleId: 10,
              label: '危化类别'
            }
          ]
        },
        {
          moduleId: 2,
          label: '数据管理',
          children: [{
            moduleId: 5,
            label: '供应商'
          }, {
            moduleId: 6,
            label: '试剂管理'
          }, {
            moduleId: 7,
            label: '角色管理'
          }, {
            moduleId: 8,
            label: '用户管理'
          }
          ]
        },
        {
          moduleId: 3,
          label: '检验科室',
          children: [{
            moduleId: 12,
            label: '试剂申领'
          }, {
            moduleId: 13,
            label: '试剂退库'
          }]
        }],
      addDialogVisible: false, // 添加科室信息窗口控制标识
      innerAddDialogVisible: false, // 添加科室信息内层窗口控制标识
      modifyDialogVisible: false, // 修改科室信息窗口控制标识
      innerModifyDialogVisible: false // 修改科室信息内层窗口控制标识
    }
  },
  methods: {
    addSelectNode: function (moduleInfo) {
      this.addForm.parent_moduleName = moduleInfo.label
      this.addForm.parent_moduleID = moduleInfo.moduleID
      this.innerAddDialogVisible = false
    },
    addModifySelectNode: function (moduleInfo) {
      this.editForm.parent_moduleName = moduleInfo.label
      this.editForm.parent_moduleID = moduleInfo.moduleID
      this.innerModifyDialogVisible = false
    },
    addModuleSet: function () {
      // todo 先判断在列表中是否存在相同的供应商名称
      this.$refs['addForm'].validate((isPass, object) => {
        if (!isPass) {
          this.$message({
            message: '请输入完整信息！',
            type: 'error'
          })
        } else {
          let flag = true
          for (let i = 0; i < this.moduleData.length; i++) {
            if (this.addForm.moduleName === this.moduleData[i].moduleName) {
              flag = false
              break
            }
          }
          if (flag) {
            axios({
              method: 'post',
              url: '/api/moduleSet/addModuleSet',
              data: {
                moduleInfo: {
                  moduleName: this.addForm.moduleName,
                  moduleInfo: this.addForm.moduleInfo,
                  parent_moduleID: this.addForm.parent_moduleID
                }
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
                  this.addSupplierDialogVisible = false
                  this.getModuleList()
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
    // 添加模块对话框中的根节点按钮控制
    setAddRootNode: function (flag) {
      if (flag) {
        this.addForm.parent_moduleID = 0
        this.addForm.parent_moduleName = '根节点'
      } else {
        this.addForm.parent_moduleID = ''
        this.addForm.parent_moduleName = ''
      }
    },
    // 修改模块对话框中的根节点按钮控制
    setModifyRootNode: function (flag) {
      if (flag) {
        this.editForm.parent_moduleID = 0
        this.editForm.parent_moduleName = '根节点'
      } else {
        this.editForm.parent_moduleID = ''
        this.editForm.parent_moduleName = ''
      }
    },
    showEditModuleSet: function (node) {
      this.editForm.moduleName = node.label.split('_')[0]
      this.editForm.moduleInfo = node.label.split('_')[1]
      this.editForm.moduleID = node.data.moduleID
      this.editForm.parent_moduleID = node.data.parent_moduleID
      if (this.editForm.parent_moduleID === 0) {
        this.editForm.parent_moduleName = '根节点'
        this.isModifyRoot = true
      } else {
        this.editForm.parent_moduleName = node.parent.label.split('_')[0]
        this.isModifyRoot = false
      }
      this.modifyDialogVisible = true
    },
    deleteModuleSet: function (node) {
      this.$confirm('您确定删除该模块吗(所有子模块都将被删除)?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        axios({
          method: 'post',
          url: '/api/moduleSet/deleteModuleSet',
          data: {
            moduleID: node.data.moduleID
          }
        })
          .then((res) => {
            if (res.data.result === 1) {
              // 成功则关闭窗口，不成功不关闭
              this.$message({
                message: res.data.msg,
                type: 'success'
              })
              this.getModuleList()
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
    getModuleList: function () {
      axios({
        method: 'get',
        url: '/api/moduleSet/getModuleList'
      })
        .then((res) => {
          // 获得数据后要筛选整理
          let tempData = res.data.filter(function (item) {
            return item.parent_moduleID === 0
          })
          for (let i = 0; i < tempData.length; i++) {
            tempData[i].children = res.data.filter(function (item) {
              return item.parent_moduleID === tempData[i].moduleID
            })
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
    showAddDialog: function () {
      this.addDialogVisible = true
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
      this.modifyDialogVisible = true
    },
    // 修改模块设置信息
    modifyModuleSet: function () {
      // todo 先判断在列表中是否存在相同的供应商名称
      this.$refs['editForm'].validate((isPass, object) => {
        if (!isPass) {
          this.$message({
            message: '请输入完整信息！',
            type: 'error'
          })
        } else {
          let flag = true
          for (let i = 0; i < this.moduleData.length; i++) {
            if (this.editForm.moduleName === this.moduleData[i].moduleName && this.editForm.moduleID !== this.supplierData[i].moduleID) {
              flag = false
              break
            }
          }
          if (flag) {
            axios({
              method: 'post',
              url: '/api/moduleSet/modifyModuleSet',
              data: {
                moduleSetInfo: this.editForm
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
                  this.getModuleList()
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
              message: '该模块信息已存在!'
            })
          }
        }
      })
    }
  },
  mounted: function () {
    this.getModuleList()
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
