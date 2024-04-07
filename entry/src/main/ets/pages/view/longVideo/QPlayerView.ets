import { QPlayerDecodeType } from '../../common/enum/QPlayerDecodeType'
import { QIPlayerSetting } from '../../interface/longVideo/QPlayerSettingInterface'
import { QPlayerSettingViewModel } from '../../viewModel/longVideo/QPlayerSettingViewModel'
import { QMaskView } from './QMaskView'
import { window } from '@kit.ArkUI'
import {QSurfaceRenderView} from '@QN/QPlayer2-core'
@Component
export struct QPlayerView{
  private mQPlayerTimerCount : Number = 0
  private mQPlayerTimerId : Number = 0
  private mQPlayerIsTimerStart : Boolean = false
  @Link PlayerSettingViewModel: QPlayerSettingViewModel
  @State mMaskHide : Visibility = Visibility.Visible
  @Link mDeviceOrientation : window.Orientation
  private mSettingCallBacks : QIPlayerSetting = {
    decoderUpdating : (decoder_type:QPlayerDecodeType)=>{
      console.info("----------decoderUpdating log--------")
    }
  }
  build(){
    Row() {
      Stack(){

        QSurfaceRenderView()
          .width('100%')
          .height('100%')

        Column(){
        }
        .width('100%')
        .height('100%')
        .backgroundColor("#00000000")
        .onClick(() => {
          this.startTimer()
        })

        QMaskView({PlayerSettingViewModel:this.PlayerSettingViewModel,mDeviceOrientation:this.mDeviceOrientation})
          .width('100%')
          .height('100%')
          .backgroundColor('#801d1d1d')
          .onClick(() => {
            this.startTimer()
          })
          .visibility(this.mMaskHide)
      }
    }
    .height("100%")
    .width("100%")
  }
  aboutToAppear(): void {
    let ss = this.mMaskHide.toString()
    this.startTimer()
    // addQPlayerSetting 提示undefined ，crush，待解决
    // this.PlayerSettingViewModel.addQPlayerSetting(this.mSettingCallBacks)
    // this.settingDefault()
    let i = 0
  }
  settingDefault(){
    this.PlayerSettingViewModel.addQPlayerSetting(this.mSettingCallBacks)
  }
  maskShowAndHide() {
    if (this.mMaskHide === Visibility.Hidden) {
      this.mMaskHide = Visibility.Visible
    }
    else {
      this.mMaskHide = Visibility.Hidden
    }
  }
  startTimer(){
    if(this.mQPlayerIsTimerStart){
      clearInterval(this.mQPlayerTimerId.valueOf())
      this.mQPlayerTimerCount = 0
      this.mQPlayerIsTimerStart = false
      this.mMaskHide = Visibility.Hidden
    }else {
      this.mMaskHide = Visibility.Visible
      this.mQPlayerIsTimerStart = true
      this.mQPlayerTimerId = setInterval(()=>{
        this.mQPlayerTimerCount = this.mQPlayerTimerCount.valueOf() + 1
        if (this.mQPlayerTimerCount.valueOf() == 10) {
          clearInterval(this.mQPlayerTimerId.valueOf())
          this.mQPlayerTimerCount = 0
          this.mQPlayerIsTimerStart = false
          this.mMaskHide = Visibility.Hidden
        }
      },1000)
    }
  }
}
