package spaceballs.data.scenes {
	import org.papervision3d.core.clipping.FrustumClipping;
	import org.papervision3d.core.proto.CameraObject3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.view.BasicView;
	
	import spaceballs.data.FieldLight;
	/**
	 * Die Szene der Papervision3D Welt
	 * @author Basster
	 */
	public class Pv3dScene extends BasicView {
		
		private static var _instance:Pv3dScene;
		
		/**
		 * Liefert die statische Instanz der Klasse
		 * @return 
		 * @throws Error
		 */
		public static function getInstance():Pv3dScene {
			if (_instance) {
					return _instance;
				}
				else {
					throw new Error("Pv3dScene is not initialized!");
				}
		}
		
		/**
		 * Erstellt die Szene der Papervision3D Welt
		 * @param w
		 * @param h
		 */
		public function Pv3dScene(w:Number, h:Number) {
			init();					
			initStage(w,h);
			init3d();
			setupScene();
			startRendering();
		}

		private var _light:PointLight3D;
		
		private var _shapeDimensions:Array;
		private var _stageHeight:Number;
		
		private var _stageWidth:Number;
		
		/**
		 * Liefert die Kamera der Szene
		 * @return 
		 */
		public function get Camera():CameraObject3D {
			return camera;
		}
		
		/**
		 * Liefert alle nachträglich hinzugefügten Objekte (wie Bälle)
		 * @return 
		 */
		public function get ShapeDimensions():Array {
			return _shapeDimensions;
		}
		
		/**
		 * Fügt ein DisplayObject3D zur Szene hinzu und speichert es zusätzlich, um in der Physikengine erstellt zu werden.
		 * @param obj
		 */
		public function addDisplayObject3D(obj:DisplayObject3D):void {
			_shapeDimensions.push(obj);
			scene.addChild(obj);
		}
		
		/**
		 * Resettet die Kamera auf die ursprünglichen Werte
		 */
		public function cameraReset():void {
			
			camera.x = 0;
			camera.y = 0;
			viewport.y = -60;
			camera.z = -375;
		}
		
		/**
         * Camera hovering.
         * Debug Methode für Kameraaktionen im EnterFrame
         */
        public function updateCamera(field:DisplayObject3D = null):void {
       	        	
        	//_camera.rotationZ += 0.5;
        	
        	//_camera.moveForward(0.5)
        		
    		/* Endgültige Kamerabewegung */
    		/*
            _camera.x = _controller.X;
            _camera.y = _controller.Y;
            */
            //_camera.x -= (_camera.x - _viewport.containerSprite.mouseX * 5) / 200;
            //_camera.y -= (_camera.y - _viewport.containerSprite.mouseY * 5) / 200;
        }

		/**
		 * Initialisierung der Membervariablen
		 */
		private function init():void {
			_shapeDimensions = new Array();
			_instance = this;
		}
		
		/**
		 * Initialisiert die 3D Welt
		 */
		private function init3d():void {
			viewport.interactive = true;
			//renderer = new QuadrantRenderEngine(QuadrantRenderEngine.QUAD_SPLIT_FILTER); 
			//renderer.clipping = new FrustumClipping(FrustumClipping.FAR);

		}
		
		public function clear():void {
			for each (var obj:DisplayObject3D in scene.children) {
				scene.removeChild(obj);
				obj = null;
			}
		}
		
		/**
		 * Initialisiert die 3D Bühne
		 * @param w
		 * @param h
		 */
		private function initStage(w:Number, h:Number):void {
			_stageWidth = w;
			_stageHeight = h;
		}
		
		/**
		 * Fügt ein Licht ein und initialisiert die Kameraposition 
		 */
		private function setupScene():void {
			_light = FieldLight.getInstance();
			_light.x = 1000;
			_light.y = 1000;
			_light.z = -1000;
			
			scene.addChild(_light);
			
			cameraReset();						
		}
	}
}