import router from '@ohos.router'
import {} from './view/longVideo/QLongVideoView'

import connection from '@ohos.net.connection';
import { BusinessError } from '@ohos.base';
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

              // 使用默认网络解析主机名以获取所有IP地址
              let ss = connection.hasDefaultNetSync();
              if (error) {
                console.error(`Invoke pushUrl failed, code is ${error.code}, message is ${error.message}`);
                return
              }
              console.info('Invoke pushUrl succeeded.')
            })
          })

        Button("初始化设置")
          .width('70%')
          .height($r('app.float.index_button_height'))
          .onClick(()=>{
            router.pushUrl({
              url : 'pages/view/playerDefaultSetting/QPlayerDefaultSettingView'
            },router.RouterMode.Standard,(error)=>{
              if (error) {
                console.error(`Invoke pushUrl failed, code is ${error.code}, message is ${error.message}`);
                return
              }
              console.info('Invoke pushUrl succeeded.')
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}