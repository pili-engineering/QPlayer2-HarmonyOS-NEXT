import { QPlayerUrlType, QVideoRenderType } from '@qiniu/qplayer2-core/qplayer2-core'

export class QPlayerDemoStreamElement{
  public readonly userType : string = ""
  public readonly urlType : QPlayerUrlType = QPlayerUrlType.QAUDIO_AND_VIDEO
  public readonly url : string = ""
  public readonly quality : number = 0
  public readonly isSelected : boolean = false
  public readonly backupUrl : string = ""
  public readonly referer : string = ""
  public readonly renderType : QVideoRenderType = QVideoRenderType.PLANE
  public readonly hlsDrmKey:string = ""
  public readonly mp4DrmKey :string =""
  public readonly mp4QNDrmComKey : string =""
  public readonly mp4QNDrmFileKey : string =""
  constructor(user_type:string,
    url_type : QPlayerUrlType,
    url : string,
    quality : number,
    is_selected : boolean,
    backup_url : string,
    referer : string,
    renderType : QVideoRenderType,
    hlsDrmKey : string,
    mp4DrmKey :string,
    mp4QNDrmComKey : string,
    mp4QNDrmFileKey : string) {
    this.userType = user_type
    this.urlType = url_type
    this.url = url
    this.quality = quality
    this.isSelected = is_selected
    this.backupUrl = backup_url
    this.referer = referer
    this.renderType = renderType
    this.hlsDrmKey = hlsDrmKey
    this.mp4DrmKey = mp4DrmKey
    this.mp4QNDrmComKey = mp4QNDrmComKey
    this.mp4QNDrmFileKey = mp4QNDrmFileKey
  }
}