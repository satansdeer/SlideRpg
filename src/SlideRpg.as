package
{
	/**
	 * SlideRpg
	 * @author satansdeer
	 */
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.casalib.util.StageReference;
	
	[SWF(width=512, height=320, frameRate=45, backgroundColor="0x000000")]
	public class SlideRpg extends Sprite{
		public var gameController:GameController;
		public var mapController:MapController; 
		private var keyboardListener:KeyboardListener;
		
		public function SlideRpg(){
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:Event):void{
			StageReference.setStage(stage);			
			init();
		}
		
		public function init():void{
			keyboardListener = new KeyboardListener();
			mapController = new MapController();
			gameController = new GameController();
			addChild(mapController.groundScene);
			addChild(mapController.objectsScene);
		}
	}
}