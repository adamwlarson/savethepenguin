package
{

	import flare.basic.Viewer3D;
	
	import flash.display.*;
	
	//Wraps the engine interface into an easy to use and easy to replace class
	public class Engine
	{
		public var view:Viewer3D;
		public function Engine( view:Viewer3D )
		{
			this.view = view;
		}
		
		public function Initialize(x:int, y:int):void
		{
			
		}
		
		public function AddChild( ):void
		{
			
		}
		
		public function GetScene( ):void
		{
		}
		
		public function Render( ):void
		{
			
		}
		
		
	}
}