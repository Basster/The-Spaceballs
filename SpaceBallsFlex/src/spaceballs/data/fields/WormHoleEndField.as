package spaceballs.data.fields {
	import flash.display.Bitmap;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import spaceballs.data.FieldType;
	/**
	 * Das Endfeld eines Wurmloches
	 * @author Basster
	 */
	public class WormHoleEndField extends FieldBase {
		
		/**
		 * Das Endfeld eines Wurmloches
		 * @param x X-Koordinate
		 * @param y Y-Koordinate
		 */
		public function WormHoleEndField(x:int, y:int) {
			super(x, y);
		}
		
		[Embed(source="resources/images/texture_wormholeout.png")]
		private var Asset:Class;
		private var bitmap:Bitmap = new Asset();
		private var material:BitmapMaterial  = new BitmapMaterial(bitmap.bitmapData, true);
		
		override protected function init():void {
			setType(new FieldType(FieldType.WORM_HOLE_END));
			
			material.smooth = true;
			
			var materials:MaterialsList = new MaterialsList(
			{
				all: material
			} );
			
			Materials = materials;
		}
	}
}