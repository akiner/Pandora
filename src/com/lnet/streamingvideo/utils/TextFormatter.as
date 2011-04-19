package com.lnet.streamingvideo.utils {
	public class TextFormatter {
		public static function FormatNumWithCommas(string:String):String {
			var results:Array = string.split(/\./);
			string = results[0];
			if (string.length>3) {
				var mod:Number = string.length%3;
				var output:String = string.substr(0, mod);
				for (var i:Number = mod; i<string.length; i += 3) {
					output += ((mod == 0 && i == 0) ? "" : ",")+string.substr(i, 3);
				}
				if(results.length > 1){
					if(results[1].length == 1){
						return output+"."+results[1]+"0";
						
					}else{
						return output+"."+results[1];
					}
				}else{
					return output;
				}
			}
			
			if(results.length > 1){
				if(results[1].length == 1){
					return string+"."+results[1]+"0";
					
				}else{
					return string+"."+results[1];
				}
			}else{
				return string;
			}
			
			return string;
		}
	}
}