import { QSettingPersistentStorageHelper } from '../../common/helper/QSettingPersistentStorageHelper'
import { QPlayerSettingModel } from '../../model/longVideo/QPlayerSettingModel'
import { Context } from '@ohos.abilityAccessCtrl'
import { ArrayList } from '@kit.ArkTS'
import App from '@system.app'
import { QPlayerSeek } from '@QN/QPlayer2-core/qplayer2-core'

@Component
export struct QMaskSettingView{
  @State mQPlayerSettingModel : QPlayerSettingModel = QSettingPersistentStorageHelper.read(AppStorage.get("context") as Context)
  @State mInnerSettingModel : innerSettingModel[] = [
    new innerSettingModel("切换下集生效",[], 0),
    new innerSettingModel("立即生效",[], 0),
    new innerSettingModel("seekMode",["关键帧","精准"], this.mQPlayerSettingModel.mSeekMode.valueOf())
  ]
  private mSettingViewUnitHeight :  number = 100
  private mSettingViewUnitLineHeight :  number = 2
  build() {
    RelativeContainer(){
      Scroll(){
        Column() {
          ForEach(this.mInnerSettingModel, (element: innerSettingModel, index: number) => {
            if (index == 0) {
              if (element.mRadioButtonNameArray.length == 0) {
                SettingViewUnit({mSettingModel : element, mQPlayerSetting : this.mQPlayerSettingModel})
                  .height(this.mSettingViewUnitHeight / 2.8)
                  .width("100%")
                  .alignRules({
                    top: { anchor: "__container__", align: VerticalAlign.Top },
                    left: { anchor: "__container__", align: HorizontalAlign.Start }
                  })
                  .id(element.mTitle + "_unit_" + index.toString())
              }else {
                SettingViewUnit({mSettingModel : element, mQPlayerSetting : this.mQPlayerSettingModel})
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
                SettingViewUnit({mSettingModel : element, mQPlayerSetting : this.mQPlayerSettingModel})
                  .height(this.mSettingViewUnitHeight / 2.8)
                  .width("100%")
                  .alignRules({
                    top: { anchor: element.mTitle + "_line_" + index.toString(), align: VerticalAlign.Bottom },
                    left: { anchor: "__container__", align: HorizontalAlign.Start }
                  })
                  .id(element.mTitle + "_unit_" + index.toString())
              }
              else {
                SettingViewUnit({ mSettingModel: element, mQPlayerSetting: this.mQPlayerSettingModel })
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
    if (title == "seekMode") {
      if (index == 0) {
        this.mQPlayerSetting.mSeekMode = QPlayerSeek.NORMAL
      }else {
        this.mQPlayerSetting.mSeekMode = QPlayerSeek.ACCURATE
      }
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