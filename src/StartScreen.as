package
{
	import org.flixel.*;
	
	public class StartScreen extends FlxState
	{
		override public function create(): void
		{
			var t: FlxText;
			t = new FlxText(40, FlxG.height/2-80, FlxG.width, "Lumi the Lamp");
			t.size = 20;
			t.alignment = "left";
			add(t);
			t = new FlxText(60, FlxG.height/2-40, FlxG.width, "Press space to start")
			
			t.size = 10;
			t.alignment = "left";
			add(t);
			
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.SPACE) {
				FlxG.switchState(new PlayState());
			}
		}
	}
}