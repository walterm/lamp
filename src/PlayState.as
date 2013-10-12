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
			
			//Loading in the tilemap
			level = new FlxTilemap();
			level.loadMap(FlxTilemap.arrayToCSV(platformData,columns), FlxTilemap.ImgAuto, 0, 0, FlxTilemap.AUTO);
			add(level);
		}
	}
}