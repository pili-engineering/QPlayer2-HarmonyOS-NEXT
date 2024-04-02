import { QPlayerDecodeType } from '../../common/enum/QPlayerDecodeType'

export interface QIPlayerSetting{
  decoderUpdating:(decoder_type:QPlayerDecodeType)=>void
}