import router from '@ohos.router'
import { QSettingPersistentStorageHelper } from './common/Helper/QSettingPersistentStorageHelper'
import { QPlayerSettingModel } from './model/longVideo/QPlayerSettingModel'
import {} from './view/longVideo/QLongVideoView'
import { Context } from '@ohos.abilityAccessCtrl'

@Entry
@Component
struct Index {
  build() {
    Row() {

      Column({space:20}) {
        Button("长视频")
          .width('70%')
          .height($r('app.float.index_button_height'))
          .onClick(()=>{
            router.pushUrl({
              url: 'pages/view/longVideo/QLongVideoView'
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