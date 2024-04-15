import { Context } from '@ohos.abilityAccessCtrl';
import fileIo from '@ohos.file.fs';
import { ArrayList, util } from '@kit.ArkTS';
import { QPlayerDemoMediaModel } from '../../model/longVideo/QPlayerDemoMediaModel';
import { QPlayerCreateMediaModelHelper } from './QPlayerCreateMediaModelHelper';
import { QPlayerDemoStreamElement } from '../../model/longVideo/QPlayerDemoStreamElement';
import map from '@hms.core.map.map';

interface  UrlJsonElementModel{
  userType: String
  urlType : Number
  url: String
  quality: Number,
  isSelected: Boolean
  backupUrl: String
  referer: String
  mp4QNDrmComKey : String
  mp4QNDrmFileKey : String
}
interface  UrlJsonModel{
  name : String
  isLive : Boolean
  streamElements : Array<UrlJsonElementModel>
}

export class QUrlJsonReadWriteHelper{
  static read(context : Context,url_model_call_back :(url_models : Array<QPlayerDemoMediaModel>)=>void){
    let value = context.resourceManager.getRawFileContentSync('urls.json')
    const url_decoder = util.TextDecoder.create("utf-8")
    let url_string = url_decoder.decodeWithStream(value, { stream: false })
    let url_jsons : Array<UrlJsonModel> = JSON.parse(url_string)
    let model : ArrayList<QPlayerDemoMediaModel> = new ArrayList()
    url_jsons.forEach(element=>{
      let elements : ArrayList<QPlayerDemoStreamElement> = new ArrayList()
      element.streamElements.forEach(stream_element=>{
        let inner_stream : QPlayerDemoStreamElement = new QPlayerDemoStreamElement(stream_element.userType,
          stream_element.urlType.valueOf(),
          stream_element.url,
          stream_element.quality,
          stream_element.isSelected,
          stream_element.backupUrl,
          stream_element.referer)
        elements.add(inner_stream)
      })
      model.add(new QPlayerDemoMediaModel(element.name,QPlayerCreateMediaModelHelper.create(element.isLive,elements.convertToArray())))
    })
    url_model_call_back(model.convertToArray())
  }
}