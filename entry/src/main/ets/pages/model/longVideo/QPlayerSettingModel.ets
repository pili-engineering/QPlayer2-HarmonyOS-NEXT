
import { QBlindType, QPlayerDecoderPriority, QPlayerSeek, QRenderRatio } from '@qiniu/qplayer2-core/qplayer2-core'
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
@Observed
export class QPlayerSettingModel{
  public mSeekMode :QPlayerSeek = QPlayerSeek.NORMAL
  public mBackgroundPlay : number = 1
  public mDecoderType : QPlayerDecoderPriority = QPlayerDecoderPriority.AUTO
  public mPlaySpeed : PlaySpeed = PlaySpeed.SPEED_1_0
  public mRenderRatio : QRenderRatio = QRenderRatio.AUTO
  public mBlinderType : QBlindType = QBlindType.NONE
  public mPosition : number = 0
  constructor() {
  }
}