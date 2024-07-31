import { ArrayList } from '@kit.ArkTS'
import { QNPlayItem } from '../QNPlayItem'

export interface IPlayItemDeleteListener{
  onDelete :(position: number, deletePlayItem : QNPlayItem) => void
}