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
		public function CatchAPenguin()
		{
			// set up the stage
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//Create a new engine
			_engine = new Engine();
			addChild( _engine.Initialize(800, 600) );
			
			//Create a new scene pass in the engine
			_level = new TestAnimatedMesh( );
			_level.Initialize(_engine);
			
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