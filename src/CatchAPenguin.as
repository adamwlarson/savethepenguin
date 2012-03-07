package
{
	import flash.display.*;
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(frameRate=60, width=800, height=600)]
	public class CatchAPenguin extends Sprite
	{
		private var _engine:Engine;
		private var _level:TestAnimatedMesh;
		private var _gameBoard:Board;
		
		public function CatchAPenguin()
		{
			// set up the stage
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.width;
			stage.height;
			
			var fsm:FiniteStateMachine = new FiniteStateMachine( {
				Init: // state
				{
					onStartUp: function():Object // handler
					{
						//Create a new engine
						_engine = new Engine();
						addChild( _engine.Initialize(800, 600) );
						
						return fsm.States.Loading;
					}
				},
				Loading:
				{
					onStartUp: function():Object // handler
					{
						//Create a new scene pass in the engine
						/*_level = new TestAnimatedMesh( );
						_level.Initialize(_engine);*/	
						_gameBoard = new Board( _engine, 11, 11, 20 );
						//_gameBoard.MakeRandomBoard( 35 );
						
						return fsm.States.GamePlayerTurn;
					}
				},
				GamePlayerTurn:
				{
					onStartUp: function():void // handler
					{
						_gameBoard.CommandAllTiles( "onEnable" );
					}	
				},
				GameAiTurn:
				{
					onStartUp: function():void // handler
					{
						_gameBoard.CommandAllTiles( "onDisable" );
					}
				},
				GameEnd:
				{
					onStartUp: function():void // handler
					{
						_gameBoard.CommandAllTiles( "onDisable" );
					}	
				}				
			});
			
			fsm.Start(); // start the state machine
			
			// Initialise Event loop
			this.addEventListener(Event.ENTER_FRAME, loop);   
		}
		
		private function loop(event:Event):void 
		{
			//_level.Update( );
			// Render the 3D scene
			_engine.Render();
			
		}
	}
}