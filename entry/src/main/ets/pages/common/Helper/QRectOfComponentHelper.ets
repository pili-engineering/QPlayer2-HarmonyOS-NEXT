// export class QRectOfComponent {
//   private left: number
//   private right: number
//   private top: number
//   private bottom: number
//
//   constructor(left:number,right:number,top:number,bottom:number) {
//     this.left = left
//     this.right = right
//     this.top = top
//     this.bottom = bottom
//   }
//   getLeft(){
//     return this.left;
//   }
//   getRight(){
//     return this.right
//   }
//   getTop(){
//     return this.top
//   }
//   getBottom(){
//     return this.bottom
//   }
// }
//
// export class QRectOfComponentHelper{
//   static getComponentRectWithKey(key:string){
//     let strJson = getInspectorByKey(key)
//     let obj = JSON.parse(strJson)
//     console.info("[getInspectorByKey] current component obj is: " + JSON.stringify(obj))
//     let rectInfo = JSON.parse('[' + obj.$rect + ']')
//     console.info("[getInspectorByKey] rectInfo is: " + rectInfo)
//     let rectResult = new QRectOfComponent(JSON.parse('[' + rectInfo[0] + ']')[0],
//       JSON.parse('[' + rectInfo[0] + ']')[1],
//       JSON.parse('[' + rectInfo[1] + ']')[0],
//       JSON.parse('[' + rectInfo[1] + ']')[1])
//     return rectResult
//   }
// }