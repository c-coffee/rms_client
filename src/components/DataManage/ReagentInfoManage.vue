<template>
  <div>
    <el-row>
      <el-col :span=24>
        <el-card>
          <div slot="header">
            <span>试剂信息管理</span>
            <el-button @click.stop="showAddDialog" style="float: right; padding: 3px 0" type="text">添加</el-button>
          </div>
            <el-row>
              <el-col :span="18">
                <span>查询：</span>
                <el-select v-model="searchInfo.searchReagentTypeID" placeholder="试剂类别" size="small" style="width:120px">
                  <el-option
                    v-for="item in reagentType"
                    :key="item.typeID"
                    :label="item.typeName"
                    :value="item.typeID">
                  </el-option>
                </el-select>
                <el-select v-model="searchInfo.searchReagentDangerID" placeholder="危化类别"  size="small" style="width:120px">
                  <el-option
                    v-for="item in reagentDanger"
                    :key="item.dangerID"
                    :label="item.dangerName"
                    :value="item.dangerID">
                  </el-option>
                </el-select>
                <el-input style="width:350px" placeholder="请输入试剂名称、CAS或试剂拼音简码" v-model="searchInfo.searchReagent" size="small">
                  <el-button slot="append" icon="el-icon-search" @click="getReagentInfoList"></el-button>
                </el-input>
              </el-col>
              <el-col :span="6">
                 <el-pagination
                  @current-change="handleCurrentChange"
                  layout="prev, pager, next"
                  style="float:right"
                  :pager-count="5"
                  :page-size="this.pageSize"
                  :current-page="this.currentPage"
                  :total="this.pageCount">
                </el-pagination>
              </el-col>
            </el-row>
          <el-divider></el-divider>
          <el-table
          :data="reagentInfoData"
          style="width: 100%"
          max-height="450"
          size="mini"
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
                  CAS：
                </el-col>
                <el-col :span="9">
                  {{ props.row.CAS }}
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
                  危化类别：
                </el-col>
                <el-col :span="9">
                  {{ props.row.dangerName }}
                </el-col>
              </el-row>
              <el-row>
                <el-col :span="3" class="detailTitle">
                  关键字：
                </el-col>
                <el-col :span="21">
                  {{ props.row.keywords }}
                </el-col>
              </el-row>
              </div>
            </template>
          </el-table-column>
          <el-table-column
              prop="reagentID"
              label="序号"
              width="50"
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
              prop="CAS"
              label="CAS"
              align="center">
          </el-table-column>
          <el-table-column
            label="操作"
            width="150px"
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
    <!-- 添加试剂信息对话框 -->
    <el-dialog
    title="添加试剂信息"
    :visible.sync="addDialogVisible"
    :close-on-click-modal="false"
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
              <el-input @change="changeName($event, addForm)" v-model="addForm.reagentName" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item
            label="关键字"
            label-width="100px"
            prop="keywords">
              <el-input v-model="addForm.keywords" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item
            label="拼音短码"
            label-width="100px"
            prop="reagentShortCode"
            :rules="[
            {required: true, message:'拼音短码不能为空', trigger: 'blur'}
            ]">
              <el-input v-model="addForm.reagentShortCode" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item
            label="类型"
            label-width="100px"
            prop="reagentTypeID"
            :rules="[
            {required: true, message:'试剂类型不能为空', trigger: 'blur'}
            ]">
              <el-select v-model="addForm.reagentTypeID" placeholder="请选择" @change="changeType">
                <el-option
                  v-for="item in reagentType"
                  :key="item.typeID"
                  :label="item.typeName"
                  :value="item.typeID">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
         <el-row>
          <el-col :span="12">
            <el-form-item
            label="CAS"
            label-width="100px"
            prop="CAS"
            >
              <el-input v-model="addForm.CAS" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item
            label="危化类别"
            label-width="100px"
            prop="reagentDangerID"
            :rules="[
            {required: true, message:'危化类别不能为空', trigger: 'blur'}
            ]">
              <el-select v-model="addForm.reagentDangerID" placeholder="请选择" :disabled="addDangerDisable">
                <el-option
                  v-for="item in reagentDanger"
                  :key="item.dangerID"
                  :label="item.dangerName"
                  :value="item.dangerID">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item
            label="规格"
            label-width="100px"
            prop="reagentSpec"
            :rules="[
            {required: true, message:'规格不能为空', trigger: 'blur'}
            ]">
              <el-input v-model="addForm.reagentSpec" autocomplete="off" placeholder="多规格请用逗号分隔"></el-input>
              <span>{{specList}}</span>
            </el-form-item>
          </el-col>
          <el-col :span="12">
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addReagentInfo">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 修改试剂信息对话框 -->
    <el-dialog
    title="修改试剂信息"
    :visible.sync="modifyDialogVisible"
    :close-on-click-modal="false"
    width="600px">
      <el-form
      :model="editForm"
      style="margin-right:30px"
      ref="editForm"
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
              <el-input @change="changeName($event, editForm)" v-model="editForm.reagentName" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item
            label="关键字"
            label-width="100px"
            prop="keywords">
              <el-input v-model="editForm.keywords" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item
            label="拼音短码"
            label-width="100px"
            prop="reagentShortCode"
            :rules="[
            {required: true, message:'拼音短码不能为空', trigger: 'blur'}
            ]">
              <el-input v-model="editForm.reagentShortCode" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item
            label="类型"
            label-width="100px"
            prop="reagentTypeID"
            :rules="[
            {required: true, message:'试剂类型不能为空', trigger: 'blur'}
            ]"
            >
              <el-select v-model="editForm.reagentTypeID" placeholder="请选择" @change="modifyType">
                <el-option
                  v-for="item in reagentType"
                  :key="item.typeID"
                  :label="item.typeName"
                  :value="item.typeID">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
         <el-row>
          <el-col :span="12">
            <el-form-item
            label="CAS"
            label-width="100px"
            prop="reagentName">
              <el-input v-model="editForm.CAS" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item
            label="危化类别"
            label-width="100px"
            prop="reagentDangerID"
            :rules="[
            {required: true, message:'危化类别不能为空', trigger: 'blur'}
            ]">
              <el-select v-model="editForm.reagentDangerID" placeholder="请选择" :disabled="modifyDangerDisable">
                <el-option
                  v-for="item in reagentDanger"
                  :key="item.dangerID"
                  :label="item.dangerName"
                  :value="item.dangerID">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
         <el-row>
          <el-col :span="24">
            <el-form-item
            label="规格"
            label-width="100px"
            prop="reagentSpec"
            :rules="[
            {required: true, message:'规格不能为空', trigger: 'blur'}
            ]">
              <el-input v-model="editForm.reagentSpec" autocomplete="off" placeholder="多规格请用逗号分隔"></el-input>
              <span>{{editSpecList}}</span>
            </el-form-item>
          </el-col>
          <el-col :span="12">
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="modifyDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="editReagentInfo">确 定</el-button>
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
      addDangerDisable: true,
      modifyDangerDisable: true,
      searchInfo: {
        searchReagentTypeID: '',
        searchReagentDangerID: '',
        searchReagentStateID: '',
        searchReagent: ''
      },
      currentPage: 1,
      pageSize: 10,
      pageCount: 0,
      // 初始试剂信息模拟数据
      reagentInfoData: [],
      addForm: {
        reagentSpec: '',
        reagentDangerID: 0,
        CAS: '',
        keywords: ''
      },
      editForm: {
        reagentSpec: '',
        keywords: ''
      },
      reagentDanger: [],
      reagentState: [],
      reagentType: [],
      reagentPurity: [],
      addDialogVisible: false, // 添加试剂信息窗口控制标识
      modifyDialogVisible: false // 修改试剂信息窗口控制标识
    }
  },
  methods: {
    changeName (name, form) {
      form.keywords = name
    },
    modifyType (value) {
      // 当用户选择了易制毒（爆） value===4 时，危化类别的其它选项才可选，否则为 /
      if (value === 4) {
        this.modifyDangerDisable = false
        this.editForm.reagentDangerID = 0
      } else {
        this.modifyDangerDisable = true
        this.editForm.reagentDangerID = 1
      }
    },
    changeType (value) {
      // 当用户选择了易制毒（爆） value===4 时，危化类别的其它选项才可选，否则为 /
      if (value === 4) {
        this.addDangerDisable = false
        this.addForm.reagentDangerID = 0
      } else {
        this.addDangerDisable = true
        this.addForm.reagentDangerID = 1
      }

      if (value === 2) {
        this.addForm.CAS = '/'
      }
    },
    handleCurrentChange (currentPage) {
      this.currentPage = currentPage
      this.getReagentInfoList()
    },
    // 解决初始库存数字款不响应输入的问题，强制更新
    changeEditInput () {
      this.$forceUpdate()
    },
    addReagentInfo () {
      // todo 先判断在列表中是否存在相同的供应商名称
      this.$refs['addForm'].validate((isPass, object) => {
        if (!isPass) {
          this.$message({
            message: '请输入完整信息！',
            type: 'error'
          })
        } else {
          let flag = true
          for (let i = 0; i < this.reagentInfoData.length; i++) {
            if (this.addForm.reagentName === this.reagentInfoData[i].reagentName && this.addForm.reagentTypeID === this.reagentInfoData[i].reagentTypeID) {
              flag = false
              break
            }
          }
          if (flag) {
            console.log(this.addForm)
            axios({
              method: 'post',
              url: '/api/reagentInfo/addReagentInfo',
              data: {
                reagentinfo: this.addForm
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
                  this.getReagentInfoList()
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
              message: '该试剂信息已存在!'
            })
          }
        }
      })
    },
    editReagentInfo: function () {
      // todo 先判断在列表中是否存在相同的试剂名称
      this.$refs['editForm'].validate((isPass, object) => {
        if (!isPass) {
          this.$message({
            message: '请输入完整信息！',
            type: 'error'
          })
        } else {
          axios({
            method: 'post',
            url: '/api/reagentInfo/editReagentinfo',
            data: {
              reagentInfo: this.editForm
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
                this.getReagentInfoList()
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
        }
      })
    },
    getBaseInfoList () {
      axios({
        method: 'get',
        url: '/api/reagentInfo/getBaseInfo'
      })
        .then((res) => {
          this.reagentDanger = res.data.reagentDanger
          this.reagentState = res.data.reagentState
          this.reagentType = res.data.reagentType
          this.reagentDanger.unshift({dangerID: 0, dangerName: '请选择', state: 1})
          this.reagentState.unshift({stateID: 0, stateName: '请选择', state: 1})
          this.reagentType.unshift({typeID: 0, typeName: '请选择', state: 1})
          // console.log(res)
          this.getReagentInfoList()
        })
        .catch((err) => {
          console.log(err)
          this.$message({
            message: '服务器错误！',
            type: 'error'
          })
        })
    },
    // 通过id获取类别，性状，危化品名称，以完善页面显示
    getBaseFullName () {
      let rgInfo = this.reagentInfoData
      let rgType = this.reagentType
      let rgDanger = this.reagentDanger
      let rgState = this.reagentState

      for (let j = 0; j < rgInfo.length; j++) {
        for (let i = 0; i < rgType.length; i++) {
          if (rgInfo[j].reagentTypeID === rgType[i].typeID) {
            rgInfo[j].reagentTypeName = rgType[i].typeName
            break
          }
        }
        for (let i = 0; i < rgState.length; i++) {
          if (rgInfo[j].reagentStateID === rgState[i].stateID) {
            rgInfo[j].reagentStateName = rgState[i].stateName
            break
          }
        }
        for (let i = 0; i < rgDanger.length; i++) {
          if (rgInfo[j].reagentDangerID === rgDanger[i].dangerID) {
            rgInfo[j].reagentDangerName = rgDanger[i].dangerName
            break
          }
        }
      }
    },
    getReagentInfoList: function () {
      axios({
        method: 'get',
        url: '/api/reagentInfo/getreagentInfoList',
        params: {
          searchInfo: this.searchInfo,
          pageInfo: {
            pageSize: this.pageSize,
            currentPage: this.currentPage
          }
        }
      })
        .then((res) => {
          this.reagentInfoData = res.data.data
          this.pageCount = res.data.count
          // this.getBaseFullName()
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
      this.$confirm('您确定删除试剂信息吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        axios({
          method: 'post',
          url: '/api/reagentInfo/deleteReagentInfo',
          data: {
            reagentID: row.reagentID
          }
        })
          .then((res) => {
            if (res.data.result === 1) {
              // 成功则关闭窗口，不成功不关闭
              this.$message({
                message: res.data.msg,
                type: 'success'
              })
              this.getReagentInfoList()
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
      // 深拷贝
      this.editForm = JSON.parse(JSON.stringify(row))
      axios({
        method: 'get',
        url: '/api/reagentInfo/getReagentStock',
        params: {
          reagentID: this.editForm.reagentID
        }
      })
        .then((res) => {
          this.editForm.initialNum = res.data.initialNum
          this.modifyDialogVisible = true
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
  computed: {
    specList: function () {
      let tempStr = ''
      if (this.addForm.reagentSpec.length === 0) {
        return tempStr
      }
      let tempAry = this.addForm.reagentSpec.split(',')
      for (let i = 0; i < tempAry.length; i++) {
        tempStr += '★ ' + tempAry[i] + '             '
      }
      return tempStr
    },
    editSpecList: function () {
      let tempStr = ''
      if (this.editForm.reagentSpec.length === 0) {
        return tempStr
      }
      let tempAry = this.editForm.reagentSpec.split(',')
      for (let i = 0; i < tempAry.length; i++) {
        tempStr += '★ ' + tempAry[i] + '             '
      }
      return tempStr
    }
  },
  mounted: function () {
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
