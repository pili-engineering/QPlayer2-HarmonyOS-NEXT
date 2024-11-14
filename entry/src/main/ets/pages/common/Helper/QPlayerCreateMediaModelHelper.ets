import { ArrayList } from '@kit.ArkTS';
import { QMediaModel, QMediaModelBuilder } from '@qiniu/qplayer2-core/qplayer2-core';
import { QPlayerDemoStreamElement } from '../../model/longVideo/QPlayerDemoStreamElement';
import { QPlayerDemoSubtitleElement } from '../../model/longVideo/QPlayerDemoSubtitleElement';

export class  QPlayerCreateMediaModelHelper{
  static create(isLive: boolean, demoStreams: Array<QPlayerDemoStreamElement>, demoSubtitles : Array<QPlayerDemoSubtitleElement>) : QMediaModel{
    let builder : QMediaModelBuilder = new QMediaModelBuilder()
    demoStreams.forEach(element => {
      builder.addStreamElement(element.userType,element.urlType,element.quality.valueOf(),element.url,element.isSelected,element.referer,element.backupUrl,element.renderType,element.hlsDrmKey,element.mp4DrmKey,element.mp4QNDrmComKey,element.mp4QNDrmFileKey)
    });

    demoSubtitles.forEach(subtitle =>{
      builder.addSubtitleElement(subtitle.name,subtitle.url,subtitle.isSelected)
    })
    return builder.build(isLive)
  }

}
