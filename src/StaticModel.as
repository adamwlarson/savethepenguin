package
{
	import away3d.core.base.Mesh;
	import away3d.events.Loader3DEvent;
	import away3d.loaders.Loader3D;
	import away3d.loaders.Obj;
	
	public class StaticModel
	{
		private var _loader:Loader3D;
		private var _mesh:Mesh;
		private var _func:Function;
		private var _loaded:Boolean = false;
		
		public function StaticModel()
		{
		}
		
		//Load the Mesh
		public function LoadOBJ( src:String, engine:Engine, func:Function ):void
		{
			_func = func;
			_loader = new Loader3D( );
			
			_loader.addEventListener( Loader3DEvent.LOAD_SUCCESS, Loaded );
			_loader.addEventListener( Loader3DEvent.LOAD_ERROR, Error );
			_loader.autoLoadTextures = true;
			
			_loader.loadGeometry(src, new Obj( ) );
			/*_loader.scaleX = _loader.scaleY = _loader.scaleZ = 1000;*/
			engine.AddChild(_loader);
		}
		
		//Private helper for when the mesh is actually loaded
		protected function Loaded( event:Loader3DEvent ):void
		{
			_func();
			_loaded = true;
			_mesh = event.loader.handle as Mesh;
		}
		
		protected function Loading( event:Loader3DEvent ):void
		{
			trace( "Loading " + event.loader.bytesLoaded.toString() );
		}
		
		//Private helper for tracking when a mesh is not loaded
		protected function Error( event:Loader3DEvent ):void
		{
			trace("Error Loading Static Mesh");
		}
	}
}