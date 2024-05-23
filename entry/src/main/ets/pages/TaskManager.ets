//卡片通用属性
import { Header } from '../common/componet/NavigatorHeader'
import { TaskList } from '../views/task/TaskList'
import { TaskStatistics } from '../views/task/TaskStatistics'


@Entry
@Component
struct TaskManager {
  //总任务
  @State totalTask: number = 0
  //已完成任务
  @State finishedTask: number = 0

  build() {
    Column({space: 15}) {
      //头部组件
      Header({title:'任务管理'})
      //任务统计组件
      TaskStatistics({finishedTask:this.finishedTask, totalTask:this.totalTask})
      //任务列表组件
      TaskList({finishedTask:$finishedTask, totalTask:$totalTask})
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F2F3')
  }
}







