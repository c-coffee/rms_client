<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>试剂申领</span>
            <el-button @click.stop="reagentAppAdd" style="float: right; padding: 3px 10px" type="text">保存并提交</el-button>
            <el-button @click.stop="reagentAppAdd" style="float: right; padding: 3px 10px" type="text">保存</el-button>
          </div>
          <el-row>
            <el-col :span="12" style="text-align:center">申领用户：{{reagentAppDetail.userName}}</el-col>
            <el-col :span="12" style="text-align:center">申领时间：{{reagentAppDetail.appDatetime}}</el-col>
          </el-row>
          <el-divider></el-divider>
          <el-table
            :data="reagentAppDetail.appDetail"
            border>
              <el-table-column
                type="index"
                label="序号"
                align="center"
                width="50px">
              </el-table-column>
              <el-table-column
                prop="reagentName"
                label="试剂名称"
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
                align="center"
                width="70px">
              </el-table-column>
              <el-table-column
                prop="reagentNum"
                label="数量"
                align="center">
              </el-table-column>
              <el-table-column
                prop="remark"
                label="备注"
                align="center">
              </el-table-column>
              <el-table-column
            label="操作"
            width="250px"
            align="center">
              <template slot-scope="scope">
                <el-button
                size="mini"
                type="danger"
                @click="handleDelete(scope.$index, scope.row)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
          <el-divider></el-divider>
          <el-row>
            <el-col :span="12" style="margin-top:-15px;margin-bottom:10px;">
              <div style="margin-top: 15px;">
                <el-input placeholder="请输入试剂名称或试剂简码" v-model="searchReagent">
                  <el-button slot="append" icon="el-icon-search"></el-button>
                </el-input>
              </div>
            </el-col>
          </el-row>
          <el-table
            :data="reagentSearchInfoData"
            border>
              <el-table-column
                prop="reagentID"
                label="序号"
                align="center"
                width="50px">
              </el-table-column>
              <el-table-column
                prop="reagentName"
                label="试剂名称"
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
                align="center"
                width="70px">
              </el-table-column>
              <el-table-column
                prop="reagentNum"
                label="数量"
                align="center">
                <template slot-scope="scope">
                  <el-input-number v-model="scope.row.reagentNum" :min="0" :max="10000" label="订购数量"></el-input-number>
                </template>
              </el-table-column>
              <el-table-column
                label="备注"
                align="center">
                <template slot-scope="scope">
                  <el-input v-model="scope.remark" placeholder="请输入备注"></el-input>
                </template>
              </el-table-column>
              <el-table-column
                label="操作"
                width="250px"
                align="center">
              <template slot-scope="scope">
                <el-button
                size="mini"
                type="primary"
                @click="handleAdd(scope.$index, scope.row)">添加</el-button>
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
  name: 'ReagentApplicationAdd',
  data () {
    return {
      // 通过试剂名称或简码进行搜索
      searchReagent: '',
      // 初始试剂信息模拟数据
      reagentAppDetail: {
        appID: 1,
        appUserID: '1',
        userName: '章三',
        appDatetime: '2019-6-26',
        typeName: '有机',
        reagentStateID: 2,
        hasDanger: 0,
        approverID: '',
        approverDatetime: '',
        approveReason: '',
        applicationState: 1,
        appDetail: [
          {
            appDetailID: 1,
            appID: 1,
            reagentID: 2,
            reagentName: '甲醇',
            reagentUnit: 'L',
            reagentSpec: '>=99.9%',
            reagentNum: 10,
            remark: ''
          },
          {
            appDetailID: 2,
            appID: 1,
            reagentID: 3,
            reagentName: '二苯肼标准溶液',
            reagentUnit: 'L',
            reagentSpec: '1000μg/ml',
            reagentNum: 8,
            remark: ''
          }
        ]
      },
      reagentSearchInfoData: [
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
          reagentShortCode: 'XSY',
          reagentNum: 0,
          remark: ''
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
          reagentShortCode: 'EBJ',
          reagentNum: 0,
          remark: ''
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
          reagentShortCode: 'JC',
          reagentNum: 0,
          remark: ''
        }
      ]
    }
  },
  methods: {
    filterState: function (value, row) {
      return row.applicationState === value
    },
    showAddDialog: function () {
    },
    handleDelete: function (index, row) {
      this.$confirm('您确定删除所选试剂吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.reagentAppDetail.appDetail.splice(index, 1)
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
