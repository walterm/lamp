package {
	/**
	 * @author ethanis
	 */
	import org.flixel.FlxSprite;
	 
	public class Bulb extends FlxSprite {
		public var wasCollected:Boolean = false;
		private var offsetCount:int = 0;
		private var goingUp:Boolean = true;
		
		public function Bulb():void
		{
			loadGraphic(Sources.ImgBulb, true, false, 20, 20);
			addAnimation("glow", [0,3,1,0], 5, true);
			play("glow");
			//set animations here
			
		}
		
		override public function update():void
		{
			super.update();
			
			if (offsetCount > 60){
				goingUp = !goingUp;
				offsetCount = 0;
			} else {
				offsetCount += 1;
			}
			this.y += goingUp ? -0.05 : 0.05;
		}
	}
}
