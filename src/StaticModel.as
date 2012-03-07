package
{
	import flare.basic.*;
	import flare.core.Pivot3D;
	
	import flash.events.*;
	
	public class StaticModel
	{
		private var _func:Function;
		private var _loaded:Boolean = false;
		public var _mesh:Pivot3D; // test
		
		public function StaticModel()
		{
			
		}
		
		//Load the Mesh
		public function LoadOBJ( src:String, engine:Engine, func:Function ):void
		{
			_func = func;
			
			_mesh = engine.view.addChildFromFile( src );
			
			engine.view.addEventListener( Scene3D.COMPLETE_EVENT, function(e:Event):void 
			{
				_func();
				engine.view.resume();
			});
			
			engine.view.pause();
		}
		
		
	}
}