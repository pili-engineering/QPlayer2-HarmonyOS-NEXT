

export class  QDecimalToHexHelper{
  static decimalToHex(num : number) : string{
    if (num < 10) {
      return num.toString()
    }else if (num == 10){
      return "a"
    }else if (num == 11){
      return "b"
    }else if (num == 12){
      return "c"
    }else if (num == 13){
      return "d"
    }else if (num == 14){
      return "e"
    }else{
      return "f"
    }
  }
}