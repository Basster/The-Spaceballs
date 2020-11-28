package spaceballs.data.events {
	import flash.events.Event;
	/**
	 * 
	 * @author Basster
	 */
	public class GameEvent extends Event {
		
		/**
		 * Das Level wurde erfolgreich abgeschlossen
		 * @default 
		 */
		public static const LEVEL_FINISHED:String = "LEVEL_FINISHED";
		/**
		 * Das Level wurde nicht erfolgreich abgeschlossen
		 * @default 
		 */
		public static const LEVEL_LOST:String = "LEVEL_LOST";
		
		/**
		 * Ein Event, was über den Spielverlauf Auskunft gibt.
		 * @param type Der Eventtyp
		 * @param data Beliebige Daten
		 */
		public function GameEvent(type:String, data:* = null) {
			super(type);
			this.data = data;
		}
				
		/**
		 * Beliebige Daten
		 * @default 
		 */
		public var data:*;
	}
}