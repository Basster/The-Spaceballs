package spaceballs.data.fields
{
	/**
	 * Ein einfaches Bodenfeld.
	 * @author Basster
	 */
	public class FloorField extends FieldBase
	{
		/**
		 * Ein einfaches Bodenfeld. 
		 * @param x
		 * @param y
		 * @param width
		 * @param length
		 */
		public function FloorField(x:uint, y:uint, width:uint, length:uint) {
			// Da ein Feld per default in der FieldBase.as ein FLOOR Field initialisiert, wird hier nix weiter getan.
			super(x, y, width, length);
		}
	}
}