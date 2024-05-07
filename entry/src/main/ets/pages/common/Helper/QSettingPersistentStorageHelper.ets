import { QPlayerSettingModel } from '../../model/longVideo/QPlayerSettingModel';
import dataPreferences from '@ohos.data.preferences';
import { Context } from '@kit.AbilityKit';
import { QPlayerSeek } from '@QN/QPlayer2-core/qplayer2-core';

export class QSettingPersistentStorageHelper{
  static save(context : Context,setting_model : QPlayerSettingModel){
    let options: dataPreferences.Options = { name: 'qplayer2-setting' };
    let preferences: dataPreferences.Preferences  = dataPreferences.getPreferencesSync(context, options);
    preferences.putSync('seek_mode', setting_model.mSeekMode)
    preferences.flush()
  }

  static read(context : Context) : QPlayerSettingModel{
    let options: dataPreferences.Options = { name: 'qplayer2-setting' };
    let preferences :dataPreferences.Preferences = dataPreferences.getPreferencesSync(context,options)
    let value : QPlayerSeek = preferences.getSync('seek_mode',-1) as QPlayerSeek
    let setting_model = new QPlayerSettingModel()
    setting_model.mSeekMode = value
    return setting_model
  }

}