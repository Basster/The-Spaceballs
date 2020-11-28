package spaceballs.data {

	import flash.errors.*;
	import flash.events.Event;
	import flash.utils.Timer;
	
	import spaceballs.Highscore;
	import spaceballs.SpaceballsAS3;
	import spaceballs.data.events.*;
	import spaceballs.data.manage.FieldEventManager;
	import spaceballs.data.manage.SpaceballsEffects;
	import spaceballs.data.objects.Ball;
	import spaceballs.data.objects.Countdown;
	import spaceballs.data.objects.Spaceball;
	import spaceballs.data.scenes.Box2dScene;
	import spaceballs.data.scenes.Pv3dScene;
	import spaceballs.data.tools.Size; // define our shapes
	
	
	public class SpaceBallsGame {
		private var _currentLevel:Number;
		private var _maxLevel:Number = 30;
		private var _levelTimer:Timer = new Timer(1000, 0);
		private var _highScore:Number;
		private var _privateLevel:Boolean;
		
		private var _levelXMLText:String;
		private var _levelResources:String = null;
		private var _xml:XML = null;
		
		private var _sBFlex:SpaceBallsFlex;
		private var _hSClass:Highscore;
		private var _sbAS3:SpaceballsAS3;
		private var _box2dScene:Box2dScene;
		private var _pv3dScene:Pv3dScene;
		
		private var _pf:Playfield;
		private var _pfl:PlayfieldLoader;
		private var _fem:FieldEventManager;
		
		private var _balls:uint;
		private var _goals:uint;
		private var _error:Boolean;
		private var _activate:Boolean;
		
		private var _goalsHit:Number;

		public function SpaceBallsGame(b2d:Box2dScene, pv3d:Pv3dScene, sbAS3:SpaceballsAS3) {
			_box2dScene = b2d;
			_pv3dScene = pv3d;
			_sbAS3 = sbAS3;
			_sBFlex = SpaceBallsFlex.getInstance();
		}
		
		/**
		 *	Erstellt das Spielfeld aus dem XML 
		 */
		public function createPlayField():void {
			_pfl = new PlayfieldLoader(new Size(_sbAS3.StageWidth, _sbAS3.StageHeight), _levelResources, _xml);
  			_pfl.addEventListener(PlayfieldEvent.PLAYFIELD_LOADED, onPlayFieldLoaded);
  			try {
   				_pfl.load();
  			} catch (error:IOError) {
   				// Tuwas
  			} catch (error:SecurityError) {
   				// Tuwas
   			}			
		}
		
		private function onPlayFieldLoaded(event:PlayfieldEvent):void {
			
			_pv3dScene.clear();
			_box2dScene.clear();
			
			trace("Playfield (" + event.LevelSrc + ") loaded...");
			
			_pf = _pfl.PlayField;
									
			_pv3dScene.addDisplayObject3D(_pf.Field);

			_box2dScene.addFields(_pf);
			addBalls();
			_box2dScene.createBodiesFrom3dObjects(_pv3dScene.ShapeDimensions);
			_box2dScene.step();
			
			_sbAS3.initEvents(_pf);
		
			checkError();
			_sBFlex.setHSandLevel();
			
			if(this._error == false) {
				startCountdown();
			}
			_error = false;
		}
		
		public function startCountdown():void {
			var countDown:Countdown = new Countdown();
			countDown.addEventListener("countdownFinished",onCountDownFinished);
			_pv3dScene.addChild(countDown);
			countDown.start();
			_activate = true;
		}
		
		private function onCountDownFinished(event:Event):void {
			var c:Countdown = event.currentTarget as Countdown;
			_pv3dScene.removeChild(c);
			_activate = false;
			_sBFlex.gamePause();
			_sBFlex.startTimer();
		}

		public function checkError():void {
			if(_pf.FriendlyBallCount == 0) {
				_error = true;
				_fem.endLevel(false);
				SpaceBallsFlex.getInstance().gamePause();
			} else if(_pf.GoalsCount == 0) {
				_error = true;
				_fem.endLevel(false);
				SpaceBallsFlex.getInstance().gamePause();
			} else if(_pf.GoalsCount > _pf.FriendlyBallCount) {
				_error = true;
				_fem.endLevel(false);
				SpaceBallsFlex.getInstance().gamePause();
			}
		}
		
		private function openError():void {
			if(_sBFlex._levelBuilder == true) {
				_sBFlex.currentState = 'levelbuilder'; 
				_sBFlex.fillLevelbuilder(); 
				_sBFlex.refillLevelbuilder()
				_sBFlex._levelBuilder = true;
			} else {
				_sBFlex.currentState = 'menu';
				_sBFlex._error = "You can't play this level!\nYou need balls, goals or both ...";
				_sBFlex.levelLoadfailureVisibility = true;
			}
			
			_sBFlex._currentLevel = 1;
			_sBFlex._highscore = 0;
			_sBFlex.privateLevel = false;
		}
		
		/**
		 * Addet alle Events die wichtig sind für den Spielablauf
		 */
		public function initEvents():void {
			_fem = FieldEventManager.getInstance();
			_balls = _pf.FriendlyBallCount;
			_goals = _pf.GoalsCount;
			_fem.addEventListener(CollisionEvent.SPACEBALLHITSENEMY,onBallHitsEnemy);
			_fem.addEventListener(FieldEvent.END_FIELD_HIT, onBallHitsEndField);
			_fem.addEventListener(FieldEvent.BLACKHOLE_HIT, onBlackHoleHit);
			_fem.addEventListener(FieldEvent.HOLE_HIT, onBlackHoleHit);
			_fem.addEventListener(FieldEvent.EMPTY_FIELD_HIT, onBallHitEmpty);
			_fem.addEventListener(GameEvent.LEVEL_FINISHED, onLevelFinished);
			_fem.addEventListener(GameEvent.LEVEL_LOST, onLevelLost);
		}
		
		private function onLevelFinished(event:GameEvent):void {			
			endLevel(true);
		}
		
		private function onLevelLost(event:GameEvent):void {
			endLevel(false);
		}
		
		private function onBallHitsEnemy(event:CollisionEvent):void {
			explodeBothBalls(event);
		}
		
		private function onBallHitEmpty(event:FieldEvent):void {
			if(event.ball is Spaceball) {
				_balls--;
				_hSClass.lostBall();
				if(_balls < _goals) {
					_fem.endLevel(false);
				}
			}
		}
		
		private function onBallsKilled(event:BallEvent):void {
			_balls--;
			_hSClass.lostBall();
			if(_balls < _goals) {
				_fem.endLevel(false);
			}
		}

		private function explodeBothBalls(event:CollisionEvent):void {
			var ball1:Ball = event.Ball1;
			var ball2:Ball = event.Ball2;
			var delay:Number = 1500;
			
			if (ball1 is Spaceball) {
				ball1.addEventListener(BallEvent.BALL_KILLED, onBallsKilled);
			}
			else {
				ball2.addEventListener(BallEvent.BALL_KILLED, onBallsKilled);
			}
			
			
			SpaceballsEffects.createExplosionEffect(ball1.Radius * 4, ball1.scene, ball1.x + ball1.Radius / 2, ball1.y + ball1.Radius / 2, ball1.Radius * -1,delay);
			ball1.killMe(delay);
			
			SpaceballsEffects.createExplosionEffect(ball2.Radius * 4, ball2.scene, ball2.x + ball2.Radius / 2, ball2.y + ball2.Radius / 2, ball2.Radius * -1,delay);
			ball2.killMe(delay);
		}
		
		private function onBallHitsEndField(event:FieldEvent):void {
			this._goalsHit++;
			if(_goals == _goalsHit) {
				_fem.endLevel(true);
			}
		}
		
		private function onBlackHoleHit(event:FieldEvent):void {
			if(event.ball is Spaceball) {
				_balls--;
				_hSClass.lostBall();
				if(_balls < _goals) {
					_fem.endLevel(false);
				}
			}
		}
		
		public function get CurrentPlayfield():Playfield {
			return _pf;
		}
		
		public function playFieldLoaded():Boolean {
			return _pfl.IsLoaded;
		}
		
		private function addBalls():void {
			for (var i:uint = 0; i < _pf.Balls.length; i++) {
				var ball:Ball = _pf.Balls[i];
				_pv3dScene.addDisplayObject3D(ball);
			}
		}
		
		/**
		 * Methode wird aufgerufen zum Starten eines Levels.
		 * Dabei wird entschieden ob es ein privates Level ist (aus dem Levelbuilder oder Hochgeladen)
		 * Oder ob man ein Spiel startet oder das nächste Level aufruft
		 */
		public function startLevel():void {
			_currentLevel = _sBFlex._currentLevel;
			_highScore = _sBFlex._highscore;
			
			_xml = null;
			_levelResources = null;
			_privateLevel = this._sBFlex.privateLevel;
			_goalsHit = 0;
			_hSClass = new Highscore(this);
			
			if(_currentLevel == 1) {
				if(_privateLevel == false) {
					_levelResources = "resources/levels/level_001.xml";
					_xml = null;
					_highScore = 0;
					_currentLevel = 1;
				} else if(_privateLevel == true) {
					_sBFlex._highscore = -1;
					_sBFlex._currentLevel = -1;
					_levelResources = null;
					_xml = new XML(_sBFlex.levelXMLText);
				}
			} else {
				startNextLevel();
			}
		}
		
		/**
		 * Legt den Pfad für das nächste Level fest
		 */
		public function startNextLevel():void {
			if(_currentLevel < 10) {
				_levelResources = "resources/levels/level_00"+_currentLevel+".xml";
			} else if(_currentLevel < 100) {
				_levelResources = "resources/levels/level_0"+_currentLevel+".xml";
			}
		}
		
		/**
		 * Beendet das Spiel
		 * Stopt die Timer, Berechnet den Highscore
		 * (True - Gewonnen) (False - Verloren)
		 * Ruft die passenden Screens der SpaceballFlex auf
		 * Und entscheidet ob der Spieler ein Platz ind en Top 15 bekommt wenn er
		 * das Spiel geschafft hat
		 */
		public function endLevel(finish:Boolean):void {
			_levelTimer.stop();
			_sBFlex.gamePause();
			
			if(finish == false) {
				if(this._error == true) {
					this.openError();
				} else {
					this.resetTimer();
					this._sBFlex.levelfailedVisibility = true;
				}
			} else if (finish == true) {
				if(_privateLevel == false) {
					_sBFlex._currentLevel++;
					generateHighScore();
					if(_sBFlex._currentLevel <= _maxLevel) {
						resetTimer();
						_sBFlex.levelcompletedVisibility = true;
					} else {
						var newHS:Boolean = checkHighscore();
						if(newHS == true) {
							_sBFlex.allcompletedhighVisibility = true;
							resetLevel();
						} else {
							_sBFlex.allcompletedVisibility = true;
							resetLevel();
						}
					}
				} else {
					if(_sBFlex._levelBuilder == true) {
						_sBFlex.owntestlevelcompletedVisibility = true;
						_sBFlex._currentLevel = 1;
						_sBFlex._highscore = 0;
						resetTimer();
					} else {
						_sBFlex.ownlevelcompletedVisibility = true;
						_sBFlex._currentLevel = 1;
						_sBFlex._highscore = 0;
						resetTimer();
					}
				}
			}
			this.resetTimer();
		}
		
		/**
		 * Berechnet den aktuellen Highscore
		 * @param: gestoppter Timer für das Level
		 * @param: alter Highscore
		 * Setzt nach dem Berechnen die Highscore-Klasse wieder auf 0 zum berechnen des nächsten Levels 
		 */
		private function generateHighScore():void {
			_hSClass.setTimer(_levelTimer);
			_sBFlex._highscore = _hSClass.getHighScore(_highScore);
			_hSClass.resetHighScore();
		}
		
		/**
		 * Überprüft ob der Spieler ein eintrag im Highscore bekommt oder nicht
		 */
		private function checkHighscore():Boolean {
			var hSXML:XML = _sBFlex.myXML;
			var last:Number = hSXML.position.length();
			var lP:String = hSXML.position.(@id==last).score;
			
			var highscoreURL:Array = lP.split(" ");
			var count:Number = Number(highscoreURL[0]);
			
			if(count < _highScore) {
				return true;
			} else {
				return false;
			}
		}
		
		public function sendHighscore(nN:String):void {
			_hSClass.createNewHS(nN, _highScore);
		}
	
		public function startTimer():void {
			_levelTimer.start();
		}
		
		public function stopTimer():void {
			_levelTimer.stop();
		}
		
		public function resetTimer():void {
			_sBFlex._timer = "00:00";
			_levelTimer.reset();
		}
		
		public function resetLevel():void {
			_sBFlex._currentLevel = 1;
			_sBFlex._highscore = 0;
			_goalsHit = 0;
			resetTimer();		
		}
		
		public function resetHighscore():void {
			_sBFlex._highscore = 0;
		}
		
		public function getTimer():Timer {
			return this._levelTimer;
		}
		
		public function get HighScore():Number {
			return _sBFlex._highscore;
		}
		
		public function get Activate():Boolean {
			return _activate;
		}
		
		public function setPrivateLevel(lvl:Boolean):void {
			this._privateLevel = lvl;
		}
		
		public function setLevelXML(lvl:String):void {
			_levelXMLText = lvl;	
		}
		
	}
}