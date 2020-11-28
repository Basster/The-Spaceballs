package spaceballs.data.fields {
	import org.papervision3d.materials.utils.MaterialsList;
	
	import spaceballs.data.FieldType;
	import spaceballs.data.events.BallEvent;
	import spaceballs.data.manage.FieldEventManager;
	import spaceballs.data.manage.SpaceballsSounds;
	import spaceballs.data.objects.Ball;
	/**
	 * Ein leeres Feld. Also wirklich leer... der weite Raum quasi...
	 * @author Basster
	 */
	public class EmptyField extends FieldBase {
		
		/**
		 * Ein leeres Feld. Also wirklich leer... der weite Raum quasi.. 
		 * @param x Die X-Koordinate
		 * @param y Die Y-Koordinate
		 * @param width Breite
		 * @param length Länge
		 */
		public function EmptyField(x:int, y:int, width:uint, length:uint) {
			super(x, y, width, length);
		}
		
		override public function doHitEvent(ball:Ball):void {
			
			ball.addEventListener(BallEvent.BALL_KILLED, onBallKilled);
			
			SpaceballsSounds.playBlackholeSound();
			
			ball.fallFromWorldAndKillMe(this);
		}
		
		override protected function init():void {
			setType(new FieldType(FieldType.EMPTY));
			
			var materials:MaterialsList = new MaterialsList(
			{
				all: null
			} );
			
			Materials = materials;
		}
		
		private function onBallKilled(event:BallEvent):void {
			
			var fem:FieldEventManager = FieldEventManager.getInstance();
			fem.emptyFieldHit(event.getBall(),this)
		}
	}
}