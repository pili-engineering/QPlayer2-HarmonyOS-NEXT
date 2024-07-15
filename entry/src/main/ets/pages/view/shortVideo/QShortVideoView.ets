import {
  QIMediaItemCommandNotAllowListener,
  QIMediaItemContext,
  QIMediaItemStateChangeListener,
  QIPlayerContext,
  QIPlayerStateChangeListener,
  QLogLevel,
  QMediaItemState,
  QMediaModel, QMediaModelBuilder,
  QPlayerContextFactory,
  QPlayerUrlType,
  QSurfaceRenderView} from '@qiniu/qplayer2-core'
import { bundleManager, common } from '@kit.AbilityKit'
import { router, window } from '@kit.ArkUI'
import { QPlayerToastView } from '../../common/component/QPlayerToastView'
import { QPlayerState } from '@qiniu/qplayer2-core/src/main/ets/public/enums/QPlayerState'
import { QShortVideoMaskView } from './QShortVideoMaskView'
import { QTitleView } from '../../common/component/QTitleView'
import { QPlayerDemoMediaModels } from '../../model/longVideo/QPlayerDemoMediaModel'
import { Context } from '@ohos.arkui.UIContext'
import { QPlayerDemoShortMediaModels } from '../../model/shortVideo/QPlayerDemoShortMediaModel'

@Entry
@Component
struct QShortVideoView {
  private mMedia : QMediaModel | null = null
  @State mPlayerContext : QIPlayerContext = QPlayerContextFactory.createPlayerContext(
    QLogLevel.LOG_INFO,
    (AppStorage.get("context") as Context).filesDir,
    bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).versionName,
    "")
  @State mShortVideoXComponentId : string = "shortVideoXComponent"
  @State mToastText : String = ''
  @State mToastViewWidth : Length = '70%'
  @State mToastMarginValue : number = 0
  @State mDeviceOrientation :window.Orientation = window.Orientation.PORTRAIT
  @State mShortVideoModels : QPlayerDemoShortMediaModels = new QPlayerDemoShortMediaModels(AppStorage.get("context") as Context)
  private mMediaItemContext : QIMediaItemContext | null = null
  private mMediaItemCommandNotAllowListener : QIMediaItemCommandNotAllowListener = {

    onCommandNotAllow:(context :QIMediaItemContext ,commandName : string, state:QMediaItemState)=>{
      this.addToastView(commandName + " : " + this.mediaStateToString(state))
    }
  }
  private mMediaItemStateListener : QIMediaItemStateChangeListener = {
    onStateChanged:(context :QIMediaItemContext , state: QMediaItemState)=>{

      this.addToastView(this.mediaStateToString(state))
      switch (state){
        case QMediaItemState.LOADING:
          // let issuccess = this.mPlayerContext.get_control_handler().playMediaItem(this.mMediaItemContext!)
          // if (issuccess) {
          //   this.addToastView("播放成功")
          // }else {
            this.addToastView("播放失败")
          // }
          // this.mMediaItemContext!.get_control_handler().pause()
          break
        case QMediaItemState.PAUSED:
          // this.mMediaItemContext!.get_control_handler().stop()
          break
        default :
          break
      }
    }
  }
  private mQPlayerStateListener : QIPlayerStateChangeListener ={
    onStateChange:(context : QIPlayerContext ,state: QPlayerState)=>{
      if (state == QPlayerState.RELEASE) {
        router.back()
      }
    }
  }
  build() {
    Column(){

      Row() {
        QTitleView({ titleString: '短视频' })
          .width("100%")
          .height("100%")
          .id("title_view")
          .onClick(()=>{
            this.addToastView("测试")
          })
      }
      .justifyContent(FlexAlign.Center)
      .width("100%")
      .height($r("app.float.long_video_title_view_height"))
      .alignRules({
        top: { anchor: "__container__", align: VerticalAlign.Top },
        left: { anchor: "__container__", align: HorizontalAlign.Start }
      })
      .id("title_view_row")

      Stack(){
        RelativeContainer(){

          QSurfaceRenderView({mQPlayerContext: this.mPlayerContext, mXComponentId : this.mShortVideoXComponentId})
            .height("100%")
            .width("100%")
            .alignRules({
              left:{anchor : "__container__", align : HorizontalAlign.Start},
              bottom : {anchor : "__container__", align : VerticalAlign.Bottom}
            })
            .id("qplayer_short_video_QSurfaceRenderView")
          QShortVideoMaskView()
            .alignRules({
              left:{anchor : "__container__", align : HorizontalAlign.Start},
              bottom : {anchor : "__container__", align : VerticalAlign.Bottom}
            })
            .height("100%")
            .width("100%")
            .id("qplayer_short_video_maskView")
            .backgroundColor('#801d1d1d')

          QPlayerToastView({mToastText : this.mToastText, mDeviceOrientation : this.mDeviceOrientation})
            .backgroundColor($r('app.color.hyaline_background_color'))
            .width(this.mToastViewWidth)
            .height('70%')
            .alignRules({
              left:{anchor : "__container__", align : HorizontalAlign.Start},
              bottom : {anchor : "__container__", align : VerticalAlign.Bottom}
            })
            .margin({
              left: 5,
              bottom : this.mToastMarginValue
            })
            .id("qplayer_toast_view")
            .enabled(false)
        }
      }
      .width("100%")
      .height("95%")
      .backgroundColor("#ff000000")
    }
    .width("100%")
    .height("100%")
    .backgroundColor("#ff000000")
  }
  aboutToAppear(): void {
    this.mPlayerContext.init(AppStorage.get("context") as Context, getContext(this) as common.UIAbilityContext)
    let builder : QMediaModelBuilder = new QMediaModelBuilder()
    builder.addStreamElement("",QPlayerUrlType.QAUDIO_AND_VIDEO,1080,"http://demovideos.qiniushawn.top/qiniu-2023-1080p.mp4",true,"","")
    this.mMedia = builder.build(false)

    let mediaItemContext : QIMediaItemContext = QPlayerContextFactory.createMediaItemContext(AppStorage.get("context") as Context, this.mShortVideoModels.mMediaModels[0].mMediaModel, 0,QLogLevel.LOG_INFO, (AppStorage.get("context") as Context).filesDir)
    this.mMediaItemContext = mediaItemContext
    mediaItemContext.get_control_handler().addMediaItemStateListener(this.mMediaItemStateListener)
    mediaItemContext.get_control_handler().addMediaItemCommandNotAllowListener(this.mMediaItemCommandNotAllowListener)
    mediaItemContext.get_control_handler().start()

    this.mPlayerContext.get_control_handler().playMediaItem(this.mMediaItemContext!)
    this.mPlayerContext.get_control_handler().addPlayerStateListener(this.mQPlayerStateListener)
  }
  onBackPress(): boolean | void {
    this.mPlayerContext.get_control_handler().release()
    return true
  }
  addToastView(text:String){
    this.mToastText = text
    this.mToastText = ""
  }
  mediaStateToString(state : QMediaItemState){
    switch (state){
      case QMediaItemState.PREPARE:
        return "PREPARE"
      case QMediaItemState.LOADING:
        return "LOADING"
      case QMediaItemState.PAUSED:
        return "PAUSED"
      case QMediaItemState.STOPED:
        return "STOPED"
      case QMediaItemState.ERROR:
        return "ERROR"
      case QMediaItemState.PREPARE_USE:
        return "PREPARE_USE"
      case QMediaItemState.USED:
        return "USED"
      case QMediaItemState.DISCARD:
        return "DISCARD"
      default :
        return "NONE"

    }
  }
}