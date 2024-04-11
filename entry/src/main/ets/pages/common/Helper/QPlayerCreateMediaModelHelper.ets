import { ArrayList } from '@kit.ArkTS';
import { QMediaModel, QMediaModelBuilder } from '@QN/QPlayer2-core/Index';
import { QPlayerDemoStreamElement } from '../../model/longVideo/QPlayerDemoStreamElement';

export class  QPlayerCreateMediaModelHelper{
  static create(is_live: Boolean, demo_streams: Array<QPlayerDemoStreamElement>) : QMediaModel{
    let builder : QMediaModelBuilder = new QMediaModelBuilder()
    demo_streams.forEach(element => {
      builder.addStreamElement(element.mUserType,element.mUrlType,element.mQuality.valueOf(),element.mUrl,element.mIsSelected,element.mReferer,element.mBackupUrl)
    });
    return builder.build(is_live)
  }

}
