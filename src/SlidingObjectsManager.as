package
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	
	import managers.ZOrderManager;
	
	import tiles.Button;
	import tiles.Tile;

	/**
	 * SlidingObjectsManager
	 * @author satansdeer
	 */
	public class SlidingObjectsManager{
		
		private var _objMap:Array;
		private var canSlide:Boolean = true;
		private var counter:uint;
		
		private var _mapManager:MapController;
		
		public function SlidingObjectsManager(mapManager:MapController, objMap:Array)
		{
			_objMap = objMap;
			_mapManager = mapManager;
		}
		
		public function slide(objects:Array, direction:String):void{
			if(counter == 0){
				canSlide = true;
			}
			if(canSlide){
				canSlide = false;
			var tempArray:Array = [];
			var movedObjects:Array;
			for(i = 0; i<objects.length; i++){
				objects[i].achievedDestination = false;
			}
			for(var i:int = 0; i<objects.length; i++){
				objects[i].destX = objects[i].mapX;
				objects[i].destY = objects[i].mapY;
				objects[i].achievedDestination = false;
				if(!checkCollisionWithStaticObject(objects[i], direction)){
					tempArray.push(objects[i]);
				}else{
					objects[i].achievedDestination = true;
					trace("acheved destination")
				}
			}
			movedObjects = tempArray.concat();
			objects = tempArray.concat();
			tempArray = [];
			while(objects.length > 0){
				for(i = 0; i<objects.length; i++){
					if(!checkCollisionWithStaticObject(objects[i], direction)){
						tempArray.push(objects[i]);
					}else{
						objects[i].achievedDestination = true;
					}
					if(checkEmptySpace(objects[i], direction)){
						if(!(_objMap[objects[i].destX][objects[i].destY] is Button))
						_objMap[objects[i].destX][objects[i].destY] = null;
						updateDestination(objects[i], direction);
						if(!(_objMap[objects[i].destX][objects[i].destY] is Button))
						_objMap[objects[i].destX][objects[i].destY] = objects[i];
					}
				}
				objects = tempArray.concat();
				tempArray = [];
			}
			counter = movedObjects.length; 
			tweenObjects(movedObjects);
			}else{
				trace("can not slide " + counter );
			}
		}
		
		private function tweenObjects(movedObjects:Array):void {
			for(var i:int=0; i<movedObjects.length; i++){
				var dX:int = movedObjects[i].mapX - movedObjects[i].destX;
				var dY:int = movedObjects[i].mapY - movedObjects[i].destY;
				TweenMax.to(movedObjects[i], time(dX, dY), {x:movedObjects[i].destX * 32, y:movedObjects[i].destY * 32, ease:Cubic.easeIn, onComplete:onFinish});
				movedObjects[i].mapX = movedObjects[i].destX;
				movedObjects[i].mapY = movedObjects[i].destY;
			}
		}
		
		private function onFinish():void{
			counter--;
			if(counter <= 0){
				canSlide = true;
				if(_mapManager.hero){
					_mapManager.hero.hitNearMonters();
					ZOrderManager.instance.updateZorder();
				}	
			}
		}
		
		private function time(dX:int, dY:int):Number{
			return Math.abs((dX+dY)/10);
		}
		
		private function updateDestination(obj:Object, direction:String):void {
			switch(direction){
				case KeyboardListener.SLIDE_DOWN:
					obj.destY +=1;
					break;
				case KeyboardListener.SLIDE_UP:
					obj.destY -=1;
					break;
				case KeyboardListener.SLIDE_LEFT:
					obj.destX -=1;
					break;
				case KeyboardListener.SLIDE_RIGHT:
					obj.destX +=1;
					break;
			}
		}
		
		private function checkEmptySpace(obj:Object, direction:String):Boolean {
			var tile:Tile;
			switch(direction){
				case KeyboardListener.SLIDE_DOWN:
					tile = _objMap[obj.destX][obj.destY + 1];
					if(!(tile) || (tile.noclip)){
						if(tile){
							tile.activate();
						}
						return true;
					}
					return false;
					break;
				case KeyboardListener.SLIDE_UP:
					tile = _objMap[obj.destX][obj.destY - 1];
					if(!(tile) || (tile.noclip)){
						if(tile){
							tile.activate();
						}
						return true;
					}
					return false;
					break;
				case KeyboardListener.SLIDE_LEFT:
					tile = _objMap[obj.destX - 1][obj.destY];
					if(!(tile) || (tile.noclip)){
						if(tile){
							tile.activate();
						}
						return true;
					}
					return false;
					break;
				case KeyboardListener.SLIDE_RIGHT:
					tile = _objMap[obj.destX + 1][obj.destY];
					if(!(tile) || (tile.noclip)){
						if(tile){
							tile.activate();
						}
						return true;
					}
					return false;
					break;
				default:
					return false;
					break;
			}
		}
		
		private function checkCollisionWithStaticObject(obj:Object, direction:String):Boolean {
			switch(direction){
				case KeyboardListener.SLIDE_DOWN:
					if((_objMap[obj.destX][obj.destY + 1]) && (_objMap[obj.destX][obj.destY + 1].achievedDestination) && !(_objMap[obj.destX][obj.destY + 1].noclip)){
						return true;
					}
					obj.achievedDestination = false;
					return false;
					break;
				case KeyboardListener.SLIDE_UP:
					if((_objMap[obj.destX][obj.destY - 1]) && (_objMap[obj.destX][obj.destY - 1].achievedDestination) && !(_objMap[obj.destX][obj.destY - 1].noclip)){
						return true;
					}
					obj.achievedDestination = false;
					return false;
					break;
				case KeyboardListener.SLIDE_LEFT:
					if((_objMap[obj.destX - 1][obj.destY]) && (_objMap[obj.destX - 1][obj.destY].achievedDestination) && !(_objMap[obj.destX - 1][obj.destY].noclip)){
						return true;
					}
					obj.achievedDestination = false;
					return false;
					break;
				case KeyboardListener.SLIDE_RIGHT:
					if((_objMap[obj.destX + 1][obj.destY]) && (_objMap[obj.destX + 1][obj.destY].achievedDestination) && !(_objMap[obj.destX + 1][obj.destY].noclip)){
						return true;
					}
					obj.achievedDestination = false;
					return false;
					break;
				default:
					return false;
					break;
			}
		}
	}
}