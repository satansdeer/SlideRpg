package
{
	/**
	 * GameController
	 * @author satansdeer
	 */
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class GameController extends EventDispatcher{
		public function GameController(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}