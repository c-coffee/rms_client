<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>试剂信息管理</span>
            <el-button @click.stop="showAddDialog" style="float: right; padding: 3px 0" type="text">添加</el-button>
          </div>
          <el-table
          :data="reagentInfoData"
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
                  {{ props.row.reagentName }}
                </el-col>
                <el-col :span="3" class="detailTitle">
                  短码：
                </el-col>
                <el-col :span="9">
                  {{ props.row.reagentShortCode }}
                </el-col>
              </el-row>
              <el-row>
                <el-col :span="3" class="detailTitle">
                  类型：
                </el-col>
                <el-col :span="9">
                  {{ props.row.typeName }}
                </el-col>
                <el-col :span="3" class="detailTitle">
                  性状：
                </el-col>
                <el-col :span="9">
                  {{ props.row.stateName }}
                </el-col>
              </el-row>
              <el-row>
                <el-col :span="3" class="detailTitle">
                  规格：
                </el-col>
                <el-col :span="9">
                  {{ props.row.reagentSpec }}
                </el-col>
                <el-col :span="3" class="detailTitle">
                  单位：
                </el-col>
                <el-col :span="9">
                  {{ props.row.reagentUnit }}
                </el-col>
              </el-row>
              <el-row>
                <el-col :span="3" class="detailTitle">
                  危化类别：
                </el-col>
                <el-col :span="9">
                  {{ props.row.dangerName }}
                </el-col>
                <el-col :span="3" class="detailTitle">
                  制造商：
                </el-col>
                <el-col :span="9">
                  {{ props.row.reagentProduct }}
                </el-col>
              </el-row>
              </div>
            </template>
          </el-table-column>
          <el-table-column
              prop="reagentID"
              label="序号"
              width="180"
              align="center">
          </el-table-column>
          <el-table-column
              prop="reagentName"
              label="试剂名称"
              align="center">
          </el-table-column>
          <el-table-column
              prop="typeName"
              label="类别"
              align="center">
          </el-table-column>
          <el-table-column
              prop="stateName"
              label="性状"
              align="center">
          </el-table-column>
          <el-table-column
              prop="reagentSpec"
              label="规格"
              align="center">
          </el-table-column>
          <el-table-column
              prop="reagentUnit"
              label="单位"
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
            label="名称"
            label-width="100px"
            prop="reagentName"
            :rules="[
            {required: true, message:'试剂名称不能为空', trigger: 'blur'}
            ]"
            >
              <el-input v-model="addForm.reagentName" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item
            label="类型"
            label-width="100px"
            prop="reagentTypeID"
            :rules="[
            {required: true, message:'等级不能为空', trigger: 'blur'}
            ]"
            >
              <el-select v-model="addForm.reagentTypeID" placeholder="请选择">
                <el-option
                  v-for="item in reagentType"
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
        <el-button @click="addDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addSupplier">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 修改部门信息对话框 -->
    <el-dialog
    title="修改科室信息"
    :visible.sync="modifyDialogVisible"
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
        <el-button @click="modifyDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="editSupplier">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'DepartmentSet',
  data () {
    return {
      // 初始试剂信息模拟数据
      reagentInfoData: [
        {
          reagentID: 1,
          reagentName: '硝酸银',
          reagentTypeID: 1,
          typeName: '有机',
          reagentStateID: 2,
          stateName: '液态',
          reagentDangerID: '3',
          dangerName: '易制爆',
          reagentProduct: '阿拉丁',
          reagentSpec: '>=99.9%',
          reagentUnit: 'L',
          reagentShortCode: 'XSY'
        },
        {
          reagentID: 2,
          reagentName: '二苯肼标准溶液',
          reagentTypeID: 1,
          typeName: '有机',
          reagentStateID: 2,
          stateName: '液态',
          reagentDangerID: '1',
          dangerName: '一般',
          reagentProduct: '阿拉丁',
          reagentSpec: '1000μg/ml',
          reagentUnit: 'L',
          reagentShortCode: 'EBJ'
        },
        {
          reagentID: 3,
          reagentName: '甲醇',
          reagentTypeID: 1,
          typeName: '有机',
          reagentStateID: 2,
          stateName: '液态',
          reagentDangerID: '1',
          dangerName: '一般',
          reagentProduct: '阿拉丁',
          reagentSpec: '>=99.9%',
          reagentUnit: 'L',
          reagentShortCode: 'JC'
        }
      ],
      addForm: {},
      editForm: {},
      reagentDanger: [],
      reagentState: [],
      reagentType: [],
      addDialogVisible: false, // 添加试剂信息窗口控制标识
      modifyDialogVisible: false // 修改试剂信息窗口控制标识
    }
  },
  methods: {
    getBaseInfoList () {
      axios({
        method: 'get',
        url: '/api/reagentInfo/getBaseInfo'
      })
        .then((res) => {
          this.reagentDanger = res.data.reagentDanger
          this.reagentState = res.data.reagentState
          this.reagentType = res.data.reagentType
          console.log(this.reagentDanger)
          console.log(this.reagentState)
          console.log(this.reagentType)
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },
    getReagentInfoList: function () {
      axios({
        method: 'get',
        url: '/api/reagentInfo/getreagentInfoList'
      })
        .then((res) => {
          this.reagentInfoData = res.data
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
  },
  mounted: function () {
    this.getReagentInfoList()
    this.getBaseInfoList()
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
