import { PlaySpeed, QPlayerSettingModel } from '../../model/longVideo/QPlayerSettingModel';
import dataPreferences from '@ohos.data.preferences';
import { Context } from '@kit.AbilityKit';
import { QBlindType, QPlayerDecoderPriority, QPlayerSeek, QRenderRatio } from '@QN/QPlayer2-core/qplayer2-core';

export class QSettingPersistentStorageHelper{
  static save(context : Context,settingModel : QPlayerSettingModel){
    let options: dataPreferences.Options = { name: 'qplayer2-setting' };
    let preferences: dataPreferences.Preferences  = dataPreferences.getPreferencesSync(context, options);
    preferences.putSync('seek_mode', settingModel.mSeekMode)
    preferences.putSync('background_play_mode', settingModel.mBackgroundPlay)
    preferences.putSync('decoder_type', settingModel.mDecoderType)
    preferences.putSync('play_speed', settingModel.mPlaySpeed)
    preferences.putSync('binder_type', settingModel.mBlinderType)
    preferences.putSync('render_ratio', settingModel.mRenderRatio)
    preferences.flush()
  }

  static read(context : Context) : QPlayerSettingModel{
    let options: dataPreferences.Options = { name: 'qplayer2-setting' };
    let preferences :dataPreferences.Preferences = dataPreferences.getPreferencesSync(context,options)
    let seekValue : QPlayerSeek = preferences.getSync('seek_mode',0) as QPlayerSeek
    let backgroundPlayValue : number = preferences.getSync('background_play_mode',0) as number
    let decoderPriorityValue : QPlayerDecoderPriority = preferences.getSync('decoder_type',0) as QPlayerDecoderPriority
    let playSpeedValue : PlaySpeed = preferences.getSync('play_speed',2) as PlaySpeed
    let renderRatioValue : QRenderRatio = preferences.getSync('render_ratio',0) as QRenderRatio
    let blindType : QBlindType = preferences.getSync('binder_type',0) as QBlindType
    let settingModel = new QPlayerSettingModel()
    settingModel.mSeekMode = seekValue
    settingModel.mBackgroundPlay = backgroundPlayValue
    settingModel.mDecoderType = decoderPriorityValue
    settingModel.mPlaySpeed = playSpeedValue
    settingModel.mRenderRatio = renderRatioValue
    settingModel.mBlinderType = blindType
    return settingModel
  }

}