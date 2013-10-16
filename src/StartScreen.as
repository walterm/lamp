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
			t = new FlxText(60, FlxG.height/2-40, FlxG.width, "Press enter to start")
			
			t.size = 10;
			t.alignment = "left";
			add(t);
			
			t = new FlxText(60, FlxG.height-30, FlxG.width, "credits: stephanie gu, ethan sherbondy, jack li, walter menendez, lili sun")
			
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