package game 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import util.gTools;
	
	public class Enemies extends FlxGroup
	{
		private var gs:GameState = GameState.ref;
		private var evoCount:int = 0;
		private var evolution:int = 0;
		public var eEmitter:FlxEmitter;
		
		override public function Enemies():void
		{
			super();
			
			eEmitter = gs.createEmitter();
			gs.add(eEmitter);
			
			for (var i:int = 0; i < 3; i++) 
			{ 
				var enemy:Rival = new Rival();
				add(enemy);
			}
		}
		
		override public function update():void
		{
			if (gs.ball.alive) evoCount ++; 
			if (evoCount > 300) evolve();
			
			
				
			super.update();
		}
		
		public function evolve():void
		{
			createEnemy(Math.floor(gs.enemyStat / 10) + 1);
			gs.enemyStat += 1;
			gs.enemyText.text = "Rivals: L" + gs.enemyStat;
			gs.enemyText.bounce(0, -20);
			gs.enemyText.alpha = 1;
			if(gs.borders.counterIntervall > 50) gs.borders.counterIntervall -= 2;
			
			FlxG.play(SFX.enemyUp);
			
			evoCount = 0;
		}
		
		public function createEnemy(number:int = 1):void
		{
			for (var i:int; i < number; i++)
			{
				var rival:Rival = new Rival();
				add(rival);
			}
		}
		
		public function oEnemyBall(e:Rival, b:Ball):void
		{
			if (gs.ball.wasHit > 0 || e.elasticity != 1) return;
			
			b.wasHit = 0;
			e.wasHit = 0;
			e.hurt(gs.speedStat);
			
			gs.emitter.x = b.x;
			gs.emitter.y = b.y;
			gs.emitter.start(true, 0, 0.1, 10);	
			
			gs.combo = 0;
			gs.dnaLeft.text = "Combo: " + gs.combo;
			FlxG.shake(0.005);
			gs.changeDNA(- (gs.enemyStat));
		}
	}
}