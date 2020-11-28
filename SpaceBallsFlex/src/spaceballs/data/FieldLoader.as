package spaceballs.data {
	import flash.errors.IOError;
	
	import spaceballs.data.fields.*;
	
	public class FieldLoader {
		
		private var _playField:Playfield;
				
		public function FieldLoader(playField:Playfield) {
			_playField = playField;
		}
		
		public function load(xmlNode:XML):IField {
			
			var type:int = xmlNode.@type;
			var x:int = xmlNode.@x;
			var y:int = xmlNode.@y;
			
			var width:int = xmlNode.@width;
			var length:int = xmlNode.@length;
			
			var field:IField;
			
			/*
			START:int = 1;
			END:int = 2;
			HOLE:int = 3;
			BLACK_HOLE:int = 4;
			GRAVITY:int = 5;
			WALL:int = 6;
			WORM_HOLE_START:int = 7;
			WORM_HOLE_END:int = 8;
			START_ENEMY:int = 9;
			FLOOR:int = 10;
			*/
			
			switch(type) {
				case FieldType.START:
					field = new StartField(x,y);
					break;
				case FieldType.END:
					field = new EndField(x,y);
					break;
				case FieldType.HOLE:
					field = new HoleField(x,y);
					break;
				case FieldType.BLACK_HOLE:
					field = new BlackHoleField(x,y);
					break;
				case FieldType.GRAVITYOUT:
					field = new GravityOutField(x,y);
					break;
				case FieldType.GRAVITYIN:
					field = new GravityInField(x,y);
					break;
				case FieldType.WALL:
					field = new WallField(x,y, width, length);
					break;
				case FieldType.WORM_HOLE_START:
					field = new WormHoleStartField(x,y);
					break;
				case FieldType.WORM_HOLE_END:
					field = new WormHoleEndField(x,y);
					break;
				case FieldType.START_ENEMY:
					field = new StartEnemyField(x,y);
					break;
				case FieldType.FLOOR:
					field = new FloorField(x,y, width, length);
					break;
				case FieldType.EMPTY:
					field = new EmptyField(x,y, width, length);
					break;
				default:
					throw new IOError("Unknown FieldType (" + type.toString() + ")!");
					break;
			}
			
			field.ParentPlayfield = _playField;
			
			return field;
		}
	}
}