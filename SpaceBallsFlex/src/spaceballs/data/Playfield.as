package spaceballs.data {
	
	import org.papervision3d.objects.DisplayObject3D;
	
	import spaceballs.data.events.BallEvent;
	import spaceballs.data.fields.IField;
	import spaceballs.data.manage.FieldEventManager;
	import spaceballs.data.objects.*;
	import spaceballs.data.tools.Size;

	public class Playfield implements IXmlSerializable {
		
		// Anzahl der Felder in X-Richtung
		private var _width:uint;
		// Anzahl der Felder in Y-Richtung
		private var _height:uint;
		
		private var _stageSize:Size;
		private var _brickSize:Number;
		
		// TODO: Anzahl freundliche Bälle, gegnerische Bälle, Ziele
		private var _friendlyBallCount:uint;
		private var _enemyBallCount:uint;
		private var _goalCount:uint;
		private var _wormHoleInCounter:uint;
		private var _wormHoleOutCounter:uint;
				
		private var _fields:Array;
		private var _balls:Array;
		
		private var _field:DisplayObject3D;
		
		private var _fem:FieldEventManager;
		
		public function Playfield(stageSize:Size, width:uint = 100, height:uint = 100) {
			
			_stageSize = stageSize;
			
			_width = width;
			_height = height;
			
			init();			
		}
		
		private function init():void {
			
			_fields = new Array();
			_balls = new Array();
			
			_field = null;
			_brickSize = 0;
			_friendlyBallCount = 0;
			_enemyBallCount = 0;
			_goalCount = 0;
			_wormHoleInCounter = 1;
			_wormHoleOutCounter = 1;
		}
		
		public function setFEM(fem:FieldEventManager):void {
			_fem = fem;
			_fem.addEventListener(BallEvent.BALL_KILLED, onBallKilled);
		}
		
		private function onBallKilled(event:BallEvent):void {
			if (event.getBall() is Spaceball) {
				_friendlyBallCount--;
			}
			else {
				_enemyBallCount--;
			}
		}
		
		public function get FieldSize():Size {
			return new Size(_width, _height);
		}

		public function addField(field:IField):void {
			setFieldProperties(field);
			_fields.push(field);
		}
		
		private function setFieldProperties(field:IField):void {
			switch (field.Type.type) {
				case FieldType.WORM_HOLE_START:
					field.Name = "Wormhole_In_" + _wormHoleInCounter++;
					break;
				case FieldType.WORM_HOLE_END:
					field.Name = "Wormhole_Out_" + _wormHoleOutCounter++;
					break;
				case FieldType.END:
					_goalCount++;
					break;					
			}
		}
		
		public function get Width():uint {
			return _width;
		}
		
		public function get Height():uint {
			return _height;
		}
		
		public function get Fields():Array {
			return _fields;
		}
		
		public function get BrickSize():Number {
			if (_brickSize == 0) {
				calculateBrickSize();	
			}
			return _brickSize;
		}
		
		public function get Xml():XML {
			var level:XML = <Level />
			level.@width = _width;
			level.@height = _height;
			
			for (var i:int = 0; i < Fields.length; i++) {
				var field:IField = Fields[i];
				level.appendChild(field.Xml);
			}	
			
			return level;
		}
		
		private var _xOffset:Number = 0;
		private var _yOffset:Number = 0;
		
		public function get XOffset():Number {
			if (_xOffset == 0) {
				var width:Number = _width * BrickSize;
				_xOffset = (width / 2) * -1;
			}
			return _xOffset; 
		}
		
		public function get YOffset():Number {
			if (_yOffset == 0) {
				var height:Number = _height * BrickSize;
				_yOffset = (height / 2) * -1;
			}
			return _yOffset;
		}
		
		public function get Field():DisplayObject3D {
			if (_field == null) {
				_field = this.Cube;
			
				
				_field.x = XOffset;
				_field.y = -YOffset;
							
				_field.extra = {width:_width * BrickSize, height:_height * BrickSize};
			}
			
			return _field;
		}
		
		public function getField(x:uint, y:uint):IField {
			for each (var field:IField in Fields) {
				if (field.X == x && field.Y == y) {
					return field;
				}
			}
			throw new Error("Field not found! X/Y: " + x + "/" + y);
		}
		
		public function get Balls():Array {
			if (_balls.length == 0) {
				createBalls();
			}
			
			return _balls;
		}
		
		public function createSpaceball(radius:Number, startField:IField, xOffset:Number, yOffset:Number, scale:Number = 1):Spaceball {
			var ball:Spaceball = new Spaceball(radius);
			ball.name = "Spaceball_" + ++_friendlyBallCount;
			setBallProperties(ball,startField, xOffset, yOffset);
			ball.scale = scale;
			return ball;
		}
		
		public function createSpaceballEnemy(radius:Number, startField:IField, xOffset:Number, yOffset:Number, scale:Number = 1):SpaceballEnemy {
			var ball:SpaceballEnemy = new SpaceballEnemy(radius);
			ball.name = "SpaceballEnemy_" + ++_enemyBallCount;
			setBallProperties(ball,startField, xOffset, yOffset);
			ball.scale = scale;
			return ball;
		}
		
		private function setBallProperties(ball:Ball, startField:IField, xOffset:Number, yOffset:Number):void {
			ball.extra = {width:ball.Radius * 2, height:ball.Radius * 2, physics:true, X:startField.X, Y:startField.Y, XOffset:xOffset, YOffset:yOffset};
			ball.x = getFieldXCoord(startField) + xOffset;
			ball.y = getFieldYCoord(startField) - yOffset;
			ball.z = ball.Radius * -1;
		}
		
		private function createBalls():void {	
			
			for (var i:uint = 0; i < Fields.length; i++) {
				var myField:IField = Fields[i];
				var ball:Ball = null;
				
				switch (myField.Type.type) {
					case FieldType.START:
						ball = createSpaceball(BrickSize / 2, myField, XOffset, YOffset,0.01);
						break;
					case FieldType.START_ENEMY:
						ball = createSpaceballEnemy(BrickSize / 2, myField, XOffset, YOffset,0.01);
						break;						
				}
				
				if (ball != null) {					
					_balls.push(ball);
				}
			}
		}
		
		public function getFieldXCoord(myField:IField):Number {
			return myField.X * BrickSize + myField.WidthX * BrickSize / 2;
		}
		
		public function getFieldYCoord(myField:IField):Number {
			return (myField.Y * BrickSize + myField.WidthY * BrickSize / 2) * -1;
		}

		private function get Cube():DisplayObject3D {
			
			var field:DisplayObject3D = new DisplayObject3D();
			
			for (var i:int = 0; i < Fields.length; i++) {
				
				var myField:IField = Fields[i];
				
				var obj:DisplayObject3D = myField.get3dObject();

				obj.x = getFieldXCoord(myField);

				obj.y = getFieldYCoord(myField);
				
				obj.z = BrickSize * (myField.Height / 2);
				obj.z *= -1;		
				
				obj.extra = {X:myField.X, Y:myField.Y};		

				obj.scale = BrickSize;

				field.addChild(obj);
			}
						
			return field;
		}
		
		public function get FriendlyBallCount():uint {
			return _friendlyBallCount;
		}
		
		public function get EnemyBallCount():uint {
			return _enemyBallCount;
		}
		
		public function get GoalsCount():uint {
			return _goalCount;
		}
		
		private function calculateBrickSize():void {
			if (_stageSize.Width > _stageSize.Height) {				
				_brickSize = _stageSize.Height / _height;
			}
			else {
				_brickSize = _stageSize.Width / _width;
			}
			
			_brickSize = _brickSize / 100 * 97;			
		}
		
		public function set Xml(xml:XML):void {
			//doNothing;
		}
	}
}