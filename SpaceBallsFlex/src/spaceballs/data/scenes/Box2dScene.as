package spaceballs.data.scenes {
	import flash.display.Sprite;
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Sphere;
	import spaceballs.data.ContactListener;
	import spaceballs.data.FieldType;
	import spaceballs.data.Playfield;
	import spaceballs.data.fields.IField;
	import spaceballs.data.objects.Ball;
	/**
	 * Die Scene der 2D Physikengine
	 * @author Basster
	 */
	public class Box2dScene extends Sprite {
		
		private static var _instance:Box2dScene;
		
		/**
		 * Liefert die Instanz der Box2dScene zurück
		 * @return 
		 */
		public static function getInstance():Box2dScene {
			return _instance;
		}
		
		/**
		 * Die Scene der 2D Physikengine
		 * @param w Breite der Szene
		 * @param h Höhe der Szene
		 * @param iterate
		 */
		public function Box2dScene(w:Number, h:Number, iterate:uint) {
			initVars(w, h, iterate);
			initB2World();
			initInstance();
		}
		
		private var _box2dBodies:Array;
		private var _brickSize:Number;
		
		private var _contactListener:ContactListener;
		
		private var _iterations:uint;
		private var _timestep:Number;
		
		private var _world:b2World;
		private var _worldHeight:Number;
		private var _worldScale:uint;
		
		private var _worldWidth:Number;
		
		// Da die Weltbegrenzungen noch in die Stage hineinragen, wird dies zu allen X- und Y- Komponenten hinzuaddiert
		private var _xOffset:Number;
		private var _yOffset:Number;
        
        /**
         * Liefert alle Kontakte und Kollisionen
         * @return 
         */
        public function get ContactStack():Array {
        	return _contactListener.contactStack;
        }
        
        /**
         * Liefert den DebugSprite der Physikengine, der die Kräfte und Objekte visualisiert.
         * @return 
         */
        public function get DebugDrawSprite():Sprite {
        	
            var debugDraw:b2DebugDraw = new b2DebugDraw();
            debugDraw.m_sprite = new Sprite();
            
            /** debug draw flags:
             *    DebugDraw.e_aabbBit, DebugDraw.e_centerOfMassBit, DebugDraw.e_coreShapeBit,
             *    DebugDraw.e_obbBit, DebugDraw.e_pairBit, b2DebugDraw.e_shapeBit,
             *    b2DebugDraw.e_jointBit
             **/
            debugDraw.SetFlags(b2DebugDraw.e_aabbBit |  b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit | b2DebugDraw.e_coreShapeBit);
 
            debugDraw.m_drawScale = _worldScale;
            debugDraw.m_fillAlpha = 0.25;
            debugDraw.m_lineThickness = 1;
            
            _world.SetDebugDraw(debugDraw);
            
            return debugDraw.m_sprite;
        }
        
        /**
         * Liefert die Physik "Welt".
         * @return 
         */
        public function get World():b2World {
        	return _world;
        }
		
		/**
		 * Baut aus allen WALL Feldern die Hindernisse in der Physikwelt zusammen.
		 * @param playField
		 */
		public function addFields(playField:Playfield):void {

			_brickSize = playField.BrickSize;
			var fields:Array = playField.Fields;
			
			for (var i:uint = 0; i < fields.length; i++) {
				var field:IField = fields[i] as IField;
				
				switch (field.Type.type) {
					case FieldType.WALL:
						addWall(field);
						break;
				}
			}
		}
		
		/**
		 * Erstellt einen Ball aus einem PV3D Objekt
		 * @param do3d
		 */
		public function createBall(do3d:DisplayObject3D):void {
			
			if (do3d is Ball) {
            	var radius:Number = getScaleValue(_brickSize / 2);
            
            	var myBall:Ball = do3d as Ball;
            
                var bodyDef:b2BodyDef = new b2BodyDef();
                bodyDef.allowSleep = true;
                bodyDef.position.Set(getScaleValue(myBall.extra.X * _brickSize + _xOffset) + radius ,getScaleValue(myBall.extra.Y * _brickSize + _yOffset) + radius);
                
                var body:b2Body = _world.CreateBody(bodyDef);
                 
                if (do3d is Sphere) {
                	var sphereShape:b2CircleDef = new b2CircleDef();	                	
                	sphereShape.radius = radius;
                	
                	// Die Dichte
                	sphereShape.density = 1;
                	// Die Reibung
	                sphereShape.friction = .7;
	                // Die Rückgabe (also wie stark die Kugel von etwas abprallt)
	                sphereShape.restitution = .3;	
	                
	                body.CreateShape(sphereShape);
                } 
                
                	                
                body.SetUserData(myBall);
                	                
                body.SetMassFromShapes();
                
                myBall.B2Body = body;
                	                
                _box2dBodies.push(body);
        	}
		}
		
		/**
         * Create box2d bodies from passed pv3d objects.
         */
        public function createBodiesFrom3dObjects(pv3dObjects:Array):void {
            _box2dBodies = new Array();
                        
            for(var i:uint = 0; i < pv3dObjects.length; i++) {
                var do3d:DisplayObject3D = pv3dObjects[i] as DisplayObject3D;
                
                createBall(do3d);
                
            }
        }
        
        /**
         * Step through Box2D simulation.
         * Called from render-loop.
         */
        public function step():void {
            
            _world.Step(_timestep, _iterations);
            
            //move the assigned pv3d object from the new box2d position
            for(var bb:b2Body = _world.GetBodyList(); bb; bb = bb.GetNext()) {

                if(bb.GetUserData() is DisplayObject3D) {
                    bb.GetUserData().x = bb.GetPosition().x * _worldScale +  bb.GetUserData().extra.XOffset - _xOffset; // - _worldWidth / 2;
                    bb.GetUserData().y = -bb.GetPosition().y * _worldScale - bb.GetUserData().extra.YOffset + _yOffset; // + _worldHeight / 2;
                                        
                    if (bb.GetUserData() is Sphere) {
                    	var distance:Number = Math.sqrt(bb.m_linearVelocity.x * bb.m_linearVelocity.x + bb.m_linearVelocity.y * bb.m_linearVelocity.y);
 
						var rotationAxis:Number3D = Number3D.cross(new Number3D(bb.m_linearVelocity.x, bb.m_linearVelocity.y, 0), new Number3D(0,0,1));
						rotationAxis.normalize();
 
						var rotationMatrix:Matrix3D = Matrix3D.rotationMatrix(rotationAxis.x, -rotationAxis.y, rotationAxis.z, distance/30);
 
						bb.m_userData.transform.calculateMultiply3x3(rotationMatrix, bb.m_userData.transform);

                    }
                    else {
                    	bb.GetUserData().rotationZ = -bb.GetAngle() * (180 / Math.PI);	
                    }
                }
            }
        }
		
		/**
		 * Erstellt eine Wand aus einem WALL-Field in der Physikwelt
		 * @param field
		 */
		private function addWall(field:IField):void {
			
			var wallShapeDef:b2PolygonDef = new b2PolygonDef();
			var wallBodyDef:b2BodyDef = new b2BodyDef();
			var wall:b2Body;
			
				
			var width:Number = field.WidthX * _brickSize / 2.0;
			
			var height:Number = field.WidthY * _brickSize / 2.0;
			
			var x:Number = width;
			x += (field.X as Number) * _brickSize;
			x += _xOffset;
			
			var y:Number = height;
			y += (field.Y as Number) * _brickSize;
			y += _yOffset;				
		
			wallShapeDef.SetAsBox(getScaleValue(width), getScaleValue(height));
			wallBodyDef.position.Set(getScaleValue(x), getScaleValue(y));
			wall = _world.CreateBody(wallBodyDef);
			wall.CreateShape(wallShapeDef);
		
			wall.SetMassFromShapes();			
		}
		
		/**
		 * Erstellt die Physikwelt-Begrenzung
		 */
		private function createB2Walls():void {
			var wallShapeDef:b2PolygonDef = new b2PolygonDef();
			var wallBodyDef:b2BodyDef = new b2BodyDef();
			var wall:b2Body;
			
			// left and right shape definition
			wallShapeDef.SetAsBox(100/_worldScale, (_worldHeight + 40) / _worldScale / 2);
			
			// left
			wallBodyDef.position.Set(-95/_worldScale, _worldHeight/_worldScale/2);
            wall = _world.CreateBody(wallBodyDef);
            wall.CreateShape(wallShapeDef);
			
			// Right
            wallBodyDef.position.Set((_worldWidth+95)/_worldScale, _worldHeight/_worldScale/2);
            wall = _world.CreateBody(wallBodyDef);
            wall.CreateShape(wallShapeDef);

            //Top and bottom shape definition
            wallShapeDef.SetAsBox((_worldWidth+40)/_worldScale/2, 100/_worldScale);
            
            // Top
            wallBodyDef.position.Set(_worldWidth/_worldScale/2, -95/_worldScale);
            wall = _world.CreateBody(wallBodyDef);
            wall.CreateShape(wallShapeDef);
            
            // Bottom
            wallBodyDef.position.Set(_worldWidth/_worldScale/2, (_worldHeight+95)/_worldScale);
            wall = _world.CreateBody(wallBodyDef);
            wall.CreateShape(wallShapeDef);
            
            wall.SetMassFromShapes();

		}
		
		/**
		 * Rechnet einen Pixelwert in einen Wert für die Physikwelt um
		 * @param n
		 * @return 
		 */
		private function getScaleValue(n:Number):Number {
			return n / _worldScale;
		}
		
		/**
		 * Initialisiert die Box2D Welt
		 */
		private function initB2World():void {
			var worldBounds:b2AABB = new b2AABB();
			worldBounds.lowerBound.Set(0,0);
			worldBounds.upperBound.Set(_worldWidth/_worldScale, _worldHeight/_worldScale);
			
			var gravity:b2Vec2 = new b2Vec2(0.0,0.0);
			var sleepMode:Boolean = false;
			
			_world = new b2World(worldBounds,gravity,sleepMode);
			
			_contactListener = new ContactListener();
			_world.SetContactListener(_contactListener);
		}
		
		/**
		 * initialisiert die statische Referenz auf die Box2D Szene
		 */
		private function initInstance():void {
			_instance = this;
		}
		
		public function clear():void {
			for(var bb:b2Body = _world.GetBodyList(); bb; bb = bb.GetNext()) {
				_world.DestroyBody(bb);
            }
		}
		
		/**
		 * initialisiert Membervariablen und Standardwerte
		 * @param w
		 * @param h
		 * @param iterate
		 */
		private function initVars(w:Number, h:Number, iterate:uint):void {
			_worldWidth = w;
			_worldHeight = h;
			_iterations = iterate;
			_timestep = 1/30;
			_worldScale = 30;
			
			_xOffset = 7;
			_yOffset = 7;
		}
	}
}