package spaceballs.data.events {
	import flash.events.Event;
	import Box2D.Collision.Shapes.b2Shape;
	import spaceballs.data.objects.Ball;
	/**
	 * 
	 * @author Basster
	 */
	public class CollisionEvent extends Event {

		/**
		 * Ein Ball (egal welcher Art) trifft die Wand
		 * @default 
		 */
		public static const BALLHITSWALL:String = "BALLHITSWALL";
		
		/**
		 * Zwei SpaceballEnemy Bälle treffen sich (2 böse Bälle)
		 * @default 
		 */
		public static const SPACEBALLENEMYBALLSHIT:String = "SPACEBALLENEMYBALLSHIT";
		
		/**
		 * Ein Spaceball und ein SpaceballEnemy treffen sich (gute gegen Böse)
		 * @default 
		 */
		public static const SPACEBALLHITSENEMY:String = "SPACEBALLHITSENEMY";

		/**
		 * Zwei Spaceballs Bälle treffen such (2 gute Bälle)
		 * @default 
		 */
		public static const SPACEBALLSHIT:String = "SPACEBALLSHIT";
		
		/**
		 * Ein Event, welches bei einer Kollision zweier Objekte gefeuert wird.
		 * @param type Der Eventtyp
		 * @param ball1 Erster beteiligter Ball
		 * @param ball2 Zweiter beteiligter Ball (otpional)
		 * @param shape An der Kollision beteiligtes Objekt (optional)
		 */
		public function CollisionEvent(type:String, ball1:Ball, ball2:Ball = null, shape:b2Shape = null) {
			super(type);
			_ball1 = ball1;
			_ball2 = ball2;
			_shape = shape;
		}
		
		private var _ball1:Ball;
		private var _ball2:Ball;
		private var _shape:b2Shape;
		
		/**
		 * Liefert den ersten an der Kollision beteiligten Ball zurück.
		 * @return 
		 */
		public function get Ball1():Ball {
			return _ball1;
		}
		
		/**
		 * Liefert den zweiten an der Kollision beteiligten Ball zurück. (optional)
		 * @return 
		 */
		public function get Ball2():Ball {
			return _ball2;
		}
		
		/**
		 * Liefert das an der Kollision beteiligte Objekt zurück. (optional)
		 * @return 
		 */
		public function get Shape():b2Shape {
			return _shape;
		}
	}
}