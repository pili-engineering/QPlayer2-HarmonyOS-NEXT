import { Context } from '@ohos.abilityAccessCtrl';
import fileIo from '@ohos.file.fs';
import { ArrayList, stream, util } from '@kit.ArkTS';
import { QPlayerDemoMediaModel } from '../../model/longVideo/QPlayerDemoMediaModel';
import { QPlayerCreateMediaModelHelper } from './QPlayerCreateMediaModelHelper';
import { QPlayerDemoStreamElement } from '../../model/longVideo/QPlayerDemoStreamElement';
import { QNPlayItem } from '../../model/shortVideo/manager/QNPlayItem';
import { QPlayerDemoSubtitleElement } from '../../model/longVideo/QPlayerDemoSubtitleElement';
import { QVideoRenderType } from '@qiniu/qplayer2-core';

interface  UrlJsonElementModel{
  userType: string
  urlType : number
  url: string
  quality: number,
  isSelected: boolean
  backupUrl: string
  referer: string
  renderType?:number
  hlsDrmKey?:string
  mp4DrmKey? :string
  mp4QNDrmComKey? : string
  mp4QNDrmFileKey? : string
}
interface  UrlJsonSubtitleElementModel{
  name: string;
  url: string;
  isSelected: boolean;
}
interface  UrlJsonModel{
  name : string
  isLive : boolean
  streamElements : Array<UrlJsonElementModel>
  subtitleElements : Array<UrlJsonSubtitleElementModel>
}
interface  ShortVideoUrlJsonModel{
  coverImageName : string
  isLive : boolean
  streamElements : Array<UrlJsonElementModel>
  subtitleElements : Array<UrlJsonSubtitleElementModel>
}
export class QUrlJsonReadWriteHelper{
  static readLongVideoUrl(context : Context,url_model_call_back :(url_models : ArrayList<QPlayerDemoMediaModel>)=>void){
    let value = context.resourceManager.getRawFileContentSync('urls.json')
    const url_decoder = util.TextDecoder.create("utf-8")
    let url_string = url_decoder.decodeWithStream(value, { stream: false })
    let url_jsons : Array<UrlJsonModel> = JSON.parse(url_string)
    let model : ArrayList<QPlayerDemoMediaModel> = new ArrayList()
    url_jsons.forEach(element => {
      let elements : ArrayList<QPlayerDemoStreamElement> = new ArrayList()
      element.streamElements.forEach(stream=>{
        let innerStream : QPlayerDemoStreamElement = new QPlayerDemoStreamElement(stream.userType,
          stream.urlType.valueOf(),
          stream.url,
          stream.quality,
          stream.isSelected,
          stream.backupUrl,
          stream.referer,
          stream.renderType? stream.renderType as QVideoRenderType : QVideoRenderType.PLANE,
          stream.hlsDrmKey?stream.hlsDrmKey : "",
          stream.mp4DrmKey?stream.mp4DrmKey : "",
          stream.mp4QNDrmComKey?stream.mp4QNDrmComKey : "",
          stream.mp4QNDrmFileKey?stream.mp4QNDrmFileKey : "")
        elements.add(innerStream)
      })
      let subtitleElements : ArrayList<QPlayerDemoSubtitleElement> = new ArrayList()
      if (element.subtitleElements == undefined){
        element.subtitleElements = new Array()
      }
      element.subtitleElements.forEach(subtitle => {
        let innerSubtitle : QPlayerDemoSubtitleElement = new QPlayerDemoSubtitleElement(
          subtitle.name,
          subtitle.url,
          subtitle.isSelected
        )
        subtitleElements.add(innerSubtitle)
      })
      model.add(new QPlayerDemoMediaModel(element.name,QPlayerCreateMediaModelHelper.create(element.isLive,elements.convertToArray(),subtitleElements.convertToArray())))

    })
    url_model_call_back(model)
  }

  static readShortVideoUrl(context : Context, url_model_call_back :(url_models : ArrayList<QNPlayItem>)=>void){
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
          stream_element.referer,
          stream_element.renderType? stream_element.renderType as QVideoRenderType : QVideoRenderType.PLANE,
          "","","","")
        elements.add(inner_stream)
      })
      let subtitleElements : ArrayList<QPlayerDemoSubtitleElement> = new ArrayList()
      if (element.subtitleElements != undefined){
        element.subtitleElements.forEach(subtitle => {
          let innerSubtitle : QPlayerDemoSubtitleElement = new QPlayerDemoSubtitleElement(
            subtitle.name,
            subtitle.url,
            subtitle.isSelected
          )
          subtitleElements.add(innerSubtitle)
        })
      }
      model.add(new QNPlayItem(value,QPlayerCreateMediaModelHelper.create(element.isLive,elements.convertToArray(),subtitleElements.convertToArray()),element.coverImageName))
    })
    url_model_call_back(model)
  }
}