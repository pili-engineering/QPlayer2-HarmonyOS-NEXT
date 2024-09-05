import { QIPlayerContext,
  QIPlayerDownloadListener,
  QIPlayerFPSListener,
  QIPlayerRenderListener,
  QIPlayerStateChangeListener } from '@qiniu/qplayer2-core'
import { QPlayerState } from '@qiniu/qplayer2-core/qplayer2-core'

@Component
export struct QShortVideoStatusView{

  @State mPlayerStatus : String = "Playing"
  @State mPlayerFirstVideoTime : String = "0ms"
  @State mPlayerFPS : String = "0fps"
  @State mPlayerDownloadSpeed : String = "0kb/s"
  @State mPlayerBufferPostion : String = "0ms"
  private mStateChangeListener : QIPlayerStateChangeListener ={
    onStateChange:(context : QIPlayerContext ,state: QPlayerState)=>{
      let stateString : string
      switch (state){
        case QPlayerState.NONE:
          stateString = "NONE"
          break
        case QPlayerState.INIT:
          stateString = "INIT"
          break
        case QPlayerState.PREPARE:
          stateString = "PREPARE"
          break
        case QPlayerState.PLAYING:
          stateString = "PLAYING"
          break
        case QPlayerState.PAUSED_RENDER:
          stateString = "PAUSED_RENDER"
          break
        case QPlayerState.COMPLETED:
          stateString = "COMPLETED"
          break
        case QPlayerState.SEEKING:
          stateString = "SEEKING"
          break
        case QPlayerState.STOPPED:
          stateString = "STOPPED"
          break
        case QPlayerState.ERROR:
          stateString = "ERROR"
          break
        case QPlayerState.END:
          stateString = "END"
          break
        default :
          stateString = "default"
          break
      }
      this.mPlayerStatus = stateString
    }
  }
  private mFPSListener : QIPlayerFPSListener = {
    onFPSChanged:(context:QIPlayerContext, FPS:number)=>{
      this.mPlayerFPS = FPS.toString() + " fps"
    }
  }

  private mDownloadListener : QIPlayerDownloadListener = {
    onDownloadChanged:(context:QIPlayerContext, speed:number, bufferPos:number)=>{
      this.mPlayerDownloadSpeed = (speed/1000).toString() + " kb/s"
      this.mPlayerBufferPostion = bufferPos.toString() + " ms"
    }
  }

  private mRenderListener : QIPlayerRenderListener = {
    onFirstFrameRendered:(context : QIPlayerContext, elapsedTime:number) => {
      this.mPlayerFirstVideoTime = elapsedTime.toString() + " ms"
    }
  }
  public mPlayerContext : QIPlayerContext | null = null
  build() {
    // Column(){
      RelativeContainer(){

        Text("播放状态 : " + this.mPlayerStatus)
          .statusTextStyle()
          .alignRules({
            left : {anchor : "__container__" , align : HorizontalAlign.Start},
            top : {anchor : "__container__" , align : VerticalAlign.Bottom}
          })
          .id("player_status_text")

        Text("首开时间 : " + this.mPlayerFirstVideoTime)
          .statusTextStyle()
          .alignRules({
            left : {anchor : "__container__" , align : HorizontalAlign.Start},
            top : {anchor : "player_status_text" , align : VerticalAlign.Bottom}
          })
          .id("player_first_video_time_text")

        Text("FPS : " + this.mPlayerFPS)
          .statusTextStyle()
          .alignRules({
            left : {anchor : "__container__" , align : HorizontalAlign.Start},
            top : {anchor : "player_first_video_time_text" , align : VerticalAlign.Bottom}
          })
          .id("player_fps_text")

        Text("下载速度 : " + this.mPlayerDownloadSpeed)
          .statusTextStyle()
          .alignRules({
            left : {anchor : "__container__" , align : HorizontalAlign.Start},
            top : {anchor : "player_fps_text" , align : VerticalAlign.Bottom}
          })
          .id("player_down_load_speed_text")

        Text("BufferPostion : " + this.mPlayerBufferPostion)
          .statusTextStyle()
          .alignRules({
            left : {anchor : "__container__" , align : HorizontalAlign.Start},
            top : {anchor : "player_down_load_speed_text" , align : VerticalAlign.Bottom}
          })
          .id("player_buffer_postion_text")
      }
    // }
    // .width("100%")
    // .height("100%")
    // .backgroundColor($r("app.color.default_background_color"))
  }
  aboutToAppear(): void {
    this.mPlayerContext?.get_control_handler().addPlayerStateListener(this.mStateChangeListener)

    this.mPlayerContext?.get_control_handler().addPlayerFPSChangeListener(this.mFPSListener)
    this.mPlayerContext?.get_control_handler().addPlayerDownloadChangeListener(this.mDownloadListener)
    this.mPlayerContext?.get_render_handler().addPlayerRenderListener(this.mRenderListener)
  }

}
@Extend(Text) function statusTextStyle(){
  .fontColor("#FFFFFF")
  .fontSize($r('app.float.default_font_size'))
  .backgroundColor($r('app.color.hyaline_background_color'))
  .width("90%")
  .height("16%")
  .margin({
    left : '5%'
  })
}