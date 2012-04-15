package
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	
	import org.casalib.ui.Key;
	import org.casalib.util.StageReference;

	/**
	 * KeyboardListener
	 * @author satansdeer
	 */
	public class KeyboardListener extends EventDispatcher{
		public var mode:String = "usuall";
		
		private static var _instance:KeyboardListener;
		
		
		public static const SLIDE_LEFT:String = "slide_left";
		public static const SLIDE_UP:String = "slide_up";
		public static const SLIDE_RIGHT:String = "slide_right";
		public static const SLIDE_DOWN:String = "slide_down";
		public var altMode:Boolean;
		
		public var _num:String = new String();
		
		public function KeyboardListener()
		{
			_instance = this;
			StageReference.getStage().addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			StageReference.getStage().addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		public static function get instance():KeyboardListener{
			return _instance;
		}
		
		public function startGettingNumber():void{
			
		}
		
		protected function onKeyUp(event:KeyboardEvent):void{
			switch(event.keyCode){
				case 77:
					mode = "usuall";
					break;
				case 72:
					mode = "usuall";
					break;
				case 66:
					mode = "usuall";
					break;
				case 68:
					mode = "usuall";
					break;
			}
		}
		
		public function get num():int{
			return int(_num);
		}
		
		public function resetNum():void{
			_num = "";
		}
		
		protected function onKeyDown(event:KeyboardEvent):void{
			var char:String = String.fromCharCode(event.charCode);
			if(event.keyCode != 13){
				_num =_num.concat(char);
			}
			trace(event.keyCode);
			switch(event.keyCode){
				case 13:
					dispatchEvent(new Event("gotNumber"));
					break;
				case 18:
					altMode = !altMode;
					break;
				case 68:
					mode = "door"
					break;
				case 77:
					mode = "monster"
					break;
				case 72:
					mode = "hero"
					break;
				case 66:
					mode = "button"
					break;
				case 37:
					dispatchEvent(new Event(SLIDE_LEFT));
					break;
				case 38:
					dispatchEvent(new Event(SLIDE_UP));
					break;
				case 39:
					dispatchEvent(new Event(SLIDE_RIGHT));
					break;
				case 40:
					dispatchEvent(new Event(SLIDE_DOWN));
					break;
			}
		}
	}
}