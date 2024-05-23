import router from '@ohos.router'
@Component
export struct Header {
  //导航标题
  title:string = '标题'

  build() {
    Row() {
      Button({type:ButtonType.Normal}) {
        Image($r('app.media.ic_public_back'))
          .fillColor(Color.White)
          .objectFit(ImageFit.Contain)
      }
      .width(60)
      .height(30)
      .backgroundColor(Color.Transparent)
      .onClick(() => {
        router.back()
      })

      Text(this.title)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)

      Button('更多', {type:ButtonType.Normal, stateEffect:true})
        .fontColor(Color.White)
        .onClick(() => {
          console.log('testTag', '更多按钮点击');
        })
    }
    .width('100%')
    .height(80)
    .backgroundColor('#36D')
    .justifyContent(FlexAlign.SpaceAround)
  }
}