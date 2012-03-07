package
{
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
			
			testModel = new AnimatedModel( );
			testModel.LoadModelMD2( "Assets/panda.md2", engine, function( ):void {
				trace( "Success Loading" );
				DoneLoading();
				//testModel.AddAnimation("Walk", 0, 0.5, true );
				testModel.PlayAnimation("default");
				engine.Render();
			});
			
			/*var staticModel:StaticModel = new StaticModel( );
			staticModel.LoadOBJ( "Assets/001.obj", engine, function( ):void {
				trace( "Success Loading Static Mesh" );
			});*/
		}
		
		public override function Update( ):void
		{
			testModel.Rotate(1.0);
		}
		
	}
}