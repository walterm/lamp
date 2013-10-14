package
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	public class Plant extends FlxSprite
	{
		
		public function Plant():void
		{ 
			loadGraphic(Sources.ImgPlant, true, true, 80, 120);
			addAnimation('grow', [0, 1, 2, 3, 4, 5, 6], 10, false); 
			
		}
		
		override public function update():void
		{
			testgrow(); 
			
			super.update();
		}
		
		private function testgrow():void 
		{
			if (FlxG.keys.B)
			{
				play('grow'); 
			}
		}
		
	}
}