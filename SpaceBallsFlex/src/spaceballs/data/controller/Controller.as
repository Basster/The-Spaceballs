package spaceballs.data.controller {
	
	public class Controller {
		
		public static var MOUSECONTROLLER:uint = 1;
		public static var WIICONTROLLER:uint = 2;
		public static var NOTEBOOKCONTROLLER:uint = 3; 
		
		public function Controller() {
		}

		public static function getController(i:uint):IController {
			var controller:IController;
			
			switch (i) {
				case MOUSECONTROLLER: 
					return new MouseController();
				case WIICONTROLLER:
					return new WiiMoteController();
				case NOTEBOOKCONTROLLER:
					return new NotebookController();
				default:
					throw new Error("Unknown Controllertype!");
			}			
		}

	}
}