// import { QPlayerSettingModel } from '../../model/longVideo/QPlayerSettingModel'
// import { QIPlayerSetting } from "../../interface/longVideo/QPlayerSettingInterface"
// import { QPlayerDecodeType } from '../../common/enum/QPlayerDecodeType'
// import dataPreferences from '@ohos.data.preferences';
// import { Context } from '@kit.AbilityKit';
//
// export class QPlayerSettingViewModel{
//   private mQPlayerSettingListeners : QIPlayerSetting[] = []
//   private mQPlayerSettingModel : QPlayerSettingModel = new QPlayerSettingModel()
//   private mPreferences : dataPreferences.Preferences | null = null
//   private options : dataPreferences.Options = {name:'qplayer_demo'}
//   constructor() {
//     let context : Context = getContext(this)
//     this.mPreferences = dataPreferences.getPreferencesSync(context,this.options)
//   }
//   setDecoderType(decoder_type:QPlayerDecodeType){
//     this.mQPlayerSettingModel.setDecoderType(decoder_type)
//     if(this.mPreferences == null){
//       console.error('mpreferences is null')
//     }else {
//       this.mPreferences.putSync('decoder',decoder_type)
//     }
//     if (this.mQPlayerSettingListeners.length != 0) {
//       for (let index = 0; index < this.mQPlayerSettingListeners.length; index++) {
//         const element = this.mQPlayerSettingListeners[index];
//         element.decoderUpdating(decoder_type)
//       }
//     }
//   }
//   getDecoderType(){
//     return this.mQPlayerSettingModel.getDecoderType()
//   }
//   addQPlayerSetting(player_setting_listener:QIPlayerSetting){
//     this.mQPlayerSettingListeners.push(player_setting_listener)
//   }
//   removeQPlayerSetting(player_setting_listener:QIPlayerSetting){
//     this.mQPlayerSettingListeners = this.mQPlayerSettingListeners.filter(item => item !== player_setting_listener)
//   }
//   removeAllQPlayerSetting(){
//     this.mQPlayerSettingListeners.length = 0
//   }
// }