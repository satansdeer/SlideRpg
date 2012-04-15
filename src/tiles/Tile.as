package tiles
{
	/**
	 * Tile
	 * @author satansdeer
	 */
	import core.AssetEvent;
	import core.AssetManager;
	import core.InteractivePNG;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Tile extends InteractivePNG{
		
		public var noclip:Boolean;
		
		private var _mapX:int;
		private var _mapY:int;
		
		public var destX:int;
		public var destY:int;
		
		public var slidable:Boolean;
		
		public var achievedDestination:Boolean = true;
		
		protected var url:String;
		
		public var controller:MapController;
		
		public function Tile()
		{
			super(null);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedToStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onRemovedToStage(event:Event):void{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedToStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}		
		
		protected function onAddedToStage(event:Event):void{
			setImg()
		}
		
		public function activate():void{
			
		}
		
		public function get mapX():int{
			return _mapX;
		}
		
		public function set mapX(value:int):void{
			if(_mapX != value){
				_mapX = value;
				activateButtons(mapX, mapY);
			}
		}
		
		public function get mapY():int{
			return _mapY;
		}
		
		public function set mapY(value:int):void{
			if(_mapY != value){
				_mapY = value;
				activateButtons(mapX, mapY);
			}
		}
		
		private function activateButtons(mX:int, mY:int):void {
			if(controller){
				/*trace(controller.buttons.length)
				for(var i:int=0; i< controller.buttons.length; i++){
					if((controller.buttons[i].mapX == mX) && (controller.buttons[i].mapY== mY)){
						controller.buttons[i].activate();
					}
				}*/
			}
		}
		
		override public function set x(value:Number):void{
			super.x = value;
		//	mapX = int(value/16);
		}
		
		override public function set y(value:Number):void {
			super.y = value;
		//	mapY = int(value/10);
		}
		
		
		protected function setImg():void{
			if(AssetManager.existInCache(url)){
				src =  AssetManager.getImageByURL(url)
				width = 32;
				height = 64;
			}else{
				AssetManager.instance.addEventListener(AssetEvent.ASSET_LOADED, onAssetLoaded);
				if(!AssetManager.existInQueue(url)){
					AssetManager.load(url);
				}
			}
		}
		
		protected function onAssetLoaded(event:AssetEvent):void{
			if(url == event.url){
				AssetManager.instance.removeEventListener(AssetEvent.ASSET_LOADED, onAssetLoaded);
				src =  AssetManager.getImageByURL(url);
				width = 32;
				height = 64;
			}
		}
	}
}