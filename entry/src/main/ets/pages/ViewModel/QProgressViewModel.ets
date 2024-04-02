import { QProgressModel } from '../model/QProgressModel'

@Observed
export class QProgressViewModel{
  mProgressModel : QProgressModel
  mBarStep : Number
  constructor(progress: Number, duration : Number , barStep : Number) {
    this.mProgressModel = new QProgressModel(progress,duration)
    this.mBarStep = barStep
  }

  setProgress(progress:Number){
    this.mProgressModel.setProgress(progress)
  }
  getProgress():Number{
    return this.mProgressModel.getProgress()
  }
  setDuration(duration:Number){
    this.mProgressModel.setDuration(duration)
  }
}