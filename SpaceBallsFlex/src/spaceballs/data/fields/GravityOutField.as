package spaceballs.data.fields {
	import flash.display.Bitmap;
	import flash.media.Sound;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import spaceballs.data.FieldType;
	import spaceballs.data.manage.SpaceballsSounds;
	import spaceballs.data.objects.Ball;
	import spaceballs.data.tools.GravFieldDirection;
	import spaceballs.data.tools.GravityHelper;
	/**
	 * Ein Gravitationsfeld mit Krafteinwirkung vom Feld weg
	 * @author Basster
	 */
	public class GravityOutField extends FieldBase {
		
		/**
		 * Ein Gravitationsfeld mit Krafteinwirkung vom Feld weg
		 * @param x X-Koordinate
		 * @param y Y-Koordinate
		 */
		public function GravityOutField(x:int, y:int) {
			super(x, y);
		}
		
		[Embed(source="resources/images/texture_gravitationout.png")]
		private var Asset:Class;
		
		[Embed(source="resources/sounds/Gravitationsfeld.mp3")]
		private var GravyOutAsset:Class;
		
		private var _sound:Sound = new GravyOutAsset();
		private var bitmap:Bitmap = new Asset();
		private var material:BitmapMaterial  = new BitmapMaterial(bitmap.bitmapData, true);
		
		override public function doHitEvent(ball:Ball):void {
			SpaceballsSounds.playGravitySound();
			
			GravityHelper.gravFieldAction(ball, this, GravityHelper.CLOSEFORCEINTENSITY, GravFieldDirection.OUT);
		}
		
		override protected function init():void {
			setType(new FieldType(FieldType.GRAVITYOUT));
			
			material.smooth = true;
			
			var materials:MaterialsList = new MaterialsList(
			{
				all: material
			} );
			
			Materials = materials;
		}
	}
}