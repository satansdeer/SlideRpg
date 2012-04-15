package managers
{
	/**
	 * ZOrderManager
	 * @author satansdeer
	 */
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import tiles.Tile;
	
	public class ZOrderManager extends EventDispatcher{
		
		private var _mapController:MapController;
		
		private static var _instance:ZOrderManager;
		
		public function ZOrderManager(mapController:MapController)
		{
			_instance = this;
			_mapController = mapController;
			super();
			
		}
		
		public static function get instance():ZOrderManager{
			return _instance;
		} 
		
		public function updateZorder():void{
			var objects:Array = _mapController.objectsMap;
			for(var x:int=0; x < objects.length; x++){
				for(var y:int=0; y < objects[x].length; y++){
					if(objects[x][y]){
						_mapController.objectsScene.setChildIndex(objects[x][y], y+x)
					}
				}
			}
		}
	}
}