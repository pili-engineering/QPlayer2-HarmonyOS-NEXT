import { window } from '@kit.ArkUI'
import {
  QIPlayerContext, QIPlayerProgressListener, QIPlayerStateChangeListener,
  QPlayerUrlType } from '@qiniu/qplayer2-core/qplayer2-core'
import { QPlayerState } from '@qiniu/qplayer2-core/src/main/ets/public/enums/QPlayerState'
import { QTimestampHelper } from '../../common/helper/QTimestampHelper'
import { common } from '@kit.AbilityKit'

@Component
export struct QMaskBottomView{
  @State mPlayControlButtonImage:Resource = $r('app.media.qn_play')
  @State mMuteControlButtonImage:Resource = $r('app.media.qn_not_mute')
  @Link @Watch('mIsPlayingChange') mIsPlaying : Boolean
  @State mIsMute : Boolean = false
  @State mProgressTextString : String = "00:00"
  @State mDurationTextString : String = "00:00"
  @State mProgress : number = 0
  @State mDuration : number = 0
  @Link mDeviceOrientation : window.Orientation
  @Link mPlayerContext : QIPlayerContext
  @Link mIsLive : Boolean
  @State mButtonMarginValue : number = 4
  private mIsSeeking : boolean = false
  private mProgressListener : QIPlayerProgressListener = {
    onProgressChanged:(context:QIPlayerContext,  progress:number, duration:number) => {
      if (this.mIsSeeking) {
        return
      }
      if (this.mIsLive == false) {
        this.mProgress = progress
        this.mDuration = duration
        this.mDurationTextString = QTimestampHelper.millisecondToHMSString(duration)
      }
      else{
        this.mProgress = 0
        this.mDuration = 0
        this.mDurationTextString = QTimestampHelper.millisecondToHMSString(0)
      }
      this.mProgressTextString = QTimestampHelper.millisecondToHMSString(progress)
    }
  }
  private mQPlayerStateChangeListenrCallBack : QIPlayerStateChangeListener = {
    onStateChange :(context: QIPlayerContext, state: QPlayerState) =>{
      if (state == QPlayerState.PLAYING) {
        this.mIsPlaying = true
        this.mIsSeeking = false
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
        .margin({right : this.mButtonMarginValue/2, left: this.mButtonMarginValue/2 })
        .onClick(() => {
          if (this.mIsPlaying) {
            this.mIsPlaying = false
            this.mPlayerContext.get_control_handler().pauseRender()
          }
          else if(this.mPlayerContext.get_control_handler().currentPlayerState == QPlayerState.COMPLETED) {
            this.mPlayerContext.get_control_handler().seek(0)
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
        .margin({right : this.mButtonMarginValue/2, left: this.mButtonMarginValue/2 })
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
          .margin({right : this.mButtonMarginValue/2, left: this.mButtonMarginValue/2 })
          .id('progress_text')

        Slider({ max: this.mDuration/1000, min: 0, value: this.mProgress/1000})
          .height('100%')
          .alignRules({
            left: { anchor: "progress_text", align: HorizontalAlign.End },
            right: { anchor: "duration_text", align: HorizontalAlign.Start },
            top: { anchor: "__container__", align: VerticalAlign.Top },
            bottom: { anchor: "__container__", align: VerticalAlign.Bottom }
          })
          .backgroundColor($r("app.color.long_video_progress_slider_background_color"))
          .enabled(!this.mIsLive)
          .onChange((value,mode) => {

            if (mode == SliderChangeMode.Begin) {
              this.mIsSeeking = true
            }
            else if (mode == SliderChangeMode.End || mode == SliderChangeMode.Click){
              this.mPlayerContext.get_control_handler().seek(value * 1000)
            }
          })
          .id('progress_slider')

        Text(this.mDurationTextString.valueOf())
          .alignRules({
            right: { anchor: "mute_button", align: HorizontalAlign.Start },
            top: { anchor: "__container__", align: VerticalAlign.Top },
            bottom: { anchor: "__container__", align: VerticalAlign.Bottom }
          })
          .margin({right : this.mButtonMarginValue/2, left: this.mButtonMarginValue/2 })
          .width($r('app.float.long_video_bottom_view_progress_text_width'))
          .fontSize(10)
          .fontColor($r('app.color.long_video_mask_font_color'))
          .id('duration_text')

        Button() {
          Image(this.mMuteControlButtonImage)
            .maskNormalImageStyle()
        }
        .margin({right : this.mButtonMarginValue/2, left: this.mButtonMarginValue/2 })
        .horizontalMaskButtonStyle()
        .onClick(() => {
          if (!this.mIsMute) {
            this.mIsMute = true
            this.mMuteControlButtonImage = $r('app.media.qn_mute')
            this.mPlayerContext.get_control_handler().setMute(true)
          }
          else {
            this.mIsMute = false
            this.mMuteControlButtonImage = $r('app.media.qn_not_mute')
            this.mPlayerContext.get_control_handler().setMute(false)
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
        .margin({right : this.mButtonMarginValue/2, left: this.mButtonMarginValue/2 })
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
    this.mPlayerContext.get_control_handler().addPlayerProgressChangeListener(this.mProgressListener)
    // window.on('windowSizeChange', (size) => {
    //   let viewWidth = px2vp(size.width);
    //   let viewHeight = px2vp(size.height);
    //
    //   // 如果宽大于高，说明此时设置的窗口方向为横屏，相反为竖屏
    //   if (viewWidth > viewHeight) {
    //     // 横屏时的逻辑
    //     this.isLandscape = true;
    //   } else {
    //     // 竖屏时的逻辑
    //     this.isLandscape = false;
    //   }
    // })
  }
  mIsPlayingChange(){

    if (this.mIsPlaying) {
      this.mPlayControlButtonImage = $r('app.media.qn_pause')
    }
    else if(this.mPlayerContext.get_control_handler().currentPlayerState == QPlayerState.COMPLETED){
      this.mPlayControlButtonImage = $r('app.media.qn_replay')
    }
    else if (this.mPlayerContext.get_control_handler().currentPlayerState == QPlayerState.SEEKING){

    }
    else {
      this.mPlayControlButtonImage = $r('app.media.qn_play')
    }
  }
  rotateScreen(){
    let currentOrientation = this.mDeviceOrientation
    if (currentOrientation == window.Orientation.LANDSCAPE) {
      currentOrientation = window.Orientation.PORTRAIT
      this.mButtonMarginValue = 4
    }else {
      currentOrientation = window.Orientation.LANDSCAPE
      this.mButtonMarginValue = 12
    }
    window.getLastWindow(getContext(this) as common.UIAbilityContext).then(res =>{
      res.setPreferredOrientation(currentOrientation, (err)=>{
        if (err.code) {
          console.error('Failed to set window orientation. Cause: ' + JSON.stringify(err));
          return;
        }
        this.mDeviceOrientation = currentOrientation
        // if (this.mDeviceOrientation == window.Orientation.LANDSCAPE) {
        //   this.mDeviceOrientation = window.Orientation.PORTRAIT
        //   this.mButtonMarginValue = 4
        // }else {
        //   this.mDeviceOrientation = window.Orientation.LANDSCAPE
        //   this.mButtonMarginValue = 12
        // }

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