package
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap; 
	import org.flixel.FlxTileblock;

	public class PlayState extends FlxState
	{
		public static var level:FlxTilemap;
		public var player:FlxSprite;
		public var rows:int = 50;
		public var columns:int = 80;
		public var pause:Pause;
		
		public var ROW_PROB:Number = 0.1;
		public var PLATFORM_PROB:Number = 0.2;
		public var lightPlayer:Light;
		public var lightBeamPlayer:Light;
		
		public const BULB_COUNT:int = 5;
		public var bulbsCollected:int = 0;
		
		//private vars
		private var darkness:FlxSprite;
		private var bulbArray:Array;
		private var bulbLightArray:Array;
		private var bulbText:FlxText;
		private var debug:Boolean = false;
		
		private var block:FlxTileblock;
		
		override public function create():void
		{
			
			FlxG.playMusic(Sources.BackgroundMusic, 1);
			
			//Sets the background to gray.
			FlxG.bgColor = 0xffaaaaaa;
			
			var platformData:Array = new Array();
			
			var totalCells:int = rows * columns;
			var stop:int =  columns * 20;
			
			stop =  columns * 35;
			for(var j:int = 0; j < stop - rows; j++){
				platformData.push(0);
			}
			
			for(var n:int = stop - rows; n < stop; n++){
				platformData.push(1);
			}
			
			var last:int = n;
			for(n = last; n < totalCells - columns; n++){
				platformData.push(0);
			}
			
			for(n = platformData.length; n < totalCells; n++){
				platformData.push(1);
			}

			
			//Loading in the tilemap
			level = new FlxTilemap();
			level.loadMap(FlxTilemap.arrayToCSV(platformData,columns), FlxTilemap.ImgAuto, 0, 0, FlxTilemap.AUTO);
			add(level);
			
			block = new FlxTileblock(320, 240, 12, 6);
			block.solid = true;
			block.loadTiles(Sources.ImgBulb);
			add(block);
			
			player = new Player(); 
			player.x = FlxG.width / 2.0; 
			player.y = FlxG.height / 2.0; 
			
			add(player);
			
			//add the darkness last bc we want it to be the top layer 
			darkness = new FlxSprite(0,0);
			darkness.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
			darkness.scrollFactor.x = darkness.scrollFactor.y = 0;
			darkness.blend = "multiply";
			
			//add light around player 
			lightPlayer = new Light(player.getMidpoint().x, player.getMidpoint().y, darkness);
			lightPlayer.scale.x = 3;
			lightPlayer.scale.y = 3; 
			lightPlayer.width *= lightPlayer.scale.x; 
			lightPlayer.height *= lightPlayer.scale.y;
			add(lightPlayer);
	
			//add light beam onto player, keep invisible until needed 
			lightBeamPlayer = new Light(player.x, player.getMidpoint().y, darkness);
			lightBeamPlayer.scale.y = 3; 
			lightBeamPlayer.angle = 45; 
			add(lightBeamPlayer);
			lightBeamPlayer.visible = false; 
			
			//test plants 
			var planttest:Plant = new Plant(); 
			planttest.x = FlxG.width/2.0;
			planttest.y = FlxG.height/2.0;
			add(planttest); 
			
			// bulb stuff
			bulbText = new FlxText(FlxG.width - 120, 20, 100, "0 Bulbs");
			bulbText.size = 20;
			bulbText.alignment = "right";
			add(bulbText);
			
			bulbArray = new Array();
			bulbLightArray = new Array(); 
			for (var i:int = 0; i < BULB_COUNT; i++){
				var bulb:Bulb = new Bulb();
				// should not hard code width
				bulb.x = Math.floor(Math.random()*(FlxG.width - 80) + 40);
				bulb.y = Math.floor(Math.random()*(FlxG.height - 80) + 40);
				bulbArray.push(bulb);
				add(bulb);
				
				var bulbLight:Light = new Light(bulb.getMidpoint().x, bulb.getMidpoint().y, darkness);
				bulbLightArray.push(bulbLight);
				add(bulbLight); 
			}
			
			if (!debug) 
			{
				add(darkness);
			}
						
			pause = new Pause();
		}
		
		private function collideBulbs():void
		{
			for (var i:int = 0; i < bulbArray.length; i++){
				var bulb:Bulb = bulbArray[i];
				if (FlxG.collide(bulb, player)){
					FlxG.play(Sources.BulbPickupSoundEffect, 0.25);
					// collect it!
					bulb.exists = false;
					bulbLightArray[i].exists = false;
					bulbsCollected += 1;
					bulbText.text = bulbsCollected + " Bulb" + (bulbsCollected != 1 ? "s" : "");		
					
				}
			}
		}
		
		override public function update():void 
		{
			//update the level's tile
			
			if (!pause.showing)
			{
				super.update();
				FlxG.collide(block, player);
				FlxG.collide(level, player);
				collideBulbs();

				checkLightBeam(); 

				if (FlxG.keys.COMMA)
				{
					FlxG.switchState(new EndScreen());
				}
				if (FlxG.keys.P)
				{
					pause = new Pause;			
					pause.showPaused();
					add(pause);
				}

				if(Math.random() > PLATFORM_PROB){
					PLATFORM_PROB += 0.1;
					
				} else PLATFORM_PROB -= 0.05;

				
				lightPlayer.follow(player.getMidpoint().x, player.getMidpoint().y);	
				
			} else
			{
				pause.update();
			}
					
		}
		
		private function checkLightBeam():void {
			if (player.facing == FlxObject.RIGHT) 
			{
				lightBeamPlayer.angle = 45; 
				lightBeamPlayer.follow(player.x, player.getMidpoint().y);
			}
			else 
			{
				lightBeamPlayer.angle = 315; 
				lightBeamPlayer.follow(player.x+player.width, player.getMidpoint().y);
			}
			
			lightPlayer.follow(player.getMidpoint().x, player.getMidpoint().y);
			

			if (FlxG.keys.E)
			{
				lightBeamPlayer.visible = true; 
			}
			else 
			{
				lightBeamPlayer.visible = false;
			}
		}
		
		override public function draw():void {
			darkness.fill(0xff000000);
			super.draw();
		}
	}
}