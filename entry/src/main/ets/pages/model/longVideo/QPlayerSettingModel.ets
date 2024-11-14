
import { QBlindType, QPlayerDecoderPriority,
  QPlayerMirror,
  QPlayerSeek,
  QPlayerStart,
  QRenderRatio } from '@qiniu/qplayer2-core/qplayer2-core'
import { QSettingPersistentStorageHelper } from '../../common/helper/QSettingPersistentStorageHelper'
import { Context } from '@ohos.abilityAccessCtrl'

export enum PlaySpeed{
  SPEED_0_5,
  SPEED_0_75,
  SPEED_1_0,
  SPEED_1_25,
  SPEED_1_5,
  SPEED_2_0
}
export enum Immediately{
  IMMEDIATELY_TRUE = 0,
  IMMEDIATELY_FALSE = 1,
  IMMEDIATELY_MIX = 2
}
@Observed
export class QPlayerSettingModel{
  public mSeekMode :QPlayerSeek = QPlayerSeek.NORMAL
  public mBackgroundPlay : number = 1
  public mDecoderType : QPlayerDecoderPriority = QPlayerDecoderPriority.AUTO
  public mPlaySpeed : PlaySpeed = PlaySpeed.SPEED_1_0
  public mRenderRatio : QRenderRatio = QRenderRatio.AUTO
  public mBlinderType : QBlindType = QBlindType.NONE
  public mPosition : number = 0
  public mSEIEnable : number = 0
  public mStartAction : QPlayerStart = QPlayerStart.PLAYING
  public mImmediately : Immediately = Immediately.IMMEDIATELY_TRUE
  public mSubtitleEnable : number = 0
  public mForceNetworkAuth : number = 0
  public mMirrorType : QPlayerMirror = QPlayerMirror.MIRROR_NONE
  public mRotation : number = 0
  public mScale : number = 0
  constructor() {
  }
}