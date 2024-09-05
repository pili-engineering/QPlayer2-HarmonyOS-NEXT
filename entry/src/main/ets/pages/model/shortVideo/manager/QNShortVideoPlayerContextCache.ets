import { QIMediaItemContext, QIPlayerContext, QIPlayerStateChangeListener, QMediaItemState } from '@qiniu/qplayer2-core/'
import { QPlayerState } from '@qiniu/qplayer2-core/qplayer2-core'
import { QUrlJsonReadWriteHelper } from '../../../common/Helper/QUrlJsonReadWriteHelper'
import { QNMediaItemContextManager } from './QNMediaItemContextManager'
import { QNPlayItem } from './QNPlayItem'
import { QNPlayItemManager } from './QNPlayItemManager'

export class QNShortVideoPlayerContextCache{
  private mStateListener : QIPlayerStateChangeListener = {
    onStateChange:(context : QIPlayerContext ,state: QPlayerState)=>{

    }
  }
  private mPlayItemManager : QNPlayItemManager
  private mMediaItemContextManager : QNMediaItemContextManager
  private mCurrentPostion : number

  constructor(playItemManager : QNPlayItemManager, externalFilesDir : string) {
    this.mPlayItemManager = playItemManager
    this.mMediaItemContextManager = new QNMediaItemContextManager(this.mPlayItemManager, externalFilesDir)
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
    let playItem : QNPlayItem | null = this.mPlayItemManager.getOrNullByPosition(position + 1)
    if (playItem != null) {
        let item : QIMediaItemContext | undefined = this.mMediaItemContextManager.fetchMediaItemContextById(playItem.mItemId)
        if (item != undefined) {
          playerDown?.get_control_handler().playMediaItem(item!)
        }
    }
    let playItemUp : QNPlayItem | null = this.mPlayItemManager.getOrNullByPosition(position - 1)
    if (playItemUp != null) {
      let itemUp : QIMediaItemContext | undefined = this.mMediaItemContextManager.fetchMediaItemContextById(playItemUp.mItemId)
      if (itemUp != undefined) {
        playerUp?.get_control_handler().playMediaItem(itemUp!)
      }else {
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

}