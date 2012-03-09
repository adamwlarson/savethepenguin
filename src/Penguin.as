package
{
	import flash.events.Event;
	
	public class Penguin extends Entity
	{
		public var currentTile:Tile;
		public var _fsm:FiniteStateMachine;
		
		public function Penguin( engine:Engine )
		{
			super( engine );			
			
			SetModel("Penguin", engine );	
			
			AddAnimation("idle1", 1, 30 );
			AddAnimation("idle2", 50, 90 );
			AddAnimation("idle3", 100, 150 );
			AddAnimation("idle4", 170, 210 );
			AddAnimation("idle5", 240, 280 );
			AddAnimation("idle6", 300, 340 );
			AddAnimation("idle7", 360, 400 );
			AddAnimation("idle8", 420, 460 );
			
			AddAnimation("walk", 500, 530 );
			AddAnimation("run", 550, 565 );
			AddAnimation("dive", 600, 640 );
			
			_fsm = new FiniteStateMachine(
			{
				Init: // state
				{
					onStartUp: function():Object // handler
					{
						return _fsm.States.Idle;
					}
				},
				Idle:
				{
					onStartUp:function():void
					{
						_PlayAnimation("idle4", 0, false );
					},
					onAnimationDone:function():void
					{
						trace("play");
						_PlayAnimation("idle4", 0, false );
					}
				}
			});	
			
			_fsm.Start();
		}	
		
		protected override function _AnimationComplete( e:Event ):void
		{
			trace("animation");
			_fsm.Fire("onAnimationDone");
		}
	}
}