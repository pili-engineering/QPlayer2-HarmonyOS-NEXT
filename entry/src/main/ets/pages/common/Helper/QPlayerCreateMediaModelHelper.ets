import { ArrayList } from '@kit.ArkTS';
import { QMediaModel, QMediaModelBuilder } from '@qiniu/qplayer2-core/qplayer2-core';
import { QPlayerDemoStreamElement } from '../../model/longVideo/QPlayerDemoStreamElement';

export class  QPlayerCreateMediaModelHelper{
  static create(is_live: boolean, demo_streams: Array<QPlayerDemoStreamElement>) : QMediaModel{
    let builder : QMediaModelBuilder = new QMediaModelBuilder()
    demo_streams.forEach(element => {
      builder.addStreamElement(element.userType,element.urlType,element.quality.valueOf(),element.url,element.isSelected,element.referer,element.backupUrl,element.hlsDrmKey,element.mp4DrmKey,element.mp4QNDrmComKey,element.mp4QNDrmFileKey)
    });
    return builder.build(is_live)
  }

}
