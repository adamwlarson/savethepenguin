package
{
	import flare.core.Camera3D;
	import flare.core.Pivot3D;
	
	import flash.events.Event;
	
	public class GameLevel extends Level
	{
		private var _testModel:Penguin;
		private var _board:Board;
		private var _fsm:FiniteStateMachine;
		private var _score:uint = 0;
		private var _level:uint = 0;
		private var _turns:uint = 0;
		
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
							engine.GetScene().camera.setPosition( -50, 658, -350 );
							engine.GetScene().camera.lookAt( -50, 0, -20 );
							
							engine.SetLoadedCallback( Loaded );
							
							// create
							_testModel = new Penguin();
							// load models
							engine.LoadModel("Assets/model.f3d", "Penguin");
							engine.LoadModel("Assets/TilePiece01.f3d", "TileModel");
							
							// Load textures
							engine.LoadTexture("Assets/IcePiece.jpg", "Tile_Normal" );
							engine.LoadTexture("Assets/Tile_Select.jpg", "Tile_Select" );
							engine.LoadTexture("Assets/Tile_Block.jpg", "Tile_Blocked" );
							engine.LoadTexture("Assets/Tile_break_Lv1.jpg", "Tile_Break1" );
							engine.LoadTexture("Assets/Tile_break_Lv2.jpg", "Tile_Break2" );
							engine.LoadTexture("Assets/Tile_break_Lv3.jpg", "Tile_Break3" );
							engine.LoadTexture("Assets/Tile_break_Lv4.jpg", "Tile_Break4" );
							engine.LoadTexture("Assets/Tile_break_Lv5.jpg", "Tile_Break5" );
						},
						onLoadDone: function():Object
						{
							trace( "Success Loading" );
							
							// Board
							_board = new Board( engine, 11, 11 );
							
							_board.ed.addEventListener("PlayerDone", function():void
							{
								_fsm.Fire("onPlayerDone");
							});
							
							// Ai
							_testModel.SetModel("Penguin", engine );
							_testModel.SetScale( 8, 8, 8 );
							//_testModel.AddAnimation("Walk", 30, 48, true );
							//_testModel.PlayAnimation("Walk", 0);
						
							return _fsm.States.GameSetUp;
						}
						
					},
					GameSetUp:
					{
						onStartUp: function():Object // handler
						{
							_board.CommandAllTiles("onReset");
							_board.MakeRandomBoard( Math.max( 10, 35 - _level ) );
							_turns = 0;
							
							_testModel.currentTile = _board.GetTile( 5, 5 );
							_testModel.MoveTo( _testModel.currentTile.GetXPosition(), _testModel.currentTile.GetYPosition(), _testModel.currentTile.GetZPosition() );
							
							return _fsm.States.GamePlayerTurn;
						}
					},
					GamePlayerTurn:
					{
						onStartUp: function():void // handler
						{
							_board.CommandAllTiles("onEnable");
							_board.CommandTile( _testModel.currentTile.GetData().x, _testModel.currentTile.GetData().y, "onDisable");							
						},
						onPlayerDone: function():Object
						{
							PlayerTurn( );
							return _fsm.States.GameAiTurn;
						}
					},
					GameAiTurn:
					{
						onStartUp: function():Object // handler
						{
							_board.CommandAllTiles("onDisable");
							if( AITurn( ) )
								return _fsm.States.GameEnd;
							_fsm.Fire("onAiDone");
							return null;
						},
						onAiDone: function():Object
						{
							_turns++;
							_board.CommandAllTiles("onFade");
							return _fsm.States.GamePlayerTurn;
						}
					},
					GameEnd:
					{
						onStartUp: function():void // handler
						{
							_fsm.Fire("onRestart");
						},
						onRestart: function():Object
						{
							return _fsm.States.GameSetUp;
						}
					}
				});
			
			_fsm.Start();			
		}
		
		public function PlayerTurn( ):void
		{
			
		}
		
		public function AITurn( ):Boolean
		{
			var tile:Tile = _testModel.currentTile;
			var direction:Array = [ tile.northWest, tile.northEast, tile.east, tile.southEast, tile.southWest, tile.west ];
			
			// check for freedom
			for( var i:int = 0; i < 6; i++ ) {
				if( direction[i] == null ) {
					Lose( );
					return true;
				}
			}
			
			// check for trapped
			for( i = 0; i < 6; i++ ) {
				if( direction[i].isOpen() ) {
					break;
				}
			}
			if( i == 6 ) {
				Win( );
				return true;
			}
			
			tile = _board.CalculatePath( tile, null );
			
			_testModel.currentTile = tile;
			_testModel.MoveTo( tile.GetXPosition(), tile.GetYPosition(), tile.GetZPosition() );
			
			return false;
		}
		
		public function Win( ):void
		{
			trace("win");
			_level++;
			_score += Math.max( 100, (1000 - _turns*10) );
			trace("score: " + _score);
		}
		
		public function Lose( ):void
		{
			trace("lose");
			_level = 1;
			_score = 0;
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
			_testModel.SetRotation( 0, 1, 0 );
		}
		
	}
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      