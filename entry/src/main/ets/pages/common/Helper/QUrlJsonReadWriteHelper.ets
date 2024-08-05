import { Context } from '@ohos.abilityAccessCtrl';
import fileIo from '@ohos.file.fs';
import { ArrayList, util } from '@kit.ArkTS';
import { QPlayerDemoMediaModel } from '../../model/longVideo/QPlayerDemoMediaModel';
import { QPlayerCreateMediaModelHelper } from './QPlayerCreateMediaModelHelper';
import { QPlayerDemoStreamElement } from '../../model/longVideo/QPlayerDemoStreamElement';
import { QNPlayItem } from '../../model/shortVideo/manager/QNPlayItem';

interface  UrlJsonElementModel{
  userType: string
  urlType : number
  url: string
  quality: number,
  isSelected: boolean
  backupUrl: string
  referer: string
  mp4QNDrmComKey : string
  mp4QNDrmFileKey : string
}
interface  UrlJsonModel{
  name : string
  isLive : boolean
  streamElements : Array<UrlJsonElementModel>
}
interface  ShortVideoUrlJsonModel{
  coverImageName : string
  isLive : boolean
  streamElements : Array<UrlJsonElementModel>
}
export class QUrlJsonReadWriteHelper{
  static readLongVideoUrl(context : Context,url_model_call_back :(url_models : Array<QPlayerDemoMediaModel>)=>void){
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

  static readShortVideoUrl(context : Context,url_model_call_back :(url_models : ArrayList<QNPlayItem>)=>void){
    let value = context.resourceManager.getRawFileContentSync('shortVideoUrls.json')
    const url_decoder = util.TextDecoder.create("utf-8")
    let url_string = url_decoder.decodeWithStream(value, { stream: false })
    let url_jsons : Array<ShortVideoUrlJsonModel> = JSON.parse(url_string)
    let model : ArrayList<QNPlayItem> = new ArrayList()
    url_jsons.forEach((element,value)=>{
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
      model.add(new QNPlayItem(value,QPlayerCreateMediaModelHelper.create(element.isLive,elements.convertToArray()),element.coverImageName))
    })
    url_model_call_back(model)
  }
}