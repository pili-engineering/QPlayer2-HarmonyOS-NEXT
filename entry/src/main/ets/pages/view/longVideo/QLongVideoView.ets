import { QTitleView } from "../../common/component/QTitleView"
import { QPlayerView } from './QPlayerView'
import { mediaquery, window } from '@kit.ArkUI'
import  { QPlayerStatusView } from  "./QPlayerStatusView"
import { QPlayerUrlListView } from './QPlayerUrlListView'
import { QPlayerToastView } from '../../common/component/QPlayerToastView'
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
  QIPlayerSeekListener,
  QIPlayerSpeedListener,
  QIPlayerVideoDecodeListener,
  QIPlayerQualityListener,
  QMediaModel,
  QIPlayerSEIDataListener,
  QIPlayerShootVideoListener,
  QPlayerShootVideoType,
  QIPlayerVideoFrameSizeChangeListener} from '@qiniu/qplayer2-core/qplayer2-core'
import { QPlayerState } from '@qiniu/qplayer2-core/src/main/ets/public/enums/QPlayerState'
import { QPlayerDecoderType } from '@qiniu/qplayer2-core/src/main/ets/public/enums/QPlayerDecoderType'
import { util } from '@kit.ArkTS'
import utils from '@arkts.utils'
import { QDecimalToHexHelper } from '../../common/Helper/QDecimalToHexHelper'
import { image } from '@kit.ImageKit'


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
  @State mToastMarginValue : number = 0
  @State mToastViewWidth : Length = '70%'
  @State mCurrentModel : QMediaModel | null = null
  @State mPlayerContext : QIPlayerContext = QPlayerContextFactory.createPlayerContext(
    QLogLevel.LOG_INFO,
    (AppStorage.get("context") as Context).filesDir,
    bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).versionName,
    "")

  private mQualityListener: QIPlayerQualityListener = {
    onQualitySwitchStart:(context : QIPlayerContext , usertype: string , urlType: QPlayerUrlType , oldQuality: number , newQuality: number ) => {

      this.addToastView(`开始切换清晰度：new : ${newQuality.valueOf()} old : ${oldQuality.valueOf()}`)
    },

    onQualitySwitchComplete:(context : QIPlayerContext , usertype: string , urlType: QPlayerUrlType , oldQuality: number , newQuality: number ) => {
      this.addToastView(`切换清晰度成功：new : ${newQuality.valueOf()} old : ${oldQuality.valueOf()}`)
      },

    onQualitySwitchCanceled:(context : QIPlayerContext , usertype: string , urlType: QPlayerUrlType , oldQuality: number , newQuality: number ) => {

      this.addToastView(`取消切换清晰度：new : ${newQuality.valueOf()} old : ${oldQuality.valueOf()}`)
    },

    onQualitySwitchFailed:(context : QIPlayerContext , usertype: string , urlType: QPlayerUrlType , oldQuality: number , newQuality: number ) => {

      this.addToastView(`切换清晰度失败：new : ${newQuality.valueOf()} old : ${oldQuality.valueOf()}`)
      },

    onQualitySwitchRetryLater:(context : QIPlayerContext ,  usertype: string , urlType: QPlayerUrlType ) => {

      this.addToastView(`不可重复切换清晰度`)
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
  private mShootVideoListener : QIPlayerShootVideoListener = {
    onShootSuccessful:(context : QIPlayerContext, imageData:Uint8Array, width:number, height:number, type: QPlayerShootVideoType) => {
      if (type == QPlayerShootVideoType.JPEG) {
        this.addToastView("截图成功 格式 jpeg")
      }else {
        this.addToastView("截图成功 格式 none")
      }
    },

    onShootFailed:(context : QIPlayerContext) => {
      this.addToastView("截图失败")
    }
  }
  private mBiteRateListener : QIPlayerBiteRateListener = {
    onBiteRateChanged:(context:QIPlayerContext, bitrate:number)=>{}
  }
  private mBufferingListener : QIPlayerBufferingListener = {
    onBufferingStart:(context:QIPlayerContext)=>{
      // this.addToastView("start buffer")
    },

    onBufferingEnd:(context: QIPlayerContext)=> {
      // this.addToastView("end buffer")
    }
  }
  private mVideoFrameSizeChangedListener : QIPlayerVideoFrameSizeChangeListener ={

    onVideoFrameSizeChanged:(context : QIPlayerContext, width: number, height:number ) => {

      this.addToastView("推流宽高变化 : width " + width + "height : " + height)
    }
  }
  private mCommandNotAllowListener : QIPlayerCommandNotAllowListener = {
    onCommandNotAllow:(context:QIPlayerContext, commandName:string, state:QPlayerState)=>{}
  }
  private mFormatListener : QIPlayerFormatListener = {
    onFormatNotSupport:(context:QIPlayerContext)=>{
      this.addToastView("onFormatNotSupport")
    }
  }
  private mPlaySpeed : QIPlayerSpeedListener = {
    onSpeedChanged:(context : QIPlayerContext, speed:number)=>{
      this.addToastView(`播放速度 : ${speed}`)
    }
  }
  private mSEIListener: QIPlayerSEIDataListener = {

    onSEIData:(context:QIPlayerContext, data:Uint8Array)=> {
      let seiData = data
      let uuid :Uint8Array
      if (data.byteLength > 16) {
        let uuid :Uint8Array = seiData.slice(0,16)
        seiData = seiData.slice(16,seiData.length)
        let uuidStr : string = ""
        uuid.forEach((value : number , index : number) =>{
          let secondValue = value % 16
          let firstValue = (value - secondValue) / 16
          uuidStr += QDecimalToHexHelper.decimalToHex(firstValue)
          uuidStr += QDecimalToHexHelper.decimalToHex(secondValue)
          if (index == 3 || index == 5 || index == 7 || index == 9) {
            uuidStr += "-"
          }
        })
        this.addToastView(uuidStr)
      }
      const textDecoder = util.TextDecoder.create("utf-8")
      let seiStr : string =  textDecoder.decodeWithStream(seiData, { stream: false })
      this.addToastView(seiStr.toString())
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

  private mDecoderTypeListener : QIPlayerVideoDecodeListener = {
    onVideoDecodeByType:(context : QIPlayerContext , Type: QPlayerDecoderType) => {
      switch (Type){
        case QPlayerDecoderType.NONE:
          this.addToastView(`解码方式 : NONE`)
          break
        case QPlayerDecoderType.HARDWARE:
          this.addToastView(`解码方式 : 硬解`)
          break
        case QPlayerDecoderType.SOFTWARE:
          this.addToastView(`解码方式 : 软解`)
          break
        default :
          this.addToastView(`解码方式 : 未知`)
          break
      }
  },

    onDecodeFailed:(context : QIPlayerContext , retry: boolean) => {
      this.addToastView(`解码失败 ： retry ${retry}`)
    },
    onNotSupportCodecFormat:(context : QIPlayerContext , codec: number) => {
      this.addToastView(`解码格式不支持 ： codec ${codec}`)
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
          mIsLive : this.mIsLive,
          mQPlayerSettingModel : this.mQPlayerSetting,
          mCurrentModel : this.mCurrentModel,
          mShootImageCallBack : (value)=>{
            this.addToastView(value)
          }
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
            mIsLive : this.mIsLive,
            mQPlayerSettingModel : this.mQPlayerSetting,
            mCurrentModel : this.mCurrentModel
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
    let mContext : Context = AppStorage.get('context') as Context
    this.mPlayerContext.init(mContext, getContext(this) as common.UIAbilityContext)
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
      this.mToastMarginValue = 50
      this.mToastViewWidth = '35%'
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
      this.mToastMarginValue = 0
      this.mToastViewWidth = '70%'
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
    this.mPlayerContext.get_control_handler().addPlayerVideoDecodeTypeListener(this.mDecoderTypeListener)
    this.mPlayerContext.get_control_handler().addPlayerSpeedChangeListener(this.mPlaySpeed)
    this.mPlayerContext.get_control_handler().addPlayerQualityListener(this.mQualityListener)
    this.mPlayerContext.get_control_handler().addPlayerSEIDataListener(this.mSEIListener)
    this.mPlayerContext.get_control_handler().addPlayerShootVideoListener(this.mShootVideoListener)
    this.mPlayerContext.get_control_handler().addPlayerVideoFrameSizeChangeListener(this.mVideoFrameSizeChangedListener)
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

