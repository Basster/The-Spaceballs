package spaceballs {
	import flash.events.Event;
	import flash.net.FileFilter;
	
	public class LoadDataWithFileRef {
		import flash.net.FileReference;
		private var loadFileRef:FileReference;
		private var saveFileRef:FileReference;
		private var loadText:String = "empty";
		
		public function LoadDataWithFileRef() {
		}
		
		/**
		 * Öffnet ein Fieldialoge zum Hochladen der ausgewählten XML-Datei
		 */ 
		public function browseFile():void {
			loadFileRef = new FileReference();
			loadFileRef.addEventListener(Event.SELECT, onFileSelected);
			var filter:FileFilter = new FileFilter("XML Datei", "*.xml");
			
			try {
				loadFileRef.browse([filter]);					
			} catch(err:Error){
				var sBF:SpaceBallsFlex = SpaceBallsFlex.getInstance();
				sBF.currentState = 'menu';
				sBF.loadlevelfailureVisibility = true;
				trace(err);
			}				
		}
		
		/**
		 * Läd die ausgewählte Datei in den Speicher
		 */ 
		private function onFileSelected(event:Event):void {
			loadFileRef.addEventListener(Event.COMPLETE, onComplete);
			//this is where we load the file into memory
			loadFileRef.load();
			
		}
		
		private function onComplete(evt:Event):void {
			var sBF:SpaceBallsFlex = SpaceBallsFlex.getInstance();
			loadText = String(loadFileRef.data);
			sBF.setLevelXMLText(loadText);
			sBF.currentState = 'game';
		}
	
		public function getXMLText():String {
			return loadText;
		}

		/**
		 * Speichert das Level aus dem Levelbuilder
		 */
		//this method will save the data to file selected
		public function saveFile(level:String):void {
			saveFileRef = new FileReference();
			var name:String = "Own_Level.xml";
			saveFileRef.addEventListener(Event.SELECT, onSaveFileSelected);
			//this will throw a window for user to select the location
			//and file name to save. Second argument is the default name
			saveFileRef.save(level, name);
		}
			
		public function onSaveFileSelected(event:Event):void {
			saveFileRef.addEventListener(Event.COMPLETE, onSaveComplete);
		}
		
		public function onSaveComplete(event:Event):void {
			saveFileRef.removeEventListener(Event.SELECT, onSaveFileSelected);
			saveFileRef.removeEventListener(Event.COMPLETE, onSaveComplete);
		}
	}
}