package
{
	import flare.core.Camera3D;
	import flare.core.Pivot3D;
	
	import flash.events.Event;

	public class GameLevel extends Level
	{
		private var _testModel:AnimatedModel;
		private var _board:Board;
		private var _fsm:FiniteStateMachine;
		
		
		public function GameLevel()
		{
			super();
		}
		
		public override function Initialize( engine:Engine ):void
		{
			super.Initialize( engine );			
			
			_fsm = new FiniteStateMachine(
				{
					Init: // state
					{
						onStartUp: function():void // handler
						{
							// set camera
							engine.GetScene().camera = new Camera3D();
							engine.GetScene().camera.setPosition( 0, 800, -800 );
							engine.GetScene().camera.lookAt( 0, 0, 0 );
							
							engine.SetLoadedCallback( Loaded );
							// create
							_testModel = new AnimatedModel( );
							// load
							engine.LoadModel("Assets/model.f3d");
							engine.LoadModel("Assets/TilePiece01.f3d");
						},
						onLoadDone: function():Object
						{			
							trace( "Success Loading" );
							
							// Board
							_board = new Board( engine, 11, 11 );
							_board.MakeRandomBoard( 35 );
							_board.ed.addEventListener("PlayerDone", function():void
							{
								_fsm.Fire("onPlayerDone");
							});
							
							// Ai
							_testModel.GetModel("model.f3d", engine );
							_testModel.SetScale( 8, 8, 8 );
							_testModel.AddAnimation("Walk", 30, 48, true );
							_testModel.PlayAnimation("Walk", 0);
							
							return _fsm.States.GamePlayerTurn;
						}
					},
					GamePlayerTurn:
					{
						onStartUp: function():void // handler
						{
							_board.CommandAllTiles("onEnable");
						},
						onPlayerDone: function():Object
						{
							return _fsm.States.GameAiTurn;
						}
					},
					GameAiTurn:
					{
						onStartUp: function():void // handler
						{
							_board.CommandAllTiles("onDisable");
							_fsm.Fire("onAiDone");// Test!!!
						},
						onAiDone: function():Object
						{
							_board.CommandAllTiles("onFade");
							return _fsm.States.GamePlayerTurn;
						}
					},
					GameEnd:
					{
						onStartUp: function():void // handler
						{
							
						},
						onRestart: function():void
						{
							
						}
					}
				});
			
			_fsm.Start();
			
		}
		
		//Called when all evel assets are loaded
		public function Loaded(e:Event ):void
		{
			DoneLoading();
			
			_fsm.Fire("onLoadDone");
		}
		
		public override function Update( ):void
		{
			if( IsLoading() ) // do nothing till done loading
				return;
		}
		
	}
}