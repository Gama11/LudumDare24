package 
{
	import org.flixel.*;
	import org.flixel.system.*;

	[SWF(width="600", height="600", backgroundColor="#000000")]
	[Frame(factoryClass = "Preloader")]
	
	public class Main extends FlxGame 
	{
		public function Main():void
		{
			super(600, 600, MenuState, 1, 60, 60);
		}
	}
}