package spaceballs.data.objects
{
	import flash.display.Bitmap;
	import org.papervision3d.materials.BitmapMaterial;
	/**
	 * 
	 * @author Basster
	 */
	public class Spaceball extends Ball
	{
		[Embed(source="resources/images/texture_spaceball.jpg")]
		private var BallAsset:Class;
		private var _ballBitmap:Bitmap;
		private var _ballMaterial:BitmapMaterial;
		
		/**
		 * Ein Spaceball (Die Guten!)
		 * @param radius
		 */
		public function Spaceball(radius:Number=100) {
			
			_ballBitmap = new BallAsset() as Bitmap;
			_ballMaterial = new BitmapMaterial(_ballBitmap.bitmapData, true);
			
			super(_ballMaterial, radius);
		}
				
	}
}