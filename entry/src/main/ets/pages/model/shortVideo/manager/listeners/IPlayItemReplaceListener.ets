import { ArrayList } from '@kit.ArkTS'
import { QNPlayItem } from '../QNPlayItem'

export interface IPlayItemReplaceListener{
  onReplace :(position: number, oldPlayItem : QNPlayItem, newPlayItem : QNPlayItem) => void
}