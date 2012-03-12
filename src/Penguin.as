package
{

	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class Penguin extends Entity
	{
		public var currentTile:Tile;
		public var fsm:FiniteStateMachine;
		public var ed:EventDispatcher = new EventDispatcher();
		
		public function Penguin( engine:Engine )
		{
			super( engine );
			
			SetModel("Penguin", engine );
			SetScale(0.75,0.75,0.75);
			AddAnimation("idle1", 0, 29 );
			AddAnimation("idle2", 30, 89 );
			AddAnimation("idle3", 90, 149 );
			AddAnimation("idle4", 150, 209 );
			AddAnimation("idle5", 210, 279 );
			AddAnimation("idle6", 280, 339 );
			AddAnimation("idle7", 440, 399 );
			AddAnimation("idle8", 400, 459 );
			
			AddAnimation("walk", 500, 529 );
			AddAnimation("run", 550, 564 );
			AddAnimation("dive", 600, 639 );
			_obj.setLayer(10);
			
			fsm = new FiniteStateMachine(
				{
					Init: // state
					{
						onStartUp: function():Object // handler
						{
							return fsm.States.Idle;
						}
					},
					Idle:
					{
						onStartUp:function():void
						{
							_PlayAnimation("idle1", 4, false );
						},
						onAnimationDone:function():void
						{
							var ran:Number = Math.floor(Math.random( )*100 );
							if( ran > 80 )
								ran = Math.floor(Math.random( )*6 );
							else
								ran = 100;
							
							switch(ran)
							{
								case 0:
									_PlayAnimation("idle2", 5, false );
									break;
								case 1:
									_PlayAnimation("idle3", 5, false );
									break;
								case 2:
									_PlayAnimation("idle4", 5, false );
									break;
								case 3:
									_PlayAnimation("idle5", 5, false );
									break;
								case 4:
									_PlayAnimation("idle6", 5, false );
									break;
								case 5:
									_PlayAnimation("idle7", 5, false );
									break;
								case 6:
									_PlayAnimation("idle8", 5, false );
									break;
								default:
									_PlayAnimation("idle1", 5, false );
									break;
							}
						},
						onWalk:function():Object
						{
							return fsm.States.Walk;
						},
						onDive:function():Object
						{
							return fsm.States.Dive;
						},
						onLose:function():Object
						{
							return fsm.States.Lose;
						}
					},
					Walk:
					{
						onStartUp:function():void
						{
							_PlayAnimation("walk", 4, true );
						},
						onAnimationDone:function():Object
						{
							return fsm.States.Idle;
						}
					},
					Dive:
					{
						onStartUp:function():void
						{
							_PlayAnimation("dive", 0, false );
						},
						onAnimationDone:function():Object
						{
							return fsm.States.Idle;
						}
					},
					Lose:
					{
						onStartUp:function():void
						{
							_PlayAnimation("idle8", 0, false );
						},
						onAnimationDone:function():Object
						{
							return fsm.States.Idle;
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
			//trace("animation done");
			fsm.Fire("onAnimationDone");
			ed.dispatchEvent( new Event("AnimationDone") );
			
		}
	}
}