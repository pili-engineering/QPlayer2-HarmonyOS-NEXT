# QPlayer2



Qplayer2是一款跨平台的播放器SDK,除了基础的播放器能力外，更致力于各种应用场景的对接。

播放器 SDK 合规使用说明请参考[七牛 SDK 合规使用说明](https://developer.qiniu.com/pili/12616/sdk-compliance-instructions)；隐私政策说明请参考[七牛 SDK 隐私策略](https://developer.qiniu.com/pili/8027/sdk-privacy-policy)

### 支持的平台

 Platform | Build Status
 -------- | ------------
 Android | https://github.com/pili-engineering/QPlayer2-Android 
 IOS |https://github.com/pili-engineering/QPlayer2-IOS
 Windows | https://github.com/pili-engineering/QPlayer2-Windows 
 HarmonyOS NEXT | Last Version: 1.5.0 
 Mac | 敬请期待 
 Linux | 敬请期待 
### qplayer2-core 功能列表

| 能力                  | 亮点                                                         | 备注                             |
| --------------------- | ------------------------------------------------------------ | -------------------------------- |
| 媒体资源组成形式      | 一个媒体资源支持多url，比如一个音频url和一个视频url组成一个媒体资源,提升拉流速度和解封装速度 |                                  |
| 播放协议及视频类型    | http/https/rtmp flv/m3u8/mp4/flac/wav(PCM_S24LE)             | 新增协议和视频类型请联系技术支持 |
| 解码                  | 软解/硬解/自动解码                                           |                                  |
| 色盲模式              | 能在业务场景中更好的服务视觉有障碍的客户                     |                                  |
| 倍速                  | 变速不变调                                                   |                                  |
| 清晰度切换            | 通用清晰度切换方案，无缝切换，即使媒体资源gop不对齐          |                                  |
| seek                  | 支持精准/关键帧 seek 两种方式                                |                                  |
| 指定起播位置          | 从指定位置开始播放                                           |                                  |
| 起播方式              | 起播播放/起播暂停 设置起播暂停时，起播后首帧渲染出来就停止画面 |                                  |
| SEI数据回调           | 所有解码方式都支持                                           |                                  |
| 纯音频播放/纯视频播放 | 播放只有单音频流或者只有单视频流的视频                       |                                  |
| VR视频                | 支持Equirect-Angular类型的vr视频播放                         |                                  |
| 后台播放              | 支持设置是否开启后台播放                                     |                                  |
| 预加载                | 提前加载点播视频，获得更好的首帧体验                         |                                  |
| 截图                  | 自动转换成jpeg格式，可以展示在UI上，也可存放到相册           |                                  |
| 缩放/旋转/镜像        | 方便用户对视频画面进行一些自定义操作                         |                                  |
| 字幕                  | 支持srt字幕文件加载并根据时间回调当前时间的文案给上层        |                                  |
| DRM                   | 支持HLS 私有加密/通用加密 2种方式，支持 MP4 CENC-AES-CTR 加密，支持七牛私有 MP4 加密方式 |                                  |
| 音视频数据上抛        | 适用于业务层需要获取当前播放的音视频数据的场景（比如推流等） |                                  |



## 环境要求

| 类别     | 说明                                         |
| -------- | -------------------------------------------- |
| 系统版本 | 版本为 5.0.0.102 的 harmony-next 手机        |
| IDE 版本 | DevEco Studio NEXT Release version 5.0.3.900 |



## 权限要求

```
  {
    "name": "ohos.permission.INTERNET"
  },
  {
    "name": "ohos.permission.GET_NETWORK_INFO"
  },
  {
    "name": "ohos.permission.KEEP_BACKGROUND_RUNNING"
  }
```

### Harmony



##### 引入依赖

须在 oh-package.json5 文件中 dependencies 字段中列出引用的三方库，sdk 在demo 工程的dependency 目录下。

```awk
{
  "dependencies": {
    "@qiniu/qplayer2-core": "^1.5.0",  //依赖 open harmony 中心仓
  }
}
```

##### 鉴权

| 权限  | 说明         | 鉴权失败结果                                                 |
| ----- | ------------ | ------------------------------------------------------------ |
| Base  | 基础播放能力 | 播放器进入error状态                                          |
| VR    | 播放VR视频   | 播放vr视频，起播后播放器进入error状态                        |
| SEI   | SEI数据回调  | 开启sei 回调，且视频有sei数据。能正常播放视频，SEI数据不回调，同时抛出鉴权失败错误码 |
| BLIND | 色盲滤镜     | 开启色盲滤镜，视频正常播放，滤镜不生效。                     |
| APM   | 性能埋点上报 | 关闭埋点上报，不影响播放器核心功能使用                       |

如需使用该套sdk到其他工程中，可通过 400-808-9176 联系七牛商务开通帐号和权限 或者 通过 [工单](https://support.qiniu.com/?ref=developer.qiniu.com) 联系七牛的技术支持。





##### 接入文档

https://developer.qiniu.io/pili/12702/qplayer2-harmony



##### Demo介绍

1. demo 工程内的 长视频播放页 是基于 qplayer2-core 来实现的

1. demo 下载：https://sdk-release.qnsdk.com/qplayer2-demo-v1.5.0.hap

1.  电脑连接 harmony next 手机，执行下方命令安装 hap 包

   ```awk
   hdc install qplayer2-demo-v1.5.0.hap
   ```

   

   

##### 技术支持与交流

产品及服务咨询：400-808-9176

问题反馈：如有问题请提交issue

