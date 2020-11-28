package spaceballs.data.objects {
	import Box2D.Dynamics.b2Body;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import gs.TweenMax;
	
	import mx.effects.easing.Quadratic;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.objects.primitives.Sphere;
	
	import spaceballs.data.events.BallEvent;
	import spaceballs.data.fields.IField;
	/**
	 * Basisklasse für alle Bälle
	 * @author Basster
	 * 
	 */	
	public class Ball extends Sphere {
		
		/**
		 * Basisklasse für alle Bälle 
		 * @param material Texturmaterial
		 * @param radius Der Radius des Balls 
		 * 
		 */		
		public function Ball(material:MaterialObject3D = null, radius:Number = 100) {
			
			_fieldX = 0;
			_fieldY = 0;
			
			_b2Body = null;
			
			_radius = radius;
			
			super(material, _radius);
			
			growToFinalSize();
		}
		
		private var _b2Body:b2Body;
	
		private var _fieldX:uint;
		private var _fieldY:uint;
		
		private var _radius:Number;
		
		/**
		 * Liefert den zugehörigen Body der Physikengine
		 * @return 
		 */
		public function get B2Body():b2Body {
			return _b2Body;
		}
		
		/**
		 * Setzt den zugehörigen Body der Physikengine
		 * @param b
		 */
		public function set B2Body(b:b2Body):void {
			_b2Body = b;
		}
		
		/**
		 * Liefert die aktuelle X-Feldkoordinate
		 * @return 
		 */
		public function get FieldX():uint {
			return _fieldX;
		}
		
		/**
		 * Setzt die aktuelle X-Feldkoordinate
		 * @param val
		 */
		public function set FieldX(val:uint):void {
			_fieldX = val;
		}
		
		/**
		 * Liefert die aktuelle Y-Feldkoordinate
		 * @return 
		 */
		public function get FieldY():uint {
			return _fieldY;
		}
		
		/**
		 * Setzt die aktuelle Y-Feldkoordinate
		 * @param val
		 */
		public function set FieldY(val:uint):void {
			_fieldY = val;
		}
		
		/**
		 * Liefert den Radius des Balles
		 * @return 
		 */
		public function get Radius():Number {
			return _radius;
		}
		
		/**
		 * Der Ball "fällt" in den Hintergrund und wird dann aus 2D und 3D gelöscht.
		 * @param field
		 */
		public function fallFromWorldAndKillMe(field:IField):void {
			destroyB2Body();
			// TODO: Noch gegen Fallanimation tauschen!
			TweenMax.to(this, 1, { z: 100, scale:0.01, ease:Quadratic.easeIn, delay:0.1, overwrite:false, onComplete:killBall});			
		}
		
		/**
		 * Der all wächst auf seine normale Größe, wenn er vorher auf eine andere Größe skaliert wurde.
		 */
		public function growToFinalSize():void {
			TweenMax.to(this, 1, { scale:1, ease:Quadratic.easeIn, delay:0.1, overwrite:false, onComplete:fireBornEvent});
		}
		
		/**
		 * Löscht einfach den Ball aus 2D und 3D Welt
		 */
		public function killMe(delay:Number = 0):void {
			destroyB2Body();			
			killBall(delay);
		}
				
		/**
		 * Der ball schrumpft auf winzige Größe und wird dann aus 2D und 3D gelöscht.
		 */
		public function shrinkAndKillMe():void {
			
			destroyB2Body();
			
			TweenMax.to(this, 1, { scale:0.01, ease:Quadratic.easeIn, delay:0.1, overwrite:false, onComplete:killBall});
		}
		
		/**
		 * Löscht den Ball aus der 2D Physikwelt
		 */
		private function destroyB2Body():void {
			_b2Body.m_world.DestroyBody(_b2Body);
		}
		
		/**
		 * Feuert das Event, dass der Ball erstellt worden ist.
		 */
		private function fireBornEvent():void {
			dispatchEvent(new BallEvent(BallEvent.BALL_BORN, this));
		}
		
		/**
		 * Löscht den Ball aus der 3D Welt und feuert das Event, dass der Ball "tot" ist.
		 */
		private function killBall(delay:Number = 0):void {
			scene.removeChild(this);
			if (delay > 0) {
				var timer:Timer = new Timer(delay,1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, onKillTimerComplete);
				timer.start();	
			}
			else {
				dispatchEvent(new BallEvent(BallEvent.BALL_KILLED, this));
			}
		}
		
		private function onKillTimerComplete(event:TimerEvent):void {
			dispatchEvent(new BallEvent(BallEvent.BALL_KILLED, this));
		}
	}
}