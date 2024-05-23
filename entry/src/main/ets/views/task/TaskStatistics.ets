//进度统计组件
@Component
export struct TaskStatistics {
  @Prop totalTask:number
  @Prop finishedTask:number

  build() {
    Row() {
      Text('任务进度:')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)

      Stack() {
        //进度指示器
        this.buildTaskProgress()
        //进度值
        this.buildTaskProgressValue()
      }
    }
    .cardStyle()
    .margin({top: 15, bottom:10})
    .justifyContent(FlexAlign.SpaceEvenly)
  }

  //进度
  @Builder buildTaskProgress() {
    Progress({
      value:this.finishedTask,
      total:this.totalTask,
      type:ProgressType.Ring
    })
      .width(120)
  }

  //进度值
  @Builder buildTaskProgressValue() {
    Row() {
      Text(`${this.finishedTask}`)
        .fontSize(28)
        .fontColor('#36D')
        .fontWeight(FontWeight.Bold)

      Text(' / ' + `${this.totalTask}`)
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
    }
  }
}

@Styles function cardStyle() {
  .width('95%')
  .padding(20)
  .backgroundColor(Color.White)
  .borderRadius(15)
  .shadow({radius: 6, color: '#1F000000', offsetX: 2, offsetY: 2})
}