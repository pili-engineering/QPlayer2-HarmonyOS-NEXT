import { QProgressViewModel } from '../../ViewModel/QProgressViewModel'
import { QIPlayerSetting } from '../../interface/longVideo/QPlayerSettingInterface'
import { QPlayerDecodeType } from '../../common/enum/QPlayerDecodeType'
import { QTimestampHelper } from '../../common/helper/QTimestampHelper'
import { router, window } from '@kit.ArkUI'
import { common } from '@kit.AbilityKit'
import { QPlayerDemoMediaModels } from '../../model/longVideo/QPlayerDemoMediaModel'
import { QIPlayerContext, QIPlayerStateChangeListener } from '@QN/QPlayer2-core/qplayer2-core'
import { QPlayerState } from '@QN/QPlayer2-core/src/main/ets/public/enums/QPlayerState'

@Component
export struct QMaskView{
  // @Link PlayerSettingViewModel: QPlayerSettingViewModel
  @Link @Watch("orientationChange") mDeviceOrientation : window.Orientation
  @State mPortraitShow : Visibility = Visibility.Hidden
  @Link mPlayerContext : QIPlayerContext
  @Link mIsPlaying : Boolean
  @State mIsBack : Boolean = false
  private mSettingCallBacks : QIPlayerSetting = {
  decoderUpdating : (decoder_type:QPlayerDecodeType)=>{
    console.info("----------decoderUpdating log--------")
  }
  }
  private mStateCallBack : QIPlayerStateChangeListener = {
    onStateChange :(context: QIPlayerContext , state : QPlayerState)=>{
      if (state == QPlayerState.STOPPED && this.mIsBack) {
        // this.mPlayerContext.get_control_handler().release()
        // router.back()
      }
      if (state == QPlayerState.RELEASE) {
        console.log(`qplayerstate : release`);
      }
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
          if (this.mDeviceOrientation == window.Orientation.PORTRAIT) {
            if (this.mIsPlaying == true) {

              this.mPlayerContext.get_control_handler().release()
              // this.mPlayerContext.get_control_handler().stop()
            }
            this.mIsBack = true
          }else {
            window.getLastWindow(getContext(this) as common.UIAbilityContext).then(res => {
              res.setPreferredOrientation(window.Orientation.PORTRAIT, (err) => {
                if (err.code) {
                  console.error('Failed to set window orientation. Cause: ' + JSON.stringify(err));
                  return;
                }
                this.mDeviceOrientation = window.Orientation.PORTRAIT
                console.info('Succeeded in setting window orientation.');
              })
            })
          }
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
        .visibility(this.mPortraitShow)
        .onClick(()=>{
          router.back()
        })
        .backgroundColor('#00000000')
        .id('setting_view_button')

        QMaskBottom({mDeviceOrientation : this.mDeviceOrientation,
                     mPlayerContext : this.mPlayerContext ,
                     mIsPlaying : this.mIsPlaying})
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
    this.mPlayerContext.get_control_handler().addPlayerStateListener(this.mStateCallBack)
  }
  settingDefault(){
    // this.PlayerSettingViewModel.addQPlayerSetting(this.mSettingCallBacks)
  }
  orientationChange(){
    if (this.mDeviceOrientation == window.Orientation.PORTRAIT) {
      this.mPortraitShow = Visibility.Hidden
    }
    else {
      this.mPortraitShow = Visibility.Visible
    }
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
  @Link @Watch('mIsPlayingChange') mIsPlaying : Boolean
  @State mIsMute : Boolean = false
  @State mProgressViewModel : QProgressViewModel = new QProgressViewModel(10,0,100)
  @State mProgressTextString : String = "00:00"
  @State mDurationTextString : String = "00:00"
  @Link mDeviceOrientation : window.Orientation
  @Link mPlayerContext : QIPlayerContext
  private mQPlayerStateChangeListenrCallBack : QIPlayerStateChangeListener = {
    onStateChange :(context: QIPlayerContext, state: QPlayerState) =>{
      if (state == QPlayerState.PLAYING) {
        this.mIsPlaying = true
      }
    }
  }

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
            this.mIsPlaying = false
            this.mPlayerContext.get_control_handler().pauseRender()
          }
          else {
            this.mIsPlaying = true
            this.mPlayerContext.get_control_handler().resumeRender()
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
          this.mPlayerContext.get_control_handler().stop()
        })
        .horizontalMaskButtonStyle()
        .id("stop_button")

        Text(this.mProgressTextString.valueOf())
          .width($r('app.float.long_video_bottom_view_progress_text_width'))
          .fontSize(10)
          .fontColor($r('app.color.long_video_mask_font_color'))
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
            this.mProgressTextString = QTimestampHelper.millisecondToHMSString(100000/100*value)
            this.mDurationTextString = QTimestampHelper.millisecondToHMSString(100000)
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
          .fontColor($r('app.color.long_video_mask_font_color'))
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
  aboutToAppear(): void {
    this.mPlayerContext.get_control_handler().addPlayerStateListener(this.mQPlayerStateChangeListenrCallBack)

  }
  mIsPlayingChange(){
    if (this.mIsPlaying) {
      this.mPlayControlButtonImage = $r('app.media.qn_pause')
    }
    else {
      this.mPlayControlButtonImage = $r('app.media.qn_play')
    }
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
