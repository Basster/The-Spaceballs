package spaceballs.data.tools {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	
	import spaceballs.data.fields.IField;
	import spaceballs.data.objects.Ball;
	/**
	 * Hilfsklasse für Gravitationsaktionen
	 * @author Basster
	 */
	public class GravityHelper {
		
		public static const CLOSEFORCEINTENSITY:Number = 1;		
		public static const NEARFORCEINTENSITY:Number = 0.25;
		
		/**
		 * Übt zusätzliche Gravitation auf einen Ball aus
		 * @param ball
		 * @param field
		 * @param intensity
		 * @param direction
		 */
		public static function gravFieldAction(ball:Ball,field:IField, intensity:Number, direction:GravFieldDirection):void {
			
			var bb:b2Body = ball.B2Body;
			var world:b2World = bb.m_world;		
   			
   			var dx:Number = field.get3dObject().x - ball.B2Body.GetPosition().x
			var dy:Number = field.get3dObject().y - ball.B2Body.GetPosition().y;
			var distSq:Number = dx*dx + dy*dy;
			var dist:Number = Math.sqrt( distSq );
			var force:Number = intensity;
			
			var velocity:b2Vec2 = ball.B2Body.GetLinearVelocity();
			velocity.x += force*dx / dist;
			velocity.y += force*dy / dist;
	
			if (direction == GravFieldDirection.OUT) {
				ball.B2Body.SetLinearVelocity(velocity);
			}
			else {
				ball.B2Body.m_linearDamping = intensity * 20;
			}
			
		}
	}
}