package
{
	import away3d.animators.Animator;
	import away3d.animators.BonesAnimator;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.core.base.Mesh;
	import away3d.core.utils.Cast;
	import away3d.events.Loader3DEvent;
	import away3d.loaders.*;
	import away3d.loaders.Loader3D;
	import away3d.loaders.Md2;
	import away3d.loaders.Obj;
	import away3d.loaders.data.AnimationData;
	import away3d.materials.*;
	
	import flash.events.Event;
	
	import flashx.textLayout.formats.Float;
	
	
	public class AnimatedModel
	{
		private var _loader:Loader3D;
		private var _loaded:Boolean = false;
		private var _func:Function;
		private var _mesh:Mesh;
		
		public function AnimatedModel()
		{
			
		}
		
		public function LoadModelDAE( src:String, engine:Engine, func:Function ):void
		{
			_func = func;
			var mat: ColorMaterial = new ColorMaterial( 0xFFFF0000 );
			_loader = Collada.load( src );
			_loader.autoLoadTextures = false;
			
			//Listeners
			_loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, Loaded);
			_loader.addOnError(Error);
			_loader.addOnProgress(Loading);
			
			_loader.material = mat; 
			engine.AddChild(_loader);
		}
		
		public function LoadModelMD2( src:String, engine:Engine, func:Function ):void
		{
			_func = func;
			var mat: ColorMaterial = new ColorMaterial( 0xFFFF0000 );
			_loader = Md2.load( src );
			_loader.autoLoadTextures = false;
			
			//Listeners
			_loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, Loaded);
			_loader.addOnError(Error);
			_loader.addOnProgress(Loading);
			
			_loader.material = mat; 
			engine.AddChild(_loader);
		}
		
		public function PlayAnimation( src:String ):void
		{
			var animationData:AnimationData = _loader.handle.animationLibrary.getAnimation( src );
			if( animationData != null )
				animationData.animator.play();
		}
		
		public function AddAnimation( src:String, start:Number, end:Number, loop:Boolean ):void
		{
			/*var animationData:AnimationData = _loader.handle.animationLibrary.addAnimation(src);
			animationData = _loader.handle.animationLibrary.getAnimation( "default" ).clone(null);
			animationData.animator = _loader.handle.animationLibrary.getAnimation( "default" ).animator.clone(null);
			animationData.animator.loop = loop;
			animationData.animator.length = 11;
			animationData.start = start;
			animationData.end = end;*/
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
			trace("Error Loading Animated Mesh");
		}
		
		public function Rotate( num:Number ):void
		{
			_loader.handle.rotationY += num;
		}
	}
}