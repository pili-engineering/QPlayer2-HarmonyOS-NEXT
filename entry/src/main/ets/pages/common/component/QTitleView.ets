import { QCountStringLengthOfType,QStringLength } from "../Helper/QCountStringLengthOfType"
@Component
export  struct QTitleView{
  @State private titleString: string = ""
  private fontSize = 20

  build(){
    Column() {
      Text(this.titleString)
        .width(QCountStringLengthOfType.countStringLength(this.titleString).getZH() * this.fontSize +
        QCountStringLengthOfType.countStringLength(this.titleString).getEN() * this.fontSize * 0.61 +
        QCountStringLengthOfType.countStringLength(this.titleString).getNum() * this.fontSize * 0.6)
        .fontSize(this.fontSize)
        .fontColor($r("app.color.default_font_color"))
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r("app.color.title_view_background"))
  }
}