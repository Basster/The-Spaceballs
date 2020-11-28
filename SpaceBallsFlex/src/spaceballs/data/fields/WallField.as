package spaceballs.data.fields {
	import flash.display.Bitmap;
	
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.shaders.ShadedMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	
	import spaceballs.data.FieldType;
	/**
	 * Ein Wandfeld
	 * @author Basster
	 */
	public class WallField extends FieldBase {
		
		/**
		 * Ein Wandfeld
		 * @param x X-Koordinate
		 * @param y Y-Koordinate
		 * @param width Breite in Feldern
		 * @param length Länge in Feldern
		 */
		public function WallField(x:int, y:int, width:int, length:int) {
			widthX = width;
			widthY = length;	
			super(x, y, width, length);		
		}
		
		[Embed(source="resources/images/texture_wall-top.jpg")]
		private var Asset1:Class;
		
		[Embed(source="resources/images/texture_wall-side2.jpg")]
		private var Asset2:Class;
		
		[Embed(source="resources/images/texture_wall-side1.jpg")]
		private var Asset3:Class;
		
		[Embed(source="resources/images/texture_wall-side3.jpg")]
		private var Asset4:Class;
		
		private var bitmap1:Bitmap = new Asset1();
		private var bitmap2:Bitmap = new Asset2();
		private var bitmap3:Bitmap = new Asset3();
		private var bitmap4:Bitmap = new Asset4();
		
		private var materialSide1:BitmapMaterial  = new BitmapMaterial(bitmap2.bitmapData);
		private var materialSide2:BitmapMaterial  = new BitmapMaterial(bitmap3.bitmapData);
		private var materialSide3:BitmapMaterial  = new BitmapMaterial(bitmap4.bitmapData);
		private var materialTop:BitmapMaterial  = new BitmapMaterial(bitmap1.bitmapData);
		
		private var widthX:uint;
		private var widthY:uint;
		
		override protected function init():void {
			
			setHeight(1);
			setType(new FieldType(FieldType.WALL));
			
			materialSide1.smooth = true;
			materialSide1.tiled = true;
			materialSide1.interactive = true;
			materialSide1.maxU = 1;
			materialSide1.maxV = widthY;
			
			materialSide3.smooth = true;
			materialSide3.tiled = true;
			materialSide3.interactive = true;
			materialSide3.maxU = 1;
			materialSide3.maxV = widthY;
			
			materialSide2.smooth = true;
			materialSide2.tiled = true;
			materialSide2.interactive = true;
			materialSide2.maxU = widthX;
			materialSide2.maxV = 1;
			
			materialTop.smooth = true;
			materialTop.tiled = true;
			materialTop.interactive = true;
			materialTop.maxU = widthX;
			materialTop.maxV = widthY;
			
			var materials:MaterialsList = new MaterialsList(
			{
				back: materialTop, //top
				right: materialSide3, //right
				left: materialSide1, //left
				top: materialSide2, //back
				bottom: materialSide2 //front
			} );
			
			Materials = materials;
		}
	}
}