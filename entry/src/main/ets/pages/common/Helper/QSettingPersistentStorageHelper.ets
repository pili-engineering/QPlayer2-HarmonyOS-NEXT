import { QPlayerSettingModel } from '../../model/longVideo/QPlayerSettingModel';
import dataPreferences from '@ohos.data.preferences';
import { Context } from '@kit.AbilityKit';
import { QPlayerSeek } from '@qiniu/qplayer2-core/qplayer2-core';

export class QSettingPersistentStorageHelper{
  static save(context : Context,settingModel : QPlayerSettingModel){
    let options: dataPreferences.Options = { name: 'qplayer2-setting' };
    let preferences: dataPreferences.Preferences  = dataPreferences.getPreferencesSync(context, options);
    preferences.putSync('seek_mode', settingModel.mSeekMode)
    preferences.putSync('background_play_mode', settingModel.mBackgroundPlay)
    preferences.flush()
  }

  static read(context : Context) : QPlayerSettingModel{
    let options: dataPreferences.Options = { name: 'qplayer2-setting' };
    let preferences :dataPreferences.Preferences = dataPreferences.getPreferencesSync(context,options)
    let seekValue : QPlayerSeek = preferences.getSync('seek_mode',0) as QPlayerSeek
    let backgroundPlayValue : number = preferences.getSync('background_play_mode',0) as number
    let settingModel = new QPlayerSettingModel()
    settingModel.mSeekMode = seekValue
    settingModel.mBackgroundPlay = backgroundPlayValue
    return settingModel
  }

}