import { QSettingPersistentStorageHelper } from '../../common/helper/QSettingPersistentStorageHelper'
import { QPlayerSettingModel } from '../../model/longVideo/QPlayerSettingModel'
import { QTitleView } from '../../common/component/QTitleView'
import { QPlayerSeek } from '@qiniu/qplayer2-core/qplayer2-core'

@Entry
@Component
struct QPlayerDefaultSettingView{
  @State mQPlayerSetting : QPlayerSettingModel = QSettingPersistentStorageHelper.read(AppStorage.get('context') as Context)
  @State mSettingModel : Array<innerSettingModel> = [
    new innerSettingModel("seekMode", this.mQPlayerSetting.mSeekMode.valueOf(),["关键帧","精准"]),
    new innerSettingModel("backgroundPlay", this.mQPlayerSetting.mBackgroundPlay.valueOf(),["关闭","开启"]),
    new innerSettingModel("decoderType", this.mQPlayerSetting.mDecoderType.valueOf(),["自动","硬解","软解"])
  ]
  mUnitHeight : Number = 150
    build() {
      Column() {

        Row() {
          QTitleView({ titleString: '初始化设置' })
            .width("100%")
            .height("100%")
            .id("title_view")
        }
        .justifyContent(FlexAlign.Center)
        .width("100%")
        .height($r("app.float.long_video_title_view_height"))
        .id("title_view_row")

        Scroll() {
          Column() {
            ForEach(this.mSettingModel, (element: innerSettingModel, index: Number) => {
              settingViewUnit({ mSettingModel: element, mQPlayerSetting : this.mQPlayerSetting })
                .width('100%')
                .height(this.mUnitHeight.valueOf())
                .id('unit_' + element.mTitleString.toString())
                .backgroundColor($r('app.color.start_window_background'))
            })
          }
          .width('100%')
          .height(this.mUnitHeight.valueOf() * this.mSettingModel.length + 50)
          .id("scroll_view")
        }
      }
      .width('100%')
      .height('100%')
    }
  aboutToDisappear(): void {
    QSettingPersistentStorageHelper.save(AppStorage.get("context") as Context, this.mQPlayerSetting)
  }
}

@Component
struct settingViewUnit{
  @ObjectLink mSettingModel : innerSettingModel
  @Link mQPlayerSetting : QPlayerSettingModel
  @State mSelected : boolean = false
  build() {
    Column(){
      RelativeContainer(){
        Text(this.mSettingModel.mTitleString.toString())
          .width('100%')
          .height(50)
          .alignRules({
            left: {anchor : "__container__", align : HorizontalAlign.Start},
            top : {anchor : "__container__", align : VerticalAlign.Top}
          })
          .id('title_' + this.mSettingModel.mTitleString)

        ForEach(this.mSettingModel.mButtonTitleStringArray,(element:String,index:Number)=>{
          if(index.valueOf() / 3 <1){
            if (index.valueOf() % 3 == 0) {
              Radio({group:this.mSettingModel.mTitleString.toString(), value:element.toString()})
                .checked(index == this.mSettingModel.mSelectedNumber)
                .alignRules({
                  left : {anchor: "__container__",align: HorizontalAlign.Start},
                  top : {anchor : 'title_' + this.mSettingModel.mTitleString , align : VerticalAlign.Bottom}
                })
                .settingRadioStyle()
                .id(this.mSettingModel.mTitleString.toString() + "radio_" + index.valueOf())
                .onClick(()=>{
                  this.radioClick(this.mSettingModel.mTitleString.toString(), index.valueOf())
                })

              Text(element.toString())
                .alignRules({
                  left : {anchor: this.mSettingModel.mTitleString.toString() + "radio_" + index.valueOf(),align: HorizontalAlign.End},
                  top : {anchor : 'title_' + this.mSettingModel.mTitleString , align : VerticalAlign.Bottom}
                })
                .settingRadioTextStyle()
                .id(this.mSettingModel.mTitleString.toString() + "text_" + index.valueOf())
                .onClick(()=>{
                  this.radioClick(this.mSettingModel.mTitleString.toString(), index.valueOf())
                })

            }
            else{
              Radio({group:this.mSettingModel.mTitleString.toString(), value:element.toString()})
                .checked(index == this.mSettingModel.mSelectedNumber)
                .alignRules({
                  left : {anchor: this.mSettingModel.mTitleString.toString() + "text_" + (index.valueOf() - 1),align: HorizontalAlign.End},
                  top : {anchor : 'title_' + this.mSettingModel.mTitleString , align : VerticalAlign.Bottom}
                })
                .settingRadioStyle()
                .id(this.mSettingModel.mTitleString.toString() + "radio_" + index.valueOf())
                .onClick(()=>{
                  this.radioClick(this.mSettingModel.mTitleString.toString(), index.valueOf())
                })

              Text(element.toString())
                .alignRules({
                  left : {anchor: this.mSettingModel.mTitleString.toString() + "radio_" + index.valueOf(),align: HorizontalAlign.End},
                  top : {anchor : 'title_' + this.mSettingModel.mTitleString , align : VerticalAlign.Bottom}
                })
                .onClick(()=>{
                  this.radioClick(this.mSettingModel.mTitleString.toString(), index.valueOf())
                })
                .onClick(()=>{
                  this.radioClick(this.mSettingModel.mTitleString.toString(), index.valueOf())
                })
                .settingRadioTextStyle()
                .id(this.mSettingModel.mTitleString.toString() + "text_" + index.valueOf())
            }
          }
          else {
            if (index.valueOf() % 3 == 0) {
              Radio({group:this.mSettingModel.mTitleString.toString(), value:element.toString()})
                .checked(index == this.mSettingModel.mSelectedNumber)
                .alignRules({
                  left : {anchor: "__container__",align: HorizontalAlign.Start},
                  top : {anchor : this.mSettingModel.mTitleString.toString() +  "radio_" + (index.valueOf() - 3) , align : VerticalAlign.Bottom}
                })
                .onClick(()=>{
                  this.radioClick(this.mSettingModel.mTitleString.toString(), index.valueOf())
                })
                .settingRadioStyle()
                .id(this.mSettingModel.mTitleString.toString() + "radio_" + index.valueOf())

              Text(element.toString())
                .alignRules({
                  left : {anchor: this.mSettingModel.mTitleString.toString() + "radio_" + index.valueOf(),align: HorizontalAlign.End},
                  top : {anchor : this.mSettingModel.mTitleString.toString() +  "radio_" + (index.valueOf() - 3) , align : VerticalAlign.Bottom}
                })
                .onClick(()=>{
                  this.radioClick(this.mSettingModel.mTitleString.toString(), index.valueOf())
                })
                .settingRadioTextStyle()
                .id(this.mSettingModel.mTitleString.toString() + "text_" + index.valueOf())
            }
            else{
              Radio({group:this.mSettingModel.mTitleString.toString(), value:element.toString()})
                .checked(index == this.mSettingModel.mSelectedNumber)
                .alignRules({
                  left : {anchor: this.mSettingModel.mTitleString.toString() + "text_" + (index.valueOf() - 1),align: HorizontalAlign.End},
                  top : {anchor : this.mSettingModel.mTitleString.toString() + "radio_" + (index.valueOf() - 3) , align : VerticalAlign.Bottom}
                })
                .onClick(()=>{
                  this.radioClick(this.mSettingModel.mTitleString.toString(), index.valueOf())
                })
                .settingRadioStyle()
                .id(this.mSettingModel.mTitleString.toString() + "radio_" + index.valueOf())

              Text(element.toString())
                .alignRules({
                  left : {anchor: this.mSettingModel.mTitleString.toString() + "radio_" + index.valueOf(),align: HorizontalAlign.End},
                  top : {anchor : this.mSettingModel.mTitleString.toString() + "radio_" + (index.valueOf() - 3) , align : VerticalAlign.Bottom}
                })
                .onClick(()=>{
                  this.radioClick(this.mSettingModel.mTitleString.toString(), index.valueOf())
                })
                .settingRadioTextStyle()
                .id(this.mSettingModel.mTitleString.toString() + "text_" + index.valueOf())
            }
          }
        })

        Line()
          .alignRules({
            left: {anchor: "__container__" , align : HorizontalAlign.Start},
            top : {anchor : this.mSettingModel.mTitleString.toString() + "radio_" + (this.mSettingModel.mButtonTitleStringArray.length.valueOf() - 1), align: VerticalAlign.Bottom}
          })
          .width('100%')
          .height(2)
          .margin({top : 3})
          .backgroundColor($r('app.color.default_line_color'))
          .id(this.mSettingModel.mTitleString.toString() + "line")
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
    this.mSettingModel.mSelectedNumber = index
    if (title == "seekMode") {
      if (index == 0) {
        this.mQPlayerSetting.mSeekMode = QPlayerSeek.NORMAL
      }else {
        this.mQPlayerSetting.mSeekMode = QPlayerSeek.ACCURATE
      }
    }else if (title == "backgroundPlay") {
        this.mQPlayerSetting.mBackgroundPlay = index
    }else if (title == "decoderType"){
      this.mQPlayerSetting.mDecoderType = index
    }
  }
}

@Extend(Radio) function  settingRadioStyle(){
  .width('10%')
  .height(30)
  .backgroundColor($r("app.color.white"))
}
@Extend(Text) function  settingRadioTextStyle(){
  .width('22%')
  .height(30)
  .backgroundColor($r("app.color.white"))
  .fontSize($r("app.float.default_font_size"))
}
@Extend(Row) function  settingRadioRowStyle(){
  .width('32%')
  .height(30)
  .backgroundColor($r("app.color.default_background_color"))
}

@Observed
class innerSettingModel{
  public mButtonTitleStringArray : Array<String>
  public mTitleString : String
  public mSelectedNumber : Number
  constructor(title_string : String, selected_number : Number , button_title_string_array : Array<String>) {
    this.mButtonTitleStringArray = button_title_string_array
    this.mTitleString = title_string
    this.mSelectedNumber = selected_number
  }
}

