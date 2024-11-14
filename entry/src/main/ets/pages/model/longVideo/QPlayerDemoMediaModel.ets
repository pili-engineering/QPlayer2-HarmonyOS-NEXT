import { QMediaModel, QPlayerUrlType, QStreamElement } from '@qiniu/qplayer2-core/qplayer2-core'
import { QUrlJsonReadWriteHelper } from '../../common/helper/QUrlJsonReadWriteHelper'
import { ArrayList } from '@kit.ArkTS'

@Observed
export class QPlayerDemoMediaModels{
  public mMediaModels : ArrayList<QPlayerDemoMediaModel> | null = new ArrayList()
  constructor(context :Context) {
    QUrlJsonReadWriteHelper.readLongVideoUrl(context,(url_models)=>{
      this.mMediaModels = url_models
    })
  }
  release(){
    this.mMediaModels?.clear()
    this.mMediaModels = null;
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