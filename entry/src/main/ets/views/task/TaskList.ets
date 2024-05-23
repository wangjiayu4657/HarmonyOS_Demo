
import TaskModel from '../../models/TaskModel';
import { TaskItem } from './TaskItem';
import TaskDB from '../../common/utils/TaskDB'


//任务列表
@Component
export struct TaskList {
  //总任务
  @Link totalTask:number
  //已完成任务
  @Link finishedTask:number
  //任务数组
  @State tasks: TaskModel[] = [];

  dialogController:CustomDialogController = new CustomDialogController({
    builder: TaskAlertView({onTaskConfirm:this.handlerAddTask.bind(this)})
  })

  aboutToAppear() {
    TaskDB
      .queryAllTask()
      .then(tasks => {
        console.log('testDB', '查询任务成功: task = ',tasks)
        this.tasks = tasks
        this.handlerValueChange()
      })
      .catch(err => console.log('testDB', '查询任务失败: err =', JSON.stringify(err)))
  }


  build() {
    Column() {
      //添加按钮
      this.buildAddButton()
      //任务列表
      this.buildTaskList()
    }
    .layoutWeight(1)
    .padding({bottom:45})
  }

  //添加按钮
  @Builder buildAddButton() {
    Button('新增任务')
      .width('80%')
      .height(44)
      .margin({bottom:15})
      .fontColor(Color.White)
      .backgroundColor('#36D')
      .onClick(() => {
        this.dialogController.open()
      })
  }

  //任务列表
  @Builder buildTaskList() {
    List({space: 15}) {
      ForEach(
        this.tasks,
        (task:TaskModel, index) => {
          ListItem() {
            TaskItem({task:task, onTaskValueChange:this.handlerValueChange.bind(this)})
          }
          .swipeAction({end:this.buildTaskListItemDelete(task.id, index)})
        }
      )}
    .width('100%')
    .height('100%')
    .padding({bottom: 30})
    .alignListItem(ListItemAlign.Center)
  }

  //滑动删除按钮
  @Builder buildTaskListItemDelete(id:number,index:number) {
    Button('删除')
      .width(125)
      .fontColor(Color.White)
      .backgroundColor(Color.Red)
      .type(ButtonType.Normal)
      .borderRadius(4)
      .margin({left:10})
      .onClick(() => this.handlerDeleteTask(id,index))
  }

  //更新任务完成状态
  handlerValueChange() {
    this.totalTask = this.tasks.length
    this.finishedTask = this.tasks.filter(task => task.finished).length
  }

  //新增任务
  handlerAddTask(name: string) {
    TaskDB.addTask(name)
      .then(id => {
        console.log('testDB', '新增任务成功: ', name)
        //添加到数组并回显到页面
        this.tasks.push(new TaskModel(id, name))
        //更新任务完成状态
        this.handlerValueChange()
        //关闭对话框
        this.dialogController.close()
      })
      .catch(err => {
        console.log('testDB','新增任务失败: err = ', JSON.stringify(err))
      })
  }

  //删除任务
  handlerDeleteTask(id:number,index:number) {
    TaskDB
      .deleteTask(id)
      .then(() => {
        this.tasks.splice(index, 1)
        this.handlerValueChange()
      })
      .catch(err => console.log('testDB','删除任务失败: err = ', JSON.stringify(err)))
  }
}

@Component
@CustomDialog
struct TaskAlertView {
  //名称
  name:string = ''
  //确认回调
  onTaskConfirm:(name:string) => void
  //绑定controller
  controller:CustomDialogController

  build() {
    Column({space:20}) {
      TextInput({placeholder: '请输入任务名称'})
        .height(44)
        .onChange((value => this.name = value))

      Row() {
        Button('确定',{type:ButtonType.Normal})
          .onClick(() => {
            this.onTaskConfirm(this.name)
          })

        Button('取消',{type:ButtonType.Normal})
          .backgroundColor(Color.Gray)
          .onClick(() => this.controller.close())
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .width('100%')
    .padding(20)
  }
}