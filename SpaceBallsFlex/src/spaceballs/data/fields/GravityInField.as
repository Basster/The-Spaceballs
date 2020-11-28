package spaceballs.data.fields {
	import flash.display.Bitmap;
	
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	
	import spaceballs.data.FieldType;
	import spaceballs.data.manage.SpaceballsSounds;
	import spaceballs.data.objects.Ball;
	import spaceballs.data.tools.GravFieldDirection;
	import spaceballs.data.tools.GravityHelper;
	/**
	 * Ein Gravitationsfeld mit Krafteinwirkung auf das Feld zu.
	 * @author Basster
	 */
	public class GravityInField extends FieldBase {
		
		/**
		 * Ein Gravitationsfeld mit Krafteinwirkung auf das Feld zu
		 * @param x X-Koordinate
		 * @param y Y-Koordinate
		 */
		public function GravityInField(x:int, y:int) {
			super(x, y);
		}
		
		[Embed(source="resources/images/texture_gravitationin.png")]
		private var Asset:Class;
		
		private var bitmap:Bitmap = new Asset();
		private var material:BitmapMaterial  = new BitmapMaterial(bitmap.bitmapData, true);
		
		override public function doHitEvent(ball:Ball):void {
			
			GravityHelper.gravFieldAction(ball, this, GravityHelper.CLOSEFORCEINTENSITY, GravFieldDirection.IN);
		}

		
		override protected function init():void {
			setType(new FieldType(FieldType.GRAVITYIN));
			
			material.smooth = true;
			
			var materials:MaterialsList = new MaterialsList(
			{
				all: material
			} );
			
			Materials = materials;
		}
	}
}