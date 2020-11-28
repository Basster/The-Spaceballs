package spaceballs.data.events {
	import flash.events.Event;
	import spaceballs.data.fields.IField;
	import spaceballs.data.objects.Ball;
	/**
	 * 
	 * @author Basster
	 */
	public class FieldEvent extends Event {
		
		/**
		 * Alle Ziele wurden erreicht
		 * @default 
		 */
		public static const ALL_GOALS_HIT:String = "ALL_GOALS_HIT";
		/**
		 * Ein Schwarzes Loch wurde getroffen
		 * @default 
		 */
		public static const BLACKHOLE_HIT:String = "BLACKHOLE_HIT";
		/**
		 * Ein leeres Feld wurde getroffen
		 * @default 
		 */
		public static const EMPTY_FIELD_HIT:String = "EMPTY_FIELD_HIT";
		
		/**
		 * Ein Zielfeld wurde getroffen
		 * @default 
		 */
		public static const END_FIELD_HIT:String = "END_FIELD_HIT";
		/**
		 * Ein Lochfeld wurde getroffen
		 * @default 
		 */
		public static const HOLE_HIT:String = "HOLE_HIT";
		/**
		 * Ein Wurmloch Eingang wurde getroffen
		 * @default 
		 */
		public static const WORMHOLE_IN_HIT:String = "WORMHOLE_IN_HIT";
		/**
		 * Ein Wurmloch Ausgang wurde getroffen
		 * @default 
		 */
		public static const WORMHOLE_OUT_HIT:String = "WORMHOLE_OUT_HIT";
		
		/**
		 * Ein Event, welches gefeuert wird, wenn ein Ball über bestimmte Felder rollt.
		 * @param type Der Eventtyp
		 * @param ball Der auslösende Ball
		 * @param field Das aktuelle Feld
		 */
		public function FieldEvent(type:String, ball:Ball, field:IField) {
			
			this.ball = ball;
			this.field = field;
			
			super(type);
		}
		
		/**
		 * Der auslösende Ball
		 * @default 
		 */
		public var ball:Ball;
		/**
		 * Das aktuelle Feld
		 * @default 
		 */
		public var field:IField;
	}
}