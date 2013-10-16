package
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxPoint;
	
	public class Plant extends FlxSprite
	{
		public var isGrown:Boolean = false;
		
		public function Plant():void
		{ 
			loadGraphic(Sources.ImgPlant, true, true, 80, 120);
			addAnimation('grow', [0, 1, 2, 3, 4, 5, 6], 10, false);
			this.width = 40;
			this.centerOffsets();
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
				this.height = 100;
				this.centerOffsets();
				isGrown = true;
			}
		}
		
	}
}