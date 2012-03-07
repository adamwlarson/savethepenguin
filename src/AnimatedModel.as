package
{

	import flash.events.Event;
	
	import flashx.textLayout.formats.Float;
	
	
	public class AnimatedModel
	{
		private var _loaded:Boolean = false;
		private var _func:Function;
		
		public function AnimatedModel()
		{
			
		}
		
		public function LoadModelDAE( src:String, engine:Engine, func:Function ):void
		{
			_func = func;
		}
		
		public function LoadModelMD2( src:String, engine:Engine, func:Function ):void
		{
			_func = func;
		}
		
		public function PlayAnimation( src:String ):void
		{
			
		}
		
		public function AddAnimation( src:String, start:Number, end:Number, loop:Boolean ):void
		{
			
		}
		
		public function Rotate( num:Number ):void
		{
		}
	}
}