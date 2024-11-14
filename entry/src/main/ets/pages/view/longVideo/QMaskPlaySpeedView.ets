import { QIPlayerContext } from '@qiniu/qplayer2-core/qplayer2-core'
import { QSettingPersistentStorageHelper } from '../../common/helper/QSettingPersistentStorageHelper'
import { PlaySpeed, QPlayerSettingModel } from '../../model/longVideo/QPlayerSettingModel'

@Component
export struct QMaskPlaySpeedView{
  private playSpeedTitleArray : Array<string> = ["0.5","0.75","1.0","1.25","1.5","2.0"]
  @Link mQPlayerSettingModel : QPlayerSettingModel | null
  @State playSpeedButtonBackgroundColorArray : Array<ResourceColor> = [
    $r('app.color.not_selected_play_speed_button_background_color'),
    $r('app.color.not_selected_play_speed_button_background_color'),
    $r('app.color.selected_play_speed_button_background_color'),
    $r('app.color.not_selected_play_speed_button_background_color'),
    $r('app.color.not_selected_play_speed_button_background_color'),
    $r('app.color.not_selected_play_speed_button_background_color'),
  ]
  @Link mPlayerContext : QIPlayerContext | null
  build() {
    Column(){
      ForEach(this.playSpeedTitleArray,(title:string, index : number)=>{
        Button(this.playSpeedTitleArray[index])
          .backgroundColor($r('app.color.hyaline_background_color'))
          .margin({top: 10})
          .width('90%')
          .height('12%')
          .fontColor(this.playSpeedButtonBackgroundColorArray[index])
          .onClick(()=>{
            this.playSpeedButtonBackgroundColorArray.forEach((resource : ResourceColor, indexOfColor :number)=>{
              if (indexOfColor == index) {
                this.playSpeedButtonBackgroundColorArray[indexOfColor] = $r('app.color.selected_play_speed_button_background_color')
              }else {
                this.playSpeedButtonBackgroundColorArray[indexOfColor] = $r('app.color.not_selected_play_speed_button_background_color')
              }
            })
            this.mPlayerContext?.get_control_handler().setSpeed(Number(title).valueOf())
            this.mQPlayerSettingModel!.mPlaySpeed = index as PlaySpeed
            QSettingPersistentStorageHelper.save(AppStorage.get("context") as Context, this.mQPlayerSettingModel!)
          })
          .type(ButtonType.Normal)
      })
    }
    .width('100%')
    .height('100%')
  }
  aboutToAppear(): void {
    this.playSpeedButtonBackgroundColorArray.forEach((resource : ResourceColor, indexOfColor :number)=>{
      if (indexOfColor == this.mQPlayerSettingModel?.mPlaySpeed.valueOf()) {
        this.playSpeedButtonBackgroundColorArray[indexOfColor] = $r('app.color.selected_play_speed_button_background_color')
      }else {
        this.playSpeedButtonBackgroundColorArray[indexOfColor] = $r('app.color.not_selected_play_speed_button_background_color')
      }
    })
  }
}