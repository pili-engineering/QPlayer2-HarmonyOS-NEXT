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
  QPlayerStart,
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
import { QShortVideoDataSource } from '../../model/shortVideo/QShortVideoDataSource'
import { QNPlayItemManager } from '../../model/shortVideo/manager/QNPlayItemManager'
import { QNShortVideoPlayerContextCache } from '../../model/shortVideo/manager/QNShortVideoPlayerContextCache'
import { QUrlJsonReadWriteHelper } from '../../common/helper/QUrlJsonReadWriteHelper'
import { ArrayList } from '@kit.ArkTS'

@Entry
@Component
struct QShortVideoView {
  private mMedia : QMediaModel | null = null

  @State mPlayerContextUp : QIPlayerContext | null = null
  @State mPlayerContextDown : QIPlayerContext | null  = null
  @State mShortVideoXComponentId : string[] = ["shortVideoXComponent1","shortVideoXComponent2","shortVideoXComponent3","shortVideoXComponent4","shortVideoXComponent5"]
  @State mToastText : String = ''
  @State mToastViewWidth : Length = '70%'
  @State mToastMarginValue : number = 0
  @State mDeviceOrientation :window.Orientation = window.Orientation.PORTRAIT
  @State mShortVideoModels : QPlayerDemoShortMediaModels = new QPlayerDemoShortMediaModels(AppStorage.get("context") as Context)
  private mMediaItemContext : QIMediaItemContext | null = null
  private swiperController: SwiperController = new SwiperController()
  private mPlayItemManager : QNPlayItemManager = new QNPlayItemManager()
  private mShortVideoPlayerViewCache : QNShortVideoPlayerContextCache = new QNShortVideoPlayerContextCache(this.mPlayItemManager, (AppStorage.get("context") as Context).filesDir)

  // @State mPlayerContext1 : QIPlayerContext | null = QPlayerContextFactory.createPlayerContext(
  //   QLogLevel.LOG_INFO,
  //   (AppStorage.get("context") as Context).filesDir,
  //   bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).versionName,
  //   "")
  // @State mPlayerContext2 : QIPlayerContext | null = QPlayerContextFactory.createPlayerContext(
  //   QLogLevel.LOG_INFO,
  //   (AppStorage.get("context") as Context).filesDir,
  //   bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).versionName,
  //   "")
  @State mQShortVideoDataSource : QShortVideoDataSource = new QShortVideoDataSource([
    QPlayerContextFactory.createPlayerContext(
      QLogLevel.LOG_INFO,
      (AppStorage.get("context") as Context).filesDir,
      bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).versionName,
      ""),
    QPlayerContextFactory.createPlayerContext(
    QLogLevel.LOG_INFO,
    (AppStorage.get("context") as Context).filesDir,
    bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).versionName,
    ""),
    QPlayerContextFactory.createPlayerContext(
    QLogLevel.LOG_INFO,
    (AppStorage.get("context") as Context).filesDir,
    bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).versionName,
    "")
  ])
  private mPlayerContext : QIPlayerContext | null = this.mQShortVideoDataSource.getData(0)
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
          //   this.addToastView("播放失败")
          // }
          // this.mMediaItemContext!.get_control_handler().pause()
          break
        case QMediaItemState.PREPARE_USE:
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
      if (state == QPlayerState.PLAYING && context == this.mPlayerContext) {
        console.log(`qplayer state playing`)
      }
      if (state == QPlayerState.PAUSED_RENDER && context == this.mPlayerContext) {
        console.log(`qplayer state pause`)

      }
    }
  }
  @State mCurrentNumber : number = 0
  private mCurrentViewNumber : number = 0
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
          Swiper(this.swiperController){
            LazyForEach(this.mQShortVideoDataSource,(item: QIPlayerContext,value : number)=>{
              QSurfaceRenderView({mQPlayerContext : item, mXComponentId : this.mShortVideoXComponentId[value]})
              // Text()
              //   .backgroundColor("#ffe31e1e")
                .height("100%")
                .width("100%")
                .alignRules({
                  left:{anchor : "__container__", align : HorizontalAlign.Start},
                  bottom : {anchor : "__container__", align : VerticalAlign.Bottom}
                })
                .id("qplayer_short_video_QSurfaceRenderView")
              QShortVideoMaskView({mPlayerContext : item})
                .alignRules({
                  left:{anchor : "__container__", align : HorizontalAlign.Start},
                  bottom : {anchor : "__container__", align : VerticalAlign.Bottom}
                })
                .height("100%")
                .width("100%")
                .id("qplayer_short_video_maskView" + value.toString())
                .backgroundColor('#801d1d1d')
            })
          }
          .id("qplayer_short_video_Swiper")
          .displayCount(1, false)
          .autoPlay(false)
          .interval(4000)
          // .loop(true)
          .loop(this.mCurrentNumber != 0 && this.mPlayItemManager.count()-this.mCurrentNumber > 3)
          .duration(100)
          .itemSpace(10)
          .vertical(true)
          .indicator(false)
          .onAppear(()=>{
            this.mShortVideoPlayerViewCache.playMediaItemContextById(0,this.mQShortVideoDataSource.getData(0))
            this.mShortVideoPlayerViewCache.changePosition(0,this.mQShortVideoDataSource.getData(1),null)
          })
          .onChange((value : number)=>{
            console.log(`Swiper value : ${value} currentNumber : ${this.mCurrentNumber} loop : ${this.mCurrentNumber != 0 && this.mPlayItemManager.count()-this.mCurrentNumber > 3}`)
            let isDown : boolean = false
            if (value - this.mCurrentViewNumber == 1 || value - this.mCurrentViewNumber <= -2){
              isDown = true
              if (this.mPlayItemManager.count() == this.mCurrentNumber) {
                return
              }
              this.mCurrentNumber ++
            }else {
              if (this.mCurrentNumber == 0) {
                return
              }
              this.mCurrentNumber --
            }
            this.mCurrentViewNumber = value
            // this.mShortVideoPlayerViewCache.recyclePlayerContext(this.mPlayerContext)
            // this.mPlayerContext = this.mShortVideoPlayerViewCache.fetchPlayerContext(value)!
            // this.mPlayerContext.get_control_handler().resumeRender()
            // if (!isDown) {
            //   this.mQShortVideoDataSource.getData((value+1)%this.mQShortVideoDataSource.totalCount())?.get_control_handler().stop()
            // }else {
            //   this.mQShortVideoDataSource.getData((value-1)%this.mQShortVideoDataSource.totalCount())?.get_control_handler().stop()
            // }

            this.mPlayerContext = this.mQShortVideoDataSource.getData(value)
            this.mQShortVideoDataSource.getData((value - 1)%this.mQShortVideoDataSource.totalCount())?.get_control_handler().removePlayerStateListener(this.mQPlayerStateListener)
            this.mQShortVideoDataSource.getData((value + 1)%this.mQShortVideoDataSource.totalCount())?.get_control_handler().removePlayerStateListener(this.mQPlayerStateListener)
            this.mQShortVideoDataSource.getData(value)?.get_control_handler().addPlayerStateListener(this.mQPlayerStateListener)
            this.mShortVideoPlayerViewCache.changePosition(this.mCurrentNumber,this.mQShortVideoDataSource.getData((value + 1)%this.mQShortVideoDataSource.totalCount()),this.mQShortVideoDataSource.getData((value - 1)%this.mQShortVideoDataSource.totalCount()))

            console.log(`qplayer resume`)
            this.mQShortVideoDataSource.getData(value)?.get_control_handler().resumeRender()
        })
          .height("100%")
          .width("100%")
          // Row({ space: 12 }) {
          //   Button('showNext')
          //     .onClick(() => {
          //       this.swiperController.showNext()
          //     })
          //   Button('showPrevious')
          //     .onClick(() => {
          //       this.swiperController.showPrevious()
          //     })
          // }.margin(5)
          // QShortVideoMaskView({mPlayerContext : this.mPlayerContext})
          //   .alignRules({
          //     left:{anchor : "__container__", align : HorizontalAlign.Start},
          //     bottom : {anchor : "__container__", align : VerticalAlign.Bottom}
          //   })
          //   .height("100%")
          //   .width("100%")
          //   .id("qplayer_short_video_maskView")
          //   .backgroundColor('#801d1d1d')

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

    // this.mShortVideoPlayerViewCache.start()
    // this.mPlayerContext?.init(AppStorage.get("context") as Context, getContext(this) as common.UIAbilityContext)
    // this.mPlayerContext1?.init(AppStorage.get("context") as Context, getContext(this) as common.UIAbilityContext)
    // this.mPlayerContext2?.init(AppStorage.get("context") as Context, getContext(this) as common.UIAbilityContext)
    // this.mPlayerContext?.get_control_handler().setStartAction(QPlayerStart.PAUSE)
    // this.mPlayerContext1?.get_control_handler().setStartAction(QPlayerStart.PAUSE)
    // this.mPlayerContext2?.get_control_handler().setStartAction(QPlayerStart.PAUSE)
    // let mediaBuilder : QMediaModelBuilder = new QMediaModelBuilder()
    // mediaBuilder.addStreamElement("",QPlayerUrlType.QAUDIO_AND_VIDEO,1080,"http://demovideos.qiniushawn.top/shortvideo/喷泉.mp4",true,"","")
    // let media : QMediaModel = mediaBuilder.build(false)
    // this.mPlayerContext?.get_control_handler().playMediaModel(media,0)
    // this.mPlayerContext1?.get_control_handler().playMediaModel(media,0)
    // this.mPlayerContext2?.get_control_handler().playMediaModel(media,0)
    // let mediaItemContext : QIMediaItemContext = QPlayerContextFactory.createMediaItemContext(AppStorage.get("context") as Context, this.mShortVideoModels.mMediaModels[0].mMediaModel, 0,QLogLevel.LOG_INFO, (AppStorage.get("context") as Context).filesDir)
    // this.mMediaItemContext = mediaItemContext
    // mediaItemContext.get_control_handler().addMediaItemStateListener(this.mMediaItemStateListener)
    // mediaItemContext.get_control_handler().addMediaItemCommandNotAllowListener(this.mMediaItemCommandNotAllowListener)
    // mediaItemContext.get_control_handler().start()
    // this.mPlayerContext.get_control_handler().addPlayerStateListener(this.mQPlayerStateListener)
    // this.mPlayerContext.get_control_handler().resumeRender()
  }
  onBackPress(): boolean | void {
    this.mPlayerContext?.get_control_handler().release()
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