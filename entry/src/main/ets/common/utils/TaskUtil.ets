import relationalStore from '@ohos.data.relationalStore';
import TaskModel from '../../models/TaskModel';

//任务数据库存储
class TaskUtil {
  private tableName:string = 'TASK_TABLE'
  private rdbStore:relationalStore.RdbStore

  //初始化数据库
  initTaskDB(context) {
    //rdb配置
    const config = {
      name:'MyApplication_TASK.db',
      securityLevel:relationalStore.SecurityLevel.S1
    }
    //初始化SQL语句
    const sql = `CREATE TABLE IF NOT EXISTS ${this.tableName} (
                  ID INTEGER PRIMARY KEY AUTOINCREMENT,
                  NAME TEXT NOT NULL,
                  FINISHED bit
                 )`

    //获取rdb
    relationalStore.getRdbStore(context, config, (err, rdbStore) => {
      if(err) {
        console.log('testDB', '数据库初始化获取rdbStore失败! ')
        return
      }
      //执行SQL语句
      rdbStore.executeSql(sql)
      console.log('testDB', '数据库初始化获取rdbStore成功! ')

      //保存rdbStore的引用
      this.rdbStore = rdbStore
    })
  }

  /**
   * 添加任务
   * @param name 任务名称
   * @returns 任务id
   */
  addTask(name:string):Promise<number> {
    const data = {'NAME':name, 'FINISHED':false}
    console.log('testDB', '数据库添加任务', 'data  ', data)
    return this.rdbStore.insert(this.tableName, data)
  }

  /**
   * 删除任务
   * @param id 根据任务 id 删除
   * @returns 任务id
   */
  deleteTask(id:number):Promise<number> {
    //构建删除条件
    const predicates = new relationalStore.RdbPredicates(this.tableName)
    predicates.equalTo('ID', id)

    //删除操作
    return this.rdbStore.delete(predicates)
    console.log('testDB', '数据库删除任务', 'id:', id)
  }

  /**
   * 更新任务
   * @param id 任务id
   * @param status 任务完成状态
   * @returns 任务id
   */
  updateTaskStatus(id:number, finished:boolean):Promise<number>{
    //需要更新的数据
    const data = { 'FINISHED':finished }
    //构建更新条件
    const predicate = new relationalStore.RdbPredicates(this.tableName)
    predicate.equalTo('ID',id)
    //更新操作
    return this.rdbStore.update(data,predicate)
    console.log('testDB', '数据库更新任务', `id:${id}  finished:${finished}}`)
  }

  /**
   * 查询所有任务数据
   * @returns 返回任务列表
   */
  async queryAllTask() {
    //构建查询条件
    const predicates = new relationalStore.RdbPredicates(this.tableName)
    //查询
    const result = await this.rdbStore.query(predicates, ['ID', 'NAME', 'FINISHED'])
    //解析查询结果
    const tasks: TaskModel[] = []
    //遍历处理数据
    while(!result.isAtLastRow) {  //如果不是最后一行则继续遍历
      //先跳转到下一行, 因为默认处于-1行
      result.goToNextRow()
      //获取任务id
      const id = result.getLong(result.getColumnIndex('ID'))
      //获取任务名称
      const name = result.getString(result.getColumnIndex('NAME'))
      //获取任务状态
      const finished = result.getLong(result.getColumnIndex('FINISHED'))
      //将查询到的数据放入数组中
      tasks.push({id, name, finished: !!finished})
    }

    result.close()
    console.log('testDB', '数据库查询任务', JSON.stringify(tasks))
    return tasks
  }
}

const taskDB = new TaskUtil();
export default taskDB as TaskUtil;