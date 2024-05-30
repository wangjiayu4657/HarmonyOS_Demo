import router from '@ohos.router'
import RouterModel from '../models/RouterModel'
import RouterUtil from '../common/utils/RouterUtil'
import StorageUtil from '../common/utils/StorageUtil'
import FontSizePanel from '../views/FontSizePanel'

@Extend(Text) function textStyles() {
  .fontColor(Color.White)
  .fontWeight(FontWeight.Bold)
}



@Entry
@Component
struct Index {
  @State showPanel:boolean = false
  @Provide fontSize:number = 16

  async aboutToAppear() {
    this.fontSize = await StorageUtil.getPreference('FontSizePreference','FontSizeKey', 16) as number
    this.fontSize = this.fontSize ?? 16
    console.log(`fontSize == ${this.fontSize}`)
  }

  //UI构建
  build() {
   Column() {
     //底部header组件
     this.HeaderView()

     //列表组件
     this.ListView()

     //是否展示字体设置面板
     if(this.showPanel) {
       FontSizePanel()
         .transition({translate: {y: 115}})
     }
   }
   .width('100%')
   .height('100%')
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
          animateTo({duration:500, curve:Curve.EaseInOut}, () => this.showPanel = !this.showPanel)
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
        RouterUtil.routers,
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
        .fontSize(this.fontSize)
        .padding({left:15})

      Text(title)
        .textStyles()
        .fontSize(this.fontSize)
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
    router.pushUrl({
      url:model.url
    }, router.RouterMode.Single, (err) => {
        if(err) {
          console.log(`路由失败, errCode: ${err.code} errMsg:${err.message}`)
        } else {
          console.info('pushUrl success')
        }
    })
  }
}



