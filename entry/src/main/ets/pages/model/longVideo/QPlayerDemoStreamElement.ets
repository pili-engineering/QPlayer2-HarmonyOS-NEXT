import { QPlayerUrlType } from '@qiniu/qplayer2-core/qplayer2-core'

export class QPlayerDemoStreamElement{
  public mUserType : string = ""
  public mUrlType : QPlayerUrlType = QPlayerUrlType.QAUDIO_AND_VIDEO
  public mUrl : string = ""
  public mQuality : number = 0
  public mIsSelected : boolean = false
  public mBackupUrl : string = ""
  public mReferer : string = ""
  constructor(user_type:string, url_type : QPlayerUrlType, url : string, quality : number, is_selected : boolean, backup_url : string, referer : string) {
    this.mUserType = user_type
    this.mUrlType = url_type
    this.mUrl = url
    this.mQuality = quality
    this.mIsSelected = is_selected
    this.mBackupUrl = backup_url
    this.mReferer = referer
  }
}