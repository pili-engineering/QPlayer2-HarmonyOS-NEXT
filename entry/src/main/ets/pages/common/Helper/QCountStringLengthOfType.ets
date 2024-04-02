export class QStringLength{
  private zh:number
  private en:number
  private num:number
  constructor(en:number,zh:number,num:number) {
    this.zh = zh
    this.en = en
    this.num = num
  }
  getZH(){
    return this.zh
  }
  getEN(){
    return this.en
  }
  getNum(){
    return this.num
  }
}

export class  QCountStringLengthOfType{
  static countStringLength(str:string){
    let strOfZH = str.match(/[\u4e00-\u9fa5，。、《》？；：「」【】、！……￥]/g)
    let numOfZH = strOfZH ? strOfZH.length : 0
    let strOfNum = str.match(/[0-9]/g)
    let numOfNum = strOfNum ? strOfNum.length : 0
    let numOfEN = str.length - numOfZH - numOfNum
    return new QStringLength(numOfEN, numOfZH, numOfNum)
  }
}