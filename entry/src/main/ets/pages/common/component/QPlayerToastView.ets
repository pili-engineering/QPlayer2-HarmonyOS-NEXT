import { window } from '@kit.ArkUI'

@Observed
class InnerToastModel{
  public mViewWidth : Length = 0
  public mViewHeight : Length = 0
  public mViewText : String = ""
  public mViewId : Number = 0
  public mViewBottom : String = ""
  public mViewAlign : VerticalAlign = VerticalAlign.Top
  public  mViewShow : Visibility = Visibility.Visible
  private mViewTimerId : Number = 0
  private mViewTimeCount : Number = 5
  constructor(view_id : Number,width : Length, height: Length , text : String,bottom: String, call_back : ()=>void, align? : VerticalAlign ) {
    this.mViewWidth = width
    this.mViewHeight = height
    this.mViewText = text
    this.mViewAlign = align? align:VerticalAlign.Top
    this.mViewBottom = bottom
    this.mViewId = view_id

    this.mViewTimerId = setInterval(()=>{
      this.mViewTimeCount = this.mViewTimeCount.valueOf() - 1
      if (this.mViewTimeCount == 0) {
        clearInterval(this.mViewTimerId.valueOf())
        this.mViewShow = Visibility.Hidden
        call_back()
      }
    },1000)
  }
  public stopTimer(){
    clearInterval(this.mViewTimerId.valueOf())
    this.mViewShow = Visibility.Hidden
  }
}

@Component
export struct QPlayerToastView{
  private mTextCount = 0
  @Link @Watch('textChange') mToastText : String
  @State @Watch('arrayChange') mInnerToastModelArray : Array<InnerToastModel> = [

  ]
  @Link @Watch('deviceOrientationChange') mDeviceOrientation : window.Orientation
  build() {
    Column() {
      RelativeContainer() {

        ForEach(this.mInnerToastModelArray, (item: InnerToastModel) => {
          InnerToast({ mToastText: item.mViewText.toString() })
            .backgroundColor($r('app.color.hyaline_background_color'))
            .width(item.mViewWidth)
            .height(item.mViewHeight)
            .alignRules({
              left: {anchor : "__container__", align : HorizontalAlign.Start},
              bottom : {anchor : item.mViewBottom.toString(), align : item.mViewAlign}
            })
            .id("toastView_" + item.mViewId.toString())
            .responseRegion({ x: 0, y: 0, width: 0, height: 0 })
            .margin({
              bottom: 3
            })
            .visibility(item.mViewShow)
            

        })
      }
      .responseRegion({x : 0 , y : 0 , width : 0 , height : 0})
    }
    .width('100%')
    .height('100%')
    .responseRegion({x:0, y : 0 , width : 0, height : 0})
  }
  textChange(name:String){
    if (this.mToastText.toString() == "") {
      return
    }
    let new_toast_model : InnerToastModel
    if(this.mDeviceOrientation == window.Orientation.PORTRAIT){
      new_toast_model = new InnerToastModel(this.mTextCount.valueOf(),'100%','5%',this.mToastText.toString(),"__container__",()=>{
        this.mInnerToastModelArray.shift()
      })
    }else {
      new_toast_model = new InnerToastModel(this.mTextCount.valueOf(),'100%','10%',this.mToastText.toString(),"__container__",()=>{
        this.mInnerToastModelArray.shift()
      })
    }
    this.mTextCount ++
    this.mInnerToastModelArray.push(new_toast_model)
  }
  arrayChange(name:String){
    let count : Number = this.mTextCount.valueOf() - this.mInnerToastModelArray.length.valueOf()
    this.mInnerToastModelArray.forEach(element => {
      if (count.valueOf() +1 == this.mTextCount.valueOf()) {
        element.mViewBottom = "__container__"
        element.mViewAlign = VerticalAlign.Bottom
      }else {
        count = count.valueOf() +1
        element.mViewBottom = "toastView_" + count.toString()
        element.mViewAlign = VerticalAlign.Top
      }
    });
  }
  deviceOrientationChange(name : String){
    this.mInnerToastModelArray.forEach(element => {
       element.stopTimer()
    });
    this.mInnerToastModelArray = []
  }
}

@Component
struct  InnerToast{
  mToastText : String = ""
  build() {
    Row(){
      Text(this.mToastText.toString())
        .backgroundColor($r('app.color.toast_view_background_color'))
        .fontSize($r('app.float.default_font_size'))
        .fontColor($r('app.color.toast_view_font_color'))
        .height('100%')
        .responseRegion({x:0, y : 0 , width : 0, height : 0})
        .id("text_view")
        .textOverflow({overflow : TextOverflow.Ellipsis})
        .maxLines(1)

    }
    .width('100%')
    .height('100%')
    .responseRegion({x:0, y : 0 , width : 0, height : 0})
  }
}