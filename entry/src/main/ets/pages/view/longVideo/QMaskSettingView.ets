import { QSettingPersistentStorageHelper } from '../../common/helper/QSettingPersistentStorageHelper'
import { QPlayerSettingModel } from '../../model/longVideo/QPlayerSettingModel'
import { Context } from '@ohos.abilityAccessCtrl'
import { ArrayList } from '@kit.ArkTS'
import App from '@system.app'
import {
  QBlindType,
  QIPlayerContext, QPlayerDecoderPriority, QPlayerSeek, QRenderRatio } from '@qiniu/qplayer2-core/qplayer2-core'

@Component
export struct QMaskSettingView{
  @Link mQPlayerSettingModel : QPlayerSettingModel
  @State mInnerSettingModel : innerSettingModel[] = [
    new innerSettingModel("切换下集生效",[], 0),
    new innerSettingModel("解码方式",["自动","硬解","软解"] , this.mQPlayerSettingModel.mDecoderType.valueOf()),
    new innerSettingModel("立即生效",[], 0),
    new innerSettingModel("起播位置",[], this.mQPlayerSettingModel.mPosition.valueOf()),
    new innerSettingModel("seek模式",["关键帧","精准"], this.mQPlayerSettingModel.mSeekMode.valueOf()),
    new innerSettingModel("后台播放",["关闭","开启"] , this.mQPlayerSettingModel.mBackgroundPlay.valueOf()),
    new innerSettingModel("渲染比例",["自动","拉伸","铺满","16:9","4:3"], this.mQPlayerSettingModel.mRenderRatio.valueOf() - 1),
    new innerSettingModel("色盲模式",["无","红色盲","绿色盲","蓝色盲"], this.mQPlayerSettingModel.mBlinderType.valueOf()),
    new innerSettingModel("sei",["关闭","开启"], this.mQPlayerSettingModel.mSEIEnable.valueOf())
  ]
  private mSettingViewUnitHeight :  number = 100
  private mSettingViewUnitLineHeight :  number = 2
  @Link mPlayerContext : QIPlayerContext
  build() {
    RelativeContainer(){
      Scroll(){
        Column() {
          ForEach(this.mInnerSettingModel, (element: innerSettingModel, index: number) => {
            if (index == 0) {
              if (element.mRadioButtonNameArray.length == 0) {
                SettingViewUnit({mSettingModel : element, mQPlayerSetting : this.mQPlayerSettingModel, mPlayerContext : this.mPlayerContext})
                  .height(this.mSettingViewUnitHeight / 2.8)
                  .width("100%")
                  .alignRules({
                    top: { anchor: "__container__", align: VerticalAlign.Top },
                    left: { anchor: "__container__", align: HorizontalAlign.Start }
                  })
                  .id(element.mTitle + "_unit_" + index.toString())
              }else {
                SettingViewUnit({mSettingModel : element, mQPlayerSetting : this.mQPlayerSettingModel, mPlayerContext : this.mPlayerContext})
                  .height(this.mSettingViewUnitHeight)
                  .width("100%")
                  .alignRules({
                    top: { anchor: "__container__", align: VerticalAlign.Top },
                    left: { anchor: "__container__", align: HorizontalAlign.Start }
                  })
                  .id(element.mTitle + "_unit_" + index.toString())
              }
            } else {
              if (element.mRadioButtonNameArray.length == 0) {
                if (element.mTitle.toString() == "起播位置") {
                  SettingViewUnit({
                    mSettingModel: element,
                    mQPlayerSetting: this.mQPlayerSettingModel,
                    mPlayerContext: this.mPlayerContext
                  })
                    .height(this.mSettingViewUnitHeight)
                    .width("100%")
                    .alignRules({
                      top: { anchor: element.mTitle + "_line_" + index.toString(), align: VerticalAlign.Bottom },
                      left: { anchor: "__container__", align: HorizontalAlign.Start }
                    })
                    .id(element.mTitle + "_unit_" + index.toString())

                } else {
                  SettingViewUnit({
                    mSettingModel: element,
                    mQPlayerSetting: this.mQPlayerSettingModel,
                    mPlayerContext: this.mPlayerContext
                  })
                    .height(this.mSettingViewUnitHeight / 2.8)
                    .width("100%")
                    .alignRules({
                      top: { anchor: element.mTitle + "_line_" + index.toString(), align: VerticalAlign.Bottom },
                      left: { anchor: "__container__", align: HorizontalAlign.Start }
                    })
                    .id(element.mTitle + "_unit_" + index.toString())
                }
              }
              else {
                SettingViewUnit({ mSettingModel: element, mQPlayerSetting: this.mQPlayerSettingModel , mPlayerContext : this.mPlayerContext})
                  .height(this.mSettingViewUnitHeight)
                  .width("100%")
                  .alignRules({
                    top: { anchor: element.mTitle + "_line_" + index.toString(), align: VerticalAlign.Bottom },
                    left: { anchor: "__container__", align: HorizontalAlign.Start }
                  })
                  .id(element.mTitle + "_unit_" + index.toString())
              }
            }

            Line()
              .height(this.mSettingViewUnitLineHeight)
              .width("100%")
              .backgroundColor($r("app.color.white"))
              .alignRules({
                top: { anchor: element.mTitle + "_unit_" + index.toString(), align: VerticalAlign.Bottom },
                left: { anchor: "__container__", align: HorizontalAlign.Start }
              })
              .id(element.mTitle + "_line_" + index.toString())
          })
        }
        .width("100%")
        .height((this.mSettingViewUnitHeight + this.mSettingViewUnitLineHeight) * this.mInnerSettingModel.length)
        .id("mask_setting_view_scroll_column")
        .alignRules({left : { anchor : "__container__" , align : HorizontalAlign.Start} ,
          top : {anchor : "__container__" , align : VerticalAlign.Top} })
      }
      .width("100%")
      .height("100%")
      .scrollBar(BarState.Off)
      .id("mask_setting_view_scroll")
      .alignRules({left : { anchor : "__container__" , align : HorizontalAlign.Start} ,
        top : {anchor : "__container__" , align : VerticalAlign.Top} })
    }
    .width("100%")
    .height("100%")
    .id("mask_setting_view")
    .alignRules({left : { anchor : "__container__" , align : HorizontalAlign.Start} ,
                 top : {anchor : "__container__" , align : VerticalAlign.Top} })
  }
}

@Component
struct SettingViewUnit{
  @ObjectLink mSettingModel : innerSettingModel
  @Link mQPlayerSetting : QPlayerSettingModel
  @Link mPlayerContext : QIPlayerContext
  build() {
    Column(){
      RelativeContainer(){
        Text(this.mSettingModel.mTitle.toString())
          .width('100%')
          .height(50)
          .fontColor($r("app.color.white"))
          .alignRules({
            left: {anchor : "__container__", align : HorizontalAlign.Start},
            top : {anchor : "__container__", align : VerticalAlign.Top}
          })
          .id('title_' + this.mSettingModel.mTitle)
        if (this.mSettingModel.mTitle.toString() == "起播位置"){

          TextInput({placeholder : this.mQPlayerSetting.mPosition.valueOf() + ""})
            .alignRules({
              left : {anchor: "__container__",align: HorizontalAlign.Start},
              top : {anchor : 'title_' + this.mSettingModel.mTitle , align : VerticalAlign.Bottom}
            })
            .backgroundColor($r('app.color.white'))
            .type(InputType.Number)
            .enterKeyType(EnterKeyType.Done)
            .onChange((value)=>{
              this.mQPlayerSetting.mPosition = Number(value).valueOf()
              QSettingPersistentStorageHelper.save(AppStorage.get("context") as Context , this.mQPlayerSetting)
            })
            .height(40)
            .width('90%')
            .id(this.mSettingModel.mTitle.toString() + "radio_" + -1)
        }
          ForEach(this.mSettingModel.mRadioButtonNameArray,(element:String,index:Number)=>{
          if(index.valueOf() / 4 <1){
            if (index.valueOf() % 4 == 0) {
              Radio({group:this.mSettingModel.mTitle.toString(), value:element.toString()})
                .checked(index == this.mSettingModel.mIsSelectedIndex)
                .alignRules({
                  left : {anchor: "__container__",align: HorizontalAlign.Start},
                  top : {anchor : 'title_' + this.mSettingModel.mTitle , align : VerticalAlign.Bottom}
                })
                .settingRadioStyle()
                .id(this.mSettingModel.mTitle.toString() + "radio_" + index.valueOf())
                .onClick(()=>{
                  this.radioClick(this.mSettingModel.mTitle.toString(), index.valueOf())
                })
              Text(element.toString())
                .alignRules({
                  left : {anchor: this.mSettingModel.mTitle.toString() + "radio_" + index.valueOf(),align: HorizontalAlign.End},
                  top : {anchor : 'title_' + this.mSettingModel.mTitle , align : VerticalAlign.Bottom}
                })
                .settingRadioTextStyle()
                .id(this.mSettingModel.mTitle.toString() + "text_" + index.valueOf())
                .onClick(()=>{
                  this.radioClick(this.mSettingModel.mTitle.toString(), index.valueOf())
                })

            }
            else{
              Radio({group:this.mSettingModel.mTitle.toString(), value:element.toString()})
                .checked(index == this.mSettingModel.mIsSelectedIndex)
                .alignRules({
                  left : {anchor: this.mSettingModel.mTitle.toString() + "text_" + (index.valueOf() - 1),align: HorizontalAlign.End},
                  top : {anchor : 'title_' + this.mSettingModel.mTitle , align : VerticalAlign.Bottom}
                })
                .settingRadioStyle()
                .id(this.mSettingModel.mTitle.toString() + "radio_" + index.valueOf())
                .onClick(()=>{
                  this.radioClick(this.mSettingModel.mTitle.toString(), index.valueOf())
                })

              Text(element.toString())
                .alignRules({
                  left : {anchor: this.mSettingModel.mTitle.toString() + "radio_" + index.valueOf(),align: HorizontalAlign.End},
                  top : {anchor : 'title_' + this.mSettingModel.mTitle , align : VerticalAlign.Bottom}
                })
                .onClick(()=>{
                  this.radioClick(this.mSettingModel.mTitle.toString(), index.valueOf())
                })
                .onClick(()=>{
                  this.radioClick(this.mSettingModel.mTitle.toString(), index.valueOf())
                })
                .settingRadioTextStyle()
                .id(this.mSettingModel.mTitle.toString() + "text_" + index.valueOf())
            }
          }
          else {
            if (index.valueOf() % 4 == 0) {
              Radio({group:this.mSettingModel.mTitle.toString(), value:element.toString()})
                .checked(index == this.mSettingModel.mIsSelectedIndex)
                .alignRules({
                  left : {anchor: "__container__",align: HorizontalAlign.Start},
                  top : {anchor : this.mSettingModel.mTitle.toString() +  "radio_" + (index.valueOf() - 4) , align : VerticalAlign.Bottom}
                })
                .onClick(()=>{
                  this.radioClick(this.mSettingModel.mTitle.toString(), index.valueOf())
                })
                .settingRadioStyle()
                .id(this.mSettingModel.mTitle.toString() + "radio_" + index.valueOf())

              Text(element.toString())
                .alignRules({
                  left : {anchor: this.mSettingModel.mTitle.toString() + "radio_" + index.valueOf(),align: HorizontalAlign.End},
                  top : {anchor : this.mSettingModel.mTitle.toString() +  "radio_" + (index.valueOf() - 4) , align : VerticalAlign.Bottom}
                })
                .onClick(()=>{
                  this.radioClick(this.mSettingModel.mTitle.toString(), index.valueOf())
                })
                .settingRadioTextStyle()
                .id(this.mSettingModel.mTitle.toString() + "text_" + index.valueOf())
            }
            else{
              Radio({group:this.mSettingModel.mTitle.toString(), value:element.toString()})
                .checked(index == this.mSettingModel.mIsSelectedIndex)
                .alignRules({
                  left : {anchor: this.mSettingModel.mTitle.toString() + "text_" + (index.valueOf() - 1),align: HorizontalAlign.End},
                  top : {anchor : this.mSettingModel.mTitle.toString() + "radio_" + (index.valueOf() - 4) , align : VerticalAlign.Bottom}
                })
                .onClick(()=>{
                  this.radioClick(this.mSettingModel.mTitle.toString(), index.valueOf())
                })
                .settingRadioStyle()
                .id(this.mSettingModel.mTitle.toString() + "radio_" + index.valueOf())

              Text(element.toString())
                .alignRules({
                  left : {anchor: this.mSettingModel.mTitle.toString() + "radio_" + index.valueOf(),align: HorizontalAlign.End},
                  top : {anchor : this.mSettingModel.mTitle.toString() + "radio_" + (index.valueOf() - 4) , align : VerticalAlign.Bottom}
                })
                .onClick(()=>{
                  this.radioClick(this.mSettingModel.mTitle.toString(), index.valueOf())
                })
                .settingRadioTextStyle()
                .id(this.mSettingModel.mTitle.toString() + "text_" + index.valueOf())
            }
          }
        })
      }
      .width("100%")
      .height("100%")
      .id("settingViewUnit_view")
    }
    .width("100%")
    .height("100%")
    .id("settingViewUnit_view")
  }

  radioClick(title:string, index : number)
  {
    this.mSettingModel.mIsSelectedIndex = index
    if (title == "seek模式") {
      if (index == 0) {
        this.mQPlayerSetting.mSeekMode = QPlayerSeek.NORMAL
      }else {
        this.mQPlayerSetting.mSeekMode = QPlayerSeek.ACCURATE
      }
      this.mPlayerContext.get_control_handler().setSeekMode(this.mQPlayerSetting.mSeekMode)
    }else if (title == "后台播放"){
      this.mQPlayerSetting.mBackgroundPlay = index
      if (this.mQPlayerSetting.mBackgroundPlay == 0) {
        this.mPlayerContext.get_control_handler().setBackgroundPlayEnable(false)
      }else {
        this.mPlayerContext.get_control_handler().setBackgroundPlayEnable(true)
      }
    }else if (title == "解码方式"){
      this.mQPlayerSetting.mDecoderType = index as QPlayerDecoderPriority
      this.mPlayerContext.get_control_handler().setDecoderType(this.mQPlayerSetting.mDecoderType)
    }else if (title == "渲染比例"){
      this.mQPlayerSetting.mRenderRatio = (index + 1) as QRenderRatio
      this.mPlayerContext.get_render_handler().setRenderRatio(this.mQPlayerSetting.mRenderRatio)
    }else if (title == "色盲模式"){
      this.mQPlayerSetting.mBlinderType = index as QBlindType
      this.mPlayerContext.get_render_handler().setBlindType(this.mQPlayerSetting.mBlinderType)
    }else if (title == "sei"){
      this.mQPlayerSetting.mSEIEnable = index
      this.mPlayerContext.get_control_handler().setSEIEnable(this.mQPlayerSetting.mSEIEnable == 0 ? false : true)
    }
    QSettingPersistentStorageHelper.save(AppStorage.get("context") as Context, this.mQPlayerSetting)
  }
}

@Extend(Radio) function  settingRadioStyle(){
  .width('7%')
  .height(20)
  .backgroundColor($r("app.color.hyaline_background_color"))
}
@Extend(Text) function  settingRadioTextStyle(){
  .width('18%')
  .height(20)
  .backgroundColor($r("app.color.hyaline_background_color"))
  .fontColor($r("app.color.white"))
  .fontSize($r("app.float.default_font_size"))
}
@Observed
class innerSettingModel{
  public readonly  mTitle : string
  public readonly mRadioButtonNameArray : string[]
  public mIsSelectedIndex : number
  constructor(title : string, radioButtonNameArray : string[] , isSelectedIndex : number) {
    this.mTitle = title
    this.mRadioButtonNameArray = radioButtonNameArray
    this.mIsSelectedIndex = isSelectedIndex
  }

}