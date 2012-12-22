package game 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import util.gTools;
	
	public class Borders extends FlxGroup
	{
		private var gs:GameState = GameState.ref;
		public var counter:int = 0;
		public var counterIntervall:int = 150;
		public var borderColored:Border;
		public var highlight:uint;
		public var left:Border;
		public var right:Border;
		public var top:Border;
		public var bottom:Border;
		
		override public function Borders():void
		{
			super();
			
			var borderSize:int = 10;
			
			// links 
			left = new Border(0, 0, borderSize, FlxG.height);
			add(left);
			left.type = 1;
			// rechts
			right = new Border(FlxG.width - borderSize, 0, borderSize, FlxG.height);
			add(right);
			right.type = 2;
			// oben
			top = new Border(0, 0, FlxG.width, 30);
			add(top);
			top.type = 3;
			// unten
			bottom = new Border(0, FlxG.height - borderSize, FlxG.width, borderSize);
			add(bottom);	
			bottom.type = 4;
		}
		
		override public function update():void
		{
			if (gs.ball.alive) counter++;
			if (counter >= counterIntervall) recolorRandom();
			
			super.update();
		}
		
		public function recolorRandom():void
		{
			if (!gs.ball.alive) return;
			
			resetColors();
			highlight = FlxU.makeColorFromHSB(Math.random() * 360, 1, 1);
			
			var d:Border = getRandom() as Border;
			
			while (d == borderColored) d = getRandom() as Border;
			
			d.makeGraphic(d.width, d.height, highlight);
			counter = 0;
			borderColored = d;
			
			FlxG.play(SFX.bordercolor);
		}
		
		public function resetColors():void
		{
			for (var i:int; i < length; i++)
			{
				var b:Border = members[i];
				b.makeGraphic(b.width, b.height);
			}
		}
		
		public function hit(b:Border):void
		{
			if (b == borderColored) {
				FlxG.play(SFX.jump);
				borderColored = null;
				gs.changeDNA(gs.speedStat);
				resetColors();
				gs.combo ++;
				if (gs.combo > gs.maxCombo) gs.maxCombo = gs.combo;
				gs.createFloatText(0, FlxG.height / 2, "Combo: " + gs.combo , FlxU.makeColorFromHSB(Math.random() * 360, 1, 1), 16, "center");
				gs.dnaLeft.text = "Combo: " + gs.combo;
				gs.dnaLeft.bounce();
				counter = 0;
			}
			else FlxG.play(SFX.bounce);
		}
	}
}