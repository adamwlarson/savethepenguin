package
{
	import flare.basic.*;
	import flare.core.*;
	import flare.loaders.*;
	import flare.materials.*;
	import flare.system.*;
	
	import flash.display.*;
	
	//Wraps the engine interface into an easy to use and easy to replace class
	public class Engine
	{
		private var _scene:Scene3D;
		
		public function Engine()
		{
			
		}
		
		public function Initialize(container:DisplayObjectContainer, x:int, y:int):void
		{
			// creates a new 3d scene.
			_scene = new Viewer3D( container );
			_scene.antialias = 2;
		}
		
		public function GetScene( ):Scene3D
		{
			return _scene;
		}
		
		public function AddChild( ):void
		{
			
		}
		
		public function Render( ):void
		{
			
		}
		
		public function SetLoadedCallback( func:Function ):void
		{
			_scene.addEventListener( Scene3D.COMPLETE_EVENT, func );
		}
	}
}