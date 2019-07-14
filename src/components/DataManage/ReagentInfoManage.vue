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
  </div>
</template>

<script>
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
      ]
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
