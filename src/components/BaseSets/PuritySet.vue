<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>纯度设置</span>
            <el-button @click.stop="showAddDialog" style="float: right; padding: 3px 0" type="text">添加</el-button>
          </div>
          <el-table
          :data="purityData"
          style="width: 100%"
          max-height="450"
          size="mini"
          >
          <el-table-column
              prop="purityID"
              label="序号"
              width="180"
              align="center">
          </el-table-column>
          <el-table-column
              prop="purityName"
              label="纯度"
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
    <!-- 添加纯度对话框 -->
    <el-dialog
    title="添加纯度信息"
    :visible.sync="addDialogVisible"
    width="350px">
      <el-form :model="addForm" ref="addForm">
        <el-form-item
        label="纯度信息"
        label-width="100px"
        :rules="[
            {required: true, message:'纯度信息不能为空', trigger: 'blur'}
          ]"
        prop="purityName">
          <el-input v-model="addForm.purityName" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addPurityInfo">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 修改纯度信息对话框 -->
    <el-dialog
    title="修改纯度信息"
    :close-on-click-modal="false"
    :visible.sync="modifyDialogVisible"
    width="350px">
      <el-form :model="editForm" ref="editForm">
        <el-form-item
        label="纯度信息"
        label-width="100px"
        prop="purityName"
        :rules="[
            {required: true, message:'纯度信息不能为空', trigger: 'blur'}
        ]">
          <el-input v-model="editForm.purityName" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="modifyDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="editPurityInfo">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 删除危化类型对话框采用 MessageBox弹框方式 -->
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'PuritySet',
  data () {
    return {
      // 初始危化类型模拟数据
      purityData: [],
      // 添加危化类型表单对应对象
      addForm: {
        purityName: ''
      },
      editForm: {
        purityID: '',
        purityName: ''
      },
      addDialogVisible: false, // 添加危化类型窗口控制标识
      modifyDialogVisible: false // 修改危化类型窗口控制标识
    }
  },
  methods: {
    getPurityList: function () {
      axios({
        method: 'get',
        url: '/api/puritySet/getPurityList'
      })
        .then((res) => {
          this.purityData = res.data
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },
    addPurityInfo: function () {
      // todo 先判断在列表中是否存在相同的科室名称
      this.$refs['addForm'].validate((isPass, object) => {
        if (!isPass) {
          this.$message({
            message: '请输入完整信息！',
            type: 'error'
          })
        } else {
          let flag = true
          for (let i = 0; i < this.purityData.length; i++) {
            if (this.addForm.purityName === this.purityData[i].purityName) {
              flag = false
              break
            }
          }
          if (flag) {
            axios({
              method: 'post',
              url: '/api/puritySet/addPurityInfo',
              data: {
                purityName: this.addForm.purityName
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
                  this.getPurityList()
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
              message: '该纯度信息已存在!'
            })
          }
        }
      })
    },
    showAddDialog: function () {
      this.addDialogVisible = true
    },
    handleDelete: function (index, row) {
      this.$confirm('您确定删除纯度信息吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        axios({
          method: 'post',
          url: '/api/dangerType/deleteDangerType',
          data: {
            dangerID: row.dangerID
          }
        })
          .then((res) => {
            if (res.data.result === 1) {
              // 成功则关闭窗口，不成功不关闭
              this.$message({
                message: res.data.msg,
                type: 'success'
              })
              this.getPurityList()
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
      this.editForm.purityID = row.purityID
      this.editForm.purityName = row.purityName
      this.modifyDialogVisible = true
    },
    editPurityInfo: function () {
      this.$refs['editForm'].validate((isPass, object) => {
        if (isPass) {
          if (!isPass) {
            this.$message({
              message: '请输入完整信息！',
              type: 'error'
            })
          } else {
            let flag = true
            for (let i = 0; i < this.purityData.length; i++) {
              if (this.editForm.purityName === this.purityData[i].purityName) {
                flag = false
                break
              }
            }
            if (flag) {
              axios({
                method: 'post',
                url: '/api/puritySet/editPurityInfo',
                data: {
                  // deptID: this.editForm.deptID,
                  // deptName: this.editForm.deptName
                  purityInfo: this.editForm
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
                    this.getPurityList()
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
                message: '该危化品类型已存在!'
              })
            }
          }
        }
      })
    }
  },
  mounted: function () {
    this.getPurityList()
  }
}
</script>

<style scoped>
</style>
