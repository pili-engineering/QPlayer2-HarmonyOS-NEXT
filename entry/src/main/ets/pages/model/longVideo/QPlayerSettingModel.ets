import { QPlayerDecoderPriority, QPlayerSeek } from '@QN/QPlayer2-core/qplayer2-core'
import { QSettingPersistentStorageHelper } from '../../common/helper/QSettingPersistentStorageHelper'
import { Context } from '@ohos.abilityAccessCtrl'
import { QPlayerDecoderType } from '@QN/QPlayer2-core/src/main/ets/public/enums/QPlayerDecoderType'

@Observed
export class QPlayerSettingModel{
  public mSeekMode :QPlayerSeek = QPlayerSeek.NORMAL
  public mBackgroundPlay : number = 1
  public mDecoderType : QPlayerDecoderPriority = QPlayerDecoderPriority.AUTO
  constructor() {
  }
}