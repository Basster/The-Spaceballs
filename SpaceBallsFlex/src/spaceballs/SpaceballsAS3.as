package spaceballs {
	
	import Box2D.Dynamics.b2Body;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	
	import org.papervision3d.core.proto.CameraObject3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Sphere;
	
	import spaceballs.data.Playfield;
	import spaceballs.data.SpaceBallsGame;
	import spaceballs.data.controller.Controller;
	import spaceballs.data.controller.IController;
	import spaceballs.data.controller.MouseController;
	import spaceballs.data.controller.WiiMoteController;
	import spaceballs.data.events.CollisionEvent;
	import spaceballs.data.events.FieldEvent;
	import spaceballs.data.manage.FieldEventManager;
	import spaceballs.data.manage.SpaceballsSounds;
	import spaceballs.data.objects.Ball;
	import spaceballs.data.scenes.Box2dScene;
	import spaceballs.data.scenes.Pv3dScene; // define our shapes

	// 1 meter = 30 pixels

	public class SpaceballsAS3 extends UIComponent {
		
		private const MAX_CONTROLLER_VALUE:Number = 7;
		
		// MXML Component Properties
		private var currentController:IController = new MouseController();
		public var currentSoundState:Boolean = true; // Sound on/off
		public var currentGameState:Boolean = false; // Pause
		
		private var isDown:Boolean = false;
		private var isUp:Boolean = false;
		private var isLeft:Boolean = false;
		private var isRight:Boolean = false;
		
		private var moveDown:Boolean = false;
		private var moveUp:Boolean = false;
		private var moveLeft:Boolean = false;
		private var moveRight:Boolean = false;
		
		private var zoomIn:Boolean = false;
		private var zoomOut:Boolean = false;
		
		private var cameraPitch:Number = 90;
		private var cameraYaw:Number = 270;
		private var isOrbiting:Boolean = false;
		private var previousMouseX:Number;
		private var previousMouseY:Number;
		
		private var _fieldXAngle:uint = 45;
		
		private var _stageWidth:Number;
		private var _stageHeight:Number;
		
		//private var _pfl:PlayfieldLoader;
		private var _pf:Playfield;
		
		private var _ball:DisplayObject3D;
		
		private var _pv3dScene:Pv3dScene;
		private var _box2dScene:Box2dScene;
		
		private var _fem:FieldEventManager;
		
		public static const BOX2D_ITERATIONS:uint = 10;
		private var _box2dDebug:Sprite;
		
		private var _debugField:TextField;
		
		private var _game:SpaceBallsGame;	
		private var _levelXMLText:String;
		private var _privateLevel:Boolean;
		
		public function start():void {
			
			invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
            
			stageSetup();
			
			init3d();
			initBox2d();
			
			initGame();
			
			setupText();
			
			setupDataForGame();
			
			_game.createPlayField();
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
		}
		
		private function setupDataForGame():void {
			_game.setPrivateLevel(_privateLevel);
			_game.setLevelXML(_levelXMLText);
			_game.startLevel();	
		}
		
		public function get SpaceballsGame():SpaceBallsGame {
			return _game;
		}
		
		private function initGame():void {
			_game = new SpaceBallsGame(_box2dScene, _pv3dScene, this);
		}
		
		public function changeController(i:uint):void {
			try {
				currentController.removeController();
				currentController = Controller.getController(i);
				currentController.initController(stage);
			}
			catch (e:Error) {
				trace(e.message);
			}
		}
		
		override protected function updateDisplayList(
            unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            start();
        }
		
		private function setupText():void {
			_debugField = new TextField();
			_debugField.autoSize = TextFieldAutoSize.LEFT;
			_debugField.multiline = true;
			_debugField.textColor = 0xFFFFFF;
			_debugField.x = 20;
			_debugField.y = 10;
			_debugField.text = "";
			_debugField.visible = false;
			
			addChild(_debugField);
		}
		
		public function get StageHeight():Number {
			return _stageHeight;
		}
		
		public function get StageWidth():Number {
			return _stageWidth;
		}
		
		/**
		 * Setup Stage
		 */ 
		private function stageSetup():void {
			_stageWidth = 750;
			_stageHeight = 480;
		}
		
		/**
		 * Papervision3D Setup
		 */ 
		public function init3d():void {
			if (_pv3dScene) {
				_pv3dScene.clear();
				removeChild(_pv3dScene);
				_pv3dScene = null;
			}
			_pv3dScene = new Pv3dScene(_stageWidth, _stageHeight);
			addChild(_pv3dScene);
		}
		
		private function get Camera():CameraObject3D {
			return _pv3dScene.Camera;
		}
		
		/**
		 * Setup Box2D
		 */ 
		public function initBox2d():void {
			if (_box2dScene && _box2dDebug) {
				_box2dScene.clear()
				
				removeChild(_box2dScene);
				removeChild(_box2dDebug);
				
				_box2dScene = null;
				_box2dDebug = null;
			}
			
			_box2dScene = new Box2dScene(_stageWidth, _stageHeight, BOX2D_ITERATIONS);
			addChild(_box2dScene);
			
			_box2dDebug = _box2dScene.DebugDrawSprite;
			_box2dDebug.visible = false;
			addChild(_box2dDebug);			 
		}
		
		public function ballsSleep(sleep:Boolean = true):void {
			for(var bb:b2Body = _box2dScene.World.GetBodyList(); bb; bb = bb.GetNext()) {
					if (bb.GetUserData() is Sphere) {
						if (sleep) {
							bb.PutToSleep();
							_game.stopTimer();
						}
						else {
							bb.WakeUp();
							_game.startTimer();							
						}
					}
				}
		}
		
		public function get stageWidth():Number {
			return _stageWidth;
		}
		
		public function get stageHeight():Number {
			return _stageHeight;
		}
		
		public function set SpaceballsGame(s:SpaceBallsGame):void {
			this._game = s;
		}
		
		public function setLevelXML(lvl:String):void {
			this._levelXMLText = lvl;
		}
		
		public function setPrivateLevel(priv:Boolean):void {
			this._privateLevel = priv;
		}
		
		public function initEvents(pf:Playfield):void {
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			_fem = FieldEventManager.initialize(pf,_box2dScene);
			_fem.addEventListener(CollisionEvent.BALLHITSWALL, onBallHitsWall);
			_fem.addEventListener(CollisionEvent.SPACEBALLHITSENEMY,onBallHitsEnemy);
			_fem.addEventListener(FieldEvent.ALL_GOALS_HIT, onBallHitsEndField);
			_game.initEvents();
		}
		
		private function onBallHitsEndField(event:FieldEvent):void {
			trace("Ende!");
		}
		
		private function onBallHitsEnemy(event:CollisionEvent):void {
			SpaceballsSounds.playExplosionSound();
		}
		
		private function onBallHitsWall(event:CollisionEvent):void {
			SpaceballsSounds.playWallSound();
			
			if (currentController is WiiMoteController) {
				var c:WiiMoteController = currentController as WiiMoteController;
				c.rumble();
			}
		}
		
		private function onEnterFrame(event:Event):void {			
			
			if (_game.playFieldLoaded() && currentGameState) {
				
				_pv3dScene.cameraReset();
				
				var xCon:Number = currentController.X;
				var yCon:Number = currentController.Y;
				
				_box2dScene.World.m_gravity.x = xCon;
				Camera.moveLeft(xCon);	
				
				_box2dScene.World.m_gravity.y = yCon;
				Camera.moveUp(yCon);			
				
				_fem.getBallCoords();
				_fem.handleCollisions();
				_fem.handleFieldEvents();
				
				updateDebugText();
				
				// nur zu Debug Zwecken
				_pv3dScene.updateCamera();
				// Physikengine Berechnung seit dem letzten Frame
				_box2dScene.step();
			}	
		}
		
		private function orbitCamLR(degrees:Number = 0):void {
			
			Camera.target = DisplayObject3D.ZERO;
			Camera.orbit(1,0,true,_pf.Field);
			
		}
		
		private function updateDebugText():void {
			_debugField.text = "Gravity (x/y): " + _box2dScene.World.m_gravity.x + "/" + _box2dScene.World.m_gravity.y + "\n";
			_debugField.appendText("Camera (x/y/z): " + Camera.x + "/" + Camera.y + "/" + Camera.z + "\n");
			_debugField.appendText("Camera Target: " + Camera.target + "\n");
			_debugField.appendText("Pause: " + currentGameState.toString() + "\n");
			if (_game.playFieldLoaded()) {
				_debugField.appendText("Field (x/y/z): " + _game.CurrentPlayfield.Field.x + "/" + _game.CurrentPlayfield.Field.y + "/" + _game.CurrentPlayfield.Field.z + "\n");
				
				for(var bb:b2Body = _box2dScene.World.GetBodyList(); bb; bb = bb.GetNext()) {
					if (bb.GetUserData() is Ball) {
						var sphere:Ball = bb.GetUserData();
						
						_debugField.appendText(sphere.name + ": (x/y)" + sphere.FieldX + "/" + sphere.FieldY + "\n");
						_debugField.appendText("Box2D pos: " + sphere.B2Body.GetPosition().x + " / " + sphere.B2Body.GetPosition().y + "\n");
					}
				}
			}
		}
        
        private function toggleDebugDraw():void {
        	if(_box2dDebug.visible) {
                _box2dDebug.visible = false;                
            } else {
                _box2dDebug.visible = true;
            }
            _debugField.visible = _box2dDebug.visible;
        }
		
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			trace(event.keyCode);
			switch(event.keyCode)
			{
				/* Backspace for debug */
				case Keyboard.BACKSPACE:
					toggleDebugDraw();
					break;
				/* Pp = Pause*/	
				case 80:
					if(SpaceBallsFlex.getInstance().instructionsVisibility == false) {
						SpaceBallsFlex.getInstance().gamePause();
					}
					break;
				case Keyboard.F1:
					SpaceBallsFlex.getInstance().instructionsVisibility = !SpaceBallsFlex.getInstance().instructionsVisibility;
					if(SpaceBallsFlex.getInstance().instructionsVisibility == true && SpaceBallsFlex.getInstance().pauseGameState == true) {
						SpaceBallsFlex.getInstance().gamePause();
					} else if(SpaceBallsFlex.getInstance().pauseGameState == false && SpaceBallsFlex.getInstance().instructionsVisibility == false) {
						SpaceBallsFlex.getInstance().gamePause();
					} else {
						SpaceBallsFlex.getInstance().pauseGameState == false;
					}
					break;
				case Keyboard.ESCAPE:
					Application.application.onEscape();
					break;
				case 83:
					SpaceBallsFlex.getInstance().playSound();
					break;
			}
		}
		
		private function toggleXView():void {
			
			//orbitCamLR();
			_pv3dScene.cameraReset();
			
			switch (_fieldXAngle) {
				case 45:
					_fieldXAngle = 0;
					break;
				case 0:
					_fieldXAngle = 45;
					break;
			}
			
		}
 
		 override protected function keyUpHandler(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.DOWN:
					isDown = false;
					break;
				case Keyboard.UP:
					isUp = false;
					break;
				case Keyboard.LEFT:
					isLeft = false;
					break;
				case Keyboard.RIGHT:
					isRight = false;
					break;
				/* Ww */	
				case 119:
				case  87:
					moveUp = false;
					break;
				/* Aa */
				case 65:
				case 97:
					moveLeft = false;
					break;
				/* Ss */
				case  83:
				case 115:
					moveDown = false;
					break;
				/* Dd */
				case 100:
				case  68:
					moveRight = false;
					break;
				case Keyboard.NUMPAD_ADD:
					zoomIn = false;
					break;
				case Keyboard.NUMPAD_SUBTRACT:
					zoomOut = false;
					break;
			}
		}
	}
}
