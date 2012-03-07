package
{
	import flare.basic.*;
	import flare.core.Pivot3D;
	
	import flash.events.*;
	
	public class StaticModel
	{
		private var _loaded:Boolean = false;
		public var _mesh:Pivot3D; // test
		
		public function StaticModel()
		{
			
		}
		
		//Load the Mesh
		public function LoadOBJ( src:String, engine:Engine, func:Function ):void
		{
			_mesh = engine.GetScene( ).addChildFromFile( src );		
		}
	}
}