package spaceballs.data.objects
{
	import flash.display.Bitmap;
	
	import org.papervision3d.materials.BitmapMaterial;

	public class SpaceballEnemy extends Ball
	{
		
		[Embed(source="resources/images/texture_enemy.jpg")]
		private var BallAsset:Class;
		private var _ballBitmap:Bitmap;
		private var _ballMaterial:BitmapMaterial;
		
		/**
		 * Ein SpaceballEnemy (Die Bösen!) 
		 * @param radius
		 * 
		 */		
		public function SpaceballEnemy(radius:Number=100) {
		
			_ballBitmap = new BallAsset() as Bitmap;
			_ballMaterial = new BitmapMaterial(_ballBitmap.bitmapData, true);
			
			super(_ballMaterial, radius);
		}
		
	}
}