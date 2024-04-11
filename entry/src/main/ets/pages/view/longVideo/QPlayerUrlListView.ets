import { fileIo, fileIO } from '@kit.CoreFileKit'
import { FaultLogger } from '@kit.PerformanceAnalysisKit'
import { QPlayerDemoMediaModel, QPlayerDemoMediaModels } from '../../model/longVideo/QPlayerDemoMediaModel'
import { QPlayerDemoStreamElement } from '../../model/longVideo/QPlayerDemoStreamElement'


class InnerSubtitleElement{
  constructor() {
  }
}
class InnerUrlClass{
  public mId : Number = 0
  public mName: String = ""
  public mStreamElements:Array<QPlayerDemoStreamElement> = []
  public mSubtitleElements:Array<InnerSubtitleElement> = []
  constructor(id:Number , name : String,stream_elements:Array<QPlayerDemoStreamElement>,subtitle_elements:Array<InnerSubtitleElement>) {
     //本地文件读取只能是沙河路径，预览器获取不到../../json/urls.json 数据
    // let stat = fileIo.statSync('../../json/urls.json');
    // let jsonfd = fileIo.openSync('../../json/urls.json').fd
    // let stream : fileIo.Stream = fileIo.fdopenStreamSync(jsonfd, "r")
    // let buf = new ArrayBuffer(stat.size) //文件大小
    // let readOut = stream.read(buf)
    // console.log(`json: ${readOut.toString()}`)
    this.mId = id
    this.mName = name
    this.mStreamElements = stream_elements
    this.mSubtitleElements = subtitle_elements
  }
}

@Component
export struct QPlayerUrlListView{
  @ObjectLink mMediaModel : QPlayerDemoMediaModels
  build() {
    Column(){
      RelativeContainer(){
        titleView()
          .alignRules({
            left : {anchor : "__container__", align : HorizontalAlign.Start},
            top : {anchor : "__container__", align : VerticalAlign.Top}
          })
          .width("100%")
          .height('10%')
          .id("title_view")

        List(){

          ForEach(this.mMediaModel.mMediaModels,(item:QPlayerDemoMediaModel)=> {
            ListItem() {
              UrlListItem({mName : item.mName, mUrl : item.mMediaModel.streamElements[0].url})
                .height($r('app.float.url_list_item_view_height'))
                .width('100%')
                .backgroundColor($r('app.color.hyaline_background_color'))
                .margin({
                  bottom: 5
                })
                .id("item_view_" + item.mName.toString())
            }
          })

        }
        .alignRules({
          left: {anchor : "__container__" , align : HorizontalAlign.Start},
          top : {anchor : "title_view" , align : VerticalAlign.Bottom},
          bottom : {anchor : "__container__" , align : VerticalAlign.Bottom}
        })
        .backgroundColor($r('app.color.hyaline_background_color'))
        .width('100%')
        .listDirection(Axis.Vertical)
        .lanes(1)
        .id("list_view")
      }
    }
    .width('100%')
    .height('100%')
  }
}
@Component
struct UrlListItem{
  mName :String = ""
  mUrl : String = ""
  build() {
    Row(){
      RelativeContainer(){
          Button(this.mName.toString())
            .backgroundColor($r('app.color.hyaline_background_color'))
            .fontColor($r('app.color.default_font_color'))
            .fontSize(($r('app.float.default_font_size')))
            .alignRules({
              left : {anchor : "__container__" , align : HorizontalAlign.Start},
              top : {anchor : "__container__" , align : VerticalAlign.Top}
            })
            .onClick(()=>{
              console.log(`id: ${this.mName}`)
            })
            .width('100%')
            .height('100%')
            .id(this.mName.toString())
            .align(Alignment.Start)

      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.hyaline_background_color'))

  }
}
@Component
struct titleView{
  build() {
    Row(){
      RelativeContainer(){
        Text("QPlayer2 播放地址列表")
          .fontColor($r('app.color.default_font_color'))
          .fontSize($r('app.float.default_font_size'))
          .backgroundColor($r('app.color.hyaline_background_color'))
          .width("95%")
          .height("100%")
          .margin({
            left: '5%'
          })
          .id("title_view_text")
      }
    }
    .height("100%")
    .width("100%")
    .backgroundColor($r('app.color.long_video_title_view_background_color'))
  }
}
