package spaceballs.data.controller {
	import flash.events.*;
	
	import mx.core.Application;
	
	import org.wiiflash.Wiimote;
	import org.wiiflash.events.*;
	
	public class WiiMoteController implements IController {

		private var newRotX:Number=0;
		private var oldRotX:Number=0;
		private var newRotY:Number=0;
		private var oldRotY:Number=0;
		
		private var myWiimote:Wiimote = new Wiimote();
		
		private var _activateRumble:Boolean = true;
		
		public function initController(data:* = null):void {
					
			myWiimote.addEventListener( WiimoteEvent.UPDATE, onUpdated );
			myWiimote.addEventListener(ButtonEvent.A_PRESS, onAButtonPressed);	
			myWiimote.addEventListener(ButtonEvent.MINUS_PRESS, onMinusPressed);	
			myWiimote.addEventListener(ButtonEvent.HOME_PRESS, onHomePress);	
			myWiimote.addEventListener( IOErrorEvent.IO_ERROR, onWiimoteConnectError );
			myWiimote.connect();
		
		}
		
		public function removeController():void {	
			
			myWiimote.removeEventListener( WiimoteEvent.UPDATE, onUpdated );
			myWiimote.removeEventListener( IOErrorEvent.IO_ERROR, onWiimoteConnectError );
			myWiimote.removeEventListener(ButtonEvent.A_PRESS, onAButtonPressed);
			myWiimote.removeEventListener(ButtonEvent.A_RELEASE, onAButtonRelease);
			myWiimote.close();
			
		}
		
		private function onAButtonPressed(bEvent:ButtonEvent):void {
			myWiimote.removeEventListener(ButtonEvent.A_PRESS, onAButtonPressed);
			myWiimote.addEventListener(ButtonEvent.A_RELEASE, onAButtonRelease);
			
			// Wenn einer der folgenden Dialoge offen ist, kann mit einem Druck auf A der Dialog geschlossen werden.
			if (Application.application.levelcompletedVisibility) {
				Application.application.levelCompletedClick();
			} 
			else if (Application.application.levelfailedVisibility) {
				Application.application.levelFailedClick();
			}
			else if (Application.application.allcompletedVisibility) {
				Application.application.allLevelCompletedClick();
			}
			else {
				Application.application.gamePause();
			}
		}
		
		private function onMinusPressed(bEvent:ButtonEvent):void {
			_activateRumble = !_activateRumble;
		}
		
		private function onHomePress(bEvent:ButtonEvent):void {
			Application.application.onEscape();
		}
		
		private function onAButtonRelease(bEvent:ButtonEvent):void {
			myWiimote.removeEventListener(ButtonEvent.A_RELEASE, onAButtonRelease);
			myWiimote.addEventListener(ButtonEvent.A_PRESS, onAButtonPressed);
		}
		
		private function onWiimoteConnectError ( pEvent:IOErrorEvent ):void {
		}
		
 		private function onUpdated ( pEvt:WiimoteEvent ):void 
		{
			newRotX = myWiimote.roll; // Evtl. Geschwindigkeit anpassen
		    newRotY = myWiimote.pitch; // Evtl. Geschwindigkeit anpassen

		    newRotX *=  15;
			newRotY *= -15;
		}
		
		// Funktion aufrufen wenn der Ball gegen eine Wand
		// oder gegen einen Gegner prallt!
		public function rumble():void {
			if (_activateRumble) {
				myWiimote.rumbleTimeout = 50; // Evtl. Zeit anpassen
			}
		}
		
		public function get X():Number {
			return newRotX;
		}
		
		public function get Y():Number {
			return newRotY;
		}
	}
}