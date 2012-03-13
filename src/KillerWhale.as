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
			
			AddAnimation("swim1", 1, 60 );
			AddAnimation("swim2", 100, 160);
			AddAnimation("jump1", 200, 260 );
			AddAnimation("jump2", 300, 360 );
			
			_obj.setLayer(0);
			
			fsm = new FiniteStateMachine(
			{
				Init: // state
				{
					onStartUp: function():void // handler
					{
						_PlayAnimation("swim1", 10, false );
					},
					onAnimationDone:function():void
					{
					/*	var ran:Number = Math.floor(Math.random( )*100 );
						if( ran > 80 )
							_PlayAnimation("swim1", 10, false );	
						else
							_PlayAnimation("swim2", 10, false );*/
					}
				}
			});
			
			fsm.Start();
		}
		
		public function MoveTo( x:Number, y:Number, z:Number, callback:Function=null ):void
		{
			fsm.Fire("onSwim");
			SetLookAt( x, 0, z );
			Tween( {x:x, z:z}, 3, function():void
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