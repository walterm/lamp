package
{
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxBackdrop;
	
	public class EndScreen extends FlxState
	{
		
		private var background:FlxBackdrop 
		
		override public function create(): void
		{
			
			background = new FlxBackdrop(Sources.ImgEndScreen, 0, 0, false, false); 
			add(background);
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


