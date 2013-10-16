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
		
		public function grow():void
		{
			if (!isGrown){
				play('grow');
				this.height = 100;
				isGrown = true;
			}
		}
	}
}