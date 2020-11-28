package spaceballs.data.events
{
	import flash.events.Event;
	import spaceballs.data.objects.Ball;
	/**
	 * 
	 * @author Basster
	 */
	public class BallEvent extends Event {
		/**
		 * Wenn ein Ball erstellt wird
		 * @default 
		 */
		public static const BALL_BORN:String = "BALL_BORN";
		
		/**
		 * Wenn ein Ball entfernt wird
		 * @default 
		 */
		public static const BALL_KILLED:String = "BALL_KILLED";
		
		/**
		 * Events für Spacebälle
		 * @param type
		 * @param ball
		 */
		public function BallEvent(type:String, ball:Ball) {
			_ball = ball;
			super(type);
		}
		
		private var _ball:Ball;
		
		/**
		 * Liefert den Ball, der dieses Event geworfen hat.
		 * @return 
		 */
		public function getBall():Ball {
			return _ball;
		}
	}
}