import { QIPlayerContext, QMediaModel } from '@QN/QPlayer2-core/qplayer2-core'
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
    this.mId = id
    this.mName = name
    this.mStreamElements = stream_elements
    this.mSubtitleElements = subtitle_elements
  }
}

@Component
export struct QPlayerUrlListView{
  @ObjectLink mMediaModel : QPlayerDemoMediaModels
  @Link mPlayerContext : QIPlayerContext
  @Link mIsPlaying : Boolean
  @Link mIsLive : Boolean
  @State @Watch('currentMediaModelIdChange') mCurrentPlayerMediaModelId : Number  = 0
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
          ForEach(this.mMediaModel.mMediaModels,(item:QPlayerDemoMediaModel,index : Number)=> {
            ListItem() {
              UrlListItem({mName : item.mName,
                mUrl : item.mMediaModel.streamElements[0].url,mId: index ,
                mCurrentPlayerMediaModelId: this.mCurrentPlayerMediaModelId,
                mIsPlaying : this.mIsPlaying})
                .height($r('app.float.url_list_item_view_height'))
                .width('100%')
                .backgroundColor($r('app.color.hyaline_background_color'))
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
  currentMediaModelIdChange () {
    if (this.mCurrentPlayerMediaModelId == -1) {
      return
    }
    this.mPlayerContext.get_control_handler().playMediaModel(this.mMediaModel.mMediaModels[this.mCurrentPlayerMediaModelId.valueOf()].mMediaModel,0)

    this.mIsLive = this.mMediaModel.mMediaModels[this.mCurrentPlayerMediaModelId.valueOf()].mMediaModel.isLive
  }
}
@Component
struct UrlListItem{
  mName :String = ""
  mUrl : String = ""
  mId: Number = 0
  @Link @Watch("currentPlayerMediaModelIdChange") mCurrentPlayerMediaModelId : Number
  @Link mIsPlaying : Boolean
  @State fontColor : ResourceColor = $r('app.color.default_font_color')
  build() {
    Row(){
      RelativeContainer(){
          Button(this.mName.toString())
            .backgroundColor($r('app.color.hyaline_background_color'))
            .fontColor(this.fontColor)
            .fontSize(($r('app.float.default_font_size')))
            .alignRules({
              left : {anchor : "__container__" , align : HorizontalAlign.Start},
              top : {anchor : "__container__" , align : VerticalAlign.Top}
            })
            .onClick(()=>{
              this.mIsPlaying = false
              if (this.mCurrentPlayerMediaModelId == this.mId) {
                //此处设置-1 用于触发 mCurrentPlayerMediaModelId 后面的@watch监听
                this.mCurrentPlayerMediaModelId = -1
              }
              this.mCurrentPlayerMediaModelId = this.mId

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
  aboutToAppear(): void {
    this.currentPlayerMediaModelIdChange()
  }
  currentPlayerMediaModelIdChange(){
    if (this.mCurrentPlayerMediaModelId == this .mId) {
      this.fontColor = $r("app.color.selected_font_color")
    }else {
      this.fontColor = $r("app.color.default_font_color")
    }
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
