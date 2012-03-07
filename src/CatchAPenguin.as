package
{
	import flare.basic.*;
	import flare.basic.Viewer3D;
	import flare.core.*;
	import flare.system.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.events.Event;
	
	
	[SWF(frameRate=60, width=800, height=600)]
	public class CatchAPenguin extends Base
	{
		private var _engine:Engine;
		private var _level:TestAnimatedMesh;
		private var _gameBoard:Board;
		
		private var scene:Viewer3D;
		
		public function CatchAPenguin()
		{
			// set up the stage
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.width;
			stage.height;
			
			// creates a new 3d scene.
			scene = new Viewer3D(this);
			scene.antialias = 2;
			scene.camera = new Camera3D( "myOwnCamera" );
			scene.camera.setPosition( 0, 1000, -1000 );
			scene.camera.lookAt( 0, 0, 0 );
			
			var fsm:FiniteStateMachine = new FiniteStateMachine( {
				Init: // state
				{
					onStartUp: function():Object // handler
					{
						//Create a new engine
						_engine = new Engine( scene );
						//addChild( _engine.Initialize(800, 600) );
						
						return fsm.States.Loading;
					}
				},
				Loading:
				{
					onStartUp: function():void // handler
					{
						//Create a new scene pass in the engine
						_level = new TestAnimatedMesh( );
						_level.Initialize(_engine);
						_gameBoard = new Board( _engine, 11, 11, 10 );
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