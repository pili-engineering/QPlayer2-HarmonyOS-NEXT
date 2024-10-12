import { QSettingPersistentStorageHelper } from '../../common/helper/QSettingPersistentStorageHelper'
import { Immediately, PlaySpeed, QPlayerSettingModel } from '../../model/longVideo/QPlayerSettingModel'
import { QTitleView } from '../../common/component/QTitleView'
import { QPlayerMirror, QPlayerSeek, QPlayerStart } from '@qiniu/qplayer2-core/qplayer2-core'

@Entry
@Component
struct QPlayerDefaultSettingView{
  @State mQPlayerSetting : QPlayerSettingModel = QSettingPersistentStorageHelper.read(AppStorage.get('context') as Context)
  @State mSettingModel : Array<innerSettingModel> = [
    new innerSettingModel("解码方式", this.mQPlayerSetting.mDecoderType.valueOf(),["自动","硬解","软解"]),
    new innerSettingModel("seek模式", this.mQPlayerSetting.mSeekMode.valueOf(),["关键帧","精准"]),
    new innerSettingModel("起播模式", this.mQPlayerSetting.mStartAction.valueOf(),["播放","暂停"]),
    new innerSettingModel("起播位置", this.mQPlayerSetting.mPosition.valueOf(),[]),
    new innerSettingModel("渲染比例", this.mQPlayerSetting.mRenderRatio.valueOf() - 1,["自动","拉伸","铺满","16:9","4:3"]),
    new innerSettingModel("播放速度", this.mQPlayerSetting.mPlaySpeed.valueOf(),["0.5","0.75","1.0","1.25","1.5","2.0"]),
    new innerSettingModel("色盲模式", this.mQPlayerSetting.mBlinderType.valueOf(),["无","红色盲","绿色盲","蓝色盲"]),
    new innerSettingModel("sei", this.mQPlayerSetting.mSEIEnable.valueOf(),["关闭","开启"]),
    new innerSettingModel("后台播放", this.mQPlayerSetting.mBackgroundPlay.valueOf(),["关闭","开启"]),
    new innerSettingModel("字幕", this.mQPlayerSetting.mSubtitleEnable.valueOf(),["关闭","开启"]),
    new innerSettingModel("清晰度切换模式", this.mQPlayerSetting.mImmediately.valueOf(),["立即切换","无缝切换","直播立即点播无缝"]),
    new innerSettingModel("强制网络鉴权", this.mQPlayerSetting.mForceNetworkAuth.valueOf(),["关闭","开启"]),
    new innerSettingModel("镜像", this.mQPlayerSetting.mMirrorType.valueOf(),["无","横向镜像","垂直镜像","横向和垂直都镜像"]),
  ]
  mUnitHeight : Number = 125
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
        if (this.mSettingModel.mTitleString.toString() == "起播位置"){
          TextInput({placeholder : this.mQPlayerSetting.mPosition.valueOf() + ""})
            .alignRules({
              left : {anchor: "__container__",align: HorizontalAlign.Start},
              top : {anchor : 'title_' + this.mSettingModel.mTitleString , align : VerticalAlign.Bottom}
            })
            .type(InputType.Number)
            .enterKeyType(EnterKeyType.Done)
            .onChange((value)=>{
              this.mQPlayerSetting.mPosition = Number(value).valueOf()
            })
            .height(40)
            .width('90%')
            .id(this.mSettingModel.mTitleString.toString() + "radio_" + -1)
        }
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
            bottom : {anchor : "__container__", align : VerticalAlign.Bottom}
            // top : {anchor : this.mSettingModel.mTitleString.toString() + "radio_" + (this.mSettingModel.mButtonTitleStringArray.length.valueOf() - 1), align: VerticalAlign.Bottom}
          })
          .width('94%')
          .height(2)
          .margin({top : 3, left : '3%'})
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
    if (title == "seek模式") {
      if (index == 0) {
        this.mQPlayerSetting.mSeekMode = QPlayerSeek.NORMAL
      }else {
        this.mQPlayerSetting.mSeekMode = QPlayerSeek.ACCURATE
      }
    }else if (title == "后台播放") {
        this.mQPlayerSetting.mBackgroundPlay = index
    }else if (title == "解码方式"){
      this.mQPlayerSetting.mDecoderType = index
    }else if (title == "播放速度"){
      this.mQPlayerSetting.mPlaySpeed = index as PlaySpeed
    }else if (title == "渲染比例"){
      this.mQPlayerSetting.mRenderRatio = index + 1
    }else if (title == "色盲模式"){
      this.mQPlayerSetting.mBlinderType = index
    }else if (title == "sei"){
      this.mQPlayerSetting.mSEIEnable = index
    }else if (title == "起播模式"){
      this.mQPlayerSetting.mStartAction = index as QPlayerStart
    }else if (title == "清晰度切换模式"){
      this.mQPlayerSetting.mImmediately = index as Immediately
    }else if (title == "字幕"){
      this.mQPlayerSetting.mSubtitleEnable = index
    }else if (title == "强制网络鉴权"){
      this.mQPlayerSetting.mForceNetworkAuth = index
    }else if (title == "镜像"){
      this.mQPlayerSetting.mMirrorType = index as QPlayerMirror
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

