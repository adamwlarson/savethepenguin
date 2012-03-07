package
{
	import flare.loaders.*;
	import flare.materials.filters.*;
	import flare.system.*;
	import flash.display.*;
	import flash.text.*;
	
	public class Base extends Sprite 
	{
		private var textField:TextField;
		
		public function Base( info:String = "" ) 
		{
			Flare3DLoader1; // force to include the old f3d loader.
			
			textField = new TextField();
			textField.selectable = false;
			textField.defaultTextFormat = new TextFormat( "arial", 12, 0xffffff );
			textField.autoSize = "left";
			textField.multiline = true;
			textField.text = info;
			addChild( textField );
		}
	}
}