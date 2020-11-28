package spaceballs.data
{
	public class FieldType
	{
		public static const START:int = 1;
		public static const END:int = 2;
		public static const HOLE:int = 3;
		public static const BLACK_HOLE:int = 4;
		public static const GRAVITYOUT:int = 5;
		public static const WALL:int = 6;
		public static const WORM_HOLE_START:int = 7;
		public static const WORM_HOLE_END:int = 8;
		public static const START_ENEMY:int = 9;
		public static const FLOOR:int = 10;
		public static const GRAVITYIN:int = 11;
		public static const EMPTY:int = 12;
		
		private var _fType:int;
		
		public function FieldType(type:int = 0) {
			_fType = type;
		}
		
		public function get type():int {
			return _fType;
		}

	}
}