
export class QProgressModel{
  mDuration : Number = 0
  mProgress : Number = 0

  constructor(duration:Number , progress: Number) {
    this.mDuration = duration
    this.mProgress = progress

  }

  setDuration(duration:Number){
    this.mDuration = duration
  }

  getDuration():Number{
    return this.mDuration
  }

  setProgress(progress:Number){
    this.mProgress = progress
  }

  getProgress():Number{
    return this.mProgress
  }

}