
@Component
export  struct  QPlayerStatusView{
   @State mPlayerStatus : String = "Playing"
   @State mPlayerFirstVideoTime : String = "1000ms"
   @State mPlayerFPS : String = "60fps"
   @State mPlayerDownloadSpeed : String = "1222kb/s"
   @State mPlayerBufferPostion : String = "11861ms"
   build() {
      Column(){
         RelativeContainer(){
            titleView()
               .alignRules({
                  left : {anchor : "__container__", align : HorizontalAlign.Start},
                  top : {anchor : "__container__", align : VerticalAlign.Top}
               })
               .width("100%")
               .height('20%')
               .id("title_view")

            Text("播放状态 : " + this.mPlayerStatus)
               .statusTextStyle()
               .alignRules({
                  left : {anchor : "__container__" , align : HorizontalAlign.Start},
                  top : {anchor : "title_view" , align : VerticalAlign.Bottom}
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

            Text("下载速度 : " + this.mPlayerBufferPostion)
               .statusTextStyle()
               .alignRules({
                  left : {anchor : "__container__" , align : HorizontalAlign.Start},
                  top : {anchor : "player_down_load_speed_text" , align : VerticalAlign.Bottom}
               })
               .id("player_buffer_postion_text")
         }
      }
      .width("100%")
      .height("100%")
      .backgroundColor($r("app.color.default_background_color"))
   }
}

@Extend(Text) function statusTextStyle(){
   .fontColor($r('app.color.default_font_color'))
   .fontSize($r('app.float.default_font_size'))
   .backgroundColor($r('app.color.hyaline_background_color'))
   .width("90%")
   .height("16%")
   .margin({
      left : '5%'
   })
}

@Component
struct titleView{
   build() {
      Row(){
         RelativeContainer(){
            Text("QPlayer2 播放相关信息")
               .fontColor($r('app.color.default_font_color'))
               .fontSize($r('app.float.default_font_size'))
               .backgroundColor($r('app.color.hyaline_background_color'))
               .width("95%")
               .height("100%")
               .margin({
                  left: '5%'
               })
               .id("title_view_text")
         }
      }
      .height("100%")
      .width("100%")
      .backgroundColor($r('app.color.long_video_title_view_background_color'))
   }
}