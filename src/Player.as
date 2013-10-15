package
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	public class Player extends FlxSprite
	{
		public var camTar:FlxObject;
	
		private var camY:int = 120;
		private var jumpHeight:int = -200;
		private var movespeed:int = 150;
		private var yVelocity:int = -400;
		
		public function Player():void
		{ 
			loadGraphic(Sources.ImgPlayer, true, true, 80, 80);
			
//			var lightbeam:FlxSprite;
//			lightbeam = new FlxSprite;
//			lightbeam.loadGraphic(Sources.ImgLightBeam, true, true, 80, 80); 
//			FlxG.state.add(lightbeam); 
			
			//set animations here
			addAnimation("idle"/*name of animation*/, [0]/*used frames*/);
			addAnimation("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8], 10/*frames per second*/);
			addAnimation("jump", [2, 1, 0], 3/*frames per second*/);
			
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
			velocity.x = 0; 
			var right:Boolean = ( FlxG.keys.RIGHT || FlxG.keys.D ); 
			var left:Boolean = (FlxG.keys.LEFT || FlxG.keys.A);
			var up:Boolean = (FlxG.keys.UP || FlxG.keys.W);
			
			if (touching & DOWN)
			{
				if (!left && !right) 
				{
					play('idle');
				} else 
				{
					play('walk');
//					FlxG.play(Sources.LampWalkSoundEffect, 0.25);
				}
				if (up)
				{
					velocity.y = yVelocity;
				}
			} else
			{
				play('jump');
//				FlxG.play(Sources.LampJumpSoundEffect, 0.25);
			}
			if (right)
			{
				velocity.x = 75;
				facing = LEFT; 
				if (x > FlxG.width - width) 
				{
					velocity.x = 0; 
				}
			}
			if (left)
			{
				velocity.x = -75;
				facing = RIGHT; 
				if (x < 0) 
				{
					velocity.x = 0; 
				}
			}
			super.update();
	
		}
	}
}