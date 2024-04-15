import { QTitleView } from "../../common/component/QTitleView"
import { QPlayerView } from './QPlayerView'
import { mediaquery, window } from '@kit.ArkUI'
import  { QPlayerStatusView } from  "./QPlayerStatusView"
import { QPlayerUrlListView } from './QPlayerUrlListView'
import { QPlayerToastView } from './QPlayerToastView'
import { QPlayerSettingModel } from '../../model/longVideo/QPlayerSettingModel'
import { QPlayerDemoMediaModels } from '../../model/longVideo/QPlayerDemoMediaModel'
import { QSettingPersistentStorageHelper } from '../../common/helper/QSettingPersistentStorageHelper'
import { common, Context } from '@kit.AbilityKit'
import { ifaa } from '@kit.OnlineAuthenticationKit'
import { PlayerContextFactory, QIPlayerContext, QLogLevel } from '@QN/QPlayer2-core/Index'

@Entry
@Component
struct QLongVideoView {
  @State @Watch('QPlayerSettingModelChange') mQPlayerSetting : QPlayerSettingModel = QSettingPersistentStorageHelper.read(AppStorage.get('context') as Context)
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
  @State mPlayerContext : QIPlayerContext = PlayerContextFactory.createPlayerContext(QLogLevel.LOG_DEBUG,"s","s","1.4.0")
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
          mPlayerContext : this.mPlayerContext
        })
          .alignRules({
            left: { anchor: "__container__", align: HorizontalAlign.Start },
            top: { anchor: this.mQPlayerViewFrameTop.toString(), align: this.mQPlayerViewFrameTopAlign },
            bottom: { anchor: this.mQPlayerViewFrameBottom.toString(), align: this.mQPlayerViewFrameBottomAlign },
          })
          .backgroundColor($r('app.color.long_video_player_view_background_color'))
          .width(this.mQPlayerViewWidth)// .height(this.mQPlayerViewHeight)
          .id("qplayer_view")

        QPlayerStatusView()
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
            mPlayerContext : this.mPlayerContext
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
            .responseRegion({x : 0 , y : 0 , width : 0 , height : 0})
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
    // this.rotateScreen('mDeviceOrientation')
    // let pa = JSON.parse(str)
    // inner_param.setDecoderType(QPlayerDecodeType.SOFTWARE)
    // this.rotateScreen(this.mDeviceOrientation)
    // QUrlJsonReadWriteHelper.read(context,(value)=>{})
    // QSettingPersistentStorageHelper.save(context,this.mQPlayerSetting)
  }
  aboutToDisappear(): void {
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

  QPlayerSettingModelChange(name: String){

  }
  //弹出toast，文本为text
  addToastView(text:String){
    this.mToastText = text
    this.mToastText = ""
  }
}

