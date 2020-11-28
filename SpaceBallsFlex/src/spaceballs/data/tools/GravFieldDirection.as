package spaceballs.data.tools
{
	/**
	 * Typensicherer Enum für die Feldgravitation
	 * @author Basster
	 */
	public class GravFieldDirection {
			/**
			 * Gravitations zum Feld hin
			 * @default 
			 */
			public static const IN:GravFieldDirection = new GravFieldDirection("in");
			/**
			 * Gravitation vom Feld weg
			 * @default 
			 */
			public static const OUT:GravFieldDirection = new GravFieldDirection("out");
			
			private static var _enumCreated:Boolean = false;
			// Kranker Scheiss: Der statische Code Block, aber es funktioniert! :D
			{
				_enumCreated = true;
			}
			
			/**
			 * Enum für die Feldgravitation
			 * @param name
			 * @throws Error
			 */
			public function GravFieldDirection(name:String) {
				if (_enumCreated) {
					throw new Error("The enum is already created.");
				}
				_name = name;
			}
			
			private var _name:String;
			
		}
}