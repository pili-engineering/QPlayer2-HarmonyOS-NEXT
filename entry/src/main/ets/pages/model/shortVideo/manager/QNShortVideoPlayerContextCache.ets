import { QIMediaItemContext, QIPlayerContext, QIPlayerStateChangeListener, QMediaItemState } from '@qiniu/qplayer2-core/'
import { QPlayerState } from '@qiniu/qplayer2-core/src/main/ets/public/enums/QPlayerState'
import { QUrlJsonReadWriteHelper } from '../../../common/Helper/QUrlJsonReadWriteHelper'
import { QNMediaItemContextManager } from './QNMediaItemContextManager'
// import { QNPlayerViewManager } from './QNPlayerViewManager'
import { QNPlayItem } from './QNPlayItem'
import { QNPlayItemManager } from './QNPlayItemManager'

export class QNShortVideoPlayerContextCache{
  private mStateListener : QIPlayerStateChangeListener = {
    onStateChange:(context : QIPlayerContext ,state: QPlayerState)=>{

    }
  }
  private mPlayItemManager : QNPlayItemManager
  private mExternalFilesDir : string
  private mMediaItemContextManager : QNMediaItemContextManager
  // private mPlayerViewManager : QNPlayerViewManager
  private mCurrentPostion : number

  constructor(playItemManager : QNPlayItemManager, externalFilesDir : string) {
    this.mPlayItemManager = playItemManager
    this.mExternalFilesDir = externalFilesDir
    this.mMediaItemContextManager = new QNMediaItemContextManager(this.mPlayItemManager, externalFilesDir)
    // this.mPlayerViewManager = new QNPlayerViewManager()
    this.mCurrentPostion = -1
    this.start()
    QUrlJsonReadWriteHelper.readShortVideoUrl(AppStorage.get("context") as Context,(url_models)=>{
      playItemManager.append(url_models)
    })
  }
  start(){
    this.mMediaItemContextManager.start()
  }
  stop(){
    this.mMediaItemContextManager.stop()
  }
  changePosition(position : number, playerDown : QIPlayerContext | null, playerUp : QIPlayerContext | null){
    this.mMediaItemContextManager.updateMediaItemContext(position)
    // console.log(`change position pos=${position}`)
    // this.mPlayerViewManager.recyclePrePlayerContext()
    let playItem : QNPlayItem | null = this.mPlayItemManager.getOrNullByPosition(position + 1)
    if (playItem != null) {
      // if (!this.mPlayerViewManager.isPreRenDerValaId()) {
        let item : QIMediaItemContext | undefined = this.mMediaItemContextManager.fetchMediaItemContextById(playItem.mItemId)
        if (item != undefined) {
          // this.mPlayerViewManager.prepare(playItem.mItemId,item)
          console.log(`down playMediaItem`)
          playerDown?.get_control_handler().playMediaItem(item!)
        }

      // }
    }
    let playItemUp : QNPlayItem | null = this.mPlayItemManager.getOrNullByPosition(position - 1)
    if (playItemUp != null) {
      // if (!this.mPlayerViewManager.isPreRenDerValaId()) {
      let itemUp : QIMediaItemContext | undefined = this.mMediaItemContextManager.fetchMediaItemContextById(playItemUp.mItemId)
      if (itemUp != undefined) {
        // this.mPlayerViewManager.prepare(playItem.mItemId,item)
        console.log(`up playMediaItem`)
        playerUp?.get_control_handler().playMediaItem(itemUp!)
      }else {
        console.log(`up not playMediaItem`)
        playerUp?.get_control_handler().playMediaModel(playItemUp.mMediaModel,0)
      }
    }
    this.mCurrentPostion = position
  }
  getCurrentPosition() : number{
    return this.mCurrentPostion
  }
  playMediaItemContextById(itemId : number , qplayer : QIPlayerContext | null){
    let playItem : QNPlayItem | null = this.mPlayItemManager.getOrNullById(itemId)
    let mediaItem : QIMediaItemContext | undefined=  this.mMediaItemContextManager.fetchMediaItemContextById(itemId)
    if (mediaItem == undefined && playItem != null) {
      qplayer?.get_control_handler().playMediaModel(playItem.mMediaModel,0)
    }else if (mediaItem != undefined){
      qplayer?.get_control_handler().playMediaItem(mediaItem)
    }
    qplayer?.get_control_handler().resumeRender()
  }
  removeAllListers(playerContext : QIPlayerContext) {
    playerContext.get_control_handler().removeAllPlayerSeekListener()
    playerContext.get_control_handler().removeAllPlayerStateListener()
    playerContext.get_control_handler().removeAllPlayerFormatListener()
    playerContext.get_control_handler().removeAllPlayerQualityListener()
    playerContext.get_control_handler().removeAllPlayerSEIDataListener()
    playerContext.get_control_handler().removeAllPlayerFPSChangeListener()
    playerContext.get_control_handler().removeAllPlayerShootVideoListener()
    playerContext.get_control_handler().removeAllPlayerAuthenticationListener()
    playerContext.get_control_handler().removeAllPlayerSpeedChangeListener()
    playerContext.get_control_handler().removeAllPlayerMediaNetworkListener()
    playerContext.get_control_handler().removeAllPlayerDownloadChangeListener()
    playerContext.get_control_handler().removeAllPlayerProgressChangeListener()
    playerContext.get_control_handler().removeAllPlayerBufferingChangeListener()
    playerContext.get_control_handler().removeAllPlayerBiteRateChangeListener()
    playerContext.get_control_handler().removeAllPlayerCommandNotAllowListener()
    playerContext.get_control_handler().removeAllPlayerVideoDecodeTypeListener()
    playerContext.get_control_handler().removeAllPlayerVideoFrameSizeChangeListener()
    playerContext.get_render_handler().removeAllPlayerRenderListener()
  }

}