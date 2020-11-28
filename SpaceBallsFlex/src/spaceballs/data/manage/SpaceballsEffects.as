package spaceballs.data.manage {
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.papervision3d.core.proto.SceneObject3D;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.objects.primitives.Plane;
	
	public class SpaceballsEffects {
		
		/**
		 * Erstellt eine Plane mit einem Wurmloch Effekt drauf
		 * @param size Die Kantenlänge der Plane. Die Plane ist quadratisch!
		 * @param scene Die Scene3D, in dem die Plane erstellt werden soll.
		 * @param x Die X-Koordinate der Plane
		 * @param y Die Y-Koordinate der Plane
		 * @param z Die Z-Koordinate der Plane
		 * @param removeAfterDelay Die Plane verschwindet automatisch nach der angegebenen Zeit in ms, wenn größer 0!
		 * @return Die erzeugte Plane 
		 * 
		 */		
		public static function createWormholeEffect(size:Number, scene:SceneObject3D, x:Number, y:Number, z:Number, removeAfterDelay:Number = 0):Plane {
			
			[Embed(source="resources/effects/wurmloch.swf")]
			var WormholeEfx:Class;
			var wormMC:MovieClip = new WormholeEfx() as MovieClip;
			
			var wormEfxPlane:Plane = createEffectPlane(wormMC, size, scene, x, y, z);
			
			scene.addChild(wormEfxPlane);
			SpaceballsSounds.playWormholeSound();
			
			SpaceballsEffects.removeAfterDelay(wormEfxPlane, scene, removeAfterDelay);
			
			return wormEfxPlane;
		}
		
		/**
		 * Erstellt eine Plane mit einem Explosionseffekt drauf.
		 * @param size Die Kantenlänge der Plane. Die Plane ist quadratisch!
		 * @param scene Die Scene3D, in dem die Plane erstellt werden soll.
		 * @param x Die X-Koordinate der Plane
		 * @param y Die Y-Koordinate der Plane
		 * @param z Die Z-Koordinate der Plane
		 * @param removeAfterDelay Die Plane verschwindet automatisch nach der angegebenen Zeit in ms, wenn größer 0!
		 * @return Die erzeugte Plane 
		 * 
		 */ 		
		public static function createExplosionEffect(size:Number, scene:SceneObject3D, x:Number, y:Number, z:Number, removeAfterDelay:Number = 0):Plane {
			[Embed(source="resources/effects/explosion.swf")]
			var ExplosionEfx:Class;
			var explosionMC:MovieClip = new ExplosionEfx() as MovieClip;
			
			var explosionEfxPlane:Plane = createEffectPlane(explosionMC, size, scene, x, y, z);
			
			scene.addChild(explosionEfxPlane);
			SpaceballsSounds.playExplosionSound();
			
			SpaceballsEffects.removeAfterDelay(explosionEfxPlane, scene, removeAfterDelay);
			
			return explosionEfxPlane;
		}
		
		/**
		 * Erstellt einen Timer um die Plane nach einer bestimmten Zeit wieder aus der Szene zu entfernen. 
		 * @param plane Die Effektplane
		 * @param scene Die Szene
		 * @param delay Die Zeit in ms, nach der die Plane entfernt werden soll.
		 * 
		 */		
		private static function removeAfterDelay(plane:Plane, scene:SceneObject3D, delay:Number):void {
			if (delay > 0) {
				// Timer erstellen, um die Explosion automatisch nach 2,5 Sek wieder zu entfernen.
				var timer:Timer = new Timer(delay,1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(event:TimerEvent):void {
					scene.removeChild(plane);
				});
				timer.start();
			}
		}
		
		/**
		 * Erstellt eine Plane mit einem MovieClip um einen Effekt darzustellen 
		 * @param mc Der MovieClip, der auf der Plane als Textur benutzt wird.
		 * @param size Die Kantenlänge der Plane. Die Plane ist quadratisch!
		 * @param scene Die Scene3D, in dem die Plane erstellt werden soll.
		 * @param x Die X-Koordinate der Plane
		 * @param y Die Y-Koordinate der Plane
		 * @param z Die Z-Koordinate der Plane
		 * @return Die erzeugte Plane
		 * 
		 */		
		private static function createEffectPlane(mc:MovieClip, size:Number, scene:SceneObject3D, x:Number, y:Number, z:Number):Plane {
			
			// Erstellt ein MovieMaterial mit dem übergebenen MovieClip
			var efxMat:MovieMaterial = new MovieMaterial(mc, true, true);
			
			// Die Plane
			var efxPlane:Plane;
			
			// ...nen paar Properties setzen
			efxMat.smooth = true;
			efxMat.interactive = true;
			efxMat.animated = true;
			
			// Instanz erstellen
			efxPlane = new Plane(efxMat,size,size,8,8);
			// ...und ausrichten
			efxPlane.x = x;
			efxPlane.y = y;
			efxPlane.z = z;
			
			return efxPlane;
		}

	}
}