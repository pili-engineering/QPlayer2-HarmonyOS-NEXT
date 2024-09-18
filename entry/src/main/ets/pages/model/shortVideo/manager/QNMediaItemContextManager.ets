import { IPlayItemAppendListener } from './listeners/IPlayItemAppendListener';
import { IPlayItemArrayRefreshListener } from './listeners/IPlayItemArrayRefreshListener';
import { IPlayItemDeleteListener } from './listeners/IPlayItemDeleteListener';
import { IPlayItemReplaceListener } from './listeners/IPlayItemReplaceListener';
import { QNPlayItem } from './QNPlayItem';
import { ArrayList } from '@kit.ArkTS';
import { QNPlayItemManager } from './QNPlayItemManager';
import { QIMediaItemContext, QLogLevel, QMediaItemState, QMediaModel,
  QPlayerContextFactory } from '@qiniu/qplayer2-core/qplayer2-core';
import { Context } from '@ohos.abilityAccessCtrl';
export class QNMediaItemContextManager{
  private readonly LOAD_FORWARD_POS : number = 1
  private readonly LOAD_BACKWARD_POS : number = 5
  private readonly TAG : string = "QNMediaItemContextManager"
  private mPlayItemManager : QNPlayItemManager
  private mExternalFilesDir : string
  private mMediaItemContextMap : Map<number,QIMediaItemContext>
  private mCurrentPosition : number
  private mDeleteListener : IPlayItemDeleteListener = {
    onDelete :(position: number, deletePlayItem : QNPlayItem) => {
      this.discardMediaItemContext(deletePlayItem.mItemId)
      this.updateMediaItemContext(this.mCurrentPosition)
    }
  }
  private mReplaceListener : IPlayItemReplaceListener = {
    onReplace :(position: number, oldPlayItem : QNPlayItem, newPlayItem : QNPlayItem) => {
      this.updateMediaItemContext(this.mCurrentPosition)
    }
  }

  private mAppendListener : IPlayItemAppendListener ={
    onAppend :(appendItems : ArrayList<QNPlayItem>) => {
      this.updateMediaItemContext(this.mCurrentPosition)
    }
  }
  private mRefrashListener : IPlayItemArrayRefreshListener = {
    onRefresh :(itemArray : ArrayList<QNPlayItem>) => {
      this.mCurrentPosition = 0
      this.updateMediaItemContext(this.mCurrentPosition)
    }
  }

  constructor(playItemManager : QNPlayItemManager, externalFilesDir : string) {
    this.mPlayItemManager = playItemManager;
    this.mExternalFilesDir = externalFilesDir;
    this.mMediaItemContextMap = new Map()
    this.mCurrentPosition = 0 ;
  }
  load(itemId : number, mediaModel : QMediaModel, startPos : number, logLevel : QLogLevel, localStorageDir : string) {
    let mediaItem : QIMediaItemContext | undefined = this.mMediaItemContextMap.get(itemId)
    if (mediaItem != undefined) {
      if (mediaItem.get_control_handler().currentState == QMediaItemState.STOPED ||
        mediaItem.get_control_handler().currentState == QMediaItemState.ERROR) {
        mediaItem.get_control_handler().stop()
        this.mMediaItemContextMap.delete(itemId)
        mediaItem = undefined
        console.error(`${this.TAG} load::remove error or stoped mediaitem id = ${itemId}`)
      }
    }
    if (mediaItem == undefined) {
      mediaItem = QPlayerContextFactory.createMediaItemContext(AppStorage.get("context") as Context, mediaModel, startPos, logLevel, localStorageDir)
      mediaItem.get_control_handler().start()
      this.mMediaItemContextMap.set(itemId, mediaItem)
      console.error(`${this.TAG} load::mediaitem id = ${itemId}`)
    }
  }

  discardMediaItemContext(itemId : number){
    let mediaItem : QIMediaItemContext | undefined = this.mMediaItemContextMap.get(itemId)
    if (mediaItem != undefined) {
      mediaItem.get_control_handler().stop()
      this.mMediaItemContextMap.delete(itemId)
    }
    console.log(`${this.TAG} discardMediaItemContext id = ${itemId}`);
  }
  updateMediaItemContext(currentPosition : number){
    this.mCurrentPosition = currentPosition
    let newContextIds : Set<number> = new Set()
    let start : number = currentPosition - this.LOAD_FORWARD_POS
    let end : number = currentPosition - 1
    for (let index = start; index < end; index++) {
      let item : QNPlayItem | null = this.mPlayItemManager.getOrNullByPosition(index)
      if (item != null) {
        newContextIds.add(item.mItemId)
      }
    }
    start = currentPosition + 1
    end = currentPosition + this.LOAD_BACKWARD_POS
    for (let index = start; index < end; index++) {
      let item : QNPlayItem | null = this.mPlayItemManager.getOrNullByPosition(index)
      if (item != null) {
        newContextIds.add(item.mItemId)
      }
    }
    let addContextIdsSet : Set<number> = new Set()
    newContextIds.forEach((num : number)=>{
      let isExist : boolean = false
      this.mMediaItemContextMap.forEach((value : QIMediaItemContext, key : number)=>{
        if (key == num) {
          isExist = true
          return
        }
      })
      if (isExist == false) {
        addContextIdsSet.add(num)
      }
    })
    addContextIdsSet.forEach((value : number)=>{
      let item : QNPlayItem | null = this.mPlayItemManager.getOrNullById(value)
      if (item != null) {
        this.load(item.mItemId, item.mMediaModel, 0 , QLogLevel.LOG_VERBOSE, this.mExternalFilesDir)
      }
    })
    console.log(`${this.TAG} add preload ids = ${addContextIdsSet}`)
    let discardContextIdsSet : Set<number> = new Set()
    this.mMediaItemContextMap.forEach((value : QIMediaItemContext, key : number) =>{
      let isExist : boolean = false
      newContextIds.forEach((newValue : number) =>{
        if (newValue == key) {
          isExist = true
          return
        }
      })
      if (isExist == false) {
        discardContextIdsSet.add(key)
      }
    })
    discardContextIdsSet.forEach((value : number)=>{
      this.discardMediaItemContext(value)
    })
    console.log(`${this.TAG} remove preload ids = ${discardContextIdsSet}`);
  }

  start(){
    this.mPlayItemManager.addPlayItemAppendListener(this.mAppendListener)
    this.mPlayItemManager.addPlayItemDeleteListener(this.mDeleteListener)
    this.mPlayItemManager.addPlayItemReplaceListener(this.mReplaceListener)
    this.mPlayItemManager.addPlayItemArrayRefreshListener(this.mRefrashListener)
  }

  stop(){
    this.mPlayItemManager.removePlayItemAppendListener(this.mAppendListener)
    this.mPlayItemManager.removePlayItemDeleteListener(this.mDeleteListener)
    this.mPlayItemManager.removePlayItemReplaceListener(this.mReplaceListener)
    this.mPlayItemManager.addPlayItemArrayRefreshListener(this.mRefrashListener)
    this.discardAllMediaItemContexts()
  }
  discardAllMediaItemContexts(){
    console.log(`${this.TAG} discardAllMediaItemContexts stop`)
    this.mMediaItemContextMap.forEach((value : QIMediaItemContext, key : number)=>{
      value.get_control_handler().stop()
    })
    this.mMediaItemContextMap.clear()
  }

  fetchMediaItemContextById(itemId : number) : QIMediaItemContext | undefined{
    let mediaItem : QIMediaItemContext | undefined = this.mMediaItemContextMap.get(itemId)
    this.mMediaItemContextMap.delete(itemId)
    console.log(`${this.TAG} rfetchMediaItemContextById id = ${itemId}`);
    return mediaItem
  }
}