package spaceballs.data.controller
{
	import flash.display.Stage;
	import flash.events.*;
	import flash.geom.Point;
	
	import mx.managers.CursorManager;
	
	public class MouseController implements IController
	{
		private var rotX:Number=0;
		private var rotY:Number=0;
		
		private var _stage:Stage;
		
		private var _clickOrigin:Point;

				
		public function initController(data:* = null):void {
			if (data is Stage) {
				_stage = data as Stage;		
				
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				
			}
		}
		
		public function removeController():void {	
			if (_stage) {
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);				
			}
		}
		
		public function get X():Number {
			return rotX;
		}
		
		public function get Y():Number {
			return rotY;
		}
		
		private function onMouseMove(event:MouseEvent):void {

			rotX = _stage.mouseX - _stage.width / 2;
			rotY = _stage.mouseY - _stage.height / 2;
			
			rotX /= 8;
			rotY /= 8;
			
			//trace("X: " + X + ", Y: " + Y);
		}
	}
}