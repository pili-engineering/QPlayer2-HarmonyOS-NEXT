import { QProgressViewModel } from '../../ViewModel/QProgressViewModel'
import { QPlayerSettingViewModel } from '../../viewModel/longVideo/QPlayerSettingViewModel'
import { QIPlayerSetting } from '../../interface/longVideo/QPlayerSettingInterface'
import { QPlayerDecodeType } from '../../common/enum/QPlayerDecodeType'
import { QTimestampHelper } from '../../common/Helper/QTimestampHelper'
import { router, window } from '@kit.ArkUI'
import { common } from '@kit.AbilityKit'

@Component
export struct QMaskView{
  @Link PlayerSettingViewModel: QPlayerSettingViewModel
  @Link mDeviceOrientation : window.Orientation
  private mSettingCallBacks : QIPlayerSetting = {
  decoderUpdating : (decoder_type:QPlayerDecodeType)=>{
    console.info("----------decoderUpdating log--------")
  }
}
  build(){
    Column() {
      RelativeContainer(){
        Button(){
          Image($r('app.media.qn_back'))
            .maskNormalImageStyle()
        }
        .type(ButtonType.Normal)
        .width($r('app.float.long_video_back_button_width'))
        .height($r('app.float.long_video_back_button_height'))
        .alignRules({
          left:{anchor: "__container__" , align : HorizontalAlign.Start},
          top : { anchor : "__container__" , align : VerticalAlign.Top}
        })
        .onClick(()=>{
          router.back()
        })
        .backgroundColor('#00000000')
        .id('mask_back_button')

        Button(){
          Image($r('app.media.qn_more'))
            .maskNormalImageStyle()
        }
        .type(ButtonType.Normal)
        .width($r('app.float.long_video_back_button_width'))
        .height($r('app.float.long_video_back_button_height'))
        .alignRules({
          right:{anchor: "__container__" , align : HorizontalAlign.End},
          top : { anchor : "__container__" , align : VerticalAlign.Top}
        })
        .margin({right : 30,top : 20})
        .onClick(()=>{
          router.back()
        })
        .backgroundColor('#00000000')
        .id('setting_view_button')

        QMaskBottom({mDeviceOrientation : this.mDeviceOrientation})
          .height($r('app.float.long_video_bottom_view_height'))
          .alignRules({
            bottom : {anchor : "__container__" , align : VerticalAlign.Bottom},
            left : {anchor : "__container__" , align : HorizontalAlign.Start},
            right : {anchor : "__container__" , align : HorizontalAlign.End}
          })
          .backgroundColor('#00000000')
          .id('mask_bottom_view')
      }
    }
    .width('100%')
    .height('100%')
  }

  aboutToAppear(): void {
    // this.settingDefault()
    let i = 0
  }
  settingDefault(){
    this.PlayerSettingViewModel.addQPlayerSetting(this.mSettingCallBacks)
  }


}
@Component
struct QMaskSettingView{

  build() {
  }
}

@Component
struct QMaskBottom{
  @State mPlayControlButtonImage:Resource = $r('app.media.qn_play')
  @State mMuteControlButtonImage:Resource = $r('app.media.qn_not_mute')
  @State mIsPlaying : boolean = false
  @State mIsMute : boolean = false
  @State mProgressViewModel : QProgressViewModel = new QProgressViewModel(10,0,100)
  @State mProgressTextString : String = "00:00"
  @State mDurationTextString : String = "00:00"
  @Link mDeviceOrientation : window.Orientation
  build(){
    Row({space: 5}) {
      RelativeContainer() {
        Button() {
          Image(this.mPlayControlButtonImage)
            .maskNormalImageStyle()
        }
        .alignRules({
          left: { anchor: "__container__", align: HorizontalAlign.Start },
          top: { anchor: "__container__", align: VerticalAlign.Top },
          bottom: { anchor: "__container__", align: VerticalAlign.Bottom }
        })
        .margin({ left: 2 })
        .onClick(() => {
          if (this.mIsPlaying) {
            this.mPlayControlButtonImage = $r('app.media.qn_pause')
            this.mIsPlaying = false
          }
          else {
            this.mPlayControlButtonImage = $r('app.media.qn_play')
            this.mIsPlaying = true
          }
        })
        .horizontalMaskButtonStyle()
        .id("play_button")

        Button() {
          Image($r('app.media.qn_stop'))
            .maskNormalImageStyle()
        }
        .alignRules({
          left: { anchor: "play_button", align: HorizontalAlign.End },
          top: { anchor: "__container__", align: VerticalAlign.Top },
          bottom: { anchor: "__container__", align: VerticalAlign.Bottom }
        })
        .onClick(()=>{
          console.log(`stop click`)
        })
        .horizontalMaskButtonStyle()
        .id("stop_button")

        Text(this.mProgressTextString.valueOf())
          .width($r('app.float.long_video_bottom_view_progress_text_width'))
          .fontSize(10)
          .fontColor($r('app.color.default_font_color'))
          .alignRules({
            left: { anchor: "stop_button", align: HorizontalAlign.End },
            top: { anchor: "__container__", align: VerticalAlign.Top },
            bottom: { anchor: "__container__", align: VerticalAlign.Bottom }
          })
          .id('progress_text')

        Slider({ max: 100, min: 0, value: 0, step: 0.1 })
          .height('100%')
          .alignRules({
            left: { anchor: "progress_text", align: HorizontalAlign.End },
            right: { anchor: "duration_text", align: HorizontalAlign.Start },
            top: { anchor: "__container__", align: VerticalAlign.Top },
            bottom: { anchor: "__container__", align: VerticalAlign.Bottom }
          })
          .backgroundColor($r("app.color.long_video_progress_slider_background_color"))
          .onChange((value) => {
            this.mProgressViewModel.setProgress(100)
            this.mProgressTextString = QTimestampHelper.millisecondToHMSString(10000)
          })
          .id('progress_slider')

        Text(this.mDurationTextString.valueOf())
          .alignRules({
            right: { anchor: "mute_button", align: HorizontalAlign.Start },
            top: { anchor: "__container__", align: VerticalAlign.Top },
            bottom: { anchor: "__container__", align: VerticalAlign.Bottom }
          })
          .width($r('app.float.long_video_bottom_view_progress_text_width'))
          .fontSize(10)
          .fontColor($r('app.color.default_font_color'))
          .id('duration_text')

        Button() {
          Image(this.mMuteControlButtonImage)
            .maskNormalImageStyle()
        }
        .horizontalMaskButtonStyle()
        .onClick(() => {
          if (!this.mIsMute) {
            this.mIsMute = true
            this.mMuteControlButtonImage = $r('app.media.qn_mute')
          }
          else {
            this.mIsMute = false
            this.mMuteControlButtonImage = $r('app.media.qn_not_mute')
          }
        })
        .alignRules({
          // left: { anchor: "progress_text", align: HorizontalAlign.End },
          right: { anchor: "full_screen_button", align: HorizontalAlign.Start },
          top: { anchor: "__container__", align: VerticalAlign.Top },
          bottom: { anchor: "__container__", align: VerticalAlign.Bottom }
        })
        .id("mute_button")


        Button() {
          Image($r('app.media.qn_full_screen'))
            .maskNormalImageStyle()
        }
        .alignRules({
          right: { anchor: "__container__", align: HorizontalAlign.End },
          top: { anchor: "__container__", align: VerticalAlign.Top },
          bottom: { anchor: "__container__", align: VerticalAlign.Bottom }
        })
        .horizontalMaskButtonStyle()
        .id('full_screen_button')
        .onClick(()=>{
          this.rotateScreen()
        })
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
  }

  rotateScreen(){
    if (this.mDeviceOrientation == window.Orientation.LANDSCAPE) {
      this.mDeviceOrientation = window.Orientation.PORTRAIT
    }else {
      this.mDeviceOrientation = window.Orientation.LANDSCAPE
    }
    window.getLastWindow(getContext(this) as common.UIAbilityContext).then(res =>{
      res.setPreferredOrientation(this.mDeviceOrientation, (err)=>{
        if (err.code) {
          console.error('Failed to set window orientation. Cause: ' + JSON.stringify(err));
          return;
        }
        console.info('Succeeded in setting window orientation.');
      })
    })
  }
}
@Extend(Image) function maskNormalImageStyle(){
  .fillColor($r('app.color.start_window_background'))
  .objectFit(ImageFit.Contain)
}
@Extend(Button) function  horizontalMaskButtonStyle(){
  .type(ButtonType.Normal)
  .width($r('app.float.long_video_bottom_view_button_width'))
  .backgroundColor('#00000000')
}
@Extend(Button) function  verticalMaskButtonStyle(){

}
