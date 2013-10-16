package
{
	import org.flixel.*;
	
	public class StartScreen extends FlxState
	{
		private var background:FlxBackdrop 
		
		override public function create(): void
		{
			background = new FlxBackdrop(Sources.ImgStartScreen, 0, 0, false, false); 
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