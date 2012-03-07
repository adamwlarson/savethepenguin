package
{

	import flare.core.Label3D;
	import flare.core.Pivot3D;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import flashx.textLayout.formats.Float;
	
	
	public class AnimatedModel
	{
		private var _loaded:Boolean = false;
		private var _func:Function;
		private var _obj:Pivot3D;
		
		public function AnimatedModel()
		{
		}
		
		public function LoadModelF3D( src:String, engine:Engine ):void
		{
			_obj = engine.GetScene().addChildFromFile(src);
		}
		
		public function LoadModelMD2( src:String, engine:Engine, func:Function ):void
		{
			_func = func;
		}
		
		public function PlayAnimation( src:String, blend:int ):void
		{
			_obj.gotoAndPlay( src, blend );
		}
		
		public function AddAnimation( src:String, start:Number, end:Number, loop:Boolean ):void
		{
			_obj.addLabel( new Label3D( src, start, end ) );
		}
		
		public function Rotate( num:Number ):void
		{
		}
	}
}