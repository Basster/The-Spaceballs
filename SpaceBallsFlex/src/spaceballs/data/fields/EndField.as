package spaceballs.data.fields {
	import flash.display.Bitmap;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import spaceballs.data.FieldType;
	import spaceballs.data.events.BallEvent;
	import spaceballs.data.manage.FieldEventManager;
	import spaceballs.data.manage.SpaceballsSounds;
	import spaceballs.data.objects.Ball;
	import spaceballs.data.objects.Spaceball;
	/**
	 * Ein Zielfeld
	 * @author Basster
	 */
	public class EndField extends FieldBase {
		
		/**
		 * Ein Zielfeld
		 * @param x X-Koordinate
		 * @param y Y-Koordinate
		 */
		public function EndField(x:int, y:int) {
			super(x, y);
		}
		
		[Embed(source="resources/images/texture_end.png")]
		private var Asset:Class;
		private var bitmap:Bitmap = new Asset();
		private var material:BitmapMaterial  = new BitmapMaterial(bitmap.bitmapData, true);
		
		override public function doHitEvent(ball:Ball):void {
			if (ball is Spaceball) {
				
				SpaceballsSounds.playEndFieldSound();
				
				ball.addEventListener(BallEvent.BALL_KILLED, onBallKilled);
				ball.shrinkAndKillMe();	
			}		
		}
		
		override protected function init():void {
			setType(new FieldType(FieldType.END));
			
			material.smooth = true;
			
			var materials:MaterialsList = new MaterialsList(
			{
				all: material
			} );
			
			Materials = materials;
		}
		
		private function onBallKilled(event:BallEvent):void {
			var fem:FieldEventManager = FieldEventManager.getInstance();
			fem.endFieldHit(event.getBall(), this);
		}
	}
}