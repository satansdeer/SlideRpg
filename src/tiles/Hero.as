package tiles
{
	import com.bit101.components.Label;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 * Hero
	 * @author satansdeer
	 */
	public class Hero extends SlidingObject{
		
		private var _level:int = 0;
		private var levelLabel:Label;
		
		private var _mapController:MapController;
		
		public function Hero(mapManager:MapController)
		{
			_mapController = mapManager;
			url = "assets/Character Boy.png"
			super();
			levelLabel = new Label(this, 64,64, _level.toString());
			levelLabel.textField.scaleX = 4;
			levelLabel.textField.scaleY = 4;
			levelLabel.textField.textColor = 0xFFFFFF;
			offsetY = 32;
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		public function get level():int{
			return _level;
		}
		
		public function hitNearMonters():void{
			var objects:Array = _mapController.objectsMap;
			var nearMonsters:Array = [];
			nearMonsters.push(objects[mapX-1][mapY]);
			nearMonsters.push(objects[mapX+1][mapY]);
			nearMonsters.push(objects[mapX][mapY+1]);
			nearMonsters.push(objects[mapX][mapY-1]);
			for(var i:int = 0; i< nearMonsters.length; i++){
				if(nearMonsters[i] && (nearMonsters[i] is Mob)){
					if(nearMonsters[i].level > _level){
						trace("You lose");
					}else{
						_mapController.removeObject(nearMonsters[i]);
					}
				}
			}
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
		
		public function set level(value:int):void{
			_level = value;
			levelLabel.text = value.toString();
		}
	}
}