
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
  QPlayerShootVideoType,
  QIPlayerVideoDataListener,
  QIPlayerAudioDataListener,
  QSampleFormat,
  QChannelLayout,
  QVideoType,
  QIPlayerRenderListener,
  QPlayerState,
  QIPlayerSubtitleListener,
  QVideoRenderType
} from '@qiniu/qplayer2-core/qplayer2-core'
import { QPlayerDemoMediaModels } from '../../model/longVideo/QPlayerDemoMediaModel'
import { QMaskSettingView } from './QMaskSettingView'
import { QSettingPersistentStorageHelper } from '../../common/helper/QSettingPersistentStorageHelper'
import { PlaySpeed, QPlayerSettingModel } from '../../model/longVideo/QPlayerSettingModel'
import { common } from '@kit.AbilityKit'
import { QMaskPlaySpeedView } from './QMaskPlaySpeedView'
import { QMaskSwitchQualityView } from './QMaskSwitchQualityView'
import { image } from '@kit.ImageKit'
import { BusinessError } from '@ohos.base'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import fileIo from '@ohos.file.fs'
import { QMaskSubtitleSettingView } from './QMaskSubtitleSettingView'

@Component
export struct QPlayerView{
  private vrFrameRate = 60
  private mQPlayerMaskTimerCount : Number = 0
  private mQPlayerMaskTimerId : Number = 0
  private mQPlayerIsMaskTimerStart : Boolean = false
  @State mShootViewVisible : Visibility = Visibility.Hidden
  @State mSubtitleText : string = ""
  @State mMaskVisible : Visibility = Visibility.Visible
  @State @Watch("settingViewVisibleChange") mSettingViewVisible : Visibility = Visibility.Hidden
  @State @Watch("playSpeedViewVisibleChange") mPlaySpeedViewVisible : Visibility = Visibility.Hidden
  @State @Watch("playSwitchQualityVisibleChange") mSwitchQualityViewVisible : Visibility = Visibility.Hidden
  @State @Watch("playSubtitleVisibleChange") mSubtitleViewVisible : Visibility = Visibility.Hidden
  @Link @Watch("deviceOrientationChange") mDeviceOrientation : window.Orientation
  @Link mMediaModel : QPlayerDemoMediaModels | null
  @Link mPlayerContext : QIPlayerContext | null
  @Link mIsPlaying : Boolean
  @Link mIsLive : Boolean
  @State mShootImagePixelMap : PixelMap | null = null
  @State mBufferringVisible  : Visibility = Visibility.Hidden
  @State mXComponentId : string = 'qplayer2-core-renderview'
  @Link mQPlayerSettingModel : QPlayerSettingModel | null
  @Link mCurrentModel : QMediaModel | null
  @State mShootSaveButtonOptions : SaveButtonOptions = {text : SaveDescription.SAVE_IMAGE,buttonType: ButtonType.Capsule}
  private mShootImageCallBack : (value : string)=>void = (value : string)=>{};
  private mShootImageBuffer : ArrayBuffer | null = null
  private mVideoDataSaveFileName : string = "/videoOrAudioDataFile/video"
  @State mVideoDataSaveTimes : number = 0
  private mAudioDataSaveFileName : string = "/videoOrAudioDataFile/audio"
  @State mAudioDataSaveTimes : number = 0
  private currentTimeNumber : number = 0;
  private mStateCallBack : QIPlayerStateChangeListener = {
    onStateChange :(context: QIPlayerContext , state : QPlayerState)=>{
      if (state != QPlayerState.PLAYING && state != QPlayerState.SEEKING && state != QPlayerState.PAUSED_RENDER){
        this.mSubtitleText = ""
      }
      if (state == QPlayerState.PLAYING) {
        this.mIsPlaying = true
      }
      else {
        this.mIsPlaying = false
      }
      if (state == QPlayerState.END) {
        this.stopMaskTimer()
      }
    }
  }
  private mSubtitleListener : QIPlayerSubtitleListener = {

    onSubtitleTextChange:(context : QIPlayerContext , text: string ) => {
      this.mSubtitleText = text
    },

    onSubtitleNameChange:(context : QIPlayerContext , name: string ) => {
    },

    onSubtitleEnable:(context : QIPlayerContext , enable: boolean ) => {
      if (enable == false) {
        this.mSubtitleText = ""
      }
    },

    onSubtitleLoaded:(context : QIPlayerContext , name: string , result: boolean ) => {
    },

    onSubtitleDecoded:(context : QIPlayerContext , name: string , result: boolean ) => {
    }
  }
  private mFirstFrameListener : QIPlayerRenderListener = {

    onFirstFrameRendered:(context : QIPlayerContext, elapsedTime:number) => {
      let pathDir = (AppStorage.get("context") as Context).filesDir + this.mVideoDataSaveFileName;
      if (fileIo.accessSync(pathDir + ".yuv")) {
        fileIo.unlinkSync(pathDir + ".yuv")
      }else if (fileIo.accessSync(pathDir + ".rgba")){
        fileIo.unlinkSync(pathDir + ".rgba")
      }
      this.mVideoDataSaveTimes = 0
      pathDir = (AppStorage.get("context") as Context).filesDir + this.mAudioDataSaveFileName;
      if (fileIo.accessSync(pathDir + ".raw")){
        fileIo.unlinkSync(pathDir + ".raw")
      }
      this.mAudioDataSaveTimes = 0
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
        this.mShootViewVisible = Visibility.Visible
        this.mShootImageBuffer = buffer as ArrayBuffer
      }
    },

    onShootFailed:(context : QIPlayerContext) => {
    }
  }

  private mVideoDataListener : QIPlayerVideoDataListener = {
    onVideoData:(context : QIPlayerContext, width: number, height: number, videoType: QVideoType, buffer: Uint8Array) => {
      if (videoType == QVideoType.NV12 || videoType == QVideoType.YUV_420P) {
        if (this.mVideoDataSaveTimes == 100) {
          return
        }else {
          this.mVideoDataSaveTimes ++
        }
        let fileName= this.mVideoDataSaveFileName +".yuv";
        let pathDir = (AppStorage.get("context") as Context).filesDir;
        let fileStr:string=pathDir+fileName;
        let destFile = fileIo.openSync(fileStr, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE|fileIo.OpenMode.APPEND);//若不存在则创建,追加写入
        // 写入至目的文件
        let buf:ArrayBufferLike= buffer.buffer;
        if (buffer.length > 0) {
          fileIo.writeSync(destFile.fd, buf);
        }
        fileIo.closeSync(destFile); // 关闭文件
      }
      else if (videoType == QVideoType.RGBA){
        if (this.mVideoDataSaveTimes == 100) {
          return
        }else {
          this.mVideoDataSaveTimes ++
        }
        let fileName= this.mVideoDataSaveFileName +".rgba";
        let pathDir = (AppStorage.get("context") as Context).filesDir;
        let fileStr:string=pathDir+fileName;
        let destFile = fileIo.openSync(fileStr, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE|fileIo.OpenMode.APPEND);//若不存在则创建,追加写入
        // 写入至目的文件
        let buf:ArrayBufferLike= buffer.buffer;
        if (buffer.length > 0) {
          fileIo.writeSync(destFile.fd, buf);
        }
        fileIo.closeSync(destFile); // 关闭文件
      }
    }
  }
  private mAudioDataListener : QIPlayerAudioDataListener = {
    onAudioData:(context : QIPlayerContext, sampleRate: number, format:QSampleFormat, channelNum: number, channelLayout: QChannelLayout, data:Uint8Array)=>{
      if (this.mAudioDataSaveTimes == 100) {
        return
      }else {
        this.mAudioDataSaveTimes ++
      }
      let fileName= this.mAudioDataSaveFileName +".raw";
      let pathDir = (AppStorage.get("context") as Context).filesDir;
      let fileStr:string=pathDir+fileName;
      let destFile = fileIo.openSync(fileStr, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE|fileIo.OpenMode.APPEND);//若不存在则创建,追加写入
      // 写入至目的文件
      let buf:ArrayBufferLike= data.buffer;
      if (data.length > 0) {
        fileIo.writeSync(destFile.fd, buf);
      }
      fileIo.closeSync(destFile); // 关闭文件
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
  private mRotateX : number = 0;
  private mRotateY : number = 0;
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
          PanGesture()
            .onActionEnd((event : GestureEvent)=>{
              if (this.mCurrentModel?.streamElements[0].videoRenderType == QVideoRenderType.PANORAMA_EQUIRECT_ANGULAR) {
                this.mPlayerContext?.get_render_handler().setPanoramaViewRotate(this.mRotateY - event.offsetY,this.mRotateX - event.offsetX)
                this.mRotateX -= event.offsetX
                this.mRotateY -= event.offsetY
              }
            })
            .onActionUpdate((event : GestureEvent)=>{
              if (this.mCurrentModel?.streamElements[0].videoRenderType == QVideoRenderType.PANORAMA_EQUIRECT_ANGULAR) {
                if ((new Date()).valueOf()-this.currentTimeNumber>1000.0/this.vrFrameRate) {
                  this.mPlayerContext?.get_render_handler().setPanoramaViewRotate(this.mRotateY - event.offsetY,this.mRotateX - event.offsetX)
                  this.currentTimeNumber = (new Date()).valueOf()
                }
              }
            })
            .onActionStart((event : GestureEvent)=>{
              if (this.mCurrentModel?.streamElements[0].videoRenderType == QVideoRenderType.PANORAMA_EQUIRECT_ANGULAR) {
                this.currentTimeNumber = (new Date()).valueOf()
              }
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

        RelativeContainer(){

          Text(this.mSubtitleText)
            .width('100%')
            .height('10%')
            .textAlign(TextAlign.Center)
            .alignRules({
              left:{anchor: "__container__" , align : HorizontalAlign.Start},
              bottom : { anchor : "__container__" , align : VerticalAlign.Bottom},
            })
            .id("subtitle_text")
            .enabled(false)
            .fontColor($r("app.color.white"))
            .backgroundColor($r("app.color.hyaline_background_color"))
            .fontSize(15)
            .margin({bottom: 60})
        }
        .width('100%')
        .height('100%')
        .enabled(false)
        .id("subtitle_relative_container")

        QMaskView({
          mDeviceOrientation: this.mDeviceOrientation,
          mPlayerContext: this.mPlayerContext,
          mIsPlaying: this.mIsPlaying,
          mSettingViewVisible : this.mSettingViewVisible,
          mIsLive : this.mIsLive,
          mPlaySpeedViewVisible : this.mPlaySpeedViewVisible,
          mSwitchQualityViewVisible : this.mSwitchQualityViewVisible,
          mSubtitleViewVisible : this.mSubtitleViewVisible
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

          .gesture(
            PanGesture()
              .onActionEnd((event : GestureEvent)=>{
                if (this.mCurrentModel?.streamElements[0].videoRenderType == QVideoRenderType.PANORAMA_EQUIRECT_ANGULAR) {
                  this.mPlayerContext?.get_render_handler().setPanoramaViewRotate(this.mRotateY - event.offsetY,this.mRotateX - event.offsetX)
                  this.mRotateX -= event.offsetX
                  this.mRotateY -= event.offsetY
                }
              })
              .onActionUpdate((event : GestureEvent)=>{
                if (this.mCurrentModel?.streamElements[0].videoRenderType == QVideoRenderType.PANORAMA_EQUIRECT_ANGULAR) {
                  if ((new Date()).valueOf()-this.currentTimeNumber>1000.0/this.vrFrameRate) {
                    this.mPlayerContext?.get_render_handler().setPanoramaViewRotate(this.mRotateY - event.offsetY,this.mRotateX - event.offsetX)
                    this.currentTimeNumber = (new Date()).valueOf()
                  }
                }
              })
              .onActionStart((event : GestureEvent)=>{
                if (this.mCurrentModel?.streamElements[0].videoRenderType == QVideoRenderType.PANORAMA_EQUIRECT_ANGULAR) {
                  this.currentTimeNumber = (new Date()).valueOf()
                }
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

        RelativeContainer() {
          QMaskSubtitleSettingView({mCurrentModel : this.mCurrentModel, mPlayerContext : this.mPlayerContext})
            .alignRules({
              top : {anchor : "__container__" , align : VerticalAlign.Top},
              right : {anchor : "__container__", align : HorizontalAlign.End}
            })
            .visibility(this.mSubtitleViewVisible)
            .height("100%")
            .width(100)
            .id("subtitle_view")
            .backgroundColor($r("app.color.setting_view_background_color"))
            .margin({
              right: 50
            })
        }
        .visibility(this.mSubtitleViewVisible)
        .onClick(()=>{
          this.mSubtitleViewVisible = Visibility.Hidden
          this.stopMaskTimer()
        })
        .height("100%")
        .width("100%")
        .id("subtitle_view_relativeContainer")
      }
    }
    .height("100%")
    .width("100%")
  }
  aboutToAppear(): void {
    this.maskVisibleTimerChange()
    this.mPlayerContext?.get_control_handler().setSeekMode(this.mQPlayerSettingModel!.mSeekMode)
    if (this.mQPlayerSettingModel?.mBackgroundPlay == 0) {
      this.mPlayerContext?.get_control_handler().setBackgroundPlayEnable(false)
    }else {
      this.mPlayerContext?.get_control_handler().setBackgroundPlayEnable(true)
    }
    this.mPlayerContext?.get_control_handler().addPlayerStateListener(this.mStateCallBack)

    this.mPlayerContext?.get_control_handler().addPlayerBufferingChangeListener(this.mBufferingCallBack)
    this.mPlayerContext?.get_control_handler().addPlayerShootVideoListener(this.mShootVideoListener)
    this.mPlayerContext?.get_control_handler().setDecoderType(this.mQPlayerSettingModel!.mDecoderType)
    this.mPlayerContext?.get_control_handler().setSEIEnable(this.mQPlayerSettingModel!.mSEIEnable == 0 ? false : true)
    this.mPlayerContext?.get_render_handler().setRenderRatio(this.mQPlayerSettingModel!.mRenderRatio)
    this.mPlayerContext?.get_render_handler().setBlindType(this.mQPlayerSettingModel!.mBlinderType)
    this.mPlayerContext?.get_control_handler().setStartAction(this.mQPlayerSettingModel!.mStartAction)
    this.mPlayerContext?.get_render_handler().setMirrorType(this.mQPlayerSettingModel!.mMirrorType)
    if (this.mQPlayerSettingModel?.mForceNetworkAuth != 0) {
      this.mPlayerContext?.get_control_handler().forceAuthenticationFromNetwork()
    }
    this.mPlayerContext?.get_render_handler().setRotation(this.mQPlayerSettingModel!.mRotation)
    this.mPlayerContext?.get_render_handler().setScale(this.mQPlayerSettingModel!.mScale)
    this.mPlayerContext?.get_control_handler().addPlayerVideoDataListener(this.mVideoDataListener)
    this.mPlayerContext?.get_control_handler().addPlayerAudioDataListener(this.mAudioDataListener)
    this.mPlayerContext?.get_render_handler().addPlayerRenderListener(this.mFirstFrameListener)
    this.mPlayerContext?.get_control_handler().addPlayerSubtitleListener(this.mSubtitleListener)
    this.mPlayerContext?.get_control_handler().setSubtitleEnable(this.mQPlayerSettingModel?.mSubtitleEnable == 0 ? false : true)
    //此处开启音视频回调，会将音视频数据存储到沙河目录的 videoOrAudioDataFile 下的 video.yuv / video.rgba 和 audio.raw
    //每次切集会删除保存的音视频回调数据，并重新保存当前视频的前一百帧数据
    //具体的实现方式见 mAudioDataListener 和 mVideoDataListener 以及 mFirstFrameListener 的 文件操作
    // this.mPlayerContext?.get_control_handler().setVideoDataEnable(true)
    // this.mPlayerContext?.get_control_handler().setAudioDataEnable(true)
    // this.mPlayerContext?.get_control_handler().setVideoDataType(QVideoType.RGBA)
    if (!fileIo.accessSync((AppStorage.get("context") as Context).filesDir + "/videoOrAudioDataFile")){
      fileIo.mkdirSync((AppStorage.get("context") as Context).filesDir + "/videoOrAudioDataFile")
    }
    this.mVideoDataSaveTimes = 0
    this.mPlayerContext?.get_control_handler().playMediaModel(this.mMediaModel!.mMediaModels![0].mMediaModel, this.mQPlayerSettingModel!.mPosition)

    if (this.mQPlayerSettingModel?.mPlaySpeed == PlaySpeed.SPEED_0_5) {
      this.mPlayerContext?.get_control_handler().setSpeed(0.5)
    }else if (this.mQPlayerSettingModel?.mPlaySpeed == PlaySpeed.SPEED_0_75){
      this.mPlayerContext?.get_control_handler().setSpeed(0.75)
    }else if (this.mQPlayerSettingModel?.mPlaySpeed == PlaySpeed.SPEED_1_0){
      this.mPlayerContext?.get_control_handler().setSpeed(1.0)
    }else if (this.mQPlayerSettingModel?.mPlaySpeed == PlaySpeed.SPEED_1_25){
      this.mPlayerContext?.get_control_handler().setSpeed(1.25)
    }else if (this.mQPlayerSettingModel?.mPlaySpeed == PlaySpeed.SPEED_1_5){
      this.mPlayerContext?.get_control_handler().setSpeed(1.5)
    }else if (this.mQPlayerSettingModel?.mPlaySpeed == PlaySpeed.SPEED_2_0){
      this.mPlayerContext?.get_control_handler().setSpeed(2.0)
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
  playSubtitleVisibleChange(){
    if (this.mSubtitleViewVisible == Visibility.Visible) {
      this.mMaskVisible = Visibility.Hidden
    }
  }
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
      this.mPlayerContext?.get_control_handler().pauseRender()
    }else {
      this.mPlayerContext?.get_control_handler().resumeRender()
    }
  }
}
