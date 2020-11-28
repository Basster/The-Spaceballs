package spaceballs.data.manage {
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	
	import flash.events.EventDispatcher;
	
	import spaceballs.data.CustomContactPoint;
	import spaceballs.data.Playfield;
	import spaceballs.data.events.CollisionEvent;
	import spaceballs.data.events.FieldEvent;
	import spaceballs.data.events.GameEvent;
	import spaceballs.data.fields.EmptyField;
	import spaceballs.data.fields.EndField;
	import spaceballs.data.fields.IField;
	import spaceballs.data.objects.Ball;
	import spaceballs.data.objects.Spaceball;
	import spaceballs.data.objects.SpaceballEnemy;
	import spaceballs.data.scenes.Box2dScene;
	
	/**
	 * Diese Klasse managed nahezu alle Events, die vom Spiel gefeuert werden.
	 * Daher werden hier alle Events angehängt. Diese Klasse feuert sie zentral, wenn sie
	 * von den jeweiligen Stellen dazu aufgefordert wird.
	 */ 
	public class FieldEventManager extends EventDispatcher {
		
		private static var _fem:FieldEventManager = null;
		
		/**
		 * Liefert die Instanz des FieldEventmanagers
		 * @return 
		 * @throws Error
		 */
		public static function getInstance():FieldEventManager {
			if (!_fem) {
				throw new Error("FieldEventManager has not been initialized yet, please call FieldEventManager.initialize() first!");
			}
			return _fem;
		}
		
		/**
		 * Initialisiert den FieldEventManager neu! Achtung, überschreibt die existierende Instanz!
		 *  
		 * @param playfield Das aktuelle Spielfeld
		 * @param box2dScene Die Physikengine Scene
		 * @return 
		 * 
		 */		
		public static function initialize(playfield:Playfield, box2dScene:Box2dScene):FieldEventManager {
			
			_fem = new FieldEventManager(playfield, box2dScene);
			_fem.setInitialized();
			
			return _fem;
		}
		
		/**
		 * Erstellt eine neue FieldEventManager Instanz 
		 * @param playfield Das aktuelle Spielfeld
		 * @param box2dScene Die Physikengine Scene
		 * @throws Error
		 */
		public function FieldEventManager(playfield:Playfield, box2dScene:Box2dScene) {
			if (_initialized) {
				throw new Error("FieldEventManager has not been initialized yet, please call FieldEventManager.initialize() first!");
			}
			_b2d = box2dScene;
			_pf = playfield;
			_initialized = false;
			_pf.setFEM(this);
		}
		
		private var _b2d:Box2dScene;
		
		private var _goals:Array;
		
		private var _initialized:Boolean;
		
		private var _lastHitEvent:Function;
		private var _lastNearbyEvent:Function;
		private var _pf:Playfield;
		
		/* 
		Field Event Methoden
		Werden von den Feldern selbst aufgerufen 
		*/
		
		/**
		 * Erteilt dem FEM die Aufgabe das Event zu feuern, dass ein Schwarzes Loch Feld berührt worden ist.
		 * @param ball
		 * @param field
		 */
		public function blackHoleHit(ball:Ball, field:IField):void {
			dispatchEvent(new FieldEvent(FieldEvent.BLACKHOLE_HIT, ball, field));
		}
		
		/**
		 * Erteilt dem FEM die Aufgabe das Event zu feuern, dass ein leeres Feld berührt worden ist.
		 * @param ball
		 * @param field
		 */
		public function emptyFieldHit(ball:Ball, field:IField):void {
			dispatchEvent(new FieldEvent(FieldEvent.EMPTY_FIELD_HIT, ball, field));
		}
		
		/**
		 * Erteilt dem FEM die Aufgabe das Event zu feuern, dass ein Endfeld berührt worden ist.
		 * @param ball
		 * @param field
		 */
		public function endFieldHit(ball:Ball, field:IField):void {
			dispatchEvent(new FieldEvent(FieldEvent.END_FIELD_HIT, ball, field));
		}
		
		/**
		 * Erteilt dem FEM die Aufgabe das Event zu feuern, dass das Level abgeschlossen wurde.
		 * @param finished true, wenn das Level erfolgreich beendet wurde, false, wenn nicht.
		 */
		public function endLevel(finished:Boolean):void {
		
			var event:String;

			event = finished ? GameEvent.LEVEL_FINISHED : GameEvent.LEVEL_LOST;
			
			dispatchEvent(new GameEvent(event));
		}
		
		/**
		 * Ermittelt die X/Y-Feldkoordinaten aller Bälle, also über welchem Feld sich der jeweilige Ball gerade befindet
		 */
		public function getBallCoords():void {

			for(var bb:b2Body = _b2d.World.GetBodyList(); bb; bb = bb.GetNext()) {
				if (bb.GetUserData() is Ball) {
					var ball:Ball = bb.GetUserData() as Ball;
					ball.FieldX = Math.ceil((ball.x - _pf.XOffset) / _pf.BrickSize);
					ball.FieldY = _pf.FieldSize.Height - Math.floor((ball.y - _pf.YOffset) / _pf.BrickSize);
				}
			}			

		}
		
		/**
		 * Sucht durch den ContactStack der Physikengine, ob es zu Kollisionen gekommen ist und feuert die entsprechenden Events.
		 */
		public function handleCollisions():void {
			while(_b2d.ContactStack[0]) {
				var currentContact:CustomContactPoint = _b2d.ContactStack.pop();
				
				// Kugel trifft Kugel
				if (currentContact.shape1 is b2CircleShape && currentContact.shape2 is b2CircleShape) {
					var ball1:Ball = currentContact.shape1.GetBody().GetUserData();
					var ball2:Ball = currentContact.shape2.GetBody().GetUserData();
					
					// Spaceballenemy trifft SpaceballEnemy
					if (ball1 is SpaceballEnemy && ball2 is SpaceballEnemy) {
						dispatchEvent(new CollisionEvent(CollisionEvent.SPACEBALLENEMYBALLSHIT,ball1,ball2));
					}
					// Spaceball trifft Spaceball
					else if (ball1 is Spaceball && ball2 is Spaceball) {
						dispatchEvent(new CollisionEvent(CollisionEvent.SPACEBALLSHIT,ball1,ball2));
					}
					// Spaceball trifft Spaceballenemy
					else if ((ball1 is Spaceball && ball2 is SpaceballEnemy) || (ball1 is SpaceballEnemy && ball2 is Spaceball)) {
						dispatchEvent(new CollisionEvent(CollisionEvent.SPACEBALLHITSENEMY,ball1,ball2));
					}
				}
				// Ball trifft Wand
				else if (currentContact.shape1 is b2CircleShape && currentContact.shape2 is b2PolygonShape) {
					dispatchEvent(new CollisionEvent(CollisionEvent.BALLHITSWALL,ball1,null,currentContact.shape2));		
				}
				else if (currentContact.shape1 is b2PolygonShape && currentContact.shape2 is b2CircleShape) {
					dispatchEvent(new CollisionEvent(CollisionEvent.BALLHITSWALL,ball2,null,currentContact.shape1));
				}
			}			
		}
		
		/**
		 * Ermittelt für alle Bälle, die Felder, auf denen sie sich befinden
		 * und führt die FieldHit oder Field Nearby Events aus.
		 */
		public function handleFieldEvents():void {
			
			_goals = new Array();
							
			for(var bb:b2Body = _b2d.World.GetBodyList(); bb; bb = bb.GetNext()) {
				if (bb.GetUserData() is Ball) {
					var ball:Ball = bb.GetUserData() as Ball;
					ball.B2Body.m_linearDamping = 1;
					
					// Ball wird nun wie bei einem EmptyField behandelt, wenn er aus dem Spielfeld rausrollt,
					// z.B. wenn es drum herum keine Mauern gibt
					if (ball.FieldX <= 0 || ball.FieldY <= 0 
						|| ball.FieldX > _pf.FieldSize.Width || ball.FieldY > _pf.FieldSize.Height) {
						var eField:IField = new EmptyField(ball.FieldX,ball.FieldY,1,1);
						eField.doHitEvent(ball);
					}
					
					// da die Felder von 0 an durchnummeriert sind, muss hier 1 addiert werden!
					for (var x:int = ball.FieldX - 2; x < ball.FieldX + 1; x++) {
						for (var y:int = ball.FieldY - 2; y < ball.FieldY + 1; y++) {
							
							try {
								var field:IField = _pf.getField(x,y);
							
								// erstmal das Feld checken, auf dem sich der Ball direkt befindet
								if (field.X + 1 == ball.FieldX && field.Y + 1 == ball.FieldY) {
									field.doHitEvent(ball);
									if (field is EndField && ball is Spaceball) {
										_goals.push(true);
									}
								}
								// dann alle Felder drumherum checken
								else {
									field.doNearbyEvent(ball);
								}
							}
							catch (err:Error) {
								;//doNothing()
							}
						} 
					}
				}
			}
			
			if (_goals.length == _pf.GoalsCount) {
				dispatchEvent(new FieldEvent(FieldEvent.ALL_GOALS_HIT,null,null));
			}
		}
		
		/**
		 * Erteilt dem FEM die Aufgabe das Event zu feuern, dass ein Loch Feld berührt worden ist.
		 * @param ball
		 * @param field
		 */
		public function holeHit(ball:Ball, field:IField):void {
			dispatchEvent(new FieldEvent(FieldEvent.HOLE_HIT, ball, field));
		}
		
		/**
		 * Erteilt dem FEM die Aufgabe das Event zu feuern, dass ein Wurmloch-In Feld berührt worden ist.
		 * @param ball
		 * @param field
		 */
		public function wormHoleInHit(ball:Ball, field:IField):void {
			dispatchEvent(new FieldEvent(FieldEvent.WORMHOLE_IN_HIT, ball, field));
		}
		
		/**
		 * Erteilt dem FEM die Aufgabe das Event zu feuern, dass ein Wurmloch-Out Feld berührt worden ist.
		 * @param ball
		 * @param field
		 */
		public function wormHoleOutHit(ball:Ball, field:IField):void {
			dispatchEvent(new FieldEvent(FieldEvent.WORMHOLE_OUT_HIT, ball, field));
		}
		
		/**
		 * Setzt den initialized Status für den FEM um den Singleton zu realisieren.
		 */
		private function setInitialized():void {
			_initialized = true;
		}
	}
}