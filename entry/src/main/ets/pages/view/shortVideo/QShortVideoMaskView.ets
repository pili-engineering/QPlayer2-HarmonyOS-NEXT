import { QIPlayerContext } from '@qiniu/qplayer2-core'
import { QShortVideoMaskBottom } from './QShortVideoMaskBottom'

@Component
export struct QShortVideoMaskView{

  public mPlayerContext : QIPlayerContext | null = null
  build() {
    Column() {
      RelativeContainer() {
        QShortVideoMaskBottom({mPlayerContext : this.mPlayerContext})
          .height($r('app.float.long_video_bottom_view_height'))
          .alignRules({
            bottom : {anchor : "__container__" , align : VerticalAlign.Bottom},
            left : {anchor : "__container__" , align : HorizontalAlign.Start},
            right : {anchor : "__container__" , align : HorizontalAlign.End}
          })
          .margin({bottom: 0})
          .backgroundColor('#00000000')
          .id('short_video_mask_bottom_view')
      }
      .width("100%")
      .height("100%")
      .id("short_relative")
    }
    .width("100%")
    .height("100%")
    .id("short_column")
  }
}