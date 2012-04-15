package tiles
{
	import com.bit101.components.Label;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.text.TextFormat;

	/**
	 * Mob
	 * @author satansdeer
	 */
	public class Mob extends SlidingObject{
		
		private var _level:int = 1;
		private var levelLabel:Label;
		
		
		public function Mob()
		{
			url="assets/Enemy Bug.png"
			super();
			levelLabel = new Label(this, 64,64, _level.toString());
			levelLabel.textField.scaleX = 4;
			levelLabel.textField.scaleY = 4;
			levelLabel.textField.textColor = 0xFFFFFF;
			offsetY = 32;
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
				swapChildren(bmp, levelLabel);
			}
			
			bmp.bitmapData = value;
		}
		
		public function get level():int{
			return _level;
		}
		
		public function set level(value:int):void{
			_level = value;
			levelLabel.text = value.toString();
		}
	}
}