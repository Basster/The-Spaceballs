package spaceballs {
	import flash.events.*;
	import flash.net.*;
	import flash.utils.Timer;
	
	import spaceballs.data.SpaceBallsGame;
	
	public class Highscore {
		private var _balls:Number = 5;
		private var _highscore:Number;
		private var _time:Number;
		private var _ballMulti:Number;
		private var _max:Number = 1665;
		private var _game:SpaceBallsGame;
			
		/**
		 * HIGHSCORE
		 * Berechnet den Highscore und versendet neu Eintragungen in diesem
		 * 
		 * Maximale Punktzahl pro Level 3333 (Disigngründe)
		 * Man hat pro Level 5 Bälle zur Verfügung diese werden auch nach einem Level nicht bestanden
		 * nicht zurück gesetzt erst bei einem neuen Level
		 * Jeden Ball den man verliert verliert man einen Multiplikator um 0.2 hat man alle 5 Bälle noch
		 * so ist der Multiplikator 2.0 und bei 0 Bällen 1.0
		 * 
		 * Nun möchte man das Level so schnell wie möglich beenden. Da jede Sekunde 10 Punkte vom Zeit-Highscore
		 * abgezogen werden (dieser ist 1665)
		 * 
		 * Hat man nun ein Level in 30 Sekunden und mit 5 Bällen geschafft so wird für die 30 Sekunden Dauer
		 * 300 Punkte abgezogen von den 1665 und diese 1365 werden dann mit dem Ballmultiplikator (in dem Beispiel
		 * 2.0) Multipliziert also: 1365 * 2 = 2730 und dieser neue Highscore wird zu dem schon bestehendem dazu
		 * addiert.
		 */	
				
		public function Highscore(game:SpaceBallsGame) {
			_game = game;
		}
		
		public function lostBall():void {
			if(_balls >= 1) {
				_balls--;
			}
		}
		
		public function setTimer(timer:Timer):void {
			var time:String = timer.currentCount.toString();
			_time = Number(time);
		}
		
		public function resetHighScore():void {
			_time = 0;
			_balls = 5;
			_ballMulti = 0;
			_highscore = 0;
			_max = 1665;
		}
		
		public function getHighScore(oldHS:Number):Number {
			ballMultiplicator();
			
			_highscore = (_max - (_time * 10)) * _ballMulti;
			if(_highscore < 0) {
				_highscore = 0;
			}
			_highscore = _highscore + oldHS;
			
			return _highscore;
		}
		
		private function ballMultiplicator():void {
			if(_balls < 1) {
				_ballMulti = 1;
			} else if(_balls == 1) {
				_ballMulti = 1.2;
			} else if(_balls == 2) {
				_ballMulti = 1.4;
			} else if(_balls == 3) {
				_ballMulti = 1.6;
			} else if(_balls == 4) {
				_ballMulti = 1.8;
			} else if(_balls == 5) {
				_ballMulti = 2;
			}
		} 
		
		/**
		 * Die Daten des Spielers werden an die URL geschickt und dort sortiert und in ein XML eingetragen
		 */
		public function createNewHS(nick:String, eHS:Number):void {
			var variables:URLVariables = new URLVariables();
			var request:URLRequest = new URLRequest();
			var loader:URLLoader = new URLLoader();
	
			// Setzt die Daten die an das PHP Script übergeben werden sollen
			variables.muh = "abcdef";
			variables.name = nick;
			variables.score = eHS;
			
			request.url = "http://www.basster.de/spaceballs/spaceballs_highscores.php";
			request.method = URLRequestMethod.POST;
       		request.data = variables;
			
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			loader.load(request);
			loader.addEventListener (Event.COMPLETE, completeHandler);
		}
		
		/**
		 * Der Highscore der Runde im Spaceballgame wird resetet 
		 */
		private function completeHandler(event:Event):void { 
    		onCreationComplete();
        	_game.resetHighscore();
		} 
		
		/**
		 * Man läd sich die aktuelle XML-Datei herrunter
		 */
	 	private function onCreationComplete():void {
		 	var myLoader:URLLoader = new URLLoader();
			var myURL:URLRequest = new URLRequest("http://www.basster.de/spaceballs/spaceballs_highscores.php");
			
			myLoader.addEventListener(Event.COMPLETE, onLoadComplete);
			myLoader.load(myURL);
		}
		
		/**
		 * Aktualisiert den Highscore in der SpaceBallFlex und zeigt diesen auch gleich an
		 */	
		private function onLoadComplete(evt:Event):void {
			var sBFlex:SpaceBallsFlex = SpaceBallsFlex.getInstance();
			
			XML.ignoreComments = true;
			XML.ignoreWhitespace = true;
			var myXML:XML = new XML(evt.target.data);
			
			sBFlex.myXML = myXML;
			sBFlex.currentState = 'menu'; 
        	sBFlex.allcompletedhighVisibility = false; 
        	sBFlex.highscoresVisibility = true;
		}
		
	}
}