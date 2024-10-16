import { Immediately, PlaySpeed, QPlayerSettingModel } from '../../model/longVideo/QPlayerSettingModel';
import dataPreferences from '@ohos.data.preferences';
import { Context } from '@kit.AbilityKit';
import { QBlindType, QPlayerDecoderPriority,
  QPlayerMirror,
  QPlayerSeek,
  QPlayerStart,
  QRenderRatio } from '@qiniu/qplayer2-core/qplayer2-core';

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
    preferences.putSync('position', settingModel.mPosition)
    preferences.putSync('sei_enable', settingModel.mSEIEnable)
    preferences.putSync('start_action', settingModel.mStartAction)
    preferences.putSync('immediately', settingModel.mImmediately)
    preferences.putSync('subtitle_enable', settingModel.mSubtitleEnable)
    preferences.putSync('force_network_auth', settingModel.mForceNetworkAuth)
    preferences.putSync('mirror_type', settingModel.mMirrorType)
    preferences.putSync('rotation', settingModel.mRotation)
    preferences.putSync('scale', settingModel.mScale)
    console.log(`write settingModel.mPosition : ${settingModel.mPosition}`);
    preferences.flush()
  }

  static read(context : Context) : QPlayerSettingModel{
    let options: dataPreferences.Options = { name: 'qplayer2-setting' };
    let preferences :dataPreferences.Preferences = dataPreferences.getPreferencesSync(context,options)
    let seekValue : QPlayerSeek = preferences.getSync('seek_mode',0) as QPlayerSeek
    let backgroundPlayValue : number = preferences.getSync('background_play_mode',0) as number
    let decoderPriorityValue : QPlayerDecoderPriority = preferences.getSync('decoder_type',0) as QPlayerDecoderPriority
    let playSpeedValue : PlaySpeed = preferences.getSync('play_speed',2) as PlaySpeed
    let renderRatioValue : QRenderRatio = preferences.getSync('render_ratio',1) as QRenderRatio
    let blindType : QBlindType = preferences.getSync('binder_type',0) as QBlindType
    let position : number =  preferences.getSync('position',0) as number
    let seiEnable : number =  preferences.getSync('sei_enable',0) as number
    let startAction : QPlayerStart =  preferences.getSync('start_action',0) as QPlayerStart
    let immediately : Immediately =  preferences.getSync('immediately',0) as Immediately
    let subtitleEnable : Immediately =  preferences.getSync('subtitle_enable',0) as number
    let forceNetworkAuth : Immediately =  preferences.getSync('force_network_auth',0) as number
    let mirrorType : QPlayerMirror =  preferences.getSync('mirror_type',0) as QPlayerMirror
    let rotation : QPlayerMirror =  preferences.getSync('rotation',0) as number
    let scale : number =  preferences.getSync('scale',1) as number
    let settingModel = new QPlayerSettingModel()
    settingModel.mSeekMode = seekValue
    settingModel.mBackgroundPlay = backgroundPlayValue
    settingModel.mDecoderType = decoderPriorityValue
    settingModel.mPlaySpeed = playSpeedValue
    settingModel.mRenderRatio = renderRatioValue
    settingModel.mBlinderType = blindType
    settingModel.mPosition = position
    settingModel.mSEIEnable = seiEnable
    settingModel.mStartAction = startAction
    settingModel.mImmediately = immediately
    settingModel.mSubtitleEnable = subtitleEnable
    settingModel.mForceNetworkAuth = forceNetworkAuth
    settingModel.mMirrorType = mirrorType
    settingModel.mRotation = rotation
    settingModel.mScale = scale
    return settingModel
  }

}