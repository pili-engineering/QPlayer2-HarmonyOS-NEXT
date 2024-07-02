# QPlayer2



Qplayer2是一款跨平台的播放器SDK,除了基础的播放器能力外，更致力于各种应用场景的对接。

注：preview 版本为预览版，仅支持基础功能，其他功能将陆续开放

播放器 SDK 合规使用说明请参考[七牛 SDK 合规使用说明](https://developer.qiniu.com/pili/12616/sdk-compliance-instructions)；隐私政策说明请参考[七牛 SDK 隐私策略](https://developer.qiniu.com/pili/8027/sdk-privacy-policy)

### 支持的平台

 Platform | Build Status
 -------- | ------------
 Android | https://github.com/pili-engineering/QPlayer2-Android 
 IOS |https://github.com/pili-engineering/QPlayer2-IOS
 Windows | https://github.com/pili-engineering/QPlayer2-Windows 
 HarmonyOS NEXT | Last Version: 1.5.0-preview2 
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

| 类别     | 说明                                                 |
| -------- | ---------------------------------------------------- |
| 系统版本 | 版本为 3.0.0.22 的 harmony-next 手机                 |
| IDE 版本 | DevEco Studio NEXT Developer Beta1 version 5.0.3.300 |



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
    "@qiniu/qplayer2-core": "^1.5.0-preview2",  //依赖 open harmony 中心仓
  }
}
```

##### 鉴权

| 权限 | 说明         | 鉴权失败结果        |
| ---- | ------------ | ------------------- |
| Base | 基础播放能力 | 播放器进入error状态 |

如需使用该套sdk到其他工程中，可通过 400-808-9176 联系七牛商务开通帐号和权限 或者 通过 [工单](https://support.qiniu.com/?ref=developer.qiniu.com) 联系七牛的技术支持。





##### 接入文档

https://developer.qiniu.io/pili/12702/qplayer2-harmony



##### Demo介绍

1. demo 工程内的 长视频播放页 是基于 qplayer2-core 来实现的

1. demo 下载：https://sdk-release.qiniushawn.top/qplayer2-demo-v1.5.0-preview2.hap

1.  电脑连接 harmony next 手机，执行下方命令安装 hap 包

   ```awk
   hdc install qplayer2-demo-v1.5.0-preview2.hap
   ```

   

   

##### 技术支持与交流

产品及服务咨询：400-808-9176

问题反馈：如有问题请提交issue

