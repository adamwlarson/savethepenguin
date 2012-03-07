package
{
	import flash.events.Event;

	public final class TestAnimatedMesh extends Level
	{
		private var testModel:AnimatedModel;
		
		public function TestAnimatedMesh()
		{
			super();
		}
		
		public override function Initialize( engine:Engine ):void
		{
			super.Initialize( engine );
			
			
			engine.SetLoadedCallback(Loaded);
			testModel = new AnimatedModel( );
			testModel.LoadModelF3D( "Assets/model.f3d", engine );
			
			var staticModel:StaticModel = new StaticModel( );
			staticModel.LoadOBJ( "Assets/001.obj", engine, function( ):void {
				trace( "Success Loading Static Mesh" );
			});

		}
		
		//Called when all evel assets are loaded
		public function Loaded(e:Event ):void
		{
			trace( "Success Loading" );
			DoneLoading();
			testModel.AddAnimation("Walk", 30, 48, true );
			testModel.PlayAnimation("Walk", 0);
		}
		
		public override function Update( ):void
		{
		//	testModel.Rotate(1.0);
		}
		
	}
}