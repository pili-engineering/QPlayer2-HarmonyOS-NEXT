import router from '@ohos.router'
import {} from './view/longVideo/QLongVideoView'

import connection from '@ohos.net.connection';
import { BusinessError } from '@ohos.base';
import { bundleManager, common } from '@kit.AbilityKit';
import BuildProfile from 'BuildProfile'
import window from '@ohos.window';
import { App } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State color : ResourceColor = "#ff9d0808"
  @State installTime : string = new Date(bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).installTime).toLocaleString()
  @State updataTime : string = new Date(bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).updateTime).toLocaleString()
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

        Button("短视频")
          .width('70%')
          .height($r('app.float.index_button_height'))
          .onClick(()=>{
            router.pushUrl({
              url : 'pages/view/shortVideo/QShortVideoView'
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
          .height($r('app.float.index_label_height'))
        //这里用到了自动生成的 BuildProfile 文件，rebuild 会清理掉 BuildProfile 导致报错，可以用 clean + run(上面那个三角图标，或者爬虫的图标) 代替
        Text("sdkVersion : " + BuildProfile.qplayer2_version)
          .width('70%')
          .height($r('app.float.index_label_height'))
        Text("构建时间 : " + bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).vendor)
          .width('70%')
          .height($r('app.float.index_label_height'))
      }
      .width('100%')
    }
    .height('100%')
  }
  aboutToAppear(): void {
  }
}