
import { router, window } from '@kit.ArkUI'
import { common } from '@kit.AbilityKit'
import { QIPlayerContext, QIPlayerProgressListener, QIPlayerStateChangeListener } from '@QN/QPlayer2-core/qplayer2-core'
import { QPlayerState } from '@QN/QPlayer2-core/src/main/ets/public/enums/QPlayerState'
import { QMaskBottom } from './QMaskBottom'

@Component
export struct QMaskView{
  // @Link PlayerSettingViewModel: QPlayerSettingViewModel
  @Link @Watch("orientationChange") mDeviceOrientation : window.Orientation
  @State mPortraitShow : Visibility = Visibility.Hidden
  @Link mPlayerContext : QIPlayerContext
  @Link mIsPlaying : Boolean
  @State mIsBack : Boolean = false
  @Link mSettingViewVisible : Visibility
  private mStateCallBack : QIPlayerStateChangeListener = {
    onStateChange :(context: QIPlayerContext , state : QPlayerState)=>{
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
            router.back()
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
  aboutToDisappear(): void {
    this.mPlayerContext.get_control_handler().release()
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


@Extend(Image) function maskNormalImageStyle(){
  .fillColor($r('app.color.start_window_background'))
  .objectFit(ImageFit.Contain)
}