import { QMediaModel } from '@qiniu/qplayer2-core'
import { QUrlJsonReadWriteHelper } from '../../common/Helper/QUrlJsonReadWriteHelper'


@Observed
export class QPlayerDemoShortMediaModels{
  public mMediaModels : Array<QPlayerDemoShortMediaModel> = new Array()
  constructor(context :Context) {
    QUrlJsonReadWriteHelper.readShortVideoUrl(context,(url_models)=>{
      this.mMediaModels = url_models
    })
  }
}

@Observed
export class QPlayerDemoShortMediaModel{
  public mCoverImageName : String = ""
  public mMediaModel : QMediaModel
  constructor(coverImageName : String, media_model : QMediaModel) {
    this.mCoverImageName = coverImageName
    this.mMediaModel = media_model
  }
}