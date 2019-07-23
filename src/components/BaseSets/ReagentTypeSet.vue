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
          :data="reagentData"
          style="width: 100%"
          max-height="450"
          >
          <el-table-column
              prop="typeID"
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
    :visible.sync="addDialogVisible"
    width="350px">
      <el-form :model="addForm" ref="addForm">
        <el-form-item
          prop="reagentType"
          :rules="[
            {required: true, message:'科室名称不能为空', trigger: 'blur'}
          ]"
          label="类型名称"
          label-width="100px">
          <el-input v-model="addForm.reagentType" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addReagentType">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 修改试剂类型对话框 -->
    <el-dialog
    title="修改试剂类型"
    :close-on-click-modal="false"
    :visible.sync="modifyDialogVisible"
    width="350px">
      <el-form
      :model="editForm"
      ref="editForm"
      >
        <el-form-item
        prop="typeName"
        label="类型名称"
        label-width="100px"
        :rules="[
          {required: true, message:'试剂类型不能为空', trigger: 'blur'}
        ]">
          <el-input v-model="editForm.typeName" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="modifyDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="editReagentType">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 删除部门信息对话框采用 MessageBox弹框方式 -->
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'ReagentTypeSet',
  data () {
    return {
      // 初始试剂性状数据
      reagentData: [],
      // 添加科室信息表单对应对象
      addForm: {
        reagentType: ''
      },
      editForm: {
        typeID: '',
        typeName: ''
      },
      addDialogVisible: false, // 添加试剂类型窗口控制标识
      modifyDialogVisible: false, // 修改试剂类型窗口控制标识
      deleteDialogVisible: true // 添加试剂类型窗口控制标识
    }
  },
  methods: {
    addReagentType: function () {
      // todo 先判断在列表中是否存在相同的科室名称
      this.$refs['addForm'].validate((isPass, object) => {
        if (!isPass) {
          this.$message({
            message: '请输入完整信息！',
            type: 'error'
          })
        } else {
          let flag = true
          for (let i = 0; i < this.reagentData.length; i++) {
            if (this.addForm.reagentType === this.reagentData[i].reagentType) {
              flag = false
              break
            }
          }
          if (flag) {
            axios({
              method: 'post',
              url: '/api/reagentType/addReagentType',
              data: {
                typeName: this.addForm.reagentType
              }
            })
              .then((res) => {
                if (res.data.result === 1) {
                  // 成功则关闭窗口，不成功不关闭
                  this.$message({
                    message: res.data.msg,
                    type: 'success'
                  })
                  this.addDialogVisible = false
                  this.getReagentTypeList()
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
              message: '该科室名已存在!'
            })
          }
        }
      })
    },
    getReagentTypeList: function () {
      axios({
        method: 'get',
        url: '/api/reagentType/getReagentTypeList'
      })
        .then((res) => {
          this.reagentData = res.data
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
      this.$confirm('您确定删除试剂类型吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        axios({
          method: 'post',
          url: '/api/reagentType/deleteReagentType',
          data: {
            typeID: row.typeID
          }
        })
          .then((res) => {
            if (res.data.result === 1) {
              // 成功则关闭窗口，不成功不关闭
              this.$message({
                message: res.data.msg,
                type: 'success'
              })
              this.getReagentTypeList()
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
      this.editForm.typeID = row.typeID
      this.editForm.typeName = row.typeName
      this.modifyDialogVisible = true
    },
    editReagentType: function () {
      this.$refs['editForm'].validate((isPass, object) => {
        if (isPass) {
          if (!isPass) {
            this.$message({
              message: '请输入完整信息！',
              type: 'error'
            })
          } else {
            let flag = true
            for (let i = 0; i < this.reagentData.length; i++) {
              if (this.editForm.typeName === this.reagentData[i].typeName) {
                flag = false
                break
              }
            }
            if (flag) {
              axios({
                method: 'post',
                url: '/api/reagentType/editReagentType',
                data: {
                  // deptID: this.editForm.deptID,
                  // deptName: this.editForm.deptName
                  reagentTypeInfo: this.editForm
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
                    this.getReagentTypeList()
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
                message: '该试剂类型已存在!'
              })
            }
          }
        }
      })
    }
  },
  mounted: function () {
    this.getReagentTypeList()
  }
}
</script>

<style scoped>
</style>
