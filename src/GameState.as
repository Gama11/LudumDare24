package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import game.*;
	import org.flixel.plugin.photonstorm.FX.StarfieldFX;
	import util.gTools;
	import org.flixel.plugin.photonstorm.API.FlxKongregate;
	
	public class GameState extends FlxState
	{
		public static var ref:GameState;
		public var ball:Ball;
		public var borders:Borders;
		public var ballTrail:FlxTrail;
		public var size:int = 14;
		
		public var enemies:Enemies;
		public var emitter:FlxEmitter;
		public var floatTexts:FlxGroup;
		public var subGroup:FlxGroup;
		public var eTrails:FlxGroup;
		public var head:FlxSprite;
		
		public var stars:FlxSprite;
		public var starfield:StarfieldFX;

		public var framesPassed:int = 0;
		public var startDNA:int = 10;
		public var DNA:int = startDNA;
		
		public var dnaText:FlxText;
		public var dnaLeft:FlxText;
		public var years:FlxText;
		
		public var enemyText:FlxText;
		public var speedText:FlxText;
		public var centerText:FlxText;
		public var instruction:FlxText;
		
		public var enemyStat:int = 1;
		public var speedStat:int = 1;
		
		public var speed:int = 15;
		public var combo:int = 0;
		public var maxCombo:int = 0;
		public var maxDna:int = 0;
		
		public var leftToUpgrade:int = 1;

		public var timesUpgraded:int = 0;
		public var kong:KongAPI;
		
		public var gameOverInstruction:String = "[ESC]ape or [R]estart";
		
		override public function create():void
		{
			ref = this;
			
			FlxG.mouse.hide();
			
			// Starfield
			if (FlxG.getPlugin(FlxSpecialFX) == null) FlxG.addPlugin(new FlxSpecialFX);
			starfield = FlxSpecialFX.starfield();
			stars = starfield.create(0, 0, FlxG.width, FlxG.height, 200, 2);
			add(stars);
			stars.alpha = 0.5;
			
			var statSize:int = 25;
			var statAlpha:Number = 0.1;
			var statY:int = 555;
			
			var gui:FlxGroup = new FlxGroup();
			add(gui);
			
			speedText = new FlxText(26, statY, FlxG.width, "You: L" + speedStat);
			speedText.size = statSize;
			speedText.color = 0xFFFFFFFF;
			speedText.alpha = statAlpha;
			gui.add(speedText);
			
			enemyText = new FlxText(420, statY, FlxG.width, "Rivals: L" + enemyStat);
			enemyText.size = statSize;
			enemyText.color = 0xFFFFFFFF;
			enemyText.alpha = statAlpha;
			gui.add(enemyText);
			
			centerText = new FlxText(0, FlxG.height / 2 - 60, FlxG.width, "");
			centerText.alignment = "center";
			centerText.alpha = 0.5;
			centerText.color = 0xFFFFFFFF;
			centerText.size = 45;
			add(centerText);
			centerText.solid = true;
			
			instruction = new FlxText(0, FlxG.height / 2, FlxG.width, "Hit colored borders. Use arrow keys.");
			instruction.alignment = "center";
			instruction.alpha = 0.5;
			instruction.color = 0xFFFFFFFF;
			instruction.size = 25;
			add(instruction);
			instruction.solid = true;
			
			// Ball
			ball = new Ball(FlxG.width / 2 + 100 - 300, FlxG.height / 2, IMG.redBall);
			ballTrail = new FlxTrail(ball, IMG.trail, startDNA, 1, 0.4, 0);
			
			add(ballTrail);
			subGroup = new FlxGroup();
			add(subGroup);
			add(ball);
			
			head = new FlxSprite(0, 0, IMG.head);
			add(head);
			
			// Groups
			eTrails = new FlxGroup();
			add(eTrails);
			
			enemies = new Enemies();
			add(enemies);
			
			// emitter
			add(createEmitter());
			
			// Borders
			borders = new Borders();
			add(borders);
			floatTexts = new FlxGroup;
			add(floatTexts);
			
			// GUI
			dnaText = new FlxText(260, 2, FlxG.width, "DNA: " + startDNA);
			add(dnaText);
			dnaLeft = new FlxText(430, 2, FlxG.width, "Combo: 0");
			add(dnaLeft);
			
			dnaLeft.size = 16;
			dnaText.size = 16;
			years = new FlxText(10, 2, FlxG.width, "Years passed: 1 M");
			add(years);
			years.size = 16;
			
			FlxG.playMusic(SFX.chop, 0.5);
			
			FlxKongregate.init(apiHasLoaded);
			
			super.create();
		}

		private function apiHasLoaded():void
		{
			FlxKongregate.connect();
		}
		
		public function createEmitter():FlxEmitter
		{
			emitter = new FlxEmitter();
			emitter.makeParticles(IMG.blackBall, 50);

			for each (var i:FlxParticle in emitter.members)
			{	
				var particleColor:uint = FlxU.makeColorFromHSB(Math.random() * 360, 1, 1);
				var size:int = 3;
				i.makeGraphic(size, size, particleColor);
			}	
			emitter.gravity = 600;
			var emitterSpeed:int = 400;
			emitter.setXSpeed(-emitterSpeed, emitterSpeed); 
			emitter.setYSpeed(-emitterSpeed, emitterSpeed); 
			return emitter;
		}
		
		override public function update():void
		{
			// Colissions
			FlxG.collide(borders, ball, oBorderBall);
			FlxG.collide(enemies, borders);
			FlxG.collide(enemies, ball, enemies.oEnemyBall);
			FlxG.collide(ballTrail, enemies);
			
			// Update texts
			years.text = "Years passed: " + framesPassed / 100 + " M";
			if (ball.alive) framesPassed ++;
			else {
				FlxG.music.volume -= 0.002;
				dnaText.text = "Max DNA: " + maxDna;
			}

			if (speedText.alpha > 0.1) speedText.alpha -= 0.01;
			if (enemyText.alpha > 0.1) enemyText.alpha -= 0.01;
			
			if (FlxG.keys.pressed("RIGHT")) ball.velocity.x += speed;
			if (FlxG.keys.pressed("LEFT")) ball.velocity.x -= speed;
			if (FlxG.keys.pressed("UP")) ball.velocity.y -= speed;
			if (FlxG.keys.pressed("DOWN")) ball.velocity.y += speed;
			
			if (FlxG.keys.pressed("ESCAPE")) toggle();	
			if (FlxG.keys.pressed("R") && !ball.alive) FlxG.switchState(new GameState);
			
			handleFloatTexts();
			
			if (framesPassed > 120 && ball.alive) instruction.visible = false;
			
			super.update();
		}
		
		private function oBorderBall(b:Border, bal:FlxSprite):void
		{
			emitter.x = bal.x;
			emitter.y = bal.y;
			emitter.start(true, 0, 0.1, 10);
			borders.hit(b);
		}	
		override public function destroy():void
		{
			FlxSpecialFX.clear();

			super.destroy();
		}
		
	    private function handleFloatTexts():void
        {
            for (var i:int = 0; floatTexts.length; i++){
                var cur:FlxText = floatTexts.members[i];
            
                if (cur == null) return;
                               
                cur.alpha -= 0.02;
                               
                if (cur.alpha <= 0) cur.kill();
			}
        }	
		
		public function createFloatText(X:int, Y:int, Text:String = "", Color:uint = 0xFFFFFFFF, Size:int = 12, Alignment:String = "left"):void
		{
			var deadText:FlxText = floatTexts.getFirstDead() as FlxText;
			var _text:FlxText;
			
			if (deadText == null) _text = new FlxText(X, Y, FlxG.width, Text);
			else {
				deadText.reset(X, Y);
				_text = deadText;
			}
			
			_text.alpha = 1;
			_text.color = Color;
			_text.velocity.y = 20;
			_text.size = Size;
			_text.text = Text;
			_text.alignment = Alignment;
			floatTexts.add(_text);
		}

		public function toggle():void
		{
			FlxG.switchState(new MenuState);
		}
		
		public function changeDNA(amount:int):void
		{
			if (amount > 0) {
				ballTrail.increaseLength(amount * 1);
				
				var xAdjust:int = 0;
				if (ball.x > FlxG.width - 200) xAdjust = -100;
				createFloatText(ball.x + xAdjust, ball.y, "DNA +" + amount, 0xFF008000);	
				leftToUpgrade -= amount;
			}
			else {
				createFloatText(ball.x, ball.y, "DNA " + amount , 0xFFFF0000);
				
				ballTrail.kill();
				ballTrail = new FlxTrail(ball, IMG.trail, DNA, 1, 0.7, 0);
				subGroup.add(ballTrail);
				
				FlxG.play(SFX.hit);
			}
			
			DNA += amount;
			FlxG.log(DNA);
			if (DNA > maxDna) maxDna = DNA;
			if (DNA <= 0 && ball.alive) gameOver(); 
			
			dnaText.bounce(0, -10);
			
			dnaText.text = "DNA: " + DNA;
			
			if (leftToUpgrade <= 0) upgrade();
			else if (amount > 0)FlxG.play(SFX.Powerup); 
		}
		
		public function upgrade():void
		{
			timesUpgraded++;
			leftToUpgrade = 1 + timesUpgraded;

			var speedUp:int = 10;
			
			if (speed < 1500) {
				speed += speedUp;
				ball.maxVelocity.y + speedUp;
				ball.maxVelocity.x + speedUp;
			}
			
			speedStat += 1;
			speedText.text = "You: L" + speedStat;
			speedText.bounce(0, -20);
			speedText.alpha = 1;
			
			FlxG.play(SFX.levelup);
		}
		
		public function gameOver():void
		{
			for (var i:int = 0; i < emitter.length; i++) {
				emitter.members[i].loadGraphic(IMG.trail);
				emitter.members[i].alpha = 0.5;
			}
			
			emitter.x = ball.x;
			emitter.y = ball.y;
			
			FlxG.music.volume = 0.25;
			emitter.start(true, 0, 0.1, 30);
			
			ball.kill();
			ballTrail.kill();
			borders.resetColors();
			
			centerText.visible = true;
			instruction.visible = true;
			
			centerText.text = "Exctinct.";
			instruction.text = gameOverInstruction;
			
			FlxG.shake(0.008);
			FlxG.play(SFX.plosion, 0.7);
			
			dnaText.text = "Max DNA: " + maxDna;
			dnaLeft.text = "Max Combo: " + maxCombo;
			
			FlxKongregate.submitStats("Max DNA", maxDna);
			FlxKongregate.submitStats("Max Combo", maxCombo);	
			FlxKongregate.submitStats("Years passed", framesPassed / 100 * 1000000);	
			FlxKongregate.submitStats("Rival level", enemyStat);	
			FlxKongregate.submitStats("Own level", speedStat);	
			FlxG.log(framesPassed / 100 * 1000000);
		}
	}
}