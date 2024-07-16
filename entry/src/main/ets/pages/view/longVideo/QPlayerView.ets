
import { QMaskView } from './QMaskView'
import { window } from '@kit.ArkUI'
import {QSurfaceRenderView,QIPlayerContext,
  QPlayerContextFactory,
  QLogLevel,
  QPlayerSeek,
  QIPlayerStateChangeListener,
  QIPlayerBufferingListener,
  QMediaModel,
  QIPlayerShootVideoListener,
  QPlayerShootVideoType
} from '@qiniu/qplayer2-core/qplayer2-core'
import { QPlayerDemoMediaModels } from '../../model/longVideo/QPlayerDemoMediaModel'
import { QMaskSettingView } from './QMaskSettingView'
import { QPlayerState } from '@qiniu/qplayer2-core/src/main/ets/public/enums/QPlayerState'
import { QSettingPersistentStorageHelper } from '../../common/helper/QSettingPersistentStorageHelper'
import { PlaySpeed, QPlayerSettingModel } from '../../model/longVideo/QPlayerSettingModel'
import { common } from '@kit.AbilityKit'
import { QMaskPlaySpeedView } from './QMaskPlaySpeedView'
import { QMaskSwitchQualityView } from './QMaskSwitchQualityView'
import { image } from '@kit.ImageKit'
import { BusinessError } from '@ohos.base'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import fileIo from '@ohos.file.fs'

@Component
export struct QPlayerView{
  private mQPlayerMaskTimerCount : Number = 0
  private mQPlayerMaskTimerId : Number = 0
  private mQPlayerIsMaskTimerStart : Boolean = false

  private mQPlayerShootTimerCount : Number = 0
  private mQPlayerShootTimerId : Number = 0
  private mQPlayerIsShootTimerStart : Boolean = false
  @State mShootViewVisible : Visibility = Visibility.Hidden
  // @Link PlayerSettingViewModel: QPlayerSettingViewModel
  @State mMaskVisible : Visibility = Visibility.Visible
  @State @Watch("settingViewVisibleChange") mSettingViewVisible : Visibility = Visibility.Hidden
  @State @Watch("playSpeedViewVisibleChange") mPlaySpeedViewVisible : Visibility = Visibility.Hidden
  @State @Watch("playSwitchQualityVisibleChange") mSwitchQualityViewVisible : Visibility = Visibility.Hidden
  @Link @Watch("deviceOrientationChange") mDeviceOrientation : window.Orientation
  @Link mMediaModel : QPlayerDemoMediaModels
  @Link mPlayerContext : QIPlayerContext
  @Link mIsPlaying : Boolean
  @Link mIsLive : Boolean
  @State mShootImagePixelMap : PixelMap | null = null
  @State mBufferringVisible  : Visibility = Visibility.Hidden
  @State mXComponentId : string = 'qplayer2-core-renderview'
  @Link mQPlayerSettingModel : QPlayerSettingModel
  @Link mCurrentModel : QMediaModel | null
  @State mShootSaveButtonOptions : SaveButtonOptions = {text : SaveDescription.SAVE_IMAGE,buttonType: ButtonType.Capsule}
  private mShootImageCallBack : (value : string)=>void = (value : string)=>{};
  private mShootImageBuffer : ArrayBuffer | null = null
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
  private mShootVideoListener : QIPlayerShootVideoListener = {
    onShootSuccessful:(context : QIPlayerContext, imageData:Uint8Array, width:number, height:number, type: QPlayerShootVideoType) => {
      if (type == QPlayerShootVideoType.JPEG) {
        let buffer : ArrayBufferLike = imageData.buffer
        let source:image.ImageSource = image.createImageSource(buffer)
        let option : image.InitializationOptions = {size : {height : height ,width : width}}
        let pixelMap : PixelMap = source.createPixelMapSync(option)
        if (this.mShootImagePixelMap) {
          this.mShootImagePixelMap.release()
        }
        //浅拷贝
        this.mShootImagePixelMap = pixelMap
        // this.shootVisibleTimeChange()
        this.mShootViewVisible = Visibility.Visible
        this.mShootImageBuffer = buffer as ArrayBuffer
      }
    },

    onShootFailed:(context : QIPlayerContext) => {
    }
  }
  saveImage(buffer: ArrayBuffer | string) {
    let context = getContext(this) as common.UIAbilityContext;
    let helper = photoAccessHelper.getPhotoAccessHelper(context);
    helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpg',(error,value)=>{
      if (error != undefined) {
        this.mShootImageCallBack("保存失败 : " + error.message)
        return
      }
      let file = fileIo.openSync(value, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
      fileIo.writeSync(file.fd, buffer);
      fileIo.closeSync(file.fd);
      this.mShootImageCallBack("保存成功")
    });
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
              this.maskVisibleTimerChange()
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
          mPlaySpeedViewVisible : this.mPlaySpeedViewVisible,
          mSwitchQualityViewVisible : this.mSwitchQualityViewVisible
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
                this.maskVisibleTimerChange()
              })
          )
          .visibility(this.mMaskVisible)
          .id('mask_view')


        RelativeContainer() {
          Image(this.mShootImagePixelMap)
            .alignRules({
              left:{anchor: "__container__" , align : HorizontalAlign.Start},
              top : { anchor : "__container__" , align : VerticalAlign.Top},
            })
            .margin({left : '5%'})
            .width('90%')
            .height('90%')
            .id('shoot_view')
            .enabled(false)
            .visibility(this.mShootViewVisible)
            .backgroundColor('#ff000000')
            .objectFit(ImageFit.Contain)
          Column(){
            Row() {
              // saveButton 因为 toastview（透明的） 覆盖在该按钮在上方导致该按钮无法获取点击事件，
              // 但此处用 Button 则会收到点击事件。
              // 图库必须使用 saveButton 无法使用 Button
              SaveButton(this.mShootSaveButtonOptions)
                .width("20%")
                .onClick((event: ClickEvent, result: SaveButtonOnClickResult) => {
                  if (result == SaveButtonOnClickResult.SUCCESS) {
                    this.mShootViewVisible = Visibility.Hidden
                    if (this.mShootImageBuffer == null) {
                      return
                    }
                    this.saveImage(this.mShootImageBuffer!)
                  }
                })
              Button("取消")
                .onClick(() => {
                  this.mShootViewVisible = Visibility.Hidden
                })
                .width("20%")
                .margin({left : "5%"})
            }
            .id('shoot_view_row')
          }
          .alignRules({
            left: { anchor: "shoot_view", align: HorizontalAlign.Start },
            top: { anchor: "shoot_view", align: VerticalAlign.Bottom }
          })
          .width('90%')
          .height('10%')
          .id('shoot_view_column')
          .visibility(this.mShootViewVisible)
          .backgroundColor($r("app.color.hyaline_background_color"))
        }
        .visibility(this.mShootViewVisible)
        .height("70%")
        .width("70%")
        .id("shoot_view_relativeContainer")

        RelativeContainer() {
          QMaskSettingView({mPlayerContext : this.mPlayerContext, mQPlayerSettingModel: this.mQPlayerSettingModel})
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
          this.stopMaskTimer()
        })
        .height("100%")
        .width("100%")
        .id("setting_view_relativeContainer")

        RelativeContainer() {
          QMaskPlaySpeedView({mPlayerContext : this.mPlayerContext,mQPlayerSettingModel : this.mQPlayerSettingModel})
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
          this.stopMaskTimer()
        })
        .height("100%")
        .width("100%")
        .id("play_speed_view_relativeContainer")

        RelativeContainer() {
          QMaskSwitchQualityView({mCurrentModel : this.mCurrentModel, mPlayerContext : this.mPlayerContext, mQPlayerSetting : this.mQPlayerSettingModel})
            .alignRules({
              top : {anchor : "__container__" , align : VerticalAlign.Top},
              right : {anchor : "__container__", align : HorizontalAlign.End}
            })
            .visibility(this.mSwitchQualityViewVisible)
            .height("100%")
            .width(100)
            .id("switch_quality_view")
            .backgroundColor($r("app.color.setting_view_background_color"))
            .margin({
              right: 50
            })
        }
        .visibility(this.mSwitchQualityViewVisible)
        .onClick(()=>{
          this.mSwitchQualityViewVisible = Visibility.Hidden
          this.stopMaskTimer()
        })
        .height("100%")
        .width("100%")
        .id("switch_quality_view_relativeContainer")

      }
    }
    .height("100%")
    .width("100%")
  }
  aboutToAppear(): void {
    this.maskVisibleTimerChange()
    let mContext : Context = AppStorage.get('context') as Context
    this.mPlayerContext.init(mContext, getContext(this) as common.UIAbilityContext)
    this.mPlayerContext.get_control_handler().setSeekMode(this.mQPlayerSettingModel.mSeekMode)
    if (this.mQPlayerSettingModel.mBackgroundPlay == 0) {
      this.mPlayerContext.get_control_handler().setBackgroundPlayEnable(false)
    }else {
      this.mPlayerContext.get_control_handler().setBackgroundPlayEnable(true)
    }
    this.mPlayerContext.get_control_handler().addPlayerStateListener(this.mStateCallBack)

    this.mPlayerContext.get_control_handler().addPlayerBufferingChangeListener(this.mBufferingCallBack)
    this.mPlayerContext.get_control_handler().addPlayerShootVideoListener(this.mShootVideoListener)
    this.mPlayerContext.get_control_handler().setDecoderType(this.mQPlayerSettingModel.mDecoderType)
    this.mPlayerContext.get_control_handler().setSEIEnable(this.mQPlayerSettingModel.mSEIEnable == 0 ? false : true)
    this.mPlayerContext.get_render_handler().setRenderRatio(this.mQPlayerSettingModel.mRenderRatio)
    this.mPlayerContext.get_render_handler().setBlindType(this.mQPlayerSettingModel.mBlinderType)
    this.mPlayerContext.get_control_handler().setStartAction(this.mQPlayerSettingModel.mStartAction)
    this.mPlayerContext.get_control_handler().playMediaModel(this.mMediaModel.mMediaModels[0].mMediaModel, this.mQPlayerSettingModel.mPosition)
    this.mCurrentModel = this.mMediaModel.mMediaModels[0].mMediaModel
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
  playSwitchQualityVisibleChange(){
    if (this.mSwitchQualityViewVisible == Visibility.Visible) {
      this.mMaskVisible = Visibility.Hidden
    }
  }
  // shootVisibleTimeChange(){
  //   if (this.mQPlayerIsShootTimerStart == true){
  //     this.mQPlayerShootTimerCount = 0
  //   }else {
  //     this.mShootViewVisible = Visibility.Visible
  //     this.mQPlayerIsShootTimerStart = true;
  //     this.mQPlayerShootTimerId = setInterval(() => {
  //       this.mQPlayerShootTimerCount = this.mQPlayerShootTimerCount.valueOf() + 1
  //       if (this.mQPlayerShootTimerCount.valueOf() == 7) {
  //         this.stopShootViewTimer()
  //       }
  //     }, 700)
  //   }
  // }
  // stopShootViewTimer(){
  //   clearInterval(this.mQPlayerShootTimerId.valueOf())
  //   this.mShootImagePixelMap?.release()
  //   this.mShootImagePixelMap = null
  //   this.mQPlayerShootTimerCount = 0
  //   this.mQPlayerIsShootTimerStart = false
  //   this.mShootViewVisible = Visibility.Hidden
  // }
  stopMaskTimer(){
    clearInterval(this.mQPlayerMaskTimerId.valueOf())
    this.mQPlayerMaskTimerCount = 0
    this.mQPlayerIsMaskTimerStart = false
    this.mMaskVisible = Visibility.Hidden
  }
  maskVisibleTimerChange(){
    if(this.mQPlayerIsMaskTimerStart){
      this.stopMaskTimer()
    }else {
      this.mMaskVisible = Visibility.Visible
      this.mQPlayerIsMaskTimerStart = true
      this.mQPlayerMaskTimerId = setInterval(()=>{
        this.mQPlayerMaskTimerCount = this.mQPlayerMaskTimerCount.valueOf() + 1
        if (this.mQPlayerMaskTimerCount.valueOf() == 10) {
          this.stopMaskTimer()
        }
      },1000)
    }
  }
  onDoubleClick(){
    this.mQPlayerMaskTimerCount = 0;
    if (this.mIsPlaying == true) {
      this.mPlayerContext.get_control_handler().pauseRender()
    }else {
      this.mPlayerContext.get_control_handler().resumeRender()
    }
  }
}
