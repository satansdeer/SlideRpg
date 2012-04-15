package
{
	/**
	 * MapController
	 * @author satansdeer
	 */
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.html.ControlInitializationError;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	
	import managers.ZOrderManager;
	
	import tiles.Button;
	import tiles.Door;
	import tiles.GroundTile;
	import tiles.Hero;
	import tiles.Mob;
	import tiles.SlidingObject;
	import tiles.Tile;
	import tiles.Wall;
	
	public class MapController extends EventDispatcher{
		
		public var groundScene:Sprite = new Sprite;
		public var objectsScene:Sprite = new Sprite;
		
		private var _loader:URLLoader;
		private var groundTile:Array = new Array;
		public var objectsMap:Array = new Array;
		private const sceneWidth:int = 16;
		private const sceneHeight:int = 10;
		private var slidingObjectsManager:SlidingObjectsManager;
		private var zorderManager:ZOrderManager;
		private var slidingObjects:Array = [];
		public var triggerObjects:Array = [];
		public var hero:Hero;
		public var buttons:Array = [];
		private var _monsterForNumberChange:Mob;
		private var _buttonForIdChange:Button;
		private var _doorForIdChange:Door;
		
		public function MapController(target:IEventDispatcher=null)
		{
			super(target);
			zorderManager = new ZOrderManager(this);
			addListeners();
			initMap();
			objectsScene.mouseChildren = false;
			objectsScene.mouseEnabled = false;
			slidingObjectsManager = new SlidingObjectsManager(this,objectsMap);
			drawMap(null);
		}
		
		private function addListeners():void {
			groundScene.addEventListener(MouseEvent.CLICK, onGroundClick);
			KeyboardListener.instance.addEventListener(KeyboardListener.SLIDE_LEFT, onSlide);
			KeyboardListener.instance.addEventListener(KeyboardListener.SLIDE_RIGHT, onSlide);
			KeyboardListener.instance.addEventListener(KeyboardListener.SLIDE_UP, onSlide);
			KeyboardListener.instance.addEventListener(KeyboardListener.SLIDE_DOWN, onSlide);
		}
		
		protected function onSlide(event:Event):void{
			slidingObjectsManager.slide(slidingObjects,event.type);
			zorderManager.updateZorder();
		}
		
		protected function onGroundClick(event:MouseEvent):void{
			if(!objectsMap[event.target.mapX][event.target.mapY]){
				_monsterForNumberChange = null;
				_buttonForIdChange = null
				switch(KeyboardListener.instance.mode){
						case "usuall":
							addWall(event.target.mapX, event.target.mapY);
							break;
						case "monster":
							addMob(event.target.mapX, event.target.mapY);
							break;
						case "hero":
							addHero(event.target.mapX, event.target.mapY);
							break;
						case "button":
							addButton(event.target.mapX, event.target.mapY);
							break;
						case "door":
							addDoor(event.target.mapX, event.target.mapY);
							break;
				}
			}else{
				switch(KeyboardListener.instance.mode){
					case "monster":
						setMobLevel(event.target.mapX, event.target.mapY);
						break;
					case "button":
						setButtonId(event.target.mapX, event.target.mapY);
						break;
					case "door":
						setDoorId(event.target.mapX, event.target.mapY);
						break;
					default:
					removeObject(objectsMap[event.target.mapX][event.target.mapY])
					break;
				}
			}
		}
		
		private function setDoorId(x:int, y:int):void{
			KeyboardListener.instance.startGettingNumber();
			_doorForIdChange = objectsMap[x][y];
			KeyboardListener.instance.resetNum();
			KeyboardListener.instance.addEventListener("gotNumber", onGotDoorId);
		}
		
		protected function onGotDoorId(event:Event):void{
			KeyboardListener.instance.removeEventListener("gotNumber", onGotDoorId);
			_doorForIdChange.id = event.target.num;
			event.target.resetNum();
		}
		
		private function setButtonId(x:int, y:int):void{
			KeyboardListener.instance.startGettingNumber();
			_buttonForIdChange = objectsMap[x][y];
			KeyboardListener.instance.resetNum();
			KeyboardListener.instance.addEventListener("gotNumber", onGotButtonId);
		}
		
		protected function onGotButtonId(event:Event):void{
			KeyboardListener.instance.removeEventListener("gotNumber", onGotButtonId);
			_buttonForIdChange.id = event.target.num;
			event.target.resetNum();
		}
		
		private function setMobLevel(x:int, y:int):void{
			KeyboardListener.instance.startGettingNumber();
			_monsterForNumberChange = objectsMap[x][y];
			KeyboardListener.instance.resetNum();
			KeyboardListener.instance.addEventListener("gotNumber", onGotMonsterLevel);
		}
		
		protected function onGotMonsterLevel(event:Event):void{
			KeyboardListener.instance.removeEventListener("gotNumber", onGotMonsterLevel);
			_monsterForNumberChange.level = event.target.num;
			event.target.resetNum();
		}
		
		private function addHero(x:int, y:int):void{
			if(!hero){
				hero = new Hero(this);
				hero.x = x * 32;
				hero.y = y * 32;
				hero.mapX = x;
				hero.mapY = y;
				objectsScene.addChild(hero);
				objectsMap[x][y] = hero;
				slidingObjects.push(hero);
			}else{
				if(!objectsMap[x][y]){
					objectsMap[hero.mapX][hero.mapY] = null;
					hero.x = x * 32;
					hero.y = y * 32;
					hero.mapX = x;
					hero.mapY = y;
					objectsMap[x][y] = hero;
				}
			}
			hero.controller = this;
			zorderManager.updateZorder();
		}
		
		private function initMap():void {
			for(var x:int = 0; x<sceneWidth; x++ ){
				if(!objectsMap[x]){objectsMap[x] = new Array}
				for(var y:int = 0; y<sceneHeight; y++ ){
					objectsMap[x][y] = null;
					zorderManager.updateZorder();
				}
			}
		}
		
		public function addMob(x:int, y:int):void{
			if(!objectsMap[x][y]){
				var mob:Mob = new Mob();
				mob.x = x * 32;
				mob.y = y * 32;
				mob.mapX = x;
				mob.mapY = y;
				mob.controller = this;
				slidingObjects.push(mob);
				objectsScene.addChild(mob);
				objectsMap[x][y] = mob;
				zorderManager.updateZorder();
			}
		}
		
		public function addButton(x:int, y:int):void{
			if(!objectsMap[x][y]){
				var button:Button = new Button();
				button.x = x * 32;
				button.y = y * 32;
				button.mapX = x;
				button.mapY = y;
				button.controller = this;
				buttons.push(button)
				objectsScene.addChild(button);
				objectsMap[x][y] = button;
				zorderManager.updateZorder();
			}
		}
		public function addDoor(x:int, y:int):void{
			if(!objectsMap[x][y]){
				var door:Door = new Door();
				door.x = x * 32;
				door.y = y * 32;
				door.mapX = x;
				door.mapY = y;
				objectsScene.addChild(door);
				triggerObjects.push(door);
				objectsMap[x][y] = door;
				zorderManager.updateZorder();
			}
		}
		
		public function loadMap(mapName:String):void{
			var request:URLRequest = new URLRequest(mapName);
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onMapLoaded);
		}
		
		protected function onMapLoaded(event:Event):void{
			drawMap(event.target.data);
		}
		
		protected function drawMap(value:String):void{
			var tile:Tile;
			for(var x:int = 0; x<sceneWidth; x++){
				for(var y:int = 0; y<sceneHeight; y++){
					tile = new GroundTile();
					tile.x = x * 32;
					tile.mapX = x;
					tile.y = y * 32;
					tile.mapY = y;
					groundScene.addChild(tile);
					groundTile.push(tile);
				}
			}
			addWalls();
		}
		
		private function addWall(x:int, y:int):void{
			if(!objectsMap[x][y]){
				var wall:Wall = new Wall();
				wall.x = x * 32;
				wall.y = y * 32;
				wall.mapX = x;
				wall.mapY = y;
				objectsScene.addChild(wall);
				objectsMap[x][y] = wall;
				zorderManager.updateZorder();
			}
		}
		
		private function addWalls():void {
			var wall:Wall;
			for(var i:int = 0; i<sceneWidth; i++){
				wall = new Wall();
				wall.x = i * 32;
				wall.mapX = i;
				wall.mapY = 0;
				objectsScene.addChild(wall)
				objectsMap[i][0] = wall;
			}
			for(i=1; i<(sceneHeight-1); i++){
				wall = new Wall();
				wall.y = i * 32;
				wall.mapX = 0;
				wall.mapY = i;
				objectsScene.addChild(wall)
				objectsMap[0][i] = wall;
			}
			for(i=1; i<(sceneHeight-1); i++){
				wall = new Wall();
				wall.y = i * 32;
				wall.x = (sceneWidth - 1) * 32;
				wall.mapX = sceneWidth - 1;
				wall.mapY = i;
				objectsScene.addChild(wall)
				objectsMap[sceneWidth - 1][i] = wall;
			}
			for(i=0; i<sceneWidth; i++){
				wall = new Wall();
				wall.x = i * 32;
				wall.y = (sceneHeight-1) * 32;
				wall.mapX = i;
				wall.mapY = sceneHeight-1;
				objectsScene.addChild(wall)
				objectsMap[i][sceneHeight -1] = wall;
			}
			zorderManager.updateZorder();
		}
		
		public function removeObject(param0:Tile):void {
			objectsScene.removeChild(param0);
			objectsMap[param0.mapX][param0.mapY] = null;
			slidingObjects.splice(slidingObjects.indexOf(param0),1);
		}
	}
}