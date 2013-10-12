package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;

	public class PlayState extends FlxState
	{
		public var level:FlxTilemap;
		public var player:FlxSprite;
		public var rows:int = 50;
		public var columns:int = 80;
		public var ROW_PROB:Number = 0.25;
		public var PLATFORM_PROB:Number = 0.75;
		
		//private vars
		private var darkness:FlxSprite;
		
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
			//Sets the background to gray.
			FlxG.bgColor = 0xffaaaaaa;
			
			//Top row
			var platformData:Array = new Array(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
				0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
			
			var totalCells:int = rows * columns;
			for(var n:int = 0; n < totalCells; n++){
				if(n % columns == 0 || n % columns == (columns - 1))
					platformData.push(1);
				else {
						var willPlacePlatform:Boolean = Math.random() > PLATFORM_PROB;
						if(willPlacePlatform){
							var platNum:int = Math.floor(Math.random() * 4 + 3);
							switch(platNum){
								case 3:
									platformData = pushPlatform(platformData, 3);
									break;
								case 4:
									platformData = pushPlatform(platformData, 4);
									break;
								case 5:
									platformData = pushPlatform(platformData, 5);
									break;
								case 6:
									platformData = pushPlatform(platformData, 6);
									break;
								case 7:
									platformData = pushPlatform(platformData, 7);
									break;
							}
							n = platformData.length;
						}
					
				}
			}
			
			for(n= 0; n < 80; n++){
				platformData.push(1);
			}
			
			
// ATTEMPT # 1
//			//for every row
//			for(var i:int = 0; i < rows - 1; i++){
//				//attach a 1 to make sure we have an end border
//				platformData.push(1);
//				//for each column excluding the last one
//				for(var j:int = 0; j < columns; j++){
//					//generate some random number
//					var num:Number = Math.random();
//					//if it's above some threshold
//					if(num > 0.5){
//						//place a tile there
//						platformData.push(1);
//						threshold += 0.35;
//						
//					}else platformData.push(0);
//				
//				}
//				//place a 1 for the rightmost edge
//				platformData.push(1);
//			}
			

			//Loading in the tilemap
			level = new FlxTilemap();
			level.loadMap(FlxTilemap.arrayToCSV(platformData,columns), FlxTilemap.ImgAuto, 0, 0, FlxTilemap.AUTO);
			add(level);
			
			
			player = new Player(); 
			player.x = FlxG.width / 2; 
			player.y = FlxG.height - 31; 
			
			add(player);
			
			//add the darkness last bc we want it to be the top layer 
			darkness = new FlxSprite(0,0);
			darkness.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
			darkness.scrollFactor.x = darkness.scrollFactor.y = 0;
			darkness.blend = "multiply";
			
			var light:Light = new Light(FlxG.width / 2, FlxG.height / 2, darkness);
			add(light);
//			add(darkness);
		}
		
		override public function update():void 
		{
			super.update();
			FlxG.collide(level, player);
			if (FlxG.keys.COMMA)
			{
				FlxG.switchState(new EndScreen());
			}
			
		}
		
		override public function draw():void {
			darkness.fill(0xff000000);
			super.draw();
		}
	}
}