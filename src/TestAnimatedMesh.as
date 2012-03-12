package
{
	import flare.core.Pivot3D;
	
	import flash.events.Event;
	
	public final class TestAnimatedMesh extends Level
	{
		private var _testModel:AnimatedModel;
				
		public function TestAnimatedMesh()
		{
			super();
		}
		
		public override function Initialize( engine:Engine ):void
		{
			super.Initialize( engine );
			
			_testModel = new AnimatedModel( );
			
			engine.SetLoadedCallback( Loaded );
			engine.LoadModel("Assets/model.f3d", "model");
			
			
		}
		
		//Called when all evel assets are loaded
		public function Loaded(e:Event ):void
		{
			trace( "Success Loading" );
			
			_testModel.SetModel("model", _engine );
			
			_testModel.AddAnimation("Walk", 30, 48, true );
			//_testModel.PlayAnimation("Walk", 0);
			
			DoneLoading();
		}
		
		public override function Update( ):void
		{
			if( IsLoading() ) // do nothing till done loading
				return;
			
			_testModel.SetRotation( 0, 0, 0);
		}
		
	}
}