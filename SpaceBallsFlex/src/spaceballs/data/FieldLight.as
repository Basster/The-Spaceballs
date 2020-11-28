package spaceballs.data
{
	import org.papervision3d.lights.PointLight3D;
	
	public final class FieldLight
	{
		private static var _light:PointLight3D = new PointLight3D();
		
		public function FieldLight() {
			if (_light) {
				throw new Error("FieldLight can only be accessed through FieldLight.getInstace()");
			}
		}
		
		public static function getInstance():PointLight3D {
			return _light;
		}

	}
}