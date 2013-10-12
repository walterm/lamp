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
		}
		
		override public function update():void {
			
		}
		
		public function follow(newX:Number, newY:Number):void
		{	
			x = newX; 
			y = newY; 
		}
		
		private function movement():void
		{
			
			if (FlxG.keys.SPACE) {
				if (touching & DOWN) {
					velocity.y = 20;
					//add jump animation and jump sound here
					
				} 
			} 
			if (FlxG.keys.A || FlxG.keys.LEFT){
				velocity.x = -150
				//add walk animation here
				
			} else if (FlxG.keys.D || FlxG.keys.RIGHT){
				velocity.x = 150
				//add walk animation here
			}
			
		}
	}
}