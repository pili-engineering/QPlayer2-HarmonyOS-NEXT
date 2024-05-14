import { QPlayerDecodeType } from '../../common/enum/QPlayerDecodeType'
import { QMaskView } from './QMaskView'
import { window } from '@kit.ArkUI'
import {QSurfaceRenderView,QIPlayerContext,
  QPlayerContextFactory,
  QLogLevel,
  QPlayerSeek,
  QIPlayerStateChangeListener
} from '@QN/QPlayer2-core/qplayer2-core'
import { QPlayerDemoMediaModels } from '../../model/longVideo/QPlayerDemoMediaModel'
import { QMaskSettingView } from './QMaskSettingView'
import { QPlayerState } from '@QN/QPlayer2-core/src/main/ets/public/enums/QPlayerState'

@Component
export struct QPlayerView{
  private mQPlayerTimerCount : Number = 0
  private mQPlayerTimerId : Number = 0
  private mQPlayerIsTimerStart : Boolean = false
  // @Link PlayerSettingViewModel: QPlayerSettingViewModel
  @State mMaskVisible : Visibility = Visibility.Visible
  @State @Watch("settingViewVisibleChange") mSettingViewVisible : Visibility = Visibility.Hidden
  @Link @Watch("deviceOrientationChange") mDeviceOrientation : window.Orientation
  @Link mMediaModel : QPlayerDemoMediaModels
  @Link mPlayerContext : QIPlayerContext
  @Link mIsPlaying : Boolean
  @State mXComponentId : string = 'qplayer2-core-renderview'
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

        QMaskView({
          mDeviceOrientation: this.mDeviceOrientation,
          mPlayerContext: this.mPlayerContext,
          mIsPlaying: this.mIsPlaying,
          mSettingViewVisible : this.mSettingViewVisible
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
          QMaskSettingView()
            .alignRules({
              top : {anchor : "__container__" , align : VerticalAlign.Top},
              right : {anchor : "__container__", align : HorizontalAlign.End}
            })
            .visibility(this.mSettingViewVisible)
            .height("100%")
            .width(300)
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
      }
    }
    .height("100%")
    .width("100%")
  }
  aboutToAppear(): void {
    this.visibleTimerChange()
    let mContext : Context = AppStorage.get('context') as Context
    this.mPlayerContext.init(mContext)
    this.mPlayerContext.get_control_handler().setSeekMode(QPlayerSeek.NORMAL)
    this.mPlayerContext.get_control_handler().addPlayerStateListener(this.mStateCallBack)
    this.mPlayerContext.get_control_handler().playMediaModel(this.mMediaModel.mMediaModels[0].mMediaModel,0)

  }
  settingDefault(){
  }
  deviceOrientationChange(){
    if (this.mDeviceOrientation == window.Orientation.PORTRAIT) {
      this.mSettingViewVisible = Visibility.Hidden
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
