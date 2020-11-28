package spaceballs.data.fields {
	import flash.display.Bitmap;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import spaceballs.data.FieldType;
	import spaceballs.data.events.BallEvent;
	import spaceballs.data.manage.FieldEventManager;
	import spaceballs.data.manage.SpaceballsSounds;
	import spaceballs.data.objects.Ball;
	/**
	 * Ein Schwarzes Loch Feld
	 * @author Basster
	 */
	public class BlackHoleField extends FieldBase {
		
		/**
		 * Ein Schwarzes Loch Feld
		 * @param x X-Koordinate
		 * @param y Y-Koordinate
		 */
		public function BlackHoleField(x:int, y:int) {
			super(x, y);
		}
		
		[Embed(source="resources/images/texture_blackhole.png")]
		private var Asset:Class;
		private var bitmap:Bitmap = new Asset();
		private var material:BitmapMaterial  = new BitmapMaterial(bitmap.bitmapData, true);
		
		override public function doHitEvent(ball:Ball):void {
			
			ball.addEventListener(BallEvent.BALL_KILLED, onBallKilled);
			
			SpaceballsSounds.playBlackholeSound();
			
			ball.fallFromWorldAndKillMe(this);
		}
		
		override protected function init():void {
			setType(new FieldType(FieldType.BLACK_HOLE));
			
			material.smooth = true;
			
			var materials:MaterialsList = new MaterialsList(
			{
				all: material
			} );
			
			Materials = materials;
			
		}
		
		private function onBallKilled(event:BallEvent):void {
			
			var fem:FieldEventManager = FieldEventManager.getInstance();
			fem.blackHoleHit(event.getBall(),this)
		}
	}
}