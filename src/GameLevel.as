package
{
	import flare.core.Camera3D;
	import flare.core.Light3D;
	import flare.core.Pivot3D;
	import flare.materials.Shader3D;
	
	import flash.events.Event;
	
	public class GameLevel extends Level
	{
		private var _testModel:Penguin;
		private var _board:Board;
		private var _fsm:FiniteStateMachine;
		private var _score:uint = 0;
		private var _level:uint = 0;
		private var _turns:uint = 0;
		private var _water:Water;
		private var _killer:KillerWhale;
		
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
							
							// set light
							var light:Light3D = new Light3D();
							light.setPosition( 0, 300, 0 );
							engine.GetScene().defaultLight.color.setTo(0.3, 0.3, 0.3 );
							engine.GetScene().lights.maxPointLights = 1;
							engine.GetScene().addChild( light )
							
							engine.SetLoadedCallback( Loaded );
							
							// load models
							engine.LoadModel("Assets/Penguin_w_Shadow_02.f3d", "Penguin");
							engine.LoadModel("Assets/TilePiece01.f3d", "TileModel");
							engine.LoadModel("Assets/water_update02.f3d", "WaterTest");
							engine.LoadModel("Assets/KillerWhale.f3d", "Whale");
							
							// Load textures
							engine.LoadTexture("Assets/IcePiece.jpg", "Tile_Normal" );
							engine.LoadTexture("Assets/Tile_Select.jpg", "Tile_Select" );
							engine.LoadTexture("Assets/Tile_Block.jpg", "Tile_Blocked" );
							engine.LoadTexture("Assets/Tile_break_Lv1.jpg", "Tile_Break1" );
							engine.LoadNormalTexture("Assets/Tile_break_Lv2.jpg", "Assets/Tile_breakLv2_Norm.jpg", "Tile_Break2" );
							engine.LoadNormalTexture("Assets/Tile_break_Lv3.jpg", "Assets/Tile_breakLv3_Norm.jpg", "Tile_Break3" );
							engine.LoadNormalTexture("Assets/Tile_break_Lv4.jpg", "Assets/Tile_breakLv4_Norm.jpg", "Tile_Break4" );
							engine.LoadNormalTexture("Assets/Tile_break_Lv5.jpg", "Assets/Tile_breakLv5_Norm.jpg", "Tile_Break5" );
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
							_testModel = new Penguin( engine );
							_testModel.ed.addEventListener("AnimationDone", function():void
							{
								_fsm.Fire("onPenguinAnimDone");
							});
							
							// water
							_water = new Water( engine );
							
							// killer whale
							//_killer = new KillerWhale( engine );
							
							// shadow???

							
							
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
							_testModel.SetPosition( _testModel.currentTile.GetXPosition(), 0, _testModel.currentTile.GetZPosition() );
							_testModel.SetLookAt(0,0,0);
							
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
						onStartUp: function():void
						{
							_board.CommandAllTiles("onDisable");
							AITurn( );								
						},
						onAiDone: function():Object
						{
							_turns++;
							_board.CommandAllTiles("onFade");
							return _fsm.States.GamePlayerTurn;
						},
						onWin: function():Object
						{
							return _fsm.States.Win;
						},
						onLose: function():Object
						{
							return _fsm.States.Lose;
						}
					},
					GameEnd:
					{						
						onStartUp: function():Object // from ending dialog continue game
						{
							return _fsm.States.GameSetUp;						
						}
					},
					Win:
					{
						onPenguinAnimDone: function():Object // win dialog goes here
						{
							return _fsm.States.GameEnd;
						}
					},
					Lose:
					{
						onPenguinAnimDone: function():Object // lose dialog goes here
						{
							return _fsm.States.GameEnd;
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
			_testModel.MoveTo( tile.GetXPosition(), 0, tile.GetZPosition(), function():void{
				_fsm.Fire("onAiDone"); 
			});		
			
			return false;
		}
		
		public function Win( ):void
		{
			trace("win");
			_level++;
			_score += Math.max( 100, (1000 - _turns*10) );
			trace("score: " + _score);
			_fsm.Fire("onLose");
			_testModel.fsm.Fire("onLose");
		}
		
		public function Lose( ):void
		{
			trace("lose");
			_level = 1;
			_score = 0;
			_fsm.Fire("onWin");
			_testModel.fsm.Fire("onDive");
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
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      