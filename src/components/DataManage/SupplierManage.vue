<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>供应商管理</span>
            <el-button @click.stop="showAddDialog" style="float: right; padding: 3px 0" type="text">添加</el-button>
          </div>
          <el-table
          :data="supplierData"
          style="width: 100%"
          max-height="450"
          >
          <el-table-column type="expand">
            <template slot-scope="props">
              <div class="supplierDetail">
              <el-row>
                <el-col :span="3" class="detailTitle">
                  名称：
                </el-col>
                <el-col :span="9">
                  {{ props.row.supplierName }}
                </el-col>
                <el-col :span="3" class="detailTitle">
                  等级：
                </el-col>
                <el-col :span="9">
                  {{ props.row.supplierLevel }}
                </el-col>
              </el-row>
              <el-row>
                <el-col :span="3" class="detailTitle">
                  联系人：
                </el-col>
                <el-col :span="9">
                  {{ props.row.supplierContact }}
                </el-col>
                <el-col :span="3" class="detailTitle">
                  联系电话：
                </el-col>
                <el-col :span="9">
                  {{ props.row.supplierContactPhone }}
                </el-col>
              </el-row>
              <el-row>
                <el-col :span="3" class="detailTitle">
                  地址：
                </el-col>
                <el-col :span="21">
                  {{ props.row.supplierAddress }}
                </el-col>
              </el-row>
              <el-row>
                <el-col :span="3" class="detailTitle">
                  备注：
                </el-col>
                <el-col :span="21">
                  {{ props.row.remark }}
                </el-col>
              </el-row>
              </div>
            </template>
          </el-table-column>
          <el-table-column
              prop="supplierID"
              label="序号"
              width="180"
              align="center">
          </el-table-column>
          <el-table-column
              prop="supplierName"
              label="供应商名称"
              align="center">
          </el-table-column>
          <el-table-column
              prop="supplierContact"
              label="联系人"
              align="center">
          </el-table-column>
          <el-table-column
              prop="supplierContactPhone"
              label="联系电话"
              align="center">
          </el-table-column>
          <el-table-column
            label="操作"
            width="250px"
            align="center">
              <template slot-scope="scope">
                <el-button
                size="mini"
                type="info"
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
    <!-- 添加部门信息对话框 -->
    <el-dialog
    title="添加供应商信息"
    :visible.sync="addSupplierDialogVisible"
    width="600px">
      <el-form
      :model="addForm"
      style="margin-right:30px"
      ref="addForm"
      >
        <el-row>
          <el-col :span="12">
            <el-form-item
            label="名称"
            label-width="100px"
            prop="supplierName"
            :rules="[
            {required: true, message:'供应商名称不能为空', trigger: 'blur'}
            ]"
            >
              <el-input v-model="addForm.supplierName" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item
            label="等级"
            label-width="100px"
            prop="supplierLevel"
            :rules="[
            {required: true, message:'等级不能为空', trigger: 'blur'}
            ]"
            >
              <el-select v-model="addForm.supplierLevel" placeholder="请选择">
                <el-option
                  v-for="item in options"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item
            label="联系人"
            label-width="100px"
            prop="supplierContact"
            :rules="[
            {required: true, message:'联系人不能为空', trigger: 'blur'}
            ]">
              <el-input v-model="addForm.supplierContact" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item
            label="联系电话"
            label-width="100px"
            prop="supplierContactPhone"
            :rules="[
            {required: true, message:'联系电话不能为空', trigger: 'blur'}
            ]">
              <el-input v-model="addForm.supplierContactPhone" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="地址" label-width="100px" prop="supplierAddress">
          <el-input v-model="addForm.supplierAddress" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="备注" label-width="100px" prop="remark">
          <el-input v-model="addForm.remark" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addSupplierDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addSupplier">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 修改部门信息对话框 -->
    <el-dialog
    title="修改科室信息"
    :visible.sync="modifySupplierDialogVisible"
    width="600px">
      <el-form :model="editForm" ref="editForm">
        <el-row>
          <el-col :span="12">
            <el-form-item
            label="名称"
            label-width="100px"
            prop="supplierName"
            :rules="[
            {required: true, message:'供应商名称不能为空', trigger: 'blur'}
            ]"
            >
              <el-input v-model="editForm.supplierName" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item
            label="等级"
            label-width="100px"
            prop="supplierLevel"
            :rules="[
            {required: true, message:'等级不能为空', trigger: 'blur'}
            ]"
            >
              <el-select v-model="editForm.supplierLevel" placeholder="请选择">
                <el-option
                  v-for="item in options"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item
            label="联系人"
            label-width="100px"
            prop="supplierContact"
            :rules="[
            {required: true, message:'联系人不能为空', trigger: 'blur'}
            ]">
              <el-input v-model="editForm.supplierContact" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item
            label="联系电话"
            label-width="100px"
            prop="supplierContactPhone"
            :rules="[
            {required: true, message:'联系电话不能为空', trigger: 'blur'}
            ]">
              <el-input v-model="editForm.supplierContactPhone" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="地址" label-width="100px" prop="supplierAddress">
          <el-input v-model="editForm.supplierAddress" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="备注" label-width="100px" prop="remark">
          <el-input v-model="editForm.remark" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="modifySupplierDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="editSupplier">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 删除部门信息对话框采用 MessageBox弹框方式 -->
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'SupplierManage',
  data () {
    return {
      // 供应商等级
      options: [
        {
          value: 'A',
          label: 'A'
        },
        {
          value: 'B',
          label: 'B'
        },
        {
          value: 'C',
          label: 'C'
        },
        {
          value: 'D',
          label: 'D'
        }
      ],
      // 初始供应商模拟数据
      supplierData: [],
      // 添加科室信息表单对应对象
      addForm: {},
      editForm: {},
      addSupplierDialogVisible: false, // 添加科室信息窗口控制标识
      modifySupplierDialogVisible: false // 修改科室信息窗口控制标识
    }
  },
  methods: {
    addSupplier: function () {
      // todo 先判断在列表中是否存在相同的供应商名称
      this.$refs['addForm'].validate((isPass, object) => {
        if (!isPass) {
          this.$message({
            message: '请输入完整信息！',
            type: 'error'
          })
        } else {
          let flag = true
          for (let i = 0; i < this.supplierData.length; i++) {
            if (this.addForm.supplierName === this.supplierData[i].supplierName) {
              flag = false
              break
            }
          }
          if (flag) {
            axios({
              method: 'post',
              url: '/api/supplier/addSupplier',
              data: {
                supplierInfo: this.addForm
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
                  this.addSupplierDialogVisible = false
                  this.getSupplierList()
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
    editSupplier: function () {
      // todo 先判断在列表中是否存在相同的供应商名称
      this.$refs['editForm'].validate((isPass, object) => {
        if (!isPass) {
          this.$message({
            message: '请输入完整信息！',
            type: 'error'
          })
        } else {
          let flag = true
          for (let i = 0; i < this.supplierData.length; i++) {
            if (this.editForm.supplierName === this.supplierData[i].supplierName && this.editForm.supplierID !== this.supplierData[i].supplierID) {
              flag = false
              break
            }
          }
          if (flag) {
            axios({
              method: 'post',
              url: '/api/supplier/editSupplier',
              data: {
                supplierInfo: this.editForm
              }
            })
              .then((res) => {
                if (res.data.result === 1) {
                  // 成功则关闭窗口，不成功不关闭
                  this.$message({
                    message: res.data.msg,
                    type: 'success'
                  })
                  this.modifySupplierDialogVisible = false
                  this.getSupplierList()
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
    getSupplierList: function () {
      axios({
        method: 'get',
        url: '/api/supplier/getSupplierList'
      })
        .then((res) => {
          this.supplierData = res.data
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
      this.addSupplierDialogVisible = true
    },
    handleDelete: function (index, row) {
      this.$confirm('您确定删除供应商吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        axios({
          method: 'post',
          url: '/api/supplier/deleteSupplier',
          data: {
            supplierID: row.supplierID
          }
        })
          .then((res) => {
            if (res.data.result === 1) {
              // 成功则关闭窗口，不成功不关闭
              this.$message({
                message: res.data.msg,
                type: 'success'
              })
              this.getSupplierList()
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
      this.modifySupplierDialogVisible = true
    }
  },
  mounted: function () {
    this.getSupplierList()
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
