import { ArrayList } from '@kit.ArkTS'
import { QNPlayItem } from '../QNPlayItem'

export interface IPlayItemArrayRefreshListener{
  onRefresh :(itemArray : ArrayList<QNPlayItem>) => void
}