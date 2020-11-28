package spaceballs.data {
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2ContactPoint;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2ContactListener;

	public class ContactListener extends b2ContactListener {
		
		public var contactStack:Array = new Array();
		
		override public function Add(point:b2ContactPoint):void {
			var shape1:b2Shape 		= point.shape1;
			var shape2:b2Shape 		= point.shape2;
			var separation:Number 	= point.separation;
			var position:b2Vec2		= point.position.Copy();
			
			contactStack.push(new CustomContactPoint(shape1, shape2, separation, position));
			
		}		
	}
}