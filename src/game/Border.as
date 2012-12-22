package game 
{
	import org.flixel.*;
	
	public class Border extends FlxSprite
	{
		private var gs:GameState = GameState.ref;
		
		public var activated:Boolean = false;
		
		override public function Border(X:int = 0, Y:int = 0, Width:int = 1, Height:int = 1):void
		{
			super(X, Y);	
			makeGraphic(Width, Height);
			immovable = true;
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}