import { QSettingPersistentStorageHelper } from '../../common/helper/QSettingPersistentStorageHelper'
import { QPlayerSettingModel } from '../../model/longVideo/QPlayerSettingModel'
import { ArrayList } from '@kit.ArkTS'
import { QTitleView } from '../../common/component/QTitleView'
import { ifaa } from '@kit.OnlineAuthenticationKit'

@Entry
@Component
struct QPlayerDefaultSettingView{
  // @State @Watch('QPlayerSettingModelChange') mQPlayerSetting : QPlayerSettingModel = QSettingPersistentStorageHelper.read(AppStorage.get('context') as Context)
  @State @Watch('QPlayerSettingModelChange') mQPlayerSetting : QPlayerSettingModel = new QPlayerSettingModel()
  mSettingModel : Array<innerSettingModel> = [
    new innerSettingModel("title1", 0,["titleButton1","titleButton2"]),
    new innerSettingModel("title2", 0,["titleButton1","titleButton2","titleButton2"]),
    new innerSettingModel("title3", 0,["titleButton1","titleButton2","titleButton2","titleButton2"]),
    new innerSettingModel("title3", 0,["titleButton1","titleButton2","titleButton2","titleButton2"]),
    new innerSettingModel("title3", 0,["titleButton1","titleButton2","titleButton2","titleButton2"]),
    new innerSettingModel("title3", 0,["titleButton1","titleButton2","titleButton2","titleButton2"])
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
              settingViewUnit({ mSettingModel: element })
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
  QPlayerSettingModelChange(){

  }
}

@Component
struct settingViewUnit{
  mSettingModel : innerSettingModel = new innerSettingModel("",0,[])
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
            }
            else{
              Radio({group:this.mSettingModel.mTitleString.toString(), value:element.toString()})
                .checked(index == this.mSettingModel.mSelectedNumber)
                .alignRules({
                  left : {anchor: this.mSettingModel.mTitleString.toString() + "radio_" + (index.valueOf() - 1),align: HorizontalAlign.End},
                  top : {anchor : 'title_' + this.mSettingModel.mTitleString , align : VerticalAlign.Bottom}
                })
                .settingRadioStyle()
                .id(this.mSettingModel.mTitleString.toString() + "radio_" + index.valueOf())
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
                .settingRadioStyle()
                .id(this.mSettingModel.mTitleString.toString() + "radio_" + index.valueOf())
            }
            else{
              Radio({group:this.mSettingModel.mTitleString.toString(), value:element.toString()})
                .checked(index == this.mSettingModel.mSelectedNumber)
                .alignRules({
                  left : {anchor: this.mSettingModel.mTitleString.toString() + "radio_" + (index.valueOf() - 1),align: HorizontalAlign.End},
                  top : {anchor : this.mSettingModel.mTitleString.toString() + "radio_" + (index.valueOf() - 3) , align : VerticalAlign.Bottom}
                })
                .settingRadioStyle()
                .id(this.mSettingModel.mTitleString.toString() + "radio_" + index.valueOf())
            }
          }
        })

        Line()
          .alignRules({
            left: {anchor: "__container__" , align : HorizontalAlign.Start},
            top : {anchor : this.mSettingModel.mTitleString.toString() + "radio_" + (this.mSettingModel.mButtonTitleStringArray.length.valueOf() - 1), align: VerticalAlign.Bottom}
          })
          .width('100%')
          .height(5)
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
}

@Extend(Radio) function  settingRadioStyle(){
  .width('32%')
  .height(30)
  .backgroundColor("#ffcb2b2b")
}


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

