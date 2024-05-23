//任务item组件
import TaskModel from '../../models/TaskModel'
import TaskDB from '../../common/utils/TaskDB'

@Component
export struct TaskItem {
  @ObjectLink task:TaskModel
  onTaskValueChange:() => void

  build() {
    Row() {
      if(this.task.finished) {
        Text(this.task.name)
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .finishedTextStyle()
      } else {
        Text(this.task.name)
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
      }

      Checkbox()
        .width(24)
        .height(24)
        .select(this.task.finished)
        .onChange((value) => this.handlerUpdateTask(value))
    }
    .cardStyle()
    .width('95%')
    .height(60)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  handlerUpdateTask(isFinished:boolean) {
    TaskDB
      .updateTaskStatus(this.task.id,isFinished)
      .then(() => {
        this.task.finished = isFinished
        this.onTaskValueChange()
        console.log('testDB','更新任务成功: name = ', this.task.name)
      })
      .catch(err => console.log('testDB','新增任务失败: err = ', JSON.stringify(err)))
  }
}


@Styles function cardStyle() {
  .width('95%')
  .padding(20)
  .backgroundColor(Color.White)
  .borderRadius(15)
  .shadow({radius: 6, color: '#1F000000', offsetX: 2, offsetY: 2})
}

//任务完成文本属性
@Extend(Text) function finishedTextStyle() {
  .decoration({type:TextDecorationType.LineThrough})
  .fontColor('#B1B2B1')
}