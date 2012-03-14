package
{

	import flare.core.Label3D;
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	
	import flash.events.Event;
	
	
	public class AnimatedModel extends Model
	{
		public function AnimatedModel( )
		{
			super();
		}
				
		protected function _AnimationComplete( e:Event ):void
		{
			trace("done");
		}
		
		protected function _PlayAnimation( src:String, blend:int, loop:Boolean ):void
		{
			//var findFirst:Boolean = false;
			//trace("start animation " + src);
			_obj.forEach( function addEvent( mesh:Mesh3D ):void
			{
				// this only works for models with one mesh
				//trace("found mesh"); 
				if( mesh.animationEnabled==true )
				{
					mesh.addEventListener(Pivot3D.ANIMATION_COMPLETE_EVENT, _AnimationComplete);
					//findFirst = true;
				}
					
				
			}, Mesh3D );
			
			// current bug in the engine, can't use ANIMATION_STOP_MODE or animations will stop working
			// work around : don't use ANIMATION_LOOP_MODE so I can still get ANIMATION_COMPLETE_EVENT message and manualy loop
			// this should be fixed in next engine update
			_obj.gotoAndPlay( src, blend, 0 );// ( loop )? Pivot3D.ANIMATION_LOOP_MODE:Pivot3D.ANIMATION_STOP_MODE ); 
			
			
		}
		
		public function AddAnimation( src:String, start:Number, end:Number ):void
		{
			_obj.addLabel( new Label3D( src, start, end ) );
	
		}
	}
}