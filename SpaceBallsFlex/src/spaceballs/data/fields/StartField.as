package spaceballs.data.fields {
	import flash.display.Bitmap;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import spaceballs.data.FieldType;
	/**
	 * Ein Startfeld für einen Spaceball
	 * @author Basster
	 */
	public class StartField extends FieldBase {
		
		/**
		 * Ein Startfeld für einen Spaceball
		 * @param x
		 * @param y
		 */
		public function StartField(x:int, y:int) {
			super(x, y);
		}
		
		[Embed(source="resources/images/texture_normal.png")]
		private var Asset:Class;
		private var bitmap:Bitmap = new Asset();
		private var material:BitmapMaterial  = new BitmapMaterial(bitmap.bitmapData, true);
		
		override protected function init():void {
			
			setType(new FieldType(FieldType.START));
			
			material.smooth = true;
						
			var materials:MaterialsList = new MaterialsList(
			{
				all: material
			} );			
			
			Materials = materials;
		}
	}
}