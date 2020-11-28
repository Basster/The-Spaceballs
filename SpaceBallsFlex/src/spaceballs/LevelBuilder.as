package spaceballs {
	public class LevelBuilder {
		private var fieldSize:Number;
		
		public function LevelBuilder(fS:Number) {
			fieldSize = fS;
		}
		
		/**
		 * erstellt ein Array das so groß ist wie das Spielfeld (10x10, 20x20, 30x30)
		 */
		public function levelArray():Array {
			var levelArray:Array = new Array(fieldSize);
				
			for(var i:Number = 0; i < fieldSize; i++) {
				levelArray[i] = new Array(fieldSize)
			}
				
			return levelArray;
		}

		/**
		 *	Im levelArray stehen nur die Bildnamen diese werden ausgetauscht für die Erstellung des XML 
		 */
		public function changeArrayToType(levelArray:Array):Array {
			for(var x:Number = 0; x < fieldSize; x++) {
				for(var y:Number = 0; y < fieldSize; y++) {
					var type:Number;
					var wordType:String = levelArray[x][y];
					
					switch (wordType) {
						case "normal.png": 				type = 10;
														break;
						
						case "empty.png": 				type = 12;
														break;
						
						case "wall.png": 				type = 6;
														break;
											
						case "end.png": 				type = 2;
														break;
											
						case "spaceball.png": 			type = 1;
														break;
						
						case "enemy.png": 				type = 9;
														break;
											
						case "gravitationin.png": 		type = 11;
														break;
									
						case "gravitationout.png": 		type = 5;
														break;
						
						case "wormholein.png": 			type = 7;
														break;
								
						case "wormholeout.png": 		type = 8;
														break;
														
						case "hole.png": 				type = 3;
														break;								
						
						case "blackhole.png": 			type = 4;
														break;
					}
					
					levelArray[x][y] = type;
					
				}
			}
			
			return levelArray;
		}

		/**
		 * Erstellt ein Hilfsarray mit der Dimension des Spielfeld + 2 weitere Dimensionen zur berechnung 
		 * der Breite und Länge einzelner zusammenhängender Felder
		 */
		public function combineArrayForXML(levelArray:Array):Array {
			var helpArray:Array = createHelpArray();
				
			helpArray = fillHelpArray(helpArray, levelArray);
				
			helpArray = startCombine(helpArray);
							
			return helpArray;
		}

		/**
		 * Erstellt ein Array mit den Dimensinen [fieldSize][fieldSize][3] 
		 * in [][][0] befinden sich die Typen des Feldes
		 * in [][][1] befindet sich die Breite 
		 * in [][][2] befindet sich die Länge
		 */
		public function createHelpArray():Array {
			var helpArray:Array = new Array(fieldSize); 
				
			for(var i:Number = 0; i < fieldSize; i++) {
				helpArray[i] = new Array(fieldSize);
					
				for(var j:Number = 0; j < fieldSize; j++) {
					helpArray[i][j] = new Array(3);
						
					for(var x:Number = 0; x < 3; x++) {
						helpArray[i][j][x] = null;
					}
				}
			}
				
			return helpArray;
		}

		public function fillHelpArray(helpArray:Array, levelArray:Array):Array {
			for(var i:Number = 0; i < fieldSize; i++) {
				for(var j:Number = 0; j < fieldSize; j++) {
					helpArray[i][j][0] = levelArray[i][j];
				}
			}
			return helpArray;
		}

		/**
		 * Sucht nach Zusammenhängenden Feldern des Types (Wand, Normal und Leer)
		 */
		private function startCombine(helpArray:Array):Array {
			helpArray = checkTypeLength(helpArray);
			helpArray = checkTypeWidth(helpArray);
			helpArray = checkOtherFields(helpArray);
				
			return helpArray;
		}

		/**
		 * Alle anderen Felder nicht der Typen (Wand, Normal und Leer)
		 * werden gesetzt
		 */
		private function checkOtherFields(helpArray:Array):Array {
 				for(var i:Number = 0; i < fieldSize; i++) {
					for(var j:Number = 0; j < fieldSize; j++) {
						if(helpArray[i][j][0] != 6 && helpArray[i][j][0] != 10 && helpArray[i][j][0] != 12) {
							if(helpArray[i][j][0] == 0) {
								helpArray[i][j][0] = null;
								helpArray[i][j][1] = null;
								helpArray[i][j][2] = null;
							} else {
								helpArray[i][j][1] = 1;
								helpArray[i][j][2] = 1;
							}
						} 
					}
				}
				
				return helpArray;
 		}
 		
 		/**
		 * Untersucht nach der Breite
		 */	 
 		private function checkTypeWidth(helpArray:Array):Array {
 				var check:Boolean;
 				var type:Number;
 				
				for(var i:Number = 0; i < fieldSize; i++) {
					for(var j:Number = 0; j < fieldSize; j++) {
						type = -1;
						
						if(	(helpArray[i][j][0] == 6 && isChecked(helpArray, i, j) == false) ||
							(helpArray[i][j][0] == 10 && isChecked(helpArray, i, j) == false) ||
							(helpArray[i][j][0] == 12 && isChecked(helpArray, i, j) == false)) {
								
							helpArray[i][j][1] = 1;
							helpArray[i][j][2] = 1;		
							type = helpArray[i][j][0];
							
							check = true;
							
							for(var y:Number = j+1; y < fieldSize; y++) {
								if((check == true) && (helpArray[i][y][0] == type) && (isChecked(helpArray, i, y) == false)) {
									helpArray[i][j][2] = helpArray[i][j][2]+1;
									helpArray[i][y][0] = 0;
								} else {
									check = false;
								}
							}		
						}
					}
				}
				
				return helpArray;
 		}	
 			 			
 		/**
 		 * Untersucht die Länge 
 		 */	 					
 		private function checkTypeLength(helpArray:Array):Array {
 				var check:Boolean;
 				var type:Number;
 				
 				for(var i:Number = 0; i < fieldSize; i++) {
					for(var j:Number = 0; j < fieldSize; j++) {
						type = -1;
						
						if(	(helpArray[i][j][0] == 6 && isChecked(helpArray, i, j) == false) ||
							(helpArray[i][j][0] == 10 && isChecked(helpArray, i, j) == false) ||
							(helpArray[i][j][0] == 12 && isChecked(helpArray, i, j) == false)) {
							
							helpArray[i][j][1] = 1;
							helpArray[i][j][2] = 1;		
							type = helpArray[i][j][0];
							
							check = true;
							
							for(var x:Number = i+1; x < fieldSize; x++) {
								if((check == true) && (helpArray[x][j][0] == type) && (isChecked(helpArray, x, j) == false)) {
									
									helpArray[i][j][1] = helpArray[i][j][1]+1;
									helpArray[x][j][0] = 0;
								} else {
									check = false;
									if(helpArray[i][j][1] == 1 && helpArray[i][j][2] == 1) {
										helpArray[i][j][1] = null;
										helpArray[i][j][2] = null;
									}
									
								}
							}		
						}
					}
				}
				
				return helpArray;	
 		}

		/**
		 * Untersucht ob der Algorithmus schon an dem Feld war
		 */ 
		private function isChecked(helpArray:Array, i:Number, j:Number):Boolean {
 				if(helpArray[i][j][1] == null && helpArray[i][j][2] == null) {
 					return false;
 				} else {
 					return true
 				}
 		}  

		/**
		 * Erstellt einen Sting mit Inhalt des HelpArrays zum Speichern und Spielen privater Levels
		 */ 
		public function createLevelXML(levelArray:Array):String {
			var tag:String;
				
			var levelXML:String = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
			levelXML += "<Level width=\""+(fieldSize)+"\" height=\""+(fieldSize)+"\">\n";

			for(var x:Number = 0; x < fieldSize; x++) {
				for(var y:Number = 0; y < fieldSize; y++) {
					if(levelArray[x][y][0] != null) {
						var a:Number = x+1;
						var b:Number = y+1;
						tag = "\t<Field x=\""+(a)+"\" y=\""+(b)+"\" type=\""+levelArray[x][y][0]+"\" width=\""+levelArray[x][y][1]+"\" length=\""+levelArray[x][y][2]+"\" />\n";
						levelXML += tag;
					}
				}
			}
			
			levelXML += "</Level>";
	
			return levelXML;
		}

	}
}