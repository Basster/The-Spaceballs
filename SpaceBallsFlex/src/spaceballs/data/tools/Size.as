package spaceballs.data.tools {
	/**
	 * Kleine Hilfsklasse, für eine Größe mit Höhe und Breite
	 * @author Basster
	 */
	public class Size {
		
		private var _width:Number;
		private var _height:Number;
		
		/**
		 * Kleine Hilfsklasse, für eine Größe mit Höhe und Breite
		 * @param width Breite
		 * @param height Höhe
		 */
		public function Size(width:Number = 0, height:Number = 0) {
			_width = width;
			_height = height;
		}
		
		/**
		 * Liefert die Breite
		 * @return 
		 */
		public function get Width():Number {
			return _width;
		}		
		
		/**
		 * Setzt die Breite
		 * @param w
		 */
		public function set Width(w:Number):void {
			_width = w;
		}
		
		/**
		 * Liefert die Höhe
		 * @return 
		 */
		public function get Height():Number {
			return _height;
		}
		
		/**
		 * Setzt die Höhe
		 * @param h
		 */
		public function set Height(h:Number):void {
			_height = h;
		}
	}
}