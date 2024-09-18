import { QIPlayerContext, QPlayerStart } from '@qiniu/qplayer2-core'
import { Context } from '@ohos.abilityAccessCtrl'
import { common } from '@kit.AbilityKit'
import { ArrayList } from '@kit.ArkTS'

@Observed
export class QShortVideoDataSource implements IDataSource{
  public list: (QIPlayerContext | null)[]

  constructor(list: (QIPlayerContext | null)[]) {
    list.forEach((context : QIPlayerContext | null)=>{
      context?.init(AppStorage.get("context") as Context, AppStorage.get("context") as common.UIAbilityContext)
      context?.get_control_handler().setStartAction(QPlayerStart.PAUSE)
    })
    this.list = list
  }
  totalCount(): number {
    return this.list.length
  }

  getData(index: number): QIPlayerContext | null {
    return this.list[index]
  }

  setData(context : QIPlayerContext | null, value : number){
    this.list[value] = context
  }

  registerDataChangeListener(listener: DataChangeListener): void {

  }

  unregisterDataChangeListener(listener: DataChangeListener): void {

  }

}