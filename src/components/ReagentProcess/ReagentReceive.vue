<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>试剂收取</span>
          </div>
          <el-table
          :data="reagentAppDetail"
          style="width: 100%"
          max-height="450"
          size="mini">
          <el-table-column
              prop="appID"
              label="单号"
              width="50"
              align="center">
          </el-table-column>
          <el-table-column
              prop="userRealName"
              label="申请人"
              align="center">
          </el-table-column>
          <el-table-column
              prop="appDate"
              label="申请时间"
              align="center">
          </el-table-column>
          <el-table-column
              prop="dangerInfo"
              label="是否有危化"
              align="center">
          </el-table-column>
          <el-table-column
              prop="approverName"
              label="审核人"
              align="center">
          </el-table-column>
          <el-table-column
              prop="stepName"
              label="当前流程"
              :filters="[{text:'待提交',value:'待提交'},{text:'待审核',value:'待审核'},{text:'已驳回',value:'已驳回'},{text:'待受理',value:'待受理'}]"
              :filter-method="filterState">
          </el-table-column>
          <el-table-column
            label="操作"
            width="170px"
            align="center">
              <template slot-scope="scope">
                <el-button
                size="mini"
                type="primary"
                :disabled="buttonChk(scope.row)"
                @click="handleProvide(scope.$index, scope.row)">收取</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'ReagentReceive',
  data () {
    return {
      // 初始试剂信息模拟数据
      reagentAppDetail: [],
      reagentList: [],
      expands: [] // 表格中展开的行，对应表格中 :expand-row-keys 属性值，实现单行展开
    }
  },
  methods: {
    // 用以判断按钮的禁用状态
    buttonChk: function (row) {
      return false
    },
    filterState: function (value, row) {
      return row.stepName === value
    },
    handleProvide: function (index, row) {
      // 路由跳转带参数
      this.$router.push({path: '/ReagentReceiveDetail', query: {appInfo: row}})
    },
    getApplicationList () {
      axios({
        method: 'get',
        url: '/api/application/getReceiveAppList'
      })
        .then((res) => {
          this.reagentAppDetail = res.data
          console.log(res.data)
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    }
  },
  mounted: function () {
    this.getApplicationList()
  }
}
</script>

<style>
</style>
