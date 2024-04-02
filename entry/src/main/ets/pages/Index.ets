import router from '@ohos.router'
import {} from './view/longVideo/QLongVideoView'
import { QPlayerSettingViewModel } from './viewModel/longVideo/QPlayerSettingViewModel'

@Entry
@Component
struct Index {
  mQPlayerSettingViewModel:QPlayerSettingViewModel = new QPlayerSettingViewModel()
  build() {
    Row() {
      Column({space:20}) {
        Button("长视频")
          .width('70%')
          .height($r('app.float.index_button_height'))
          .onClick(()=>{
            router.pushUrl({
              url: 'pages/view/longVideo/QLongVideoView',
              params:{
                vm : this.mQPlayerSettingViewModel
              }
            },router.RouterMode.Standard,(error)=>{
              if (error) {
                console.error(`Invoke pushUrl failed, code is ${error.code}, message is ${error.message}`);
                return;
              }
              console.info('Invoke pushUrl succeeded.');
            })
          })

        Button("初始化设置")
          .width('70%')
          .height($r('app.float.index_button_height'))
          .onClick(()=>{
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}