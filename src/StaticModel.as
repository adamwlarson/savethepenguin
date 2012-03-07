package
{
	import away3d.core.base.Mesh;
	import away3d.events.Loader3DEvent;
	import away3d.loaders.Loader3D;
	import away3d.loaders.Obj;
	
	import flash.display.Loader;
	
	public class StaticModel // check with adam
	{
		public var _loader:Loader3D;
		public var _mesh:Mesh;
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
			//var mat:ColorMaterial = new ColorMaterial( 0x000000 );
			
			_loader.addEventListener( Loader3DEvent.LOAD_SUCCESS, Loaded );
			_loader.addEventListener( Loader3DEvent.LOAD_ERROR, Error );
			_loader.autoLoadTextures = true;
			//var max3ds:Max3DS = new Max3DS();
			//max3ds.centerMeshes = true;
			//max3ds.material = mat;
			
			//_loader.scaleX = _loader.scaleY = _loader.scaleZ = 0.5;
			_loader.loadGeometry(src, new Obj() );
			
			engine.AddChild( _loader );
		}
		
		//Private helper for when the mesh is actually loaded
		protected function Loaded( event:Loader3DEvent ):void
		{
			_loaded = true;
			_mesh = event.loader.handle as Mesh;
			_func( );
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