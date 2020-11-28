package spaceballs.data.fields {
	import flash.display.Bitmap;
	
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	
	import spaceballs.data.FieldType;
	import spaceballs.data.events.BallEvent;
	import spaceballs.data.manage.SpaceballsEffects;
	import spaceballs.data.objects.Ball;
	import spaceballs.data.objects.Spaceball;
	import spaceballs.data.scenes.Box2dScene;
	import spaceballs.data.scenes.Pv3dScene;
	/**
	 * Das Startfeld eines Wurmloches. 
	 * Ein Ball, der auf dieses Feld kommt, wird eingesogen und taucht an dem dazugehörigen Ausgangsfeld wieder auf.
	 * <strong>In der aktuellen Version kann pro Level nur ein Wurmloch Paar existieren.</strong>
	 * @author Basster
	 */
	public class WormHoleStartField extends FieldBase {
		
		/**
		 * Das Startfeld eines Wurmloches. 
		 * Ein Ball, der auf dieses Feld kommt, wird eingesogen und taucht an dem dazugehörigen Ausgangsfeld wieder auf.
		 * <strong>In der aktuellen Version kann pro Level nur ein Wurmloch Paar existieren.</strong> 
		 * @param x
		 * @param y
		 */
		public function WormHoleStartField(x:uint, y:uint) {
			super(x, y);
		}
		
		[Embed(source="resources/images/texture_wormholein.png")]
		private var Asset:Class;
				
		private var _endField:IField;
		private var bitmap:Bitmap = new Asset();
		private var material:BitmapMaterial  = new BitmapMaterial(bitmap.bitmapData, true);
		
		override public function doHitEvent(ball:Ball):void {
			
			// Position des Endwurmloches finden
			findEndFieldPos();
			// Den Wurmlocheffekt einspielen
			SpaceballsEffects.createWormholeEffect(ball.Radius * 4, ball.scene,ball.x, ball.y, ball.Radius * -1.5,2000);
			// Dem Ball einen Eventlistener anfügen, der gefeuert wird, wenn er stribt...
			ball.addEventListener(BallEvent.BALL_KILLED, onBallKilled);				
			// ...und den Ball sterben lassen.
			ball.shrinkAndKillMe();			
		}
		
		override protected function init():void {
			setType(new FieldType(FieldType.WORM_HOLE_START));
			
			material.smooth = true;
			
			var materials:MaterialsList = new MaterialsList(
			{
				all: material
			} );
			
			Materials = materials;
		}
		
		/**
		 * Ermittelt das zugehörige Endfeld 
		 * 
		 */		
		private function findEndFieldPos():void {
			for each (var field:IField in ParentPlayfield.Fields) {
				if (field.Type.type == FieldType.WORM_HOLE_END) {
					_endField = field;
					break;
				}
			}
		}
				
		private function onBallKilled(event:BallEvent):void {
			// sobald der Ball auf dem Feld "getötet" wurde
			var ball:Ball = event.getBall();
			
			// ...wird eine Kopie des Balles an der Position des Endfeldes erzeugt
			var newBall:Ball;
			if (ball is Spaceball) {
				newBall = ParentPlayfield.createSpaceball(ball.Radius, _endField, ball.extra.XOffset, ball.extra.YOffset,0.01);
			}
			else {
				newBall = ParentPlayfield.createSpaceballEnemy(ball.Radius, _endField, ball.extra.XOffset, ball.extra.YOffset,0.01);
			}
		
			
			// ...und der neue Ball in 3D und 2D eingefügt
			Pv3dScene.getInstance().addDisplayObject3D(newBall);
			Box2dScene.getInstance().createBall(newBall);
			
			// ...und weils so schön war, noch auf dem EndField den Effekt abspielen :)
			SpaceballsEffects.createWormholeEffect(newBall.Radius * 4, newBall.scene, newBall.x, newBall.y, newBall.Radius * -1.5,1500);
		}
	}
}