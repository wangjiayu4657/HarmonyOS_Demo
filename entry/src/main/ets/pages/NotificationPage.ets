
import notify from '@ohos.notificationManager';
import image from '@ohos.multimedia.image';
import { Header } from '../common/componet/NavigatorHeader'
import notificationManager from '@ohos.notificationManager';

@Extend(Button) function normalStyle() {
  .width('100%')
  .height('100%')
  .fontSize(20)
  .fontColor(Color.White)
  .fontWeight(FontWeight.Bold)
  .backgroundColor(Color.Gray)
}

@Entry
@Component
struct NotificationPage {
  //全局任务id
  idx:number = 100
  //图像
  pixel: PixelMap

  @State source:string[] = ['normalText通知','longText通知','multiLine通知','picture通知']

  async aboutToAppear() {
    //获取资源管理器
    let rm = getContext(this).resourceManager
    //读取图片
    let file = await rm.getMediaContent($r('app.media.watchGT4'))
    //创建pixelMap
    image
      .createImageSource(file.buffer)
      .createPixelMap()
      .then(value => this.pixel = value)
      .catch(err => console.log('testTag', '加载图片异常', JSON.stringify(err)))
  }

  publishNotification(index:number) {
    switch (index) {
      case 0: this.publishNormalTextNotification()
        break

      case 1: this.publishLongTextNotification()
        break

      case 2: this.publishMultiLineNotification()
        break

      case 3: this.publishPictureNotification()
        break

      default :
        break
    }
  }

  //normalText通知
  publishNormalTextNotification() {
    console.log('testNotify','normalText通知')
    let request:notify.NotificationRequest = {
      id: this.idx++,
      content: {
        contentType: notify.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: 'normal通知标题' + this.idx,
          text: '通知内容详情',
          additionalText: '通知附加内容'
        }
      },
      showDeliveryTime:true,
      deliveryTime: new Date().getTime(),
      groupName: 'wechat',
      slotType: notify.SlotType.SOCIAL_COMMUNICATION
    }

    this.publish(request)
  }

  //longText通知
  publishLongTextNotification() {
    console.log('testNotify','longText通知')

    let request:notify.NotificationRequest = {
      id:this.idx++,
      content: {
        contentType:notify.ContentType.NOTIFICATION_CONTENT_LONG_TEXT,
        longText: {
          title: 'long通知标题' + this.idx,
          text: '通知内容详情',
          additionalText: '通知附加内容',
          longText: '通知内容通知内容通知内容通知内容通知内容通知内容通知内容通知内容',
          briefText: '通知该要和总结',
          expandedTitle: '通知展开时的标题' + this.idx
        }
      }
    }

    this.publish(request)
  }

  // multiLine通知
  publishMultiLineNotification() {
    console.log('testNotify','multiLine通知')
    let request:notify.NotificationRequest = {
      id:this.idx++,
      content: {
        contentType:notify.ContentType.NOTIFICATION_CONTENT_MULTILINE,
        multiLine: {
          title: 'multi通知标题' + this.idx,
          text: '通知内容详情',
          additionalText: '通知附加内容',
          longTitle: '通知内容通知内容通知内容通知内容通知内容通知内容通知内容通知内容',
          briefText: '通知该要和总结',
          lines:[
            '第一行内容',
            '第二行内容',
            '第三行内容',
            '第四行内容',
          ]
        }
      }
    }

    this.publish(request)
  }

  // picture通知
  publishPictureNotification() {
    console.log('testNotify','picture通知')
    let request:notify.NotificationRequest = {
      id:this.idx++,
      content: {
        contentType:notify.ContentType.NOTIFICATION_CONTENT_PICTURE,
        picture: {
          title: 'picture通知标题' + this.idx,
          text: '通知内容详情',
          additionalText: '通知附加内容',
          briefText:'通知总结和概要',
          expandedTitle:'展开后的标题' + this.idx,
          picture:this.pixel
        }
      }
    }

    this.publish(request)
  }


  build() {
    Row() {
      Column() {
        //头部组件
        Header({title:'通知功能'})
        //网格组件
        this.buildGridView()
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#36D')
    }
  }

  //网格组件
  @Builder buildGridView() {
    Grid(){
      ForEach(
        this.source,
        (title,index) => {
          GridItem() {
            Button(title, {type: ButtonType.Normal})
              .normalStyle()
              .onClick(() => this.publishNotification(index))
          }
        },title => title
      )
    }
    .width('96%')
    .height(200)
    .rowsGap(4)
    .columnsGap(4)
    .rowsTemplate('1fr 1fr')
    .columnsTemplate('2fr 2fr')
    .margin({top:30})
    .multiSelectable(true)
  }

  //发生通知
  private publish(request:notify.NotificationRequest) {
    notify
      .publish(request)
      .then(() => console.log('notify test', '通知发送成功'))
      .catch(err => console.log('notify test', '通知发送失败', JSON.stringify(err)))
  }
}
