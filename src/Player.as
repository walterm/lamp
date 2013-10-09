package
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		public var camTar:FlxObject;
		private var camY:int = 120;
		private var jumpHeight:int = -200;
		private var movespeed:int = 150
		
		public function Player():void
		{
			loadGraphic(Lamp, true, true, 14, 15);
			//set animations here
			
			acceleration.y = 600; 
			camTar = new FlxObject;
			camTar.x = x;
			camTar.y = camY;
		}
		
		override public function update():void
		{
			movement();
			
			camTar.x = x;
			camTar.y = camY;
			
			super.update();
			
			
		}
		
		private function movement():void
		{
			
			if (FlxG.keys.SPACE) {
				if (touching & DOWN) {
					velocity.y = jumpHeight;
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