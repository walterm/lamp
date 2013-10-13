package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
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
		
		public const BULB_COUNT:int = 5;
		public var bulbsCollected:int = 0;
		
		//private vars
		private var darkness:FlxSprite;
		private var bulbArray:Array;
		private var bulbText:FlxText;
		private var debug:Boolean = true;
		
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
			
			//Top row
			var platformData:Array = new Array(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
				0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
			
//			for(var i:int = 0; i < columns * 2; i++){
//				platformData.push(0);
//			}
//			
//			
			var totalCells:int = rows * columns;
//			for(var n:int = platformData.length; n < totalCells - (40 * 5); n++){
//				if(n % columns == 0 || n % columns == (columns - 1))
//					platformData.push(1);
//				else {
//						var willPlacePlatform:Boolean = Math.random() > PLATFORM_PROB;
//						if(willPlacePlatform){
//							var platNum:int = Math.floor(Math.random() * 4 + 3);
//							switch(platNum){
//								case 3:
//									platformData = pushPlatform(platformData, 3);
//									n = platformData.length;
//									break;
//								case 4:
//									platformData = pushPlatform(platformData, 4);
//									n = platformData.length;
//									break;
//								case 5:
//									platformData = pushPlatform(platformData, 5);
//									n = platformData.length;
//									break;
//								case 6:
//									platformData = pushPlatform(platformData, 6);
//									n = platformData.length;
//									break;
//								case 7:
//									platformData = pushPlatform(platformData, 7);
//									n = platformData.length;
//									break;
//							}
//							
//						}
//					
//				}
//			}
//			
//			for(n= 0; n < 80; n++){
//				platformData.push(1);
//			}
			
			for(var n:int = 0; n < totalCells - columns * 3; n++){
				platformData.push(0);
			}
			
			for(n = platformData.length; n < totalCells; n++){
				platformData.push(1);
			}
			
			//Loading in the tilemap
			level = new FlxTilemap();
			level.loadMap(FlxTilemap.arrayToCSV(platformData,columns), FlxTilemap.ImgAuto, 0, 0, FlxTilemap.AUTO);
			add(level);
			
			player = new Player(); 
			player.x = FlxG.width / 2.0; 
			player.y = FlxG.height / 2.0; 
			
			add(player);
			
			//add the darkness last bc we want it to be the top layer 
			darkness = new FlxSprite(0,0);
			darkness.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
			darkness.scrollFactor.x = darkness.scrollFactor.y = 0;
			darkness.blend = "multiply";
			
			lightPlayer = new Light(player.getMidpoint().x, player.getMidpoint().y, darkness);
			lightPlayer.scale.x = 2;
			lightPlayer.scale.y = 2; 
			add(lightPlayer);
			
			if (!debug) 
			{
				add(darkness);
			}
	
			// bulb stuff
			bulbText = new FlxText(FlxG.width - 120, 20, 100, "0 Bulbs");
			bulbText.size = 20;
			bulbText.alignment = "right";
			add(bulbText);
			
			bulbArray = new Array();
			for (var i:int = 0; i < BULB_COUNT; i++){
				var bulb:Bulb = new Bulb();
				// should not hard code width
				bulb.x = Math.floor(Math.random()*(FlxG.width - 80) + 40);
				bulb.y = Math.floor(Math.random()*(FlxG.height - 80) + 40);
				bulbArray.push(bulb);
				add(bulb);
			}
						
			pause = new Pause();
		}
		
		private function collideBulbs():void
		{
			for (var i:int = 0; i < bulbArray.length; i++){
				var bulb:Bulb = bulbArray[i];
				if (FlxG.collide(bulb, player)){
					// collect it!
					bulb.exists = false;
					bulbsCollected += 1;
					bulbText.text = bulbsCollected + " Bulb" + (bulbsCollected != 1 ? "s" : "");
				}
			}
		}
		
		override public function update():void 
		{
			if (!pause.showing)
			{
				super.update();
				FlxG.collide(level, player);
				collideBulbs();
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
			} else
			{
				pause.update();
			}
			
			lightPlayer.follow(player.getMidpoint().x, player.getMidpoint().y);
		}
		
		override public function draw():void {
			darkness.fill(0xff000000);
			super.draw();
		}
	}
}