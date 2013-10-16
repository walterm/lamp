package 
{
	import org.flixel.*;
	
	public class Light extends FlxSprite {
		private var LightImageClass:Class;
		
		private var darkness:FlxSprite;
		
		public function Light(x:Number, y:Number, darkness:FlxSprite):void {
			super(x, y, LightImageClass);
			loadGraphic(Sources.ImgLight, x, y); 
			
			this.darkness = darkness;
			this.blend = "screen";
		}
		
		override public function draw():void { 
			var screenXY:FlxPoint = getScreenXY();
			
			darkness.stamp(this,
				screenXY.x - this.width / 2,
				screenXY.y - this.height / 2);
			
			super.draw();
		}
		
		public function follow(newX:Number, newY:Number):void
		{	
			x = newX; 
			y = newY; 
		}
		
	}
}