<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>报表管理</span>
          </div>
          <el-row :gutter="30">
            <el-col :span="8" align="center">
              <el-card class="box-card">
                <div slot="header" class="clearfix">
                  <span>标准版/对照品</span>
                </div>
                <div>
                  <el-button type="primary" @click="show_JLA132">标准品（对照品）期间核查表</el-button>
                </div>
              </el-card>
            </el-col>
            <el-col :span="8" align="center">
              <el-card class="box-card">
                <div slot="header" class="clearfix">
                  <span>易制毒（爆）</span>
                </div>
                <div>
                  <el-button type="primary">标准品（对照品）期间核查表</el-button>
                </div>
              </el-card>
            </el-col>
            <el-col :span="8" align="center">
              <el-card class="box-card">
                <div slot="header" class="clearfix">
                  <span>易制毒（爆）</span>
                </div>
                <div>
                  <el-button type="primary">标准品（对照品）期间核查表</el-button>
                </div>
              </el-card>
            </el-col>
          </el-row>
        </el-card>
      </el-col>
    </el-row>
    <el-dialog
    title="标准品（对照品）期间核查表"
    :visible.sync="JLA132_Visable"
    width="950px">
      <el-table
        :data="JLA132Data">
        <el-table-column
          align="center"
          label="核查日期">
          <el-table-column
          prop="reagentName"
          align="center"
          label="名称">
        </el-table-column>
        </el-table-column>
        <el-table-column label="">
            <el-table-column
              prop="overwrap"
              align="center"
              label="包装外观及性状">
            </el-table-column>
            <el-table-column
              prop="expiry"
              align="center"
              label="有效期">
            </el-table-column>
            <el-table-column
              prop="storage"
              align="center"
              label="储存环境">
            </el-table-column>
            <el-table-column
              prop="zip"
              align="center"
              label="处理措施">
            </el-table-column>
            <el-table-column
              prop="zip"
              align="center"
              label="备注"
              width="80px">
            </el-table-column>
        </el-table-column>
      </el-table>
      <div slot="footer" class="dialog-footer">
        <el-button @click="JLA132_Visable = false">取 消</el-button>
        <el-button type="primary" @click="exportExcel()">导出Excel</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'ReportManage',
  data () {
    return {
      JLA132_Visable: false,
      JLA132Data: []
    }
  },
  methods: {
    show_JLA132 () {
      // 标准物质 typeID 3
      axios({
        method: 'get',
        url: '/api/stocks/getStockByTypeId',
        params: {
          typeID: 3
        }
      })
        .then((res) => {
          let temp = []
          console.log(res.data)
          for (let i = 0; i < res.data.results.length; i++) {
            temp.push({
              reagentName: res.data.results[i].reagentName,
              overwrap: '有（无）异常变化',
              expiry: '未（已）失效',
              storage: '符合（不符合）要求'
            })
          }
          this.JLA132Data = temp
          this.JLA132_Visable = true
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },
    exportExcel () {

    }
  },
  mounted: function () {
  }
}
</script>

<style scoped>
</style>
