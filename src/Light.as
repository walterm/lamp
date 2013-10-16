package 
{
	import org.flixel.*;
	
	public class Light extends FlxSprite {
		private var LightImageClass:Class;
		
		private var darkness:FlxSprite;
		
		public function Light(x:Number, y:Number, darkness:FlxSprite):void {
			FlxG.visualDebug = true;
			super(x, y, LightImageClass);
			loadGraphic(Sources.ImgLight, x, y); 
			
			this.darkness = darkness;
			this.blend = "screen";
		}
		
//		override public function draw():void {
//			var screenXY:FlxPoint = getScreenXY();
//			var divisorx:Number;
//			var divisory:Number;
//			if (this.scale.x == 2 && this.scale.y == 2 )
//			{
//				divisorx = divisory = 2.0; 
//			} 
//			else 
//			{
//				divisorx = this.scale.x * 2.0;
//				divisory = this.scale.y * 2.0;
//			}
//			darkness.stamp(this,
//				screenXY.x,
//				screenXY.y);
//		}
	
		override public function update():void {
			
		}
		
		public function follow(newX:Number, newY:Number):void
		{	
			x = newX; 
			y = newY; 
		}
		
	}
}