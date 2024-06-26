import { QTitleView } from "../../common/component/QTitleView"
import { QPlayerView } from './QPlayerView'
import { mediaquery, window } from '@kit.ArkUI'
import  { QPlayerStatusView } from  "./QPlayerStatusView"
import { QPlayerUrlListView } from './QPlayerUrlListView'
import { QPlayerToastView } from './QPlayerToastView'
import { QPlayerSettingModel } from '../../model/longVideo/QPlayerSettingModel'
import { QPlayerDemoMediaModels } from '../../model/longVideo/QPlayerDemoMediaModel'
import { QSettingPersistentStorageHelper } from '../../common/helper/QSettingPersistentStorageHelper'
import { bundleManager, common, Context } from '@kit.AbilityKit'
import { QPlayerContextFactory, QIPlayerContext, QLogLevel,
  QIPlayerAuthenticationListener,
  QPlayerAuthenticationErrorType,
  QIPlayerBiteRateListener,
  QIPlayerBufferingListener,
  QIPlayerCommandNotAllowListener,
  QIPlayerFormatListener,
  QIPlayerMediaNetworkListener,
  QPlayerOpenError,
  QPlayerUrlType,
  QIPlayerSeekListener} from '@qiniu/qplayer2-core/qplayer2-core'
import { QPlayerState } from '@qiniu/qplayer2-core/src/main/ets/public/enums/QPlayerState'


@Entry
@Component
struct QLongVideoView {
  @State mQPlayerSetting : QPlayerSettingModel = QSettingPersistentStorageHelper.read(AppStorage.get('context') as Context)
  @State mMediaModel : QPlayerDemoMediaModels = new QPlayerDemoMediaModels(AppStorage.get('context') as Context)
  @State mQPlayerViewWidth : Length = '100%'
  @State mQPlayerViewHeight : Length = '30%'
  @State mQPlayerViewFrameBottom : String = "qplayer_status_view"
  @State mQPlayerViewFrameTop : String = "title_view_row"
  @State mQPlayerViewFrameBottomAlign : VerticalAlign = VerticalAlign.Top
  @State mQPlayerViewFrameTopAlign : VerticalAlign = VerticalAlign.Bottom
  @State mPortraitShow : Visibility = Visibility.Visible
  @State @Watch('rotateScreen') mDeviceOrientation :window.Orientation = window.Orientation.PORTRAIT
  @State mToastText : String = ''
  @State mIsPlaying : Boolean = false
  @State mIsLive : Boolean = false
  @State mPlayerContext : QIPlayerContext = QPlayerContextFactory.createPlayerContext(
    QLogLevel.LOG_INFO,
    (AppStorage.get("context") as Context).filesDir,
    bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).versionName,
    "")

  private mAuthenticationListener : QIPlayerAuthenticationListener = {
    onAuthenticationFailed:(context: QIPlayerContext, error:QPlayerAuthenticationErrorType)=>{
      this.addToastView(`鉴权失败：${error.valueOf()}`)
    },

    onAuthenticationSuccess:(context: QIPlayerContext)=>{
      this.addToastView("鉴权成功")
    }
  }
  private mBiteRateListener : QIPlayerBiteRateListener = {
    onBiteRateChanged:(context:QIPlayerContext, bitrate:number)=>{}
  }
  private mBufferingListener : QIPlayerBufferingListener = {
    onBufferingStart:(context:QIPlayerContext)=>{
      this.addToastView("start buffer")
    },

    onBufferingEnd:(context: QIPlayerContext)=>{
      this.addToastView("end buffer")}
  }
  private mCommandNotAllowListener : QIPlayerCommandNotAllowListener = {
    onCommandNotAllow:(context:QIPlayerContext, commandName:string, state:QPlayerState)=>{}
  }
  private mFormatListener : QIPlayerFormatListener = {
    onFormatNotSupport:(context:QIPlayerContext)=>{
      this.addToastView("onFormatNotSupport")
    }
  }

  private mMediaNetworkListener : QIPlayerMediaNetworkListener = {
    onReconnectStart:(context : QIPlayerContext , userType: string , urlType: QPlayerUrlType , url: string , retryTime: number ) => {
      this.addToastView(`开始重连 : ${retryTime}`)
    },

    onReconnectEnd:(context : QIPlayerContext , userType: string , urlType: QPlayerUrlType , url: string , retryTime: number , error: QPlayerOpenError ) => {
      this.addToastView(`重连结束 : ${retryTime}`)
    },

    onOpenFailed:(context : QIPlayerContext , userType: string , urlType: QPlayerUrlType , url: string , error: QPlayerOpenError ) => {
      this.addToastView(`openFailed`)
    }

  }

  private mSeekListener : QIPlayerSeekListener = {
    onSeekSuccess:(context : QIPlayerContext) => {
      this.addToastView(`seek 成功`)
    },

    onSeekFailed:(context : QIPlayerContext) => {
      this.addToastView(`seek 失败`)
    }
  }


  build() {
    Column() {
      RelativeContainer() {
        Row() {
          QTitleView({ titleString: '长视频' })
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
        .visibility(this.mPortraitShow)

        //播放器视图
        QPlayerView({
          mDeviceOrientation: this.mDeviceOrientation,
          mMediaModel : this.mMediaModel,
          mPlayerContext : this.mPlayerContext,
          mIsPlaying : this.mIsPlaying,
          mIsLive : this.mIsLive
        })
          .alignRules({
            left: { anchor: "__container__", align: HorizontalAlign.Start },
            top: { anchor: this.mQPlayerViewFrameTop.toString(), align: this.mQPlayerViewFrameTopAlign },
            bottom: { anchor: this.mQPlayerViewFrameBottom.toString(), align: this.mQPlayerViewFrameBottomAlign },
          })
          .backgroundColor($r('app.color.long_video_player_view_background_color'))
          .width(this.mQPlayerViewWidth)// .height(this.mQPlayerViewHeight)
          .id("qplayer_view")

        QPlayerStatusView({mPlayerContext : this.mPlayerContext})
          .backgroundColor($r('app.color.long_video_status_view_background_color'))
          .width('100%')
          .height('20%')
          .alignRules({
            left: { anchor: "__container__", align: HorizontalAlign.Start },
            bottom: { anchor: "qplayer_url_list_view", align: VerticalAlign.Top }
          })
          .id("qplayer_status_view")
          .visibility(this.mPortraitShow)

          QPlayerUrlListView({
            mMediaModel : this.mMediaModel,
            mPlayerContext : this.mPlayerContext,
            mIsPlaying : this.mIsPlaying,
            mIsLive : this.mIsLive
          })
            .backgroundColor($r('app.color.long_video_url_list_view_background_color'))
            .width('100%')
            .height('40%')
            .alignRules({
              left: { anchor: "__container__", align: HorizontalAlign.Start },
              bottom: { anchor: "__container__", align: VerticalAlign.Bottom }
            })
            .id("qplayer_url_list_view")
            .visibility(this.mPortraitShow)

          QPlayerToastView({mToastText : this.mToastText, mDeviceOrientation : this.mDeviceOrientation})
            .backgroundColor($r('app.color.hyaline_background_color'))
            .width('70%')
            .height('70%')
            .alignRules({
              left:{anchor : "__container__", align : HorizontalAlign.Start},
              bottom : {anchor : "__container__", align : VerticalAlign.Bottom}
            })
            .margin({
              left: 5
            })
            .id("qplayer_toast_view")
            .enabled(false)
      }
    }
    .justifyContent(FlexAlign.Center)
  }
  private  listener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync('(orientation: landscape)');
  onPortrait(mediaQueryResult: mediaquery.MediaQueryResult) {
    if (mediaQueryResult.matches as boolean) {
      this.mDeviceOrientation = window.Orientation.LANDSCAPE
    } else {
      this.mDeviceOrientation = window.Orientation.PORTRAIT
    }
  }

  aboutToAppear(): void {
    this.listener.on('change', (mediaQueryResult:mediaquery.MediaQueryResult) => { this.onPortrait(mediaQueryResult) });
    this.addAllQPlayerListeners()
  }
  aboutToDisappear(): void {
    let windowStage : window.WindowStage = AppStorage.get("windowStage") as window.WindowStage

    try {
      windowStage.getMainWindowSync().setWindowBackgroundColor("#ffffffff")
    }catch (error){
      return
    }

    if (this.mDeviceOrientation == window.Orientation.PORTRAIT){
      return
    }
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
  rotateScreen(name:String){
    console.info(`mDeviceOrientation: ${this.mDeviceOrientation}`)
    let windowStage : window.WindowStage = AppStorage.get("windowStage") as window.WindowStage
    //横屏
    if (this.mDeviceOrientation == window.Orientation.LANDSCAPE) {
      this.mQPlayerViewWidth = '100%'
      this.mQPlayerViewHeight = '30%'
      this.mPortraitShow = Visibility.Hidden
      this.mQPlayerViewFrameBottom = "__container__"
      this.mQPlayerViewFrameBottomAlign = VerticalAlign.Bottom
      this.mQPlayerViewFrameTop = "__container__"
      this.mQPlayerViewFrameTopAlign = VerticalAlign.Top
      windowStage.getMainWindowSync().setWindowBackgroundColor("#ff000000")

    }
    //竖屏
    else if (this.mDeviceOrientation == window.Orientation.PORTRAIT) {
      this.mQPlayerViewWidth = '100%'
      this.mQPlayerViewHeight = '100%'
      this.mPortraitShow = Visibility.Visible
      this.mQPlayerViewFrameBottom = "qplayer_status_view"
      this.mQPlayerViewFrameBottomAlign = VerticalAlign.Top
      this.mQPlayerViewFrameTop = "title_view_row"
      this.mQPlayerViewFrameTopAlign = VerticalAlign.Bottom
      windowStage.getMainWindowSync().setWindowBackgroundColor("#ffffffff")
    }
  }

  addAllQPlayerListeners(){
    this.mPlayerContext.get_control_handler().addPlayerMediaNetworkListener(this.mMediaNetworkListener)
    this.mPlayerContext.get_control_handler().addPlayerBufferingChangeListener(this.mBufferingListener)
    this.mPlayerContext.get_control_handler().addPlayerBiteRateChangeListener(this.mBiteRateListener)
    this.mPlayerContext.get_control_handler().addPlayerCommandNotAllowListener(this.mCommandNotAllowListener)
    this.mPlayerContext.get_control_handler().addPlayerAuthenticationListener(this.mAuthenticationListener)
    this.mPlayerContext.get_control_handler().addPlayerFormatListener(this.mFormatListener)
    this.mPlayerContext.get_control_handler().addPlayerSeekListener(this.mSeekListener)
  }
  //弹出toast，文本为text
  addToastView(text:String){
    this.mToastText = text
    this.mToastText = ""
  }
  onBackPress(): boolean | void {
    this.mPlayerContext.get_control_handler().release()
    return true
  }
}

