package
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap; 
<<<<<<< HEAD
	import org.flixel.FlxTileblock;
=======
>>>>>>> d7647293741deba05ea0cf164bb3d802450bcbd1

	public class PlayState extends FlxState
	{
		public static var level:FlxTilemap;
		public var player:FlxSprite;
		public var plant:Plant;
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

<<<<<<< HEAD
		private var debug:Boolean = true;
		
		private var block:FlxTileblock;
=======
>>>>>>> d7647293741deba05ea0cf164bb3d802450bcbd1

		private var battery:Battery;
		private var batteryText:FlxText;

		
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
<<<<<<< HEAD
			lightPlayer.scale.x = 3;
			lightPlayer.scale.y = 3; 
			lightPlayer.width *= lightPlayer.scale.x; 
			lightPlayer.height *= lightPlayer.scale.y;
=======
			lightPlayer.scale.x = 2;
			lightPlayer.scale.y = 2;
>>>>>>> d7647293741deba05ea0cf164bb3d802450bcbd1
			add(lightPlayer);
	
			//add light beam onto player, keep invisible until needed 
			lightBeamPlayer = new Light(player.x, player.getMidpoint().y, darkness);
			lightBeamPlayer.scale.y = 3; 
			lightBeamPlayer.angle = 45; 
			add(lightBeamPlayer);
			lightBeamPlayer.visible = false; 
			
			//test plants 

			plant = new Plant(); 
			plant.x = FlxG.width/2.0 - 80;
			plant.y = FlxG.height/2.0;
			add(plant); 

			
			// bulb stuff
			createBulbs();
			
			if (!debug) 
			{
				add(darkness);
			}
			
			bulbText = new FlxText(FlxG.width - 120, 20, 100, "0 Bulbs");
			bulbText.size = 20;
			bulbText.alignment = "right";
			add(bulbText);
			
			createBattery();	
						
			pause = new Pause();
		}
		
		private function createBulbs():void
		{						
			bulbArray = new Array();
			bulbLightArray = new Array(); 
			for (var i:int = 0; i < BULB_COUNT; i++){
				var bulb:Bulb = new Bulb();
				// should not hard code width
				bulb.x = Math.floor(Math.random()*(FlxG.width - 80) + 40);
				bulb.y = Math.floor(Math.random()*(FlxG.height - 120) + 40);
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
		
		private function createBattery():void
		{
			// battery stuff
			batteryText = new FlxText(75, 20, 90, "100%");
			batteryText.size = 20;
			batteryText.alignment = "left";
			add(batteryText);
			
			battery = new Battery();
			add(battery);
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
					// recover battery
					battery.recover(); 
					bulbText.text = bulbsCollected + " Bulb" + (bulbsCollected != 1 ? "s" : "");
				}
			}
		}
		

		private function treeClimb():void
		{
			if (FlxG.overlap(player, plant) && (FlxG.keys.UP ||  FlxG.keys.W)) 
			{
				player.velocity.y = -100;
				player.acceleration.y = 0;
			} else if (FlxG.overlap(player, plant) && (FlxG.keys.DOWN ||  FlxG.keys.S))
			{
				player.velocity.y = 100;
				player.acceleration.y = 0;	
			} else if (FlxG.overlap(player, plant)) {
				player.velocity.y = 0
				player.acceleration.y = 0;
			} else {
				player.acceleration.y = 600;
			}
		}

		private function updateBattery():void
		{
			batteryText.text = ""+Math.ceil(battery.batteryLife)+"%";

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
				treeClimb()
				updateBattery();
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
			if (player.facing == FlxObject.LEFT) 
			{
				lightBeamPlayer.angle = 45; 
				lightBeamPlayer.follow(player.x, player.getMidpoint().y);
			}
			else 
			{
				lightBeamPlayer.angle = 315; 
				lightBeamPlayer.follow(player.x+player.width, player.getMidpoint().y);
			}
			
<<<<<<< HEAD
			lightPlayer.follow(player.getMidpoint().x, player.getMidpoint().y);
			

			if (FlxG.keys.E)
=======
			if (FlxG.keys.E && battery.batteryLife > 0)
>>>>>>> d7647293741deba05ea0cf164bb3d802450bcbd1
			{
				battery.drain();
				lightBeamPlayer.visible = true;
				lightBeamPlayer.alpha = battery.batteryLife / battery.maxBatteryLife;
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