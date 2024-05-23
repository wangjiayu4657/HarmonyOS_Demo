//任务类
@Observed
export default class TaskModel {
  //任务id
  id:number
  //任务名称
  name:string
  //任务完成状态
  finished:boolean

  constructor(id:number, name:string, finished?:boolean) {
    this.id = id
    this.name = name
    this.finished = finished ?? false
  }
}
