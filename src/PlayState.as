package
{
	import org.flixel.FlxBackdrop;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap; 
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
		private var platform1:FlxSprite; 
		private var platform2:FlxSprite; 
		
		private var gapWidth:int = 300;
		private var jumpHeight:int = 150;
		private var gapMultFactor:Number = 1.5;
		
		private var debug:Boolean = false;
		private var background:FlxBackdrop;

		private function pushPlatform(data:Array, platformLength:int):Array
		{
			for(var i:int = 0; i < platformLength; i++){
				data.push(1);
			};
			for(i = 0; i < platformLength; i++){
				data.push(0);
			};
			return data;
		}
		
		private function addBlankRow(data:Array):Array
		{
			var rowData:Array = new Array(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);
			for(var i:int = 0; i < rowData.length; i++){
				data.push(rowData);
			}
			return data;
		}
		
		override public function create():void
		{
			
			background = new FlxBackdrop(Sources.ImgBackGround, 0, 0, false, true); 
			add(background);
			FlxG.playMusic(Sources.BackgroundMusic, 1);
			
			//Sets the background to gray.
			FlxG.bgColor = 0xffaaaaaa;
			
			//Top row
			var platformData:Array = new Array(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
				0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
			
                   
			var totalCells:int = rows * columns;
			for(var n:int = 0; n < totalCells - columns * 3; n++){
				platformData.push(0);
			}
			
			for(n = platformData.length; n < totalCells; n++){
				platformData.push(1);
			}
			
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
			
			createPlatforms(10);
			
			// bulb stuff
			createBulbs();
			plantArray = new Array();
			
			if (!debug) 
			{
				add(darkness);
			} else {
				// debugging
				//FlxG.debug = true;
				//FlxG.visualDebug = true;
			}
			
			bulbText = new FlxText(FlxG.width - 120, 20, 100, "0 Bulbs");
			bulbText.size = 20;
			bulbText.alignment = "right";
			add(bulbText);
			
			createBattery();        
			
			pause = new Pause();
		}
		
		private function createPlatforms(numPlatforms:int):void 
		{
			platformArray = new Array();
			var x:int = 0;
			var y:int = 0;
			var gapWidthCurr:int = 200; 
			var jumpHeightCurr:int = 0; 
			
			for (var i:int = 0; i < numPlatforms; i++) 
			{
				gapWidthCurr = randomNum(gapWidth-80);  
				jumpHeightCurr = randomNum(jumpHeight);
				if (x == 80)
				{
					x += -100; 
				}
				else 
				{
					x += 100;
				}
				y += jumpHeightCurr; 
				var platform:FlxSprite = new FlxSprite(x, y, Sources.ImgPlatform); 
				platform.immovable = true; 
				add(platform); 
				platformArray.push(platform);
			}
			
			platform1 = new FlxSprite(0, FlxG.height, Sources.ImgPlatform);
			platform1.y = FlxG.height - platform1.height;
			platform1.immovable = true;
			add(platform1);
			platformArray.push(platform1); 
			
			platform2 = new FlxSprite(platform1.x + platform1.width + gapWidth, FlxG.height-jumpHeight, Sources.ImgPlatform);
			platform2.immovable = true;
			add(platform2);
			platformArray.push(platform2); 
		}
		
		private function randomNum(interval:Number):int
		{
			var rand:Number = Math.random() * interval + 85;
//			return base + multiplier * rand * coinFlip ;
			return Math.floor(rand);
		}

		private function createBulbs():void
		{                                                
			bulbArray = new Array();
			bulbLightArray = new Array(); 
			var gapWidthCurr:int = 200; 
			var jumpHeightCurr:int = 0; 
			
			for (var i:int = 0; i < BULB_COUNT; i++){
				var bulb:Bulb = new Bulb();
				// should not hard code width
				bulb.x = Math.floor(Math.random()*(FlxG.width - 50) + 100);
				bulb.y = Math.floor(Math.random()*(FlxG.height - 150) + 40);
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
			add(batteryText);
			
			battery = new Battery();
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
				
				if (FlxG.overlap(lightBeamPlayer, platform) && FlxG.keys.justPressed("E")){
					
					var plant1:Plant = new Plant(); 
					
					if (player.facing == FlxObject.RIGHT) 
					{
						plant1.x = player.x + player.width + lightBeamPlayer.width;
						plant1.y = player.y - player.height / 2.0;
					}
					else 
					{
						plant1.x = player.x - lightBeamPlayer.width;
						plant1.y = player.y - player.height / 2.0;
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
				lightBeamPlayer.follow(player.x, player.getMidpoint().y);
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