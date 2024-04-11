@Component
export  struct QTitleView{
  @State private titleString: string = ""
  build(){
    Column() {
      Row(){
        Text(this.titleString)
          .fontSize($r('app.float.title_font_size'))
          .fontColor($r("app.color.default_font_color"))
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)

    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r("app.color.title_view_background"))
  }
}