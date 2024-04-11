import { QPlayerUrlType } from '@QN/QPlayer2-core/Index'

export class QPlayerDemoStreamElement{
  public mUserType : String = ""
  public mUrlType : QPlayerUrlType = QPlayerUrlType.QAUDIO_AND_VIDEO
  public mUrl : String = ""
  public mQuality : Number = 0
  public mIsSelected : Boolean = false
  public mBackupUrl : String = ""
  public mReferer : String = ""
  constructor(user_type:String, url_type : QPlayerUrlType, url : String, quality : Number, is_selected : Boolean, backup_url : String, referer : String) {
    this.mUserType = user_type
    this.mUrlType = url_type
    this.mUrl = url
    this.mQuality = quality
    this.mIsSelected = is_selected
    this.mBackupUrl = backup_url
    this.mReferer = referer
  }
}