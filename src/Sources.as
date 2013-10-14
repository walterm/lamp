package  
{
	public class Sources 
	{		
		//images and spritesheets 
		[Embed(source = '../assets/lampsheet.png')] public static var ImgPlayer:Class;
		[Embed(source="/../assets/light.png")] public static var ImgLight:Class;
		[Embed(source="../assets/bulbsheet.png")] public static var ImgBulb:Class;
		[Embed(source = '../assets/lightbeam.png')] public static var ImgLightBeam:Class;
		[Embed(source = '../assets/plantsheet.png')] public static var ImgPlant:Class;
		
		//music and sound effects
		[Embed(source = '../assets/backgroundmusic.mp3')] public static var BackgroundMusic:Class;
		[Embed(source = '../assets/bulbpickup.mp3')] public static var BulbPickupSoundEffect:Class;
		[Embed(source = '../assets/lampwalksfx.mp3')] public static var LampWalkSoundEffect:Class;
		[Embed(source = '../assets/lampJumpSfx.mp3')] public static var LampJumpSoundEffect:Class;
		[Embed(source = '../assets/lightbeamonsfx.mp3')] public static var LightBeamSoundEffect:Class;

	}
}