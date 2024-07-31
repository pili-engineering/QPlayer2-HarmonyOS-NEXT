import { QIPlayerContext, QIPlayerQualityListener, QMediaModel,
  QPlayerUrlType,
  QStreamElement } from '@qiniu/qplayer2-core'
import List from '@ohos.util.List'
import { Immediately, QPlayerSettingModel } from '../../model/longVideo/QPlayerSettingModel'

@Component
export struct QMaskSwitchQualityView{
  @Link mCurrentModel : QMediaModel | null
  private mCurrentElement : QStreamElement | null = null
  @Link mPlayerContext : QIPlayerContext

  @Link mQPlayerSetting : QPlayerSettingModel
  @State mediaModelButtonBackgroundColorArray : Array<ResourceColor> = [
  ]
  private mQualityListener: QIPlayerQualityListener = {
    onQualitySwitchStart:(context : QIPlayerContext , usertype: string , urlType: QPlayerUrlType , oldQuality: number , newQuality: number ) => {

    },

    onQualitySwitchComplete:(context : QIPlayerContext , usertype: string , urlType: QPlayerUrlType , oldQuality: number , newQuality: number ) => {
      this.qualityChange(newQuality)
    },

    onQualitySwitchCanceled:(context : QIPlayerContext , usertype: string , urlType: QPlayerUrlType , oldQuality: number , newQuality: number ) => {
      this.qualityChange(oldQuality)
    },

    onQualitySwitchFailed:(context : QIPlayerContext , usertype: string , urlType: QPlayerUrlType , oldQuality: number , newQuality: number ) => {
      this.qualityChange(oldQuality)
    },

    onQualitySwitchRetryLater:(context : QIPlayerContext ,  usertype: string , urlType: QPlayerUrlType ) => {

    }

  }
  build() {
    Column(){
      ForEach(this.mCurrentModel!.streamElements,(streamElement:QStreamElement, index : number)=>{
        Button(streamElement.quality + "p")
          .backgroundColor($r('app.color.hyaline_background_color'))
          .margin({top: 10})
          .width('90%')
          .height('15%')
          .fontColor(this.mediaModelButtonBackgroundColorArray[index])
          .onClick(()=>{
            this.mediaModelButtonBackgroundColorArray.forEach((resource : ResourceColor, indexOfColor :number)=>{
              if (indexOfColor == index) {
                this.mediaModelButtonBackgroundColorArray[indexOfColor] = $r('app.color.selected_play_speed_button_background_color')
              }else {
                this.mediaModelButtonBackgroundColorArray[indexOfColor] = $r('app.color.not_selected_play_speed_button_background_color')
              }
            })
            switch (this.mQPlayerSetting.mImmediately){
              case Immediately.IMMEDIATELY_TRUE :
                this.mPlayerContext.get_control_handler().switchQuality(streamElement.userType,streamElement.urlType,streamElement.quality,true)
                break
              case Immediately.IMMEDIATELY_FALSE :
                this.mPlayerContext.get_control_handler().switchQuality(streamElement.userType,streamElement.urlType,streamElement.quality,false)
                break
              default :
                if (this.mCurrentModel?.isLive == false) {
                  this.mPlayerContext.get_control_handler().switchQuality(streamElement.userType,streamElement.urlType,streamElement.quality,false)
                }else {
                  this.mPlayerContext.get_control_handler().switchQuality(streamElement.userType,streamElement.urlType,streamElement.quality,true)
                }
                break
            }
            // this.mQPlayerSettingModel.mPlaySpeed = index as PlaySpeed
            // QSettingPersistentStorageHelper.save(AppStorage.get("context") as Context, this.mQPlayerSettingModel)
          })
          .type(ButtonType.Normal)
      })
    }
    .width('100%')
    .height('100%')
  }

  aboutToAppear(): void {
    let colorList : List<ResourceColor> = new List()
    this.mPlayerContext.get_control_handler().addPlayerQualityListener(this.mQualityListener)
    this.mCurrentModel!.streamElements.forEach((streamElement : QStreamElement, value: number)=>{
      if (streamElement.isSelected) {
        colorList.add($r('app.color.selected_play_speed_button_background_color'))
      }
      else {
        colorList.add($r('app.color.not_selected_play_speed_button_background_color'))
      }
    })
    this.mediaModelButtonBackgroundColorArray = colorList.convertToArray()
  }

  qualityChange(quality : number){
    let colorList : List<ResourceColor> = new List()
    this.mCurrentModel!.streamElements.forEach((element : QStreamElement , index : number)=>{
      if (quality == element.quality) {
        colorList.add($r('app.color.selected_play_speed_button_background_color'))
        this.mCurrentElement = element
      }
      else {
        colorList.add($r('app.color.not_selected_play_speed_button_background_color'))
      }
    })
    this.mediaModelButtonBackgroundColorArray = colorList.convertToArray()
  }
}