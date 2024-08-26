import { QIPlayerContext,
  QIPlayerSubtitleListener,
  QMediaModel, QStreamElement, QSubtitleElement } from '@qiniu/qplayer2-core'
import { List } from '@kit.ArkTS'

@Component
export struct QMaskSubtitleSettingView {
  @Link mCurrentModel: QMediaModel | null
  private mCurrentElement: QSubtitleElement | null = null
  @Link mPlayerContext: QIPlayerContext
  @State mediaModelButtonBackgroundColorArray: Array<ResourceColor> = []
  private mSubtitleListener : QIPlayerSubtitleListener = {

    onSubtitleTextChange:(context : QIPlayerContext , text: string ) => {

    },

    onSubtitleNameChange:(context : QIPlayerContext , name: string ) => {
      this.subtitleNameChange(name)
    },

    onSubtitleEnable:(context : QIPlayerContext , enable: boolean ) => {

    },

    onSubtitleLoaded:(context : QIPlayerContext , name: string , result: boolean ) => {
    },

    onSubtitleDecoded:(context : QIPlayerContext , name: string , result: boolean ) => {
    }
  }
  build() {
    Column() {
      ForEach(this.mCurrentModel!.subtitleElements, (streamElement: QSubtitleElement, index: number) => {
        Button(streamElement.name)
          .backgroundColor($r('app.color.hyaline_background_color'))
          .margin({ top: 10 })
          .width('90%')
          .height('15%')
          .fontColor(this.mediaModelButtonBackgroundColorArray[index])
          .onClick(() => {
            this.mediaModelButtonBackgroundColorArray.forEach((resource: ResourceColor, indexOfColor: number) => {
              if (indexOfColor == index) {
                this.mediaModelButtonBackgroundColorArray[indexOfColor] =
                  $r('app.color.selected_play_speed_button_background_color')
              } else {
                this.mediaModelButtonBackgroundColorArray[indexOfColor] =
                  $r('app.color.not_selected_play_speed_button_background_color')
              }
            })
            // this.mPlayerContext.get_control_handler().setSubtitle(streamElement.name)

            this.mPlayerContext.get_control_handler().setSubtitle(streamElement.name)
            this.subtitleNameChange(streamElement.name)
            // this.mQPlayerSettingModel.mPlaySpeed = index as PlaySpeed
            // QSettingPersistentStorageHelper.save(AppStorage.get("context") as Context, this.mQPlayerSettingModel)
          })
          .type(ButtonType.Normal)
      })
    }
    .width('100%')
    .height('100%')
  }

  aboutToAppear(): void {
    let colorList: List<ResourceColor> = new List()
    this.mPlayerContext.get_control_handler().addPlayerSubtitleListener(this.mSubtitleListener)
    this.mCurrentModel!.subtitleElements.forEach((subtitleElement: QSubtitleElement, value: number) => {
      if (subtitleElement.isSelected) {
        colorList.add($r('app.color.selected_play_speed_button_background_color'))
      } else {
        colorList.add($r('app.color.not_selected_play_speed_button_background_color'))
      }
    })
    this.mediaModelButtonBackgroundColorArray = colorList.convertToArray()
  }

  subtitleNameChange(name: string) {
    let colorList: List<ResourceColor> = new List()
    this.mCurrentModel!.subtitleElements.forEach((element: QSubtitleElement, index: number) => {
      if (name == element.name) {
        colorList.add($r('app.color.selected_play_speed_button_background_color'))
        this.mCurrentElement = element
      } else {
        colorList.add($r('app.color.not_selected_play_speed_button_background_color'))
      }
    })
    this.mediaModelButtonBackgroundColorArray = colorList.convertToArray()
  }
}