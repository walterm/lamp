package
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTileblock;
	import org.flixel.FlxTilemap;

	public class PlayState extends FlxState
	{
		public var level:FlxTilemap;
		public var player:FlxSprite;
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

		private var battery:Battery;
		private var batteryText:FlxText;
		private var debug:Boolean = false;
		
		private var platformGroup:FlxGroup;
		
		private var block:FlxTileblock;

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
			
			FlxG.playMusic(Sources.BackgroundMusic, 1);
			
			//Sets the background to gray.
			FlxG.bgColor = 0xffaaaaaa;
			
			//Making sure the player spawns on something solid
			var totalCells:int = rows * columns;
			var platformData:Array = new Array();
			for(var i:int = 0; i < totalCells - columns; i++){
				platformData.push(0);
			}
			
			while(i < totalCells){
				platformData.push(1);
				i++;
			}
			
			var level:FlxTilemap = new FlxTilemap();
			level.loadMap(FlxTilemap.arrayToCSV(platformData,columns), FlxTilemap.ImgAuto, 0, 0, FlxTilemap.AUTO);
			add(level);
			
			//Let's make a lamp bro
			player = new Player(); 
			player.x = FlxG.width / 2.0; 
			player.y = FlxG.height / 2.0; 
			add(player);
			
			
			//Platform generation (note that the platforms are a bit too big...)
			var LEFT_X:int = 0;
			var RIGHT_X:int = FlxG.width - 160;
			var currentY:int = FlxG.height - 80;

			for(var n:int = 0; n < 8; n++){
				if(n % 2 == 0)
					block = new FlxTileblock(LEFT_X, currentY, 160, 80);
				else block = new FlxTileblock(RIGHT_X, currentY, 160, 80);
				block.solid = true;
				block.loadGraphic(Sources.ImgPlatform1);
				add(block);
				currentY -= 80;
			}
			
			//add the darkness last bc we want it to be the top layer 
			darkness = new FlxSprite(0,0);
			darkness.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
			darkness.scrollFactor.x = darkness.scrollFactor.y = 0;
			darkness.blend = "multiply";
			
			//add light around player 
			lightPlayer = new Light(player.getMidpoint().x, player.getMidpoint().y, darkness);
			lightPlayer.scale.x = 2;
			lightPlayer.scale.y = 2;
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
			
			// battery stuff
			batteryText = new FlxText(75, 20, 90, "100%");
			batteryText.size = 20;
			batteryText.alignment = "left";
			add(batteryText);
			
			battery = new Battery();
			add(battery);
			
			// bulb stuff
			createBulbs();
			
			if (!debug) 
			{
				add(darkness);
			}
						
			pause = new Pause();
		}
		
		private function createBulbs():void
		{
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
					// recover battery
					battery.recover(); 
					bulbText.text = bulbsCollected + " Bulb" + (bulbsCollected != 1 ? "s" : "");
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
				FlxG.collide(level, player);
				collideBulbs();
				checkLightBeam(); 
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