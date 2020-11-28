package spaceballs.data.manage {
	import flash.media.Sound;
	
	import mx.core.Application;
	
	/**
	 * 
	 * @author Basster
	 */
	public class SpaceballsSounds {
		
		[Embed(source="resources/sounds/Wurmloch.mp3")]			
		private static var WormSoundAsset:Class;
		private static var _wormSound:Sound = new WormSoundAsset() as Sound;
		
		[Embed(source="resources/sounds/Ziel.mp3")]
		private static var EndSoundAsset:Class;
		private static var _endSound:Sound = new EndSoundAsset() as Sound;
		
		[Embed(source="resources/sounds/Schwarzesloch.mp3")]
		private static var BlackholeSoundAsset:Class;
		private static var _blackholeSound:Sound = new BlackholeSoundAsset() as Sound;
		
		[Embed(source="resources/sounds/Wand.mp3")]
		private static var WallAsset:Class;
		private static var _wallsound:Sound = new WallAsset();
		
		[Embed(source="resources/sounds/Explosion.mp3")]
		private static var ExplosionAsset:Class;
		private static var _explosionSound:Sound = new ExplosionAsset();
		
		[Embed(source="resources/sounds/Gravitationsfeld.mp3")]
		private static var GravityAsset:Class;
		private static var _gravitySound:Sound = new GravityAsset();		
		
		/**
		 * Spielt den Wurmloch Sound ab
		 */
		public static function playWormholeSound():void {
			if (Application.application.changeSoundState)
				_wormSound.play();
		}
		
		/**
		 * Spielt den Endfeld Sound ab
		 */
		public static function playEndFieldSound():void {
			if (Application.application.changeSoundState)
				_endSound.play();
		}
		
		/**
		 * Spielt den Schwarzes Loch Sound ab
		 */
		public static function playBlackholeSound():void {
			if (Application.application.changeSoundState)
				_blackholeSound.play();
		}
		
		/**
		 * Spielt den BallTrifftWand-Sound ab
		 */
		public static function playWallSound():void {
			if (Application.application.changeSoundState)
				_wallsound.play();
		}
		
		/**
		 * Spielt den Explosionssound ab
		 */
		public static function playExplosionSound():void {
			if (Application.application.changeSoundState)
				_explosionSound.play();
		}
		
		/**
		 * Spielt den Gravity-Feld Sound ab
		 */
		public static function playGravitySound():void {
			if (Application.application.changeSoundState)
				_gravitySound.play();
		}

	}
}