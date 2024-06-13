import { QIPlayerContext } from '@QN/QPlayer2-core/qplayer2-core'

@Component
export struct QMaskPlaySpeedView{
  private playSpeedTitleArray : Array<string> = ["0.5","0.75","1.0","1.25","1.5","2.0"]
  @State playSpeedButtonBackgroundColorArray : Array<ResourceColor> = [
    $r('app.color.not_selected_play_speed_button_background_color'),
    $r('app.color.not_selected_play_speed_button_background_color'),
    $r('app.color.selected_play_speed_button_background_color'),
    $r('app.color.not_selected_play_speed_button_background_color'),
    $r('app.color.not_selected_play_speed_button_background_color'),
    $r('app.color.not_selected_play_speed_button_background_color'),
  ]
  @Link mPlayerContext : QIPlayerContext
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
            this.mPlayerContext.get_control_handler().setSpeed(Number(title).valueOf())
          })
          .type(ButtonType.Normal)
      })
    }
    .width('100%')
    .height('100%')
  }
}