package spaceballs.data.events {
	import flash.events.Event;
	/**
	 * 
	 * @author Basster
	 */
	public class PlayfieldEvent extends Event {
		
		/**
		 * Das Spielfeld wurde erfolgreich geladen
		 * @default 
		 */
		public static const PLAYFIELD_LOADED:String = "PLAYFIELD_LOADED";
		public static const PLAYFIELD_LOAD_FAILED:String = "PLAYFIELD_LOAD_FAILED";
				
		/**
		 * Ein Event, dass Information über den Zustand des aktuellen Spielfeldes gibt.
		 * @param type Der Eventtyp
		 * @param levelSrc Der Dateiname des aktuellen Level
		 */
		public function PlayfieldEvent(type:String, levelSrc:String = null, message:String = null) {
			
			super(type);
			this._levelSrc = levelSrc;
			this._message = message;
		}
		
		private var _levelSrc:String;
		private var _message:String;
		
		/**
		 * Der Dateiname des aktuellen Level
		 * @return 
		 */
		public function get LevelSrc():String {
			return _levelSrc;
		}
		
		public function get Message():String {
			return _message;
		}
	}
}