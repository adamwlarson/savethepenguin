package
{

	import flare.core.Label3D;
	import flare.core.Pivot3D;
	
	import flash.events.Event;
	
	import flare.core.Mesh3D;
	
	
	public class AnimatedModel extends Model
	{
		public function AnimatedModel( )
		{
			super();
		}
				
		protected function _AnimationComplete( e:Event ):void
		{
		
		}
		
		protected function _PlayAnimation( src:String, blend:int, loop:Boolean ):void
		{
			//_obj.gotoAndStop( src, blend );
			//_obj.play( Pivot3D.ANIMATION_STOP_MODE );
			
			//trace("play function");
			//_obj.stop();
			//_obj.play();
			//_obj.stop();
			//_obj.children[0].removeEventListener(Pivot3D.ANIMATION_COMPLETE_EVENT, _AnimationComplete);
			_obj.gotoAndPlay( src, blend );// , ( loop )? Pivot3D.ANIMATION_LOOP_MODE:Pivot3D.ANIMATION_STOP_MODE );
			
			_obj.children[0].addEventListener(Pivot3D.ANIMATION_COMPLETE_EVENT, _AnimationComplete);
		}
		
		public function AddAnimation( src:String, start:Number, end:Number ):void
		{
			_obj.addLabel( new Label3D( src, start, end ) );
	
		}
	}
}