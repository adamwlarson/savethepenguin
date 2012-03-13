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
			AddAnimation("idle1", 1, 30 );
			AddAnimation("idle2", 50, 90 );
			AddAnimation("idle3", 110, 150 );
			AddAnimation("idle4", 170, 210 );
			AddAnimation("idle5", 240, 280 );
			AddAnimation("idle6", 300, 340 );
			AddAnimation("idle7", 360, 380 );
			AddAnimation("idle8", 420, 460 );
			
			AddAnimation("walk", 500, 530 );
			AddAnimation("run", 550, 565 );
			AddAnimation("dive", 600, 638 );
			_obj.setLayer(0);
			_obj.children[2].setLayer( 10 );// shadow
			_obj.children[2].animationEnabled = false;
			
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
							_PlayAnimation("idle1", 10, false );
						},
						onAnimationDone:function():void
						{
							
						/*	var ran:Number = Math.floor(Math.random( )*100 );
							if( ran > 80 )
								ran = Math.floor(Math.random( )*6 );
							else
								ran = 100;
							
							switch(ran)
							{
								case 0:
									_PlayAnimation("idle2",10, false );
									break;
								case 1:
									_PlayAnimation("idle3",10, false );
									break;
								case 2:
									_PlayAnimation("idle4",10, false );
									break;
								case 3:
									_PlayAnimation("idle5", 10, false );
									break;
								case 4:
									_PlayAnimation("idle6", 10, false );
									break;
								case 5:
									_PlayAnimation("idle7", 10, false );
									break;
								case 6:
									_PlayAnimation("idle8", 10, false );
									break;
								default:
									_PlayAnimation("idle1",10, false );
									break;
							}*/
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
			//_obj.stop();
			trace("animation done");
			fsm.Fire("onAnimationDone");
			ed.dispatchEvent( new Event("AnimationDone") );
			
		}
	}
}