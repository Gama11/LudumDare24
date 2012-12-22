package game 
{
	import flash.display.InteractiveObject;
	import org.flixel.*;
	import util.gTools;
	import org.flixel.plugin.photonstorm.FlxMath;
	import org.flixel.plugin.photonstorm.*;
	
	public class Rival extends FlxSprite
	{
		private var gs:GameState = GameState.ref;
		private var trail:FlxTrail;
		private var lifeTime:int = 0;
		private var launchPic:Class = IMG.redBall;;
		private var size:FlxPoint = new FlxPoint(14, 14);
		private var colord:uint = FlxU.makeColorFromHSB(Math.random() * 360, 1, 1);
		private var sinusMove:Boolean = false;
		private var horizontal:Boolean = true;
		private var vertical:Boolean = true;
		public var minSpeed:int = 200 + gs.enemyStat * 5;
		public var maxSpeed:int = 250 + gs.enemyStat * 5;
		public var damage:int = gs.enemyStat;
		public var wasHit:int = -1;
		
		override public function Rival():void
		{
			health = gs.enemyStat * 3;
			FlxG.log(health);
			var safety:int = 40;
			super(gTools.rnd(safety, FlxG.width - safety), gTools.rnd(safety, FlxG.height - safety));			
			alpha = 0;
			
			size.x = gTools.rnd(10, 20 + gs.enemyStat);
			size.y = gTools.rnd(10, 20 + gs.enemyStat);
			
			makeGraphic(size.x, size.y);
			
			if (FlxMath.chanceRoll()) angle = 90;
			var chaseChance:int = 5 + gs.enemyStat * 3;
			if (chaseChance > 25) chaseChance = 25;
			
			var primitiveChance:int = 30 - gs.enemyStat * 3;
			if (primitiveChance <= 0) primitiveChance = 1;
			
			if (FlxMath.chanceRoll(chaseChance)) sinusMove = true;
			if (FlxMath.chanceRoll(primitiveChance)) horizontal = false;
			if (FlxMath.chanceRoll(primitiveChance) && horizontal) vertical = false;
		}
		
		override public function update():void
		{	
			if (wasHit > -1) wasHit++;
			if (wasHit > 10) wasHit = -1;
			
			lifeTime++;
			if (lifeTime > 300 && elasticity != 1) launch();
			if (sinusMove && elasticity == 1) FlxVelocity.moveTowardsObject(this, gs.ball, minSpeed);
			angle += gTools.rnd(1, 5);
			
			if (alpha < 1) alpha += 1/300;
			
			super.update();
		}
		
		public function launch():void
		{
			if (vertical) velocity.x = gTools.rnd(minSpeed, maxSpeed);
			if (horizontal) velocity.y = gTools.rnd(minSpeed, maxSpeed);
			elasticity = 1;
			velocity.x *= FlxMath.randomSign();
			velocity.y *= FlxMath.randomSign();
		
			makeGraphic(size.x, size.y, colord);
			
			trail = new FlxTrail(this, launchPic, 3, 4, 0.2);
			
			for (var i:int = 0; i < trail.length; i++)
			{
				trail.members[i].makeGraphic(size.x, size.y, colord);
			}
			
			gs.eTrails.add(trail);
		}
		
		override public function kill():void
		{
			if(trail != null) trail.kill();
			
			var e:FlxEmitter = gs.enemies.eEmitter;
			e.x = x;
			e.y = y;
			e.start(true, 0, 0.2, 5);
			
			FlxG.play(SFX.enemyBoom);
			
			alive = false;
			exists = false;
		}
	}
}