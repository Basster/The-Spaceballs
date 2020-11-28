package spaceballs.data.fields {
	
	import org.papervision3d.objects.DisplayObject3D;
	
	import spaceballs.data.FieldType;
	import spaceballs.data.IXmlSerializable;
	import spaceballs.data.Playfield;
	import spaceballs.data.objects.Ball;
	
	/**
	 * Interface für alle Felder 
	 * @author Basster
	 * 
	 */	
	public interface IField	extends IXmlSerializable {
		function get3dObject():DisplayObject3D;
		function get Type():FieldType;
		function get Height():Number;
		function get WidthX():Number;
		function get WidthY():Number;		
		function get X():uint;
		function get Y():uint;
		function get Name():String;
		function set Name(name:String):void;
		function set ParentPlayfield(pf:Playfield):void;
		function get ParentPlayfield():Playfield;
		function doHitEvent(ball:Ball):void
		function doNearbyEvent(ball:Ball):void
	}
}