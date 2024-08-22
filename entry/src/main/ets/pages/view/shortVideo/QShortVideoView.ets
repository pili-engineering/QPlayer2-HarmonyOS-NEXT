import {
  QIMediaItemCommandNotAllowListener,
  QIMediaItemContext,
  QIMediaItemStateChangeListener,
  QIPlayerContext,
  QIPlayerRenderListener,
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
import { Context } from '@ohos.arkui.UIContext'
import { QShortVideoDataSource } from '../../model/shortVideo/QShortVideoDataSource'
import { QNPlayItemManager } from '../../model/shortVideo/manager/QNPlayItemManager'
import { QNShortVideoPlayerContextCache } from '../../model/shortVideo/manager/QNShortVideoPlayerContextCache'
import { ArrayList } from '@kit.ArkTS'

@Entry
@Component
struct QShortVideoView {

  @State mPlayerContextUp : QIPlayerContext | null = null
  @State mPlayerContextDown : QIPlayerContext | null  = null
  @State mShortVideoXComponentId : string[] = ["shortVideoXComponent1","shortVideoXComponent2","shortVideoXComponent3","shortVideoXComponent4","shortVideoXComponent5"]
  @State mToastText : String = ''
  @State mToastViewWidth : Length = '70%'
  @State mToastMarginValue : number = 0
  @State mSwiperUp : boolean = false
  @State mDeviceOrientation :window.Orientation = window.Orientation.PORTRAIT
  private swiperController: SwiperController = new SwiperController()
  private mPlayItemManager : QNPlayItemManager = new QNPlayItemManager()
  private mCoverImage : ArrayList<ResourceStr> = new ArrayList<ResourceStr>()
  @State mShowCoverImage : ArrayList<ResourceStr> = new ArrayList<ResourceStr>()
  @State mShowCoverImageVisible : ArrayList<Visibility> = new ArrayList<Visibility>()
  private mShortVideoPlayerViewCache : QNShortVideoPlayerContextCache = new QNShortVideoPlayerContextCache(this.mPlayItemManager, (AppStorage.get("context") as Context).filesDir)
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
          break
        case QMediaItemState.PREPARE_USE:
          break
        case QMediaItemState.PAUSED:
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
  private mQPlayerRenderListener : QIPlayerRenderListener ={
    onFirstFrameRendered:(context : QIPlayerContext, elapsedTime:number) => {
      if (context == this.mQShortVideoDataSource.getData(this.mCurrentViewNumber)) {
        this.mShowCoverImageVisible[(this.mCurrentNumber) % this.mQShortVideoDataSource.totalCount()] = Visibility.Hidden
      }else {

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
                .height("100%")
                .width("100%")
                .alignRules({
                  left:{anchor : "__container__", align : HorizontalAlign.Start},
                  bottom : {anchor : "__container__", align : VerticalAlign.Bottom}
                })
                .id("qplayer_short_video_QSurfaceRenderView")
              Image(this.mShowCoverImage[value])
                .height("100%")
                .width("100%")
                .alignRules({
                  left:{anchor : "__container__", align : HorizontalAlign.Start},
                  bottom : {anchor : "__container__", align : VerticalAlign.Bottom}
                })
                .margin({top : 8})
                .objectFit(ImageFit.Auto)
                .visibility(this.mShowCoverImageVisible[value])
                .id("qplayer_short_video_image")
              QShortVideoMaskView({mPlayerContext : item})
                .alignRules({
                  left:{anchor : "__container__", align : HorizontalAlign.Start},
                  bottom : {anchor : "__container__", align : VerticalAlign.Bottom}
                })
                .height("100%")
                .width("100%")
                .id("qplayer_short_video_maskView" + value.toString())
                .backgroundColor('#00ffffff')
            })
          }
          .id("qplayer_short_video_Swiper")
          .displayCount(1, false)
          .autoPlay(false)
          .interval(4000)
          // .loop(true)
          // .loop(this.mCurrentNumber != 0 && (this.mPlayItemManager.count()-this.mCurrentNumber > 3 || this.mSwiperUp))

          .loop(this.mCurrentNumber != 0 && this.mPlayItemManager.count()-1 != this.mCurrentNumber)
          .duration(100)
          .itemSpace(10)
          .vertical(true)
          .indicator(false)
          .onAppear(()=>{
            this.mShortVideoPlayerViewCache.playMediaItemContextById(0,this.mQShortVideoDataSource.getData(0))
            this.mShortVideoPlayerViewCache.changePosition(0,this.mQShortVideoDataSource.getData(1),null)
            this.mQShortVideoDataSource.getData(0)?.get_render_handler().addPlayerRenderListener(this.mQPlayerRenderListener)
            this.mQShortVideoDataSource.getData(0)?.get_control_handler().addPlayerStateListener(this.mQPlayerStateListener)
          })
          .onChange((value : number)=>{
            console.log(`Swiper value : ${value} currentNumber : ${this.mCurrentNumber} loop : ${this.mCurrentNumber != 0 && this.mPlayItemManager.count()-this.mCurrentNumber > 3}`)
            if (value - this.mCurrentViewNumber == 2 && this.mCurrentViewNumber == 6){

            }
            else if (value - this.mCurrentViewNumber == 1 || value - this.mCurrentViewNumber <= -2){

              if (this.mPlayItemManager.count() <= this.mCurrentNumber) {
                return
              }
              this.mSwiperUp = false
              this.mCurrentNumber ++
            }else {
              if (this.mCurrentNumber == 0) {
                return
              }
              this.mSwiperUp = true
              this.mCurrentNumber --
            }
            this.mCurrentViewNumber = value
            if (this.mCurrentNumber-1 >= 0) {
              this.mShowCoverImage[(this.mCurrentNumber-1) % this.mQShortVideoDataSource.totalCount()] = this.mCoverImage[this.mCurrentNumber-1]
            }
            if (this.mCurrentNumber+1 < this.mCoverImage.length) {
              this.mShowCoverImage[(this.mCurrentNumber+1) % this.mQShortVideoDataSource.totalCount()] = this.mCoverImage[this.mCurrentNumber + 1]
            }
            this.mShowCoverImage[(this.mCurrentNumber) % this.mQShortVideoDataSource.totalCount()] = this.mCoverImage[this.mCurrentNumber]

            for (let index = 0; index < this.mShowCoverImageVisible.length; index++) {
              this.mShowCoverImageVisible[index] = Visibility.Visible;
            }
            this.mPlayerContext = this.mQShortVideoDataSource.getData(this.mCurrentNumber%this.mQShortVideoDataSource.totalCount())
            this.mQShortVideoDataSource.getData((this.mCurrentNumber - 1)%this.mQShortVideoDataSource.totalCount())?.get_control_handler().removePlayerStateListener(this.mQPlayerStateListener)
            this.mQShortVideoDataSource.getData((this.mCurrentNumber + 1)%this.mQShortVideoDataSource.totalCount())?.get_control_handler().removePlayerStateListener(this.mQPlayerStateListener)
            this.mQShortVideoDataSource.getData((this.mCurrentNumber + 1)%this.mQShortVideoDataSource.totalCount())?.get_render_handler().addPlayerRenderListener(this.mQPlayerRenderListener)
            this.mQShortVideoDataSource.getData((this.mCurrentNumber + 1)%this.mQShortVideoDataSource.totalCount())?.get_render_handler().addPlayerRenderListener(this.mQPlayerRenderListener)
            this.mQShortVideoDataSource.getData(this.mCurrentNumber%this.mQShortVideoDataSource.totalCount())?.get_control_handler().addPlayerStateListener(this.mQPlayerStateListener)
            this.mQShortVideoDataSource.getData(this.mCurrentNumber%this.mQShortVideoDataSource.totalCount())?.get_render_handler().addPlayerRenderListener(this.mQPlayerRenderListener)
            this.mShortVideoPlayerViewCache.changePosition(this.mCurrentNumber,this.mQShortVideoDataSource.getData((this.mCurrentNumber + 1)%this.mQShortVideoDataSource.totalCount()),this.mQShortVideoDataSource.getData((this.mCurrentNumber - 1)%this.mQShortVideoDataSource.totalCount()))
            this.mQShortVideoDataSource.getData(this.mCurrentNumber%this.mQShortVideoDataSource.totalCount())?.get_control_handler().resumeRender()
        })
          .height("100%")
          .width("100%")

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
    for (let index = 0 ; index < this.mPlayItemManager.count() ; index ++){
      this.mCoverImage.add($r(`app.media.${this.mPlayItemManager.getOrNullById(index)?.mCoverUrl}`))
    }
    this.mShowCoverImage.add(this.mCoverImage[0])
    this.mShowCoverImage.add(this.mCoverImage[1])
    this.mShowCoverImage.add(this.mCoverImage[2])

    this.mShowCoverImageVisible.add(Visibility.Visible)
    this.mShowCoverImageVisible.add(Visibility.Visible)
    this.mShowCoverImageVisible.add(Visibility.Visible)
  }
  onBackPress(): boolean | void {
    this.mShortVideoPlayerViewCache.stop()
    for (let index = 0; index < this.mQShortVideoDataSource.totalCount(); index++) {
      this.mQShortVideoDataSource.getData(index)?.get_control_handler().release();
    }
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