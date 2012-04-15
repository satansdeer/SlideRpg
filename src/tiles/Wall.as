package tiles
{
	/**
	 * Wall
	 * @author satansdeer
	 */
	public class Wall extends Tile{
		public function Wall()
		{
			url = "assets/Wall Block.png"
			super();
			offsetY = 32;
			mouseEnabled = false;
			mouseChildren = false;
		}
	}
}