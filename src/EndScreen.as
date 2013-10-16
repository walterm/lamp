package
{
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class EndScreen extends FlxState
	{
		override public function create(): void
		{
			var t: FlxText;
			t = new FlxText(40, FlxG.height/2-80, FlxG.width, "Game Over");
			t.size = 20;
			t.alignment = "left";
			add(t);
			t = new FlxText(60, FlxG.height/2-40, FlxG.width, "Play Again? Press enter");
			
			t.size = 10;
			t.alignment = "left";
			add(t);
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.ENTER) {
				FlxG.switchState(new PlayState());
			}
		}
	}
}


