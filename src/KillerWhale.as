package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class KillerWhale extends Entity
	{
		public var fsm:FiniteStateMachine;
		public var ed:EventDispatcher = new EventDispatcher();
		
		public function KillerWhale( engine:Engine )
		{
			super(engine);
			
			SetModel("Whale", engine );
			SetScale(0.5,0.5,0.5);
			
			AddAnimation("swim1", 0, 59 );
			AddAnimation("swim2", 99, 159 );
			AddAnimation("jump1", 199, 256 );
			AddAnimation("jump2", 299, 359 );
			
			_obj.setLayer(0);
			
			fsm = new FiniteStateMachine(
			{
				Init: // state
				{
					onStartUp: function():void // handler
					{
						_PlayAnimation("swim1", 4, false );
					},
					onAnimationDone:function():void
					{
						var ran:Number = Math.floor(Math.random( )*100 );
						if( ran > 80 )
							_PlayAnimation("swim1", 5, false );	
						else
							_PlayAnimation("swim2", 5, false );
					}
				}
			});
			
			fsm.Start();
		}
		
		public function MoveTo( x:Number, y:Number, z:Number, callback:Function=null ):void
		{
			fsm.Fire("onWalk");
			SetLookAt( x, 0, z );
			Tween( {x:x, z:z}, 250, function():void
			{
				if(callback!=null)callback();
				_AnimationComplete( null );
				
			});
		}
		
		protected override function _AnimationComplete( e:Event ):void
		{
			trace("animation done");
			fsm.Fire("onAnimationDone");
			ed.dispatchEvent( new Event("AnimationDone") );
			
		}
	}
}