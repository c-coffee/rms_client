<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>试剂性状设置</span>
            <el-button @click.stop="showAddDialog" style="float: right; padding: 3px 0" type="text">添加</el-button>
          </div>
          <el-table
          :data="reagentData"
          style="width: 100%"
          max-height="450"
          >
          <el-table-column
              prop="stateID"
              label="序号"
              width="180"
              align="center">
          </el-table-column>
          <el-table-column
              prop="stateName"
              label="性状类型"
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
    <!-- 添加试剂性状信息对话框 -->
    <el-dialog
    title="添加试剂性状"
    :visible.sync="addDialogVisible"
    width="350px">
      <el-form :model="addForm" ref="addForm">
        <el-form-item
          prop="stateName"
          :rules="[
            {required: true, message:'性状名称不能为空', trigger: 'blur'}
          ]"
          label="性状名称"
          label-width="100px">
          <el-input v-model="addForm.stateName" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addReagentState">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 修改试剂性状对话框 -->
    <el-dialog
    title="修改试剂性状"
    :close-on-click-modal="false"
    :visible.sync="modifyDialogVisible"
    width="350px">
      <el-form
      :model="editForm"
      ref="editForm"
      >
        <el-form-item
        prop="stateName"
        label="类型名称"
        label-width="100px"
        :rules="[
          {required: true, message:'试剂性状不能为空', trigger: 'blur'}
        ]">
          <el-input v-model="editForm.stateName" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="modifyDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="editReagentState">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'ReagentStateSet',
  data () {
    return {
      // 初始试剂性状数据
      reagentData: [],
      // 添加试剂性状表单对应对象
      addForm: {},
      editForm: {
        stateName: ''
      },
      addDialogVisible: false, // 添加试剂性状窗口控制标识
      modifyDialogVisible: false // 修改试剂性状窗口控制标识
    }
  },
  methods: {
    addReagentState: function () {
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
            if (this.addForm.stateName === this.reagentData[i].stateName) {
              flag = false
              break
            }
          }
          if (flag) {
            axios({
              method: 'post',
              url: '/api/reagentState/addReagentState',
              data: {
                stateName: this.addForm.stateName
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
                  this.getReagentStateList()
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
              message: '该性状类型已存在!'
            })
          }
        }
      })
    },
    getReagentStateList: function () {
      axios({
        method: 'get',
        url: '/api/reagentState/getReagentStateList'
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
      this.$confirm('您确定删除性状类型吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        axios({
          method: 'post',
          url: '/api/reagentState/deleteReagentState',
          data: {
            stateID: row.stateID
          }
        })
          .then((res) => {
            if (res.data.result === 1) {
              // 成功则关闭窗口，不成功不关闭
              this.$message({
                message: res.data.msg,
                type: 'success'
              })
              this.getReagentStateList()
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
      this.editForm.stateID = row.stateID
      this.editForm.stateName = row.stateName
      this.modifyDialogVisible = true
    },
    editReagentState: function () {
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
              if (this.editForm.stateName === this.reagentData[i].stateName) {
                flag = false
                break
              }
            }
            if (flag) {
              axios({
                method: 'post',
                url: '/api/reagentState/editReagentState',
                data: {
                  reagentState: this.editForm
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
                    this.getReagentStateList()
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
                message: '该性状类型已存在!'
              })
            }
          }
        }
      })
    }
  },
  mounted: function () {
    this.getReagentStateList()
  }
}
</script>

<style scoped>
</style>
