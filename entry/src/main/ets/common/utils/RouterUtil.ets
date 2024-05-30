import RouterModel from '../../models/RouterModel'

export default  class RouterUtil {
  //数据源
  static routers:RouterModel[] = [
    new RouterModel('pages/TaskManager', '任务管理'),
    new RouterModel('pages/TaskManager', '本地缓存'),
    new RouterModel('pages/TaskManager', '数据库缓存'),
    new RouterModel('pages/NotificationPage', '通知'),
    new RouterModel('pages/TaskManager', '网络请求'),
    new RouterModel('pages/TaskManager', '列表上拉加载或下拉刷新'),
  ]
}

