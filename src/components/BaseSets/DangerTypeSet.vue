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
      <el-form :model="addForm" ref="addForm">
        <el-form-item
        label="危化类型"
        label-width="100px"
        :rules="[
            {required: true, message:'危化类型不能为空', trigger: 'blur'}
          ]"
        prop="dangerName">
          <el-input v-model="addForm.dangerName" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addDangerTypeDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addDangerType">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 修改危化类型对话框 -->
    <el-dialog
    title="修改危化类型"
    :close-on-click-modal="false"
    :visible.sync="modifyDangerTypeDialogVisible"
    width="350px">
      <el-form :model="editForm" ref="editForm">
        <el-form-item
        label="危化类型"
        label-width="100px"
        prop="dangerName"
        :rules="[
            {required: true, message:'科室名称不能为空', trigger: 'blur'}
        ]">
          <el-input v-model="editForm.dangerName" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="modifyDangerTypeDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="editDangerType">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 删除危化类型对话框采用 MessageBox弹框方式 -->
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'DangerTypeSet',
  data () {
    return {
      // 初始危化类型模拟数据
      dangerTypeData: [
        {
          dangerID: 1,
          dangerName: '普通品'
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
        dangerName: ''
      },
      editForm: {
        dangerID: '',
        dangerName: ''
      },
      addDangerTypeDialogVisible: false, // 添加危化类型窗口控制标识
      modifyDangerTypeDialogVisible: false // 修改危化类型窗口控制标识
    }
  },
  methods: {
    getDangerTypeList: function () {
      axios({
        method: 'get',
        url: '/api/dangerType/getDangerTypeList'
      })
        .then((res) => {
          this.dangerTypeData = res.data
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },
    addDangerType: function () {
      // todo 先判断在列表中是否存在相同的科室名称
      this.$refs['addForm'].validate((isPass, object) => {
        if (!isPass) {
          this.$message({
            message: '请输入完整信息！',
            type: 'error'
          })
        } else {
          let flag = true
          for (let i = 0; i < this.dangerTypeData.length; i++) {
            if (this.addForm.dangerName === this.dangerTypeData[i].dangerName) {
              flag = false
              break
            }
          }
          if (flag) {
            axios({
              method: 'post',
              url: '/api/dangerType/addDangerType',
              data: {
                dangerName: this.addForm.dangerName
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
                  this.addDangerTypeDialogVisible = false
                  this.getDangerTypeList()
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
              message: '该危化类型已存在!'
            })
          }
        }
      })
    },
    showAddDialog: function () {
      this.addDangerTypeDialogVisible = true
    },
    handleDelete: function (index, row) {
      this.$confirm('您确定删除危化类型吗?', '提示', {
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
              this.getDangerTypeList()
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
      this.editForm.dangerID = row.dangerID
      this.editForm.dangerName = row.dangerName
      this.modifyDangerTypeDialogVisible = true
    },
    editDangerType: function () {
      this.$refs['editForm'].validate((isPass, object) => {
        if (isPass) {
          if (!isPass) {
            this.$message({
              message: '请输入完整信息！',
              type: 'error'
            })
          } else {
            let flag = true
            for (let i = 0; i < this.dangerTypeData.length; i++) {
              if (this.editForm.dangerName === this.dangerTypeData[i].dangerName) {
                flag = false
                break
              }
            }
            if (flag) {
              axios({
                method: 'post',
                url: '/api/dangerType/editDangerType',
                data: {
                  // deptID: this.editForm.deptID,
                  // deptName: this.editForm.deptName
                  dangerTypeInfo: this.editForm
                }
              })
                .then((res) => {
                  if (res.data.result === 1) {
                    // 成功则关闭窗口，不成功不关闭
                    this.$message({
                      message: res.data.msg,
                      type: 'success'
                    })
                    this.modifyDangerTypeDialogVisible = false
                    this.getDangerTypeList()
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
    this.getDangerTypeList()
  }
}
</script>

<style scoped>
</style>
