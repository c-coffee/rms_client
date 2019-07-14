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
      <el-form :model="addForm" style="margin-right:30px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="名称" label-width="100px">
              <el-input v-model="addForm.deptName" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="等级" label-width="100px">
              <el-select v-model="value" placeholder="请选择">
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
            <el-form-item label="联系人" label-width="100px">
              <el-input v-model="addForm.deptName" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="联系电话" label-width="100px">
              <el-input v-model="addForm.deptName" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="地址" label-width="100px">
          <el-input v-model="addForm.deptName" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="备注" label-width="100px">
          <el-input v-model="addForm.deptName" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addSupplierDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addSupplierDialogVisible = false">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 修改部门信息对话框 -->
    <el-dialog
    title="修改科室信息"
    :visible.sync="modifySupplierDialogVisible"
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
  name: 'DepartmentSet',
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
      supplierData: [
        {
          supplierID: 1,
          supplierName: '裕丰药业',
          supplierAddress: '长沙市八一路467号',
          supplierContact: '章三',
          supplierContactPhone: '13911223344',
          supplierLevel: 'A',
          remark: '主要供应甲乙丙丁等药剂'
        },
        {
          supplierID: 2,
          supplierName: '大唐制药公司',
          supplierAddress: '长沙市八一路467号',
          supplierContact: '礼四',
          supplierContactPhone: '13911223344',
          supplierLevel: 'A',
          remark: '主要供应甲乙丙丁等药剂'
        },
        {
          supplierID: 3,
          supplierName: '和顺制药',
          supplierAddress: '长沙市八一路467号',
          supplierContact: '汪五',
          supplierContactPhone: '13911223344',
          supplierLevel: 'A',
          remark: '主要供应甲乙丙丁等药剂'
        }
      ],
      // 添加科室信息表单对应对象
      addForm: {
        deptName: ''
      },
      addSupplierDialogVisible: false, // 添加科室信息窗口控制标识
      modifySupplierDialogVisible: false, // 修改科室信息窗口控制标识
      deleteSupplierDialogVisible: true // 添加科室信息窗口控制标识
    }
  },
  methods: {
    showAddDialog: function () {
      this.addSupplierDialogVisible = true
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
      this.modifySupplierDialogVisible = true
    }
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
