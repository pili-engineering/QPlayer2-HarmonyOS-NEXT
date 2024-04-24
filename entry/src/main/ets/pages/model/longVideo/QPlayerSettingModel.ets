import { QPlayerSeek } from '@QN/QPlayer2-core/Index'
import { QSettingPersistentStorageHelper } from '../../common/helper/QSettingPersistentStorageHelper'
import { Context } from '@ohos.abilityAccessCtrl'

@Observed
export class QPlayerSettingModel{
  public mSeekMode :QPlayerSeek = QPlayerSeek.NORMAL
  constructor() {
  }
}