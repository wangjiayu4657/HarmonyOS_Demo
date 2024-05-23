export default class RouterModel {
  //路径
  url:string
  //标题
  title:string

  constructor(url:string,title:string) {
    this.url = url
    this.title = title
  }
}