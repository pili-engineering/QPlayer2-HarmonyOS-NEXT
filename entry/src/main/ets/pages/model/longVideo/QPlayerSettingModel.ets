import { QPlayerDecodeType } from '../../common/enum/QPlayerDecodeType'

export class QPlayerSettingModel{
  private mDecoderType :QPlayerDecodeType = QPlayerDecodeType.AUTO
  constructor() {
  }
  setDecoderType(decoder_type:QPlayerDecodeType){
    this.mDecoderType = decoder_type
  }
  getDecoderType():QPlayerDecodeType{
    return this.mDecoderType
  }
}