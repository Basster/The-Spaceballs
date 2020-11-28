package spaceballs.data.fields {
	import flash.display.Bitmap;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cube;
	import spaceballs.data.FieldType;
	import spaceballs.data.Playfield;
	import spaceballs.data.objects.Ball;
	/**
	 * Die Basisklasse füe alle Felder
	 * @author Basster
	 */
	public class FieldBase implements IField {
		
		/**
		 * Die Basisklasse füe alle Felder
		 * @param x X-Koordinate
		 * @param y Y-Koordinate
		 * @param widthX Breite in Feldern
		 * @param widthY Länge in Feldern
		 */
		public function FieldBase(x:uint, y:uint, widthX:uint = 1, widthY:uint = 1) {
			_x = --x;
			_y = --y;	
			_widthX = widthX;
			_widthY = widthY;
			
			setHeight(0);
			
			init();
		}
		/**
		 * Der Feldtyp
		 * @default 
		 */
		protected var _fieldType:FieldType;
		
		/**
		 * Das XML des Level
		 * @default 
		 */
		protected var _xml:XML;
		
		// Die Textur
		[Embed(source="resources/images/texture_normal.png")]
		private var Asset:Class;
		private var bitmap:Bitmap = new Asset();
		
		private var _cube:Cube;
		// Die Höhe des Feldes
		private  var _height:uint;
		private var _material:BitmapMaterial  = new BitmapMaterial(bitmap.bitmapData, true);
		
		private var _materials:MaterialsList;
		
		private var _name:String;
		
		// Referenz auf das Playfield
		private var _pf:Playfield;
		// Die Breite des Feldes (auf der X-Achse)
		private var _widthX:uint;
		// Die Länge des Feldes (auf der Z-Achse)
		private var _widthY:uint;
				
		private var _x:uint;
		private var _y:uint;
		
		/**
		 * Liefert die Höhe des Feldes (auf der Y-Achse)
		 * @return 
		 */
		public function get Height():Number {
			return _height;
		}
		
		/**
		 * Liefert den Namen des Feldes
		 * @return 
		 */
		public function get Name():String {
			return _name;
		}
		
		/**
		 * Setzt den Namen des Feldes
		 * @param name
		 */
		public function set Name(name:String):void {
			_name = name;
		}
		
		/**
		 * Liefert die Referenz auf das Playfield, in dem das Feld liegt
		 * @return 
		 */
		public function get ParentPlayfield():Playfield {
			return _pf;
		}
		
		/**
		 * Setzt die Referenz auf das Playfield, in dem das Feld liegt.
		 * @param pf
		 */
		public function set ParentPlayfield(pf:Playfield):void {
			_pf = pf;
		}
		
		/**
		 * Liefert den Feldtyp
		 * @return 
		 */
		public function get Type():FieldType	{
			return _fieldType;
		}
		
		/**
		 * Liefert die Breite des Feldes (auf der X-Achse)
		 * @return 
		 */
		public function get WidthX():Number {
			return _widthX;
		}
		
		/**
		 * Liefert die Länge des Feldes (auf der Z-Achse)
		 * @return 
		 */
		public function get WidthY():Number {
			return _widthY;
		}
		
		/**
		 * Liefert die X-Koordinate des Feldes
		 * @return 
		 */
		public function get X():uint {
			return _x;
		}
		
		/**
		 * Liefert das XML des Feldes
		 * @return 
		 */
		public function get Xml():XML {
			
			var field:XML = <Field />
			field.@x = _x;
			field.@y = _y;
			field.@widthX = _widthX;
			field.@widthY = _widthY;
			
			return field;
		}
		
		/**
		 * Setzt das XML des Feldes
		 * @param xml
		 */
		public function set Xml(xml:XML):void {
			_xml = xml;
		}
		
		/**
		 * Liefert die Y-Koordinate des Feldes 
		 * @return 
		 */
		public function get Y():uint {
			return _y;
		}
		
		/**
		 * Diese Methode wird aufgerufen, wenn sich ein Ball auf diesem Feld befindet.
		 * Wird vom jeweiligen Feldtyp überschrieben, wenn benötigt.
		 * @param ball Der auslösende Ball
		 */
		public function doHitEvent(ball:Ball):void {}
			
		/**
		 * Diese Methode wird aufgerufen, wenn sich ein Ball auf einem angrenzenden Feld befindet.
		 * Wird vom jeweiligen Feldtyp überschrieben, wenn benötigt.
		 * @param ball Der auslösende Ball
		 */
		public function doNearbyEvent(ball:Ball):void {}
		
		/**
		 * Liefert das PV3D DisplayObject3D des Feldes.
		 * @return 
		 */
		public function get3dObject():DisplayObject3D {
			
			if (!_cube) {			
				_cube = new Cube(_materials,WidthX,Height,WidthY);
			}
			
			return _cube;
		}
		
		/**
		 * Setzt die Texturen für das Feld.
		 * @param materials
		 */
		protected function set Materials(materials:MaterialsList):void {
			_materials = materials;
		}
		
		/**
		 * Initialisiert alle Membervariablen und erstellt standardmäßig ein FLOOR Feld.
		 */
		protected function init():void {
			// Erstellt Standardmäßig ein FLOOR Field
			setType(new FieldType(FieldType.FLOOR));
			
			_material.smooth = true;
			_material.tiled = true;
			_material.maxU = _widthX;
			_material.maxV = _widthY;
						
			var materials:MaterialsList = new MaterialsList(
			{
				all: _material
			} );			
			
			Materials = materials;
		}

		/**
		 * Setzt die Höhe des Feldes in "Höheneinheiten" (1 oder 2 (für Wände))
		 * @param height
		 */
		protected function setHeight(height:int):void {
			_height = height;
		}
		
		/**
		 * Setzt den Feldtyp.
		 * @param type
		 */
		protected function setType(type:FieldType):void {
			_fieldType = type;
		}
	}
}