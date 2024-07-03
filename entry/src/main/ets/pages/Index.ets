import router from '@ohos.router'
import {} from './view/longVideo/QLongVideoView'

import connection from '@ohos.net.connection';
import { BusinessError } from '@ohos.base';
import { bundleManager } from '@kit.AbilityKit';
import BuildProfile from 'BuildProfile'

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

        Text("demoVersion : " + bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).versionName)
          .width('70%')
          .height($r('app.float.index_button_height'))

        Text("sdkVersion : " + BuildProfile.qplayer2_version)
          .width('70%')
          .height($r('app.float.index_button_height'))
      }
      .width('100%')
    }
    .height('100%')
  }
}