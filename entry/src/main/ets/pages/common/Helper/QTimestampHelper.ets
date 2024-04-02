
export class QTimestampHelper{
   static getTimestamp(){
     return new Date().getTime()
   }
  static millisecondToHMSString(time:Number){
    let second_time = Math.floor(time.valueOf() / 1000)
    let inner_date : String = ""
    if (second_time >= 60) {
      let second = second_time % 60
      let min = Math.floor(second_time / 60) 
      if (min >= 60) {
        let hour = Math.floor(min / 60)
        min = min % 60
        inner_date = hour.toString() + ":" + innerTimeFormatHelper.innerTimeFormat(min) + ":" + innerTimeFormatHelper.innerTimeFormat(second)
      }else {
        inner_date = innerTimeFormatHelper.innerTimeFormat(min)+ ":" + innerTimeFormatHelper.innerTimeFormat(second)
      }
    }
    else {
      inner_date = "00:" + innerTimeFormatHelper.innerTimeFormat(second_time)
    }
    return inner_date
  }

}

class innerTimeFormatHelper{
  static innerTimeFormat(time:Number){
    let inner_date : String = ""
    if (time < 10) {
      inner_date = "0" + time.toString()
    }else {
      inner_date = time.toString()
    }
    return inner_date
  }
}