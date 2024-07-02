import { QMediaModel, QPlayerUrlType, QStreamElement } from '@qiniu/qplayer2-core/qplayer2-core'
import { QUrlJsonReadWriteHelper } from '../../common/helper/QUrlJsonReadWriteHelper'

@Observed
export class QPlayerDemoMediaModels{
  public mMediaModels : Array<QPlayerDemoMediaModel> = new Array()
  constructor(context :Context) {
    QUrlJsonReadWriteHelper.read(context,(url_models)=>{
      this.mMediaModels = url_models
    })
  }
}

@Observed
export class QPlayerDemoMediaModel{
  public mName : String = ""
  public mMediaModel : QMediaModel
  constructor(name : String, media_model : QMediaModel) {
    this.mName = name
    this.mMediaModel = media_model
  }
}