import { QPlayerSeek } from '@QN/QPlayer2-core/Index'

@Observed
export class QPlayerSettingModel{
  public mSeekMode :QPlayerSeek = QPlayerSeek.QPLAYER_SEEK_SETTING_NORMAL
  constructor() {
  }
}