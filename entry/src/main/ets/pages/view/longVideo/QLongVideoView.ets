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
  QIPlayerAudioDataListener,
  QSampleFormat,
  QChannelLayout,
  QIPlayerAudioListener,
  QIPlayerAuthenticationListener,
  QPlayerAuthenticationErrorType,
  QIPlayerBiteRateListener,
  QIPlayerBufferingListener,
  QIPlayerCommandNotAllowListener,
  QIPlayerFormatListener,
  QIPlayerMediaNetworkListener,
  QPlayerOpenError,
  QPlayerUrlType,
  QIPlayerQualityListener,
  QIPlayerSeekListener,
  QIPlayerSEIDataListener,
  QPlayerShootVideoType,
  QIPlayerSpeedListener,
  QIPlayerShootVideoListener,
  QIPlayerSubtitleListener,
  QIPlayerVideoDataListener,
  QIPlayerVideoDecodeListener,
  QIPlayerVideoFrameSizeChangeListener} from '@QN/QPlayer2-core/qplayer2-core'
import { QPlayerState } from '@QN/QPlayer2-core/src/main/ets/public/enums/QPlayerState'
import { QVideoType } from '@QN/QPlayer2-core/src/main/ets/public/listeners/QIPlayerVideoDataListener'
import { QPlayerDecoderType } from '@QN/QPlayer2-core/src/main/ets/public/enums/QPlayerDecoderType'


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
  private mAudioDataListener : QIPlayerAudioDataListener = {
    onAudioData:(context : QIPlayerContext, sampleRate: number, format:QSampleFormat, channelNum: number, channelLayout: QChannelLayout, data:Uint8Array)=>{}
  }
  private mAudioListener : QIPlayerAudioListener = {
    onMuteChanged:(context :QIPlayerContext , isMute:boolean)=>{
      if (isMute) {
        this.addToastView("开启静音")
      }
      else {
        this.addToastView("关闭静音")
      }
    }
  }
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
    onBufferingStart:(context:QIPlayerContext)=>{},

    onBufferingEnd:(context: QIPlayerContext)=>{}
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
  private mQualityListener : QIPlayerQualityListener = {
    onQualitySwitchStart:(context : QIPlayerContext , usertype: string , urlType: QPlayerUrlType , oldQuality: number , newQuality: number ) => {},

    onQualitySwitchComplete:(context : QIPlayerContext , usertype: string , urlType: QPlayerUrlType , oldQuality: number , newQuality: number ) => {},

    onQualitySwitchCanceled:(context : QIPlayerContext , usertype: string , urlType: QPlayerUrlType , oldQuality: number , newQuality: number ) => {},

    onQualitySwitchFailed:(context : QIPlayerContext , usertype: string , urlType: QPlayerUrlType , oldQuality: number , newQuality: number ) => {},

    onQualitySwitchRetryLater:(context : QIPlayerContext ,  usertype: string , urlType: QPlayerUrlType ) => {}

  }
  private mSeekListener : QIPlayerSeekListener = {
    onSeekSuccess:(context : QIPlayerContext) => {
      this.addToastView(`seek 成功`)
    },

    onSeekFailed:(context : QIPlayerContext) => {
      this.addToastView(`seek 失败`)
    }
  }
  private mSEIDataListener : QIPlayerSEIDataListener = {
    onSEIData:(context:QIPlayerContext, data:Uint8Array)=>{
      this.addToastView(`sei`)
    }
  }
  private mShootVideoListener : QIPlayerShootVideoListener = {
    onShootSuccessful:(context : QIPlayerContext, imageData:Uint8Array, width:number, height:number, type: QPlayerShootVideoType) => {},
    onShootFailed:(context : QIPlayerContext) => {}
  }
  private mSpeedListener : QIPlayerSpeedListener = {
    onSpeedChanged:(context : QIPlayerContext, speed:number ) => {}
  }

  private mSubtitleListener : QIPlayerSubtitleListener = {
    onSubtitleTextChange:(context : QIPlayerContext , text: string ) => {},

    onSubtitleNameChange:(context : QIPlayerContext , name: string ) => {},

    onSubtitleEnable:(context : QIPlayerContext , enable: boolean ) => {},

    onSubtitleLoaded:(context : QIPlayerContext , name: string , result: boolean ) => {},

    onSubtitleDecoded:(context : QIPlayerContext , name: string , result: boolean ) => {}

  }
  private mVideoDataListener : QIPlayerVideoDataListener = {
    onVideoData:(context : QIPlayerContext, width: number, height: number, videoType: QVideoType, buffer: Uint8Array) => {}
  }
  private mVideoDecodeListener : QIPlayerVideoDecodeListener = {
    onVideoDecodeByType:(context : QIPlayerContext , Type: QPlayerDecoderType) => {},

    onDecodeFailed:(context : QIPlayerContext , retry: boolean) => {},

    onNotSupportCodecFormat:(context : QIPlayerContext , codec: number) => {}

  }
  private mVideoFrameSizeChangeListener : QIPlayerVideoFrameSizeChangeListener = {
    onVideoFrameSizeChanged:(context : QIPlayerContext, width: number, height:number ) => {}
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
    this.mPlayerContext.get_control_handler().addPlayerVideoDecodeTypeListener(this.mVideoDecodeListener)
    this.mPlayerContext.get_control_handler().addPlayerMediaNetworkListener(this.mMediaNetworkListener)
    this.mPlayerContext.get_control_handler().addPlayerBufferingChangeListener(this.mBufferingListener)
    this.mPlayerContext.get_control_handler().addPlayerBiteRateChangeListener(this.mBiteRateListener)
    this.mPlayerContext.get_control_handler().addPlayerCommandNotAllowListener(this.mCommandNotAllowListener)
    this.mPlayerContext.get_control_handler().addPlayerQualityListener(this.mQualityListener)
    this.mPlayerContext.get_control_handler().addPlayerSpeedChangeListener(this.mSpeedListener)
    this.mPlayerContext.get_control_handler().addPlayerAuthenticationListener(this.mAuthenticationListener)
    this.mPlayerContext.get_control_handler().addPlayerFormatListener(this.mFormatListener)
    this.mPlayerContext.get_control_handler().addPlayerSEIDataListener(this.mSEIDataListener)
    this.mPlayerContext.get_control_handler().addPlayerShootVideoListener(this.mShootVideoListener)
    this.mPlayerContext.get_control_handler().addPlayerAudioListener(this.mAudioListener)
    this.mPlayerContext.get_control_handler().addPlayerVideoFrameSizeChangeListener(this.mVideoFrameSizeChangeListener)
    this.mPlayerContext.get_control_handler().addPlayerSeekListener(this.mSeekListener)
    this.mPlayerContext.get_control_handler().addPlayerSubtitleListener(this.mSubtitleListener)
    this.mPlayerContext.get_control_handler().addPlayerAudioDataListener(this.mAudioDataListener)
    this.mPlayerContext.get_control_handler().addPlayerVideoDataListener(this.mVideoDataListener)
  }
  //弹出toast，文本为text
  addToastView(text:String){
    this.mToastText = text
    this.mToastText = ""
  }
}

