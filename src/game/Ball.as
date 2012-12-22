package game 
{
	import flash.display.InteractiveObject;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxColor;
	import org.flixel.plugin.photonstorm.FlxDelay;
	
	public class Ball extends FlxSprite
	{
		private var gs:GameState = GameState.ref;
		public var shootEnabled:Boolean = false;
		
		private var shootCounter:int = 0;
		public var shootIntervall:int = 50;
		public var shotSpeed:int = 300;
		public var wasHit:int = -1;
		
		override public function Ball(X:int, Y:int, Image:Class):void
		{
			super(X, Y, IMG.blackBall);
			makeGraphic(14, 14);
			elasticity = 1;
			velocity.x = 200;
			velocity.y = 200;
			maxVelocity.x = 300;
			maxVelocity.y = 300;
		}
		
		override public function update():void
		{	
			if (wasHit > -1) wasHit++;
			if (wasHit > 20) wasHit = -1;
			
			angle += 12;
			
			super.update();
		}
		
		override public function kill():void
		{
			if(gs != null) gs.head.kill();
			super.kill();
		}
	}
}