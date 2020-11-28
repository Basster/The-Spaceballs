package spaceballs.data.controller {
	
	public interface IController {
		function get X():Number;
		function get Y():Number;
		function initController(data:* = null):void;
		function removeController():void;
	}
}