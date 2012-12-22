package 
{
	import game.Ball;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import util.gTools;
	import org.flixel.plugin.photonstorm.FX.RainbowLineFX;
	
	public class MenuState extends FlxState 
	{
		public static var ref:MenuState;
		public var ball:Ball;
		public var ballTrail:FlxTrail;
		public var frozen:Boolean;
		public var inputDetected:Boolean = false;
		public var timePassed:int = 0;
		public var foreGround:FlxSprite;
		public var timer:int = 0;
		private var line1:RainbowLineFX;
		private var line2:RainbowLineFX;
		public var playButton:FlxButtonPlus;
		public var boom:FlxSound = FlxG.play(SFX.boom);
		
		override public function create():void
		{
			ref = this;
			
			FlxG.mouse.show();
			
			boom.loadEmbedded(SFX.boom, false);
				// Play button
			var play:FlxButtonPlus = new FlxButtonPlus(285, 310, playCallback, null, ">> [B]ig Bang", 270, 38);
			play.textNormal.size = 32;
			play.textHighlight.size = 32;
			var d:FlxSprite = new FlxSprite(0, 0);
			d.makeGraphic(270, 45, 0xFF000000);
			var e:FlxSprite = new FlxSprite(0, 0);
			e.makeGraphic(270, 45, 0xFF141414);
			play.loadGraphic(e, d);
			
			// Ball
			ball = new Ball( - 55,  - 5, IMG.blackBall);
			ball.maxVelocity.y = 500;
			ball.velocity.y = 1000;
			ball.velocity.x = 500;
			ballTrail = new FlxTrail(ball, IMG.trail2, 100, 1, 1, 0.002);
			add(ballTrail);
			add(ball);
			ball.visible = false;
			
			//	Test specific
			if (FlxG.getPlugin(FlxSpecialFX) == null) FlxG.addPlugin(new FlxSpecialFX);

			line1 = FlxSpecialFX.rainbowLine();
			line2 = FlxSpecialFX.rainbowLine();

			line1.create(0, 0, FlxG.width, 10, null, 360, 4);
			line2.create(0, FlxG.height - 10, FlxG.width, 10, null, 360, 4);
			line2.setDirection(1);
			add(line1.sprite);
			add(line2.sprite);
			
			// Watches
			FlxG.watch(FlxG.mouse, "x", "Mouse X");
			FlxG.watch(FlxG.mouse, "y", "Mouse Y");
			
			// Title
			var title:FlxSprite = new FlxSprite(20, 10, IMG.title);
			add(title);
			 
			createText(30, 400, "Deoxyribonucleic acid");
			createText(337, 190, "Double Helix");
			createText(130, 80, "RNA");
			createText(435, 388, "Chromosomes");
			createText(98, 475, "Nucleotides");
			createText(270, 260, "Evolution");
			createText(500, 250, "Darwin");
			createText(160, 160, "Chemistry");
			createText(10, 280, "Biology");
			createText(400, 140, "Quadruplex structures");
			createText(50, 30, "Mutation");
			createText(100, 350, "Observer");
			createText(230, 230, "Replication");
			createText(260, 480, "Proteines");
			createText(24, 530, "Curiosity");
			createText(467, 220, "Cell division");
			createText(516, 477, "ssDNA ");
			createText(140, 520, "flixel");
			
			var t:FlxText = new FlxText(5, 570, 500, "Created by Gama11 for LD #24 in 72 hours | Music by Los-Illuminados");
			add(t);
			t.alpha = 0.3;
			t.color = 0xFFFFFFFF;
			add(play);
			
			// Fader
			foreGround = new FlxSprite(0, 0);
			foreGround.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
			add(foreGround);
			
			if(FlxG.music != null) FlxG.music.kill();

			super.create();
		}
		
		override public function update():void
		{	
			timePassed++;
			
			ball.angle += 12;
			ball.velocity.x += (timePassed / 2) * (timePassed / 2);
			
			if (timePassed >= 70) foreGround.alpha -= 0.02;
			
			for (var i:int; i < ballTrail.length; i++)
			{
				var trailSprite:FlxSprite = ballTrail.members[i];
				trailSprite.angle += 12;
			}
				
			if (ball.y > FlxG.height) {
				ball.kill();
				ballTrail.freeze = true;
			}
			
			if (FlxG.keys.pressed("B")) playCallback();
			
			super.update();
		}
		
		override public function destroy():void
		{
			//	Important! Clear out the plugin, otherwise resources will get messed right up after a while
			FlxSpecialFX.clear();

			super.destroy();
		}

		public function createText(X:int, Y:int, Text:String):void
		{
			var t:FlxText = new FlxText(X, Y, FlxG.width, Text);
			add(t);
			t.color = Math.random() * 0xFFFFFFF;
			t.size = gTools.rnd(10, 14);
			t.alpha = gTools.rnd(3, 8) / 10;
		}
		
		private function playCallback():void
		{
			FlxG.fade(0xFFFFFFFF, 3.5, toggle);
			boom.play();
			FlxG.shake(0.005, 0.5);
		}
		
		private function toggle():void
		{
			FlxG.switchState(new GameState);
		}
	}	
}