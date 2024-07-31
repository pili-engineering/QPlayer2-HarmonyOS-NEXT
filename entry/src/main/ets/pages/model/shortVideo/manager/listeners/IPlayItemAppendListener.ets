import { ArrayList } from '@kit.ArkTS'
import { QNPlayItem } from '../QNPlayItem'

export interface IPlayItemAppendListener{
  onAppend :(appendItems : ArrayList<QNPlayItem>) => void
}