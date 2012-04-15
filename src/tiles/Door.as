package tiles
{
	import com.bit101.components.Label;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 * Door
	 * @author satansdeer
	 */
	public class Door extends Tile{
		private var _id:int;
		private var idLabel:Label;
		
		private var _open:Boolean;
		
		public function Door(){	
			url = "assets/Door Tall Closed.png"
			super()
			offsetY = 32;
			idLabel = new Label(this, 64,64, _id.toString());
			idLabel.textField.scaleX = 4;
			idLabel.textField.scaleY = 4;
			idLabel.textField.textColor = 0xFFFFFF;
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		public function trigger():void{
			trace("TRIGGER")
			if(_open){
				trace("close")
				url = "assets/Door Tall Closed.png"
				_open = false;
				noclip = false;
			}else{
				trace("open")
				url = "assets/Door Tall Open.png"
				_open = true;
				noclip = true;
			}
			setImg();
		}
		
		public function get id():int{
			return _id;
		}
		
		public function set id(value:int):void{
			_id = value;
			idLabel.text = value.toString();
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
	}
}