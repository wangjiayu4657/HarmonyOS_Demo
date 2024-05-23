import router from '@ohos.router'
import RouterModel from '../models/RouterModel'

@Extend(Text) function textStyles() {
  .fontSize(20)
  .fontColor(Color.White)
  .fontWeight(FontWeight.Bold)
}

@Entry
@Component
struct Index {
  //数据源
  routers:RouterModel[] = [
    new RouterModel('pages/TaskManager', '任务管理'),
    new RouterModel('pages/TaskManager', '本地缓存'),
    new RouterModel('pages/TaskManager', '数据库缓存'),
    new RouterModel('pages/TaskManager', '通知'),
    new RouterModel('pages/TaskManager', '网络请求'),
    new RouterModel('pages/TaskManager', '列表上拉加载或下拉刷新'),
  ]

  //UI构建
  build() {
   Column() {
     //底部header组件
     this.HeaderView()
     //列表组件
     this.ListView()
   }
  }

  @Builder HeaderView() {
    Row() {
      Text('首页')
        .fontSize(50)
        .fontWeight(FontWeight.Medium)
        .height(80)

      Image($r('app.media.ic_public_settings'))
        .width(30)
        .onClick((() => {
          console.log('testTag', '设置按钮点击')
        }))
    }
    .width('100%')
    .margin({top: 15})
    .justifyContent(FlexAlign.SpaceAround)
  }

  //构建列表
  @Builder ListView() {
    List({space:0}) {
      ForEach(
        this.routers,
        (item:RouterModel, index) => {
          ListItem() {
            this.BuildListItem(index,item.title)
          }
          .margin({top: 5, left:10, bottom:5, right:10})
          .onClick(() => this.routeAction(item))
        }
      )
    }
    .width('100%')
    .layoutWeight(1)
    .backgroundColor('#F7F7F7')
    .alignListItem(ListItemAlign.Center)
    .margin({top: 30})
  }

  //构建列表的item
  @Builder BuildListItem(index: number, title: string) {
    Row() {
      Text(`${index}.`)
        .textStyles()
        .padding({left:15})

      Text(title)
        .textStyles()
        .padding({right:15})
    }
    .width('100%')
    .height(44)
    .borderRadius(22)
    .backgroundColor('#36D')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  //路由跳转
  routeAction(model:RouterModel) {
    router.pushUrl(
      {url:model.url},
      router.RouterMode.Single,
      err => {
        if(err) {
          console.log(`路由失败, errCode: ${err.code} errMsg:${err.message}`)
        }
      }
    )
  }
}



