package spaceballs.data
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import spaceballs.data.events.PlayfieldEvent;
	import spaceballs.data.fields.IField;
	import spaceballs.data.tools.Size;
	
	public class PlayfieldLoader extends EventDispatcher
	{
		
		private var _fileName:String;
		private var _playField:Playfield;
		private var _xml:XML;
		private var _isLoaded:Boolean;
		
		private var _stageSize:Size;
		
		public function PlayfieldLoader(stageSize:Size, fileName:String = null, xml:XML = null) {
			init(stageSize, fileName, xml);
		}
		
		private function init(stageSize:Size, fileName:String = null, xml:XML = null):void {
			_stageSize = stageSize;
			_fileName = fileName;
			_playField = null;
			_xml = xml;
			_isLoaded = false;
		}
		
		public function get PlayField():Playfield {
			return _playField;
		}
		
		public function get IsLoaded():Boolean {
			return _isLoaded;
		}
		
		public function load():void {
			if (_fileName) {
				var xmlLoader:URLLoader = new URLLoader();
				var myUrl:URLRequest = new URLRequest(_fileName);
				
				xmlLoader.load(myUrl);
				xmlLoader.addEventListener(Event.COMPLETE, onXmlLoadComplete);
			}			
			else if (_xml) {
				onXmlLoadComplete(null);
			}
			else {
				dispatchEvent(new PlayfieldEvent(PlayfieldEvent.PLAYFIELD_LOAD_FAILED,null,"No level source or xml given!"));
			}

		}
		
		private function onXmlLoadComplete(evt:Event):void {
			
			XML.ignoreComments = true;
			
			var levelXml:XML;
			
			if (evt) {			
				levelXml = XML(evt.target.data);
			}
			else {
				levelXml = _xml;	
			}
			
			var width:int = levelXml.@width;
			var height:int = levelXml.@height;			
			
			_playField = new Playfield(_stageSize, width, height);
			
			var fLoader:FieldLoader = new FieldLoader(_playField);
			
			for each (var element:XML in levelXml.elements()) {
				
				try {
					var field:IField = fLoader.load(element);
									
					if (field.X <= _playField.Width && field.Y < _playField.Height) {
						_playField.addField(field);
					}
				}
				catch (error:IOError) {
					trace (error.message);
				}			
			}			
			
			dispatchEvent(new PlayfieldEvent(PlayfieldEvent.PLAYFIELD_LOADED, _fileName));
			_isLoaded = true;	
		}
	}
}