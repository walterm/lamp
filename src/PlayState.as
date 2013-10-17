package
{
	import org.flixel.FlxBackdrop;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;

	public class PlayState extends FlxState
	{
		public var level:FlxTilemap;
		public var player:FlxSprite;
		//public var plant:Plant;
		public var rows:int = 50;
		public var columns:int = 80;
		public var ROW_PROBABILITY:Number = 0.1;
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
		
		private var plantArray:Array; 
		private var battery:Battery;
		private var batteryText:FlxText;
		
		private var platformArray:Array; 
		private var map:FlxTilemap; 
		
		private var gapWidth:int = 450;
		private var jumpHeight:int = 150;
		
		private var debug:Boolean = true;
		private var background:FlxBackdrop;

		override public function create():void
		{
			
			FlxG.camera.setBounds(0,0, 1000, 1000 ,true);
			
			background = new FlxBackdrop(Sources.ImgBackGround, 0, 0, false, true); 
			add(background);
			FlxG.playMusic(Sources.BackgroundMusic, 1);
			
			//Sets the background to gray.
			FlxG.bgColor = 0xffaaaaaa;

			player = new Player(); 
			player.x = 0; 
			player.y = 100; 
			
			add(player);
			
			FlxG.camera.follow(player);
			
			//add the darkness last bc we want it to be the top layer 
			darkness = new FlxSprite(0,0);
			darkness.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
			darkness.scrollFactor.x = darkness.scrollFactor.y = 0;
			darkness.blend = "multiply";
			
			//add light around player 
			lightPlayer = new Light(player.getMidpoint().x, player.getMidpoint().y, darkness);
			lightPlayer.scale.x = 4;
			lightPlayer.scale.y = 4;
			add(lightPlayer);
			
			//add light beam onto player, keep invisible until needed 
			lightBeamPlayer = new Light(player.x, player.getMidpoint().y, darkness);
			lightBeamPlayer.scale.y = 3; 
			lightBeamPlayer.angle = 45; 
			add(lightBeamPlayer);
			lightBeamPlayer.visible = false; 
			
			//generating platforms placed randomly
			createPlatforms(10);
			map = new FlxTilemap();
			map.loadMap(new Sources.TxtMap, Sources.ImgMap, 16, 16);
			add(map);
			
			// bulb stuff
			createBulbs();
			plantArray = new Array();
			
			if (!debug) 
			{
				add(darkness);
			} else {
				// debugging
				//FlxG.debug = true;
				FlxG.visualDebug = true;
			}
			
			bulbText = new FlxText(FlxG.width - 120, 20, 100, "0 Bulbs");
			bulbText.size = 20;
			bulbText.alignment = "right";
			bulbText.scrollFactor.x = 0; 
			bulbText.scrollFactor.y = 0;
			add(bulbText);
			
			createBattery();        
			
			pause = new Pause();
		}
		
		private function createPlatforms(numPlatforms:int):void 
		{
			platformArray = new Array();
			var x:int = 0;
			var y:int = FlxG.height;
			var gapWidthCurr:int = 200; 
			var jumpHeightCurr:int = 0; 
			
			for (var i:int = 0; i < numPlatforms; i++) 
			{
				var platform:FlxSprite = new FlxSprite(x, y, Sources.ImgPlatform); 
				platform.immovable = true; 
				add(platform); 
				platformArray.push(platform);
				
				gapWidthCurr = randomNum(100, gapWidth);  
				jumpHeightCurr = randomNum(player.height + platform.height + 5, jumpHeight);
				x = gapWidthCurr;
				y -= jumpHeightCurr; 
			}
		}
		
		private function randomNum(min:int, max:int):int
		{
			var rand:Number = Math.random() * (max-min) + min;
			return Math.floor(rand);
		}

		private function createBulbs():void
		{                                                
			bulbArray = new Array();
			bulbLightArray = new Array(); 
			for (var i:int = 0; i < BULB_COUNT; i++){
				var bulb:Bulb = new Bulb();
				// should not hard code width
				bulb.x = randomNum(80, FlxG.width-20);
				bulb.y = randomNum(0, FlxG.height-100);
				bulbArray.push(bulb);
				add(bulb);
				
				var bulbLight:Light = new Light(bulb.getMidpoint().x, bulb.getMidpoint().y, darkness);
				bulbLightArray.push(bulbLight);
				add(bulbLight);
			}
		}
		
		private function createBattery():void
		{
			// battery stuff
			batteryText = new FlxText(75, 20, 90, "100%");
			batteryText.size = 20;
			batteryText.alignment = "left";
			batteryText.scrollFactor.x = 0; 
			batteryText.scrollFactor.y = 0;
			add(batteryText);
			
			battery = new Battery();
			battery.scrollFactor.x = 0; 
			battery.scrollFactor.y = 0;
			add(battery);
		}
		
		private function collideBulbs():void
		{
			for (var i:int = 0; i < bulbArray.length; i++){
				var bulb:Bulb = bulbArray[i];
				if (FlxG.overlap(bulb, player)){
					FlxG.play(Sources.BulbPickupSoundEffect, 0.25);
					// collect it!
					bulb.exists = false;
					bulbLightArray[i].exists = false;
					bulbsCollected += 1;
					if (bulbsCollected == BULB_COUNT)
					{
						FlxG.switchState(new EndScreen());
					}
					// recover battery
					battery.recover(); 
					bulbText.text = bulbsCollected + " Bulb" + (bulbsCollected != 1 ? "s" : "");
				}
			}
		}
		
		private function collidePlatforms():void 
		{
			for (var i:int = 0; i < platformArray.length; i++) 
			{
				var platform:FlxSprite = platformArray[i];
				FlxG.collide(platform, player);
				
				if ((FlxG.overlap(lightBeamPlayer, platform)) && FlxG.keys.justPressed("E")){
					
					var plant1:Plant = new Plant(); 
					
					if (player.facing == FlxObject.RIGHT) 
					{
						plant1.x = player.x + player.width + lightBeamPlayer.width/2.0;
						plant1.y = player.y - player.height / 2.0 + 8;
					}
					else 
					{
						plant1.x = player.x - lightBeamPlayer.width;
						plant1.y = player.y - player.height / 2.0 + 8;
					}
					
					add(plant1);				
					plant1.grow();
					plant1.isGrown = true;
					plantArray.push(plant1);
					
					var lightPlant:Light = new Light(plant1.x - 15, plant1.y, darkness); 
					lightPlant.scale.x = 2; 
					lightPlant.scale.y = 4;
					add(lightPlant);
					
				}
			}
			
		}
		
		private function treeClimb():void
		{
			for (var i:int = 0; i < plantArray.length; i++)
			{
				var plant:Plant = plantArray[i]; 
				if (plant.isGrown && FlxG.overlap(player, plant))
				{
					if ((FlxG.keys.UP ||  FlxG.keys.W))
					{
						if (player.y + player.height <= plant.y) {
							player.velocity.y = -300; //hack to allowing jumping on plants
						} 
						else 
						{
							player.velocity.y = -100;
							player.acceleration.y = 0;
						}

					} else if ((FlxG.keys.DOWN ||  FlxG.keys.S))
					{
						player.velocity.y = 100;
						player.acceleration.y = 0;        
					} else {
						player.velocity.y = 0;
						player.acceleration.y = 0;
					}
				} 
				else 
				{
					player.acceleration.y = 600;
				}
			}
			
		}
		
		private function updateBattery():void
		{
			batteryText.text = ""+Math.ceil(battery.batteryLife)+"%";
			
		}
		
		override public function update():void 
		{
			if (!pause.showing)
			{
				
				super.update();
				FlxG.collide(player, map);
				collidePlatforms(); 
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
				lightBeamPlayer.follow(player.x-player.width/2.0, player.getMidpoint().y);
			}
			else 
			{
				lightBeamPlayer.angle = 315; 
				lightBeamPlayer.follow(player.x+player.width, player.getMidpoint().y);
			}
			
			if (FlxG.keys.E && battery.batteryLife > 0)
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