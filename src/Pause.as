package
{
	
	import org.flixel.*;
	
	
	public class Pause extends FlxGroup
	{
		private var _bg:FlxSprite;
		private var _field:FlxText;
		private var _unpause:FlxText;
		public var showing:Boolean;
		
		internal var _displaying:Boolean;
		
		private var _finishCallback:Function;
		
		public function Pause()
		{

			_field = new FlxText(20,FlxG.height/2-80, FlxG.width, "Paused");
			_field.setFormat(null, 12, 0xffffFFFF, "center");
			add(_field);
			
			_unpause = new FlxText(20,FlxG.height/2-40, FlxG.width,
				"Press space to unpause");
			_unpause.setFormat(null, 10, 0xffffFFFF, "center");
			add(_unpause);
		}
		
		public function showPaused():void
		{
			_displaying = true;
			showing = true;
		}
		
		override public function update():void
		{
			if (_displaying)
			{
				{
					_field.text = "Paused";
				}
				if(FlxG.keys.SPACE)
				{
					this.kill();
					this.exists = false;
					showing = false;
					_displaying = false;
					if (_finishCallback != null) _finishCallback();
					
				}
				else
				{
					
					showing = true;
					_displaying = true;
					
				}
				
				super.update();
			}
		}
		
		public function set finishCallback(val:Function):void
		{
			_finishCallback = val;
		}
		
	}
}