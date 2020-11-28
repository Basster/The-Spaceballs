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
	 * Ein Loch Feld. Dieses Feld ändert seinen Zustand, nachdem eine Kugel draufgerollt ist in ein ganz normales FLOOR-Feld
	 * @author Basster
	 */
	public class HoleField extends FieldBase {
		
		/**
		 * Ein Loch Feld. Dieses Feld ändert seinen Zustand, nachdem eine Kugel draufgerollt ist in ein ganz normales FLOOR-Feld
		 * @param x X-Koordinate
		 * @param y Y-Koordinate
		 */
		public function HoleField(x:int, y:int) {						
			super(x, y);
		}
		
		// Wenn noch keine Kugel reingerollt
		[Embed(source="resources/images/texture_hole-opened.png")]
		private var Asset1:Class;
		
		// Wenn Kugel reingerollt
		[Embed(source="resources/images/texture_hole-closed.png")]
		private var Asset2:Class;
		
		private var _isOpen:Boolean;
		
		private var _mat1:MaterialsList;
		private var _mat2:MaterialsList;
		private var bitmap1:Bitmap = new Asset1();
		private var bitmap2:Bitmap = new Asset2();
		private var material1:BitmapMaterial  = new BitmapMaterial(bitmap1.bitmapData, true);
		private var material2:BitmapMaterial  = new BitmapMaterial(bitmap2.bitmapData, true);
		
		override public function doHitEvent(ball:Ball):void {
			// Wenn das Feld noch offen ist, also noch keine Kugel reingerollt ist,
			// verschlingt es die erste Kugel, die drüber rollt und schließt sich.
			if (_isOpen) {
				ball.addEventListener(BallEvent.BALL_KILLED, onBallKilled);	
				SpaceballsSounds.playBlackholeSound();			
				ball.fallFromWorldAndKillMe(this);
			}
		}
		
		override protected function init():void {
			setType(new FieldType(FieldType.HOLE));
			
			_isOpen = true;
			
			material1.smooth = true;
			material2.smooth = true;
			
			_mat1 = new MaterialsList( { all: material1	} );
			
			_mat2 = new MaterialsList( { all: material2 } );
			
			Materials = _mat1;
		}
		
		/**
		 * Sobald der Ball tot ist, wird die Textur des Feldes geändert. 
		 * @param event
		 * 
		 */		
		private function onBallKilled(event:BallEvent):void {
			var fem:FieldEventManager = FieldEventManager.getInstance();
			fem.holeHit(event.getBall(),this);
			
			this.get3dObject().materials.getMaterialByName("all").bitmap = bitmap2.bitmapData;
			_isOpen = false;
		}
	}
}