import { QPlayerSeek } from '@qiniu/qplayer2-core/qplayer2-core'
import { QSettingPersistentStorageHelper } from '../../common/helper/QSettingPersistentStorageHelper'
import { Context } from '@ohos.abilityAccessCtrl'

@Observed
export class QPlayerSettingModel{
  public mSeekMode :QPlayerSeek = QPlayerSeek.NORMAL
  public mBackgroundPlay : number = 1
  constructor() {
  }
}