import { IPlayItemAppendListener } from './listeners/IPlayItemAppendListener';
import { IPlayItemArrayRefreshListener } from './listeners/IPlayItemArrayRefreshListener';
import { IPlayItemDeleteListener } from './listeners/IPlayItemDeleteListener';
import { IPlayItemReplaceListener } from './listeners/IPlayItemReplaceListener';
import { QNPlayItem } from './QNPlayItem';
import ArrayList from '@ohos.util.ArrayList';
import List from '@ohos.util.List';
import { QUrlJsonReadWriteHelper } from '../../../common/Helper/QUrlJsonReadWriteHelper';

export class QNPlayItemManager{
  private mPlayItemArray : ArrayList<QNPlayItem> = new ArrayList()
  private mPlayItemAppendListeners : ArrayList<IPlayItemAppendListener> = new ArrayList()
  private mPlayItemDeleteListeners : ArrayList<IPlayItemDeleteListener> = new ArrayList()
  private mPlayItemReplaceListeners : ArrayList<IPlayItemReplaceListener> = new ArrayList()
  private mPlayItemRefreshListeners : ArrayList<IPlayItemArrayRefreshListener> = new ArrayList()
  constructor() {

  }

  refresh(playItemArray : ArrayList<QNPlayItem>) : boolean{
    this.mPlayItemArray = playItemArray
    this.mPlayItemRefreshListeners.forEach((listener : IPlayItemArrayRefreshListener)=>{
      listener.onRefresh(playItemArray)
    })
    return true
  }

  append(playItemArray : ArrayList<QNPlayItem>) : boolean{
    playItemArray.forEach((item : QNPlayItem)=>{
      this.mPlayItemArray.add(item)
    })
    this.mPlayItemAppendListeners.forEach((listener : IPlayItemAppendListener)=>{
      listener.onAppend(playItemArray)
    })
    return true
  }

  delete(position : number) : boolean{
    if (position >= 0 && position < this.mPlayItemArray.length) {
      let deletePlayItem : QNPlayItem = this.mPlayItemArray[position]
      this.mPlayItemArray.removeByIndex(position)
      this.mPlayItemDeleteListeners.forEach((listener)=>{
        listener.onDelete(position,deletePlayItem)
      })
      return true
    }
    return false
  }
  replace(position: number, playItem : QNPlayItem): boolean{
    if (position >= 0 && position < this.mPlayItemArray.length){
      let replacePlayItem :QNPlayItem = this.mPlayItemArray[position];
      this.mPlayItemArray[position] = playItem;
      this.mPlayItemReplaceListeners.forEach((listener : IPlayItemReplaceListener)=>{
        listener.onReplace(position,replacePlayItem,playItem)
      })
      return true;
    }
    return false;
  }

  getOrNullByPosition(position : number): QNPlayItem | null{
    if(position >= 0 && position < this.mPlayItemArray.length){
      return this.mPlayItemArray[position];
    }
    return null;
  }

  getOrNullById ( itemId : number) : QNPlayItem | null {
    let result : QNPlayItem | null = null
    this.mPlayItemArray.forEach((innerItem : QNPlayItem) =>{
      if (innerItem.mItemId == itemId) {
        result = innerItem
      }
    })
    return result
  }

  count() : number {
    return this.mPlayItemArray.length
  }

  addPlayItemAppendListener(listener : IPlayItemAppendListener) {
    this.mPlayItemAppendListeners.add(listener)
  }

  removePlayItemAppendListener(listener : IPlayItemAppendListener){
    this.mPlayItemAppendListeners.remove(listener)
  }

  removeAllPlayItemAppendListener(){
    this.mPlayItemAppendListeners.clear()
  }

  addPlayItemDeleteListener(listener : IPlayItemDeleteListener){
    this.mPlayItemDeleteListeners.add(listener)
  }

  removePlayItemDeleteListener(listener : IPlayItemDeleteListener){
    this.mPlayItemDeleteListeners.remove(listener)
  }
  removeAllPlayItemDeleteListener(){
    this.mPlayItemDeleteListeners.clear()
  }
  addPlayItemReplaceListener(listener : IPlayItemReplaceListener){
    this.mPlayItemReplaceListeners.add(listener)
  }
  removePlayItemReplaceListener(listener : IPlayItemReplaceListener){
    this.mPlayItemReplaceListeners.remove(listener)
  }

  removeAllPlayItemReplaceListener(){
    this.mPlayItemReplaceListeners.clear()
  }
  addPlayItemArrayRefreshListener(listener : IPlayItemArrayRefreshListener){
    this.mPlayItemRefreshListeners.add(listener)
  }
  removePlayItemRefreshListener(listener : IPlayItemArrayRefreshListener) {
    this.mPlayItemRefreshListeners.remove(listener)
  }

  removeAllPlayItemRefreshListener(){
    this.mPlayItemRefreshListeners.clear()
  }
}

