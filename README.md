# QPlayer2



Qplayer2是一款跨平台的播放器SDK,除了基础的播放器能力外，更致力于各种应用场景的对接。

注：preview 版本为预览版，仅支持基础功能，其他功能将陆续开放

### 支持的平台

 Platform | Build Status
 -------- | ------------
 Android | https://github.com/pili-engineering/QPlayer2-Android 
 IOS |https://github.com/pili-engineering/QPlayer2-IOS
 Windows | https://github.com/pili-engineering/QPlayer2-Windows 
 HarmonyOS NEXT | Last Version: 1.5.0-preview 
 Mac | 敬请期待 
 Linux | 敬请期待 
### qplayer2-core 功能列表

| 能力               | 亮点                                                         | 备注                             |
| ------------------ | ------------------------------------------------------------ | -------------------------------- |
| 媒体资源组成形式   | 一个媒体资源支持多url，比如一个音频url和一个视频url组成一个媒体资源,提升拉流速度和解封装速度 |                                  |
| 播放协议及视频类型 | http/https/rtmp flv/m3u8/mp4/flac/wav(PCM_S24LE)             | 新增协议和视频类型请联系技术支持 |
| 后台播放           | 支持设置是否开启后台播放                                     |                                  |
| seek               | 支持精准/关键帧 seek 两种方式                                |                                  |



## 环境要求

| 类别     | 说明                                                         |
| -------- | ------------------------------------------------------------ |
| 系统版本 | harmony api 12 及以上版本的 harmony 设备 ，系统版本 3.0.0.22 |
| IDE 版本 | DevEco Studio NEXT Developer Beta1 version 5.0.3.300         |



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

##### 下载安装

https://sdk-release.qnsdk.com/qplayer2_core-harmony-1.5.0-preview.zip



##### 引入依赖

须在 oh-package.json5 文件中 dependencies 字段中列出引用的三方库，其版本号遵循 [semver](https://www.npmjs.com/package/semver) 规范。

```awk
{
  "dependencies": {
    "@QN/QPlayer2-core" : 'file:./qplayer2_core.har',  // 本地压缩包引用
  }
}
```

##### 鉴权

| 权限 | 说明         | 鉴权失败结果        |
| ---- | ------------ | ------------------- |
| Base | 基础播放能力 | 播放器进入error状态 |

如需使用该套sdk到其他工程中，请联系我们的技术支持开通帐号和权限。





##### 接入文档

https://developer.qiniu.io/pili/12702/qplayer2-harmony



##### Demo介绍

1. demo 工程内的 长视频播放页 是基于 qplayer2-core 来实现的

1. demo 下载：https://github.com/pili-engineering/QPlayer2-HarmonyOS-NEXT

   

##### 技术支持与交流

产品及服务咨询：400-808-9176

问题反馈：如有问题请提交issue

