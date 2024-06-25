
import { router, window } from '@kit.ArkUI'
import { common } from '@kit.AbilityKit'
import {
  QIPlayerContext, QIPlayerProgressListener, QIPlayerStateChangeListener } from '@qiniu/qplayer2-core/qplayer2-core'
import { QPlayerState } from '@qiniu/qplayer2-core/src/main/ets/public/enums/QPlayerState'
import { QMaskBottom } from './QMaskBottom'

@Component
export struct QMaskView{
  @Link @Watch("orientationChange") mDeviceOrientation : window.Orientation
  @State mPortraitShow : Visibility = Visibility.Hidden
  @Link mPlayerContext : QIPlayerContext
  @Link mIsPlaying : Boolean
  @State mIsBack : Boolean = false
  @Link mIsLive : Boolean
  @Link mSettingViewVisible : Visibility
  @Link mPlaySpeedViewVisible : Visibility
  @Link mSwitchQualityViewVisible : Visibility
  @State mBottomMarginValue : number = 0
  private  mSpeedButtonTitle : string = "倍速"
  private  mSwitchQualityButtonTitle : string = "清晰度"
  private mStateCallBack : QIPlayerStateChangeListener = {
    onStateChange :(context: QIPlayerContext , state : QPlayerState)=>{
      if (state == QPlayerState.RELEASE) {
        console.log(`qplayerstate : release`);
        router.back()
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
            this.mPlayerContext.get_control_handler().release()
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
        .margin({right : 30,top : 0})
        .visibility(this.mPortraitShow)
        .onClick(()=>{
          this.mSettingViewVisible = Visibility.Visible
        })
        .backgroundColor('#00000000')
        .id('setting_view_button')


        Button(){
          Image($r('app.media.qn_shoot'))
            .maskNormalImageStyle()
        }
        .type(ButtonType.Normal)
        .width(40)
        .height(40)
        .alignRules({
          right:{anchor: "__container__" , align : HorizontalAlign.End},
          top : { anchor : "setting_view_button" , align : VerticalAlign.Bottom}
        })
        .margin({right : 30,top : 40})
        .visibility(this.mPortraitShow)
        .onClick(()=>{
          this.mPlayerContext.get_control_handler().shootVideo()
        })
        .backgroundColor('#00000000')
        .id('shoot_view_button')


        Button(this.mSpeedButtonTitle)
        .type(ButtonType.Normal)
        .width(60)
        .height(40)
        .alignRules({
          right:{anchor: "setting_view_button" , align : HorizontalAlign.Start},
          top : { anchor : "__container__" , align : VerticalAlign.Top}
        })
        .margin({right : 20,top : 0})
        .visibility(this.mPortraitShow)
        .onClick(()=>{
          this.mPlaySpeedViewVisible = Visibility.Visible
        })
        .backgroundColor($r('app.color.hyaline_background_color'))
        .fontColor("#ffffffff")
        .id('setting_play_speed_button')

        Button(this.mSwitchQualityButtonTitle)
          .type(ButtonType.Normal)
          .width(100)
          .height(40)
          .alignRules({
            right:{anchor: "setting_play_speed_button" , align : HorizontalAlign.Start},
            top : { anchor : "__container__" , align : VerticalAlign.Top}
          })
          .margin({right : 20,top : 0})
          .visibility(this.mPortraitShow)
          .onClick(()=>{
            this.mSwitchQualityViewVisible = Visibility.Visible
          })
          .backgroundColor($r('app.color.hyaline_background_color'))
          .fontColor("#ffffffff")
          .fontSize(15)
          .id('switch_quality_button')

        QMaskBottom({mDeviceOrientation : this.mDeviceOrientation,
                     mPlayerContext : this.mPlayerContext ,
                     mIsPlaying : this.mIsPlaying,
                    mIsLive : this.mIsLive})
          .height($r('app.float.long_video_bottom_view_height'))
          .alignRules({
            bottom : {anchor : "__container__" , align : VerticalAlign.Bottom},
            left : {anchor : "__container__" , align : HorizontalAlign.Start},
            right : {anchor : "__container__" , align : HorizontalAlign.End}
          })
          .margin({bottom: this.mBottomMarginValue})
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
  aboutToDisappear(): void {
  }
  orientationChange(){
    if (this.mDeviceOrientation == window.Orientation.PORTRAIT) {
      this.mPortraitShow = Visibility.Hidden
      this.mBottomMarginValue = 0
    }
    else {
      this.mPortraitShow = Visibility.Visible
      this.mBottomMarginValue = 30
    }
  }


}


@Extend(Image) function maskNormalImageStyle(){
  .fillColor($r('app.color.start_window_background'))
  .objectFit(ImageFit.Contain)
}