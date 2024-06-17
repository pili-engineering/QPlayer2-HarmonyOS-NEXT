
import { QMaskView } from './QMaskView'
import { window } from '@kit.ArkUI'
import {QSurfaceRenderView,QIPlayerContext,
  QPlayerContextFactory,
  QLogLevel,
  QPlayerSeek,
  QIPlayerStateChangeListener,
  QIPlayerBufferingListener
} from '@qiniu/qplayer2-core/qplayer2-core'
import { QPlayerDemoMediaModels } from '../../model/longVideo/QPlayerDemoMediaModel'
import { QMaskSettingView } from './QMaskSettingView'
import { QPlayerState } from '@qiniu/qplayer2-core/src/main/ets/public/enums/QPlayerState'
import { QSettingPersistentStorageHelper } from '../../common/helper/QSettingPersistentStorageHelper'
import { PlaySpeed, QPlayerSettingModel } from '../../model/longVideo/QPlayerSettingModel'
import { common } from '@kit.AbilityKit'
import { QMaskPlaySpeedView } from './QMaskPlaySpeedView'

@Component
export struct QPlayerView{
  private mQPlayerTimerCount : Number = 0
  private mQPlayerTimerId : Number = 0
  private mQPlayerIsTimerStart : Boolean = false
  // @Link PlayerSettingViewModel: QPlayerSettingViewModel
  @State mMaskVisible : Visibility = Visibility.Visible
  @State @Watch("settingViewVisibleChange") mSettingViewVisible : Visibility = Visibility.Hidden
  @State @Watch("playSpeedViewVisibleChange") mPlaySpeedViewVisible : Visibility = Visibility.Hidden
  @Link @Watch("deviceOrientationChange") mDeviceOrientation : window.Orientation
  @Link mMediaModel : QPlayerDemoMediaModels
  @Link mPlayerContext : QIPlayerContext
  @Link mIsPlaying : Boolean
  @Link mIsLive : Boolean
  @State mBufferringVisible  : Visibility = Visibility.Hidden
  @State mXComponentId : string = 'qplayer2-core-renderview'
  @State mQPlayerSettingModel : QPlayerSettingModel = QSettingPersistentStorageHelper.read(AppStorage.get("context") as Context)
  private mStateCallBack : QIPlayerStateChangeListener = {
    onStateChange :(context: QIPlayerContext , state : QPlayerState)=>{
      if (state == QPlayerState.PLAYING) {
        this.mIsPlaying = true
      }
      else {
        this.mIsPlaying = false
      }
    }
  }
  private mBufferingCallBack : QIPlayerBufferingListener = {

    onBufferingStart:(context:QIPlayerContext)=>{
      this.mBufferringVisible = Visibility.Visible
    },
    onBufferingEnd:(context: QIPlayerContext)=>{
      this.mBufferringVisible = Visibility.Hidden
    }
  }
  build(){
    Row() {
      Stack() {

        QSurfaceRenderView({ mQPlayerContext: this.mPlayerContext, mXComponentId: this.mXComponentId })
          .width('100%')
          .height('100%')
        Column() {
        }
        .width('100%')
        .height('100%')
        .backgroundColor("#00000000")
        .gesture(
          TapGesture({count : 2})
            .onAction((event : GestureEvent)=>{
              this.onDoubleClick()
            })
        )
        .gesture(
          TapGesture({count : 1})
            .onAction((event : GestureEvent)=>{
              this.visibleTimerChange()
            })
        )
        .id('qplayer_render_view')

        Text("Bufferring .......")
          .width('100%')
          .height('100%')
          .textAlign(TextAlign.Center)
          .alignRules({
            left:{anchor: "__container__" , align : HorizontalAlign.Start},
            top : { anchor : "__container__" , align : VerticalAlign.Top},
          })
          .id("buffering_text")
          .visibility(this.mBufferringVisible)
          .enabled(false)
          .fontColor("#ff426ae5")
          .backgroundColor($r("app.color.hyaline_background_color"))
          .fontSize(30)
        QMaskView({
          mDeviceOrientation: this.mDeviceOrientation,
          mPlayerContext: this.mPlayerContext,
          mIsPlaying: this.mIsPlaying,
          mSettingViewVisible : this.mSettingViewVisible,
          mIsLive : this.mIsLive,
          mPlaySpeedViewVisible : this.mPlaySpeedViewVisible
        })
          .width('100%')
          .height('100%')
          .backgroundColor('#801d1d1d')
          .gesture(
            TapGesture({count : 2})
              .onAction((event : GestureEvent)=>{
                this.onDoubleClick()
              })
          )
          .gesture(
            TapGesture({count : 1})
              .onAction((event : GestureEvent)=>{
                this.visibleTimerChange()
              })
          )
          .visibility(this.mMaskVisible)
          .id('mask_view')

        RelativeContainer() {
          QMaskSettingView({mPlayerContext : this.mPlayerContext})
            .alignRules({
              top : {anchor : "__container__" , align : VerticalAlign.Top},
              right : {anchor : "__container__", align : HorizontalAlign.End}
            })
            .visibility(this.mSettingViewVisible)
            .height("100%")
            .width(340)
            .id("setting_view")
            .backgroundColor($r("app.color.setting_view_background_color"))
            .margin({
              right: 50
            })

        }
        .visibility(this.mSettingViewVisible)
        .onClick(()=>{
          this.mSettingViewVisible = Visibility.Hidden
          this.stopTimer()
        })
        .height("100%")
        .width("100%")
        .id("setting_view_relativeContainer")

        RelativeContainer() {
          QMaskPlaySpeedView({mPlayerContext : this.mPlayerContext})
            .alignRules({
              top : {anchor : "__container__" , align : VerticalAlign.Top},
              right : {anchor : "__container__", align : HorizontalAlign.End}
            })
            .visibility(this.mPlaySpeedViewVisible)
            .height("100%")
            .width(100)
            .id("play_speed_view")
            .backgroundColor($r("app.color.setting_view_background_color"))
            .margin({
              right: 50
            })
        }
        .visibility(this.mPlaySpeedViewVisible)
        .onClick(()=>{
          this.mPlaySpeedViewVisible = Visibility.Hidden
          this.stopTimer()
        })
        .height("100%")
        .width("100%")
        .id("play_speed_view_relativeContainer")
      }
    }
    .height("100%")
    .width("100%")
  }
  aboutToAppear(): void {
    this.visibleTimerChange()
    let mContext : Context = AppStorage.get('context') as Context
    this.mPlayerContext.init(mContext, getContext(this) as common.UIAbilityContext)
    this.mPlayerContext.get_control_handler().setSeekMode(this.mQPlayerSettingModel.mSeekMode)
    if (this.mQPlayerSettingModel.mBackgroundPlay == 0) {
      this.mPlayerContext.get_control_handler().setBackgroundPlayEnable(false)
    }else {
      this.mPlayerContext.get_control_handler().setBackgroundPlayEnable(true)
    }
    this.mPlayerContext.get_control_handler().addPlayerStateListener(this.mStateCallBack)
    if (this.mQPlayerSettingModel.mPlaySpeed == PlaySpeed.SPEED_0_5) {
      this.mPlayerContext.get_control_handler().setSpeed(0.5)
    }else if (this.mQPlayerSettingModel.mPlaySpeed == PlaySpeed.SPEED_0_75){
      this.mPlayerContext.get_control_handler().setSpeed(0.75)
    }else if (this.mQPlayerSettingModel.mPlaySpeed == PlaySpeed.SPEED_1_0){
      this.mPlayerContext.get_control_handler().setSpeed(1.0)
    }else if (this.mQPlayerSettingModel.mPlaySpeed == PlaySpeed.SPEED_1_25){
      this.mPlayerContext.get_control_handler().setSpeed(1.25)
    }else if (this.mQPlayerSettingModel.mPlaySpeed == PlaySpeed.SPEED_1_5){
      this.mPlayerContext.get_control_handler().setSpeed(1.5)
    }else if (this.mQPlayerSettingModel.mPlaySpeed == PlaySpeed.SPEED_2_0){
      this.mPlayerContext.get_control_handler().setSpeed(2.0)
    }
    this.mPlayerContext.get_control_handler().addPlayerBufferingChangeListener(this.mBufferingCallBack)
    this.mPlayerContext.get_control_handler().setDecoderType(this.mQPlayerSettingModel.mDecoderType)
    this.mPlayerContext.get_render_handler().setRenderRatio(this.mQPlayerSettingModel.mRenderRatio)
    this.mPlayerContext.get_render_handler().setBlindType(this.mQPlayerSettingModel.mBlinderType)
    this.mPlayerContext.get_control_handler().playMediaModel(this.mMediaModel.mMediaModels[0].mMediaModel,0)
    this.mPlayerContext.get_control_handler().setBackgroundPlayEnable(true)

  }
  settingDefault(){
  }
  deviceOrientationChange(){
    if (this.mDeviceOrientation == window.Orientation.PORTRAIT) {
      this.mSettingViewVisible = Visibility.Hidden
      this.mPlaySpeedViewVisible = Visibility.Hidden
    }
  }
  maskShowAndHide() {
    if (this.mMaskVisible === Visibility.Hidden) {
      this.mMaskVisible = Visibility.Visible
    }
    else {
      this.mMaskVisible = Visibility.Hidden
    }
  }
  settingViewVisibleChange(){
    if (this.mSettingViewVisible == Visibility.Visible) {
      this.mMaskVisible = Visibility.Hidden
    }
  }
  playSpeedViewVisibleChange(){
    if (this.mPlaySpeedViewVisible == Visibility.Visible) {
      this.mMaskVisible = Visibility.Hidden
    }
  }
  stopTimer(){
    clearInterval(this.mQPlayerTimerId.valueOf())
    this.mQPlayerTimerCount = 0
    this.mQPlayerIsTimerStart = false
    this.mMaskVisible = Visibility.Hidden
  }
  visibleTimerChange(){
    if(this.mQPlayerIsTimerStart){
      this.stopTimer()
    }else {
      this.mMaskVisible = Visibility.Visible
      this.mQPlayerIsTimerStart = true
      this.mQPlayerTimerId = setInterval(()=>{
        this.mQPlayerTimerCount = this.mQPlayerTimerCount.valueOf() + 1
        if (this.mQPlayerTimerCount.valueOf() == 10) {
          this.stopTimer()
        }
      },1000)
    }
  }
  onDoubleClick(){
    this.mQPlayerTimerCount = 0;
    if (this.mIsPlaying == true) {
      this.mPlayerContext.get_control_handler().pauseRender()
    }else {
      this.mPlayerContext.get_control_handler().resumeRender()
    }
  }
}
