import { QMediaModel } from '@qiniu/qplayer2-core/'

export class QNPlayItem {
  public readonly mItemId : number
  public readonly mMediaModel : QMediaModel
  public readonly mCoverUrl : string

  constructor(mItemId : number, mediaModel : QMediaModel, coverUrl : string) {
    this.mItemId = mItemId
    this.mMediaModel = mediaModel
    this.mCoverUrl = coverUrl
  }
}