package spaceballs.data.controller
{
	import flash.events.*;
	
	public class NotebookController implements IController
	{
		private var active:Boolean = false;
		private var newRotX:Number = 0;
		private var newRotY:Number = 0;
		private var oldRotX:Number = 0;
		private var oldRotY:Number = 0;
		
		public function initController(data:* = null):void
		{
			if (active == false) {
				//TODO: Eventlistener auf Notebook hinzufügen
				active = true;
			}
		}
		
		public function removeController():void
		{	
			if (active == true) {
				//TODO: Eventlistener auf Notebook entfernen
				active = false;
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