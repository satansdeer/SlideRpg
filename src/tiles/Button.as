package tiles
{
	import com.bit101.components.Label;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 * Button
	 * @author satansdeer
	 */
	public class Button extends Tile{
		
		private var _id:int;
		private var idLabel:Label;
		
		public function Button()
		{
			url = "assets/selector.png"
			noclip = true;
			super()
			offsetY = 32;
			idLabel = new Label(this, 64,64, _id.toString());
			idLabel.textField.scaleX = 4;
			idLabel.textField.scaleY = 4;
			idLabel.textField.textColor = 0xFFFFFF;
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		override public function set src(value:BitmapData):void{
			if (_src == value) return;
			_src = value;
			if (!bmp) {
				bmp = new Bitmap();
				bmp.x = -offsetX;
				bmp.y = -offsetY;
				addChild(bmp);
				swapChildren(bmp, idLabel);
			}
			
			bmp.bitmapData = value;
		}
		
		override public function activate():void{
			trace("activate")
			var arr:Array = controller.triggerObjects;
			for(var i:int; i< arr.length; i++){
				if(arr[i].id == id){
					arr[i].trigger();
				}
			}
		}
		
		public function get id():int{
			return _id;
		}
		
		public function set id(value:int):void{
			_id = value;
			idLabel.text = value.toString();
		}
	}
}