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
		public var rows:int = 30;
		public var columns:int = 80;
		public var ROW_PROBABILITY:Number = 0.25;
		
		
		private function pushPlatform(data:Array, platformLength:int, columns:int):Array
		{
			if(columns + 2 * platformLength  < rows){
				for(var i:int = 0; i < platformLength; i++){
					data.push(1);
				};
				for(i = 0; i < platformLength; i++){
					data.push(0);
				};
			}else{
				for(var n:int = columns; n < rows; n++){
					data.push(0);
				}
			}
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
			//for every row
			for(var j:int = 0; j < rows - 2; j++){
				//Determine if we will place a row or not.
				var willPlaceRow:Boolean = Math.random() > ROW_PROBABILITY;
			
				
				if(willPlaceRow){
					//for all the columns
					for(var i:int = 0; i < columns; i++){
						//Get a number between 3 and 6 inclusive
						var platNum:int = Math.random() * 8 + 3;
						switch(platNum){
							case 3:
								platformData = pushPlatform(platformData, 3, i);
								break;
							case 4:
								platformData = pushPlatform(platformData, 4, i);
								break;
							case 5:
								platformData = pushPlatform(platformData, 5, i);
								break;
							case 6:
								platformData = pushPlatform(platformData, 6, i);
								break;
							case 7:
								platformData = pushPlatform(platformData, 7, i);
								break;
						}	
					}
				}
				else platformData = addBlankRow(platformData);
			}
			
			//Loading in the tilemap
			level = new FlxTilemap();
			level.loadMap(FlxTilemap.arrayToCSV(platformData,columns), FlxTilemap.ImgAuto, 0, 0, FlxTilemap.AUTO);
			add(level);
		}
	}
}