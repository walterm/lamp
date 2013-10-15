package {
	import org.flixel.FlxSprite;

	/**
	 * @author ethanis
	 */
	public class Battery extends FlxSprite {
		public const maxBatteryLife:Number = 100;
		// once this drops to 0, you die		
		public var batteryLife:Number = 100;
		public const bulbBatteryRecovery:Number = 20;
		public const batteryDrain:Number = 0.04; // amount drained every update.
		
		public function Battery():void {
			this.x = 10;
			this.y = 22;
			loadGraphic(Sources.ImgBattery, true, false, 50, 23, true);
			this.frame = 3;
		}
		
		override public function update(): void {
			batteryLife -= batteryDrain;
			if (batteryLife < 0){
				// I cannot stand for the undead!
				batteryLife = 0;
			}
			// critical juncture, animate!
			var frameNo:uint = Math.max(0, Math.ceil(batteryLife/ 33));
			frame = frameNo;
			super.update();
		}
		
		public function recover(): void {
			batteryLife = Math.min((batteryLife + bulbBatteryRecovery), maxBatteryLife);
		}
	}
}
