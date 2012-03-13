package
{
	import flare.basic.Scene3D;
	import flare.basic.Viewer3D;
	
	import flash.display.*;
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(frameRate=30, width=640, height=480)]
	public class CatchAPenguin extends Base
	{
		private var _engine:Engine;
		private var _level:Level;
		private var _gameBoard:Board;
		
		public function CatchAPenguin()
		{
			var me:DisplayObjectContainer = this;
			// set up the stage
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.width;
			stage.height;
			
			var fsm:FiniteStateMachine = new FiniteStateMachine( {
				Init: // state
				{
					onStartUp: function():Object // handler
					{
						//Create a new engine
						_engine = new Engine();
						_engine.Initialize(me, 320, 240);
						
						return fsm.States.Loading;
					}
				},
				Loading:
				{
					onStartUp: function():void // handler
					{
						//Create a new scene pass in the engine
						_level = new GameLevel( );
						//_level = new KillerLevel( );
						_level.Initialize(_engine);
					}
				}
			});
			
			fsm.Start();
			
			// Initialise Event loop
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function loop(event:Event):void
		{
			_level.Update( );
			// Render the 3D scene
			_engine.Render();
			
		}
	}
}