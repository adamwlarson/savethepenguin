package
{			
	import flare.events.MouseEvent3D;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;	
	
	public class Tile extends StaticModel
	{
		static private var _count:int = 0; // debug
		
		public var northWest:Tile = null;
		public var northEast:Tile = null;
		public var east:Tile = null;
		public var southEast:Tile = null;
		public var southWest:Tile = null;
		public var west:Tile = null;
		public var ed:EventDispatcher = new EventDispatcher();
		public var fsm:FiniteStateMachine;
		
		private var _data:Object;
		private var _open:Boolean = true;
		private var _visited:int = 0;
		private var _fade:int = 0;
		
		//private var _model:StaticModel = new StaticModel();		
		
		public function Tile( engine:Engine, xPos:int, yPos:int, data:Object=null )
		{
			super();
			
			_count++; // debug count for tiles

			_data = data; // tile specific data
			SetModel( "TileModel", engine );	
			SetPosition( xPos-14, -20, yPos-14 );	
			
			//var me:Tile = this;
			// state machine
			fsm = new FiniteStateMachine(
				{
					Init: // state
					{
						onStartUp: function():Object // handler
						{
							SetTexture("Tile_Normal", engine );
							_open = true;
							return fsm.States.Enable;
						}
					},
					Enable: // state
					{
						onStartUp: function():void // handler
						{
							_visited = -1;
						},
						onMouseOut: function():void
						{
							SetTexture("Tile_Normal", engine );
						},
						onMouseOver: function():void
						{
							SetTexture("Tile_Select", engine );
						},
						onMouseClick: function():Object
						{
							return fsm.States.TileUsed;
						},
						onDisable: function():Object
						{
							return fsm.States.Disable;
						},
						onReset: function():Object
						{
							return fsm.States.Init;
						},
						onTileUsed: function():Object
						{
							return fsm.States.TileUsed;
						},
						onBlocked: function():Object
						{
							return fsm.States.TileBlocked;
						}
					},
					Disable: // state
					{
						onStartUp: function():void // handler
						{
							
						},
						onEnable: function():Object
						{
							return fsm.States.Enable;
						},
						onReset: function():Object
						{
							return fsm.States.Init;
						}
					},
					TileUsed: // state
					{
						onStartUp: function():void // handler
						{
							_open = false;
							_fade = 6;
							SetTexture("Tile_Break5", engine );
							// fire event
							ed.dispatchEvent(new Event( "Touched", false));
						},
						onReset: function():Object
						{							
							return fsm.States.Init;
						},
						onFade: function():Object
						{
							if( _fade > 0 )
							{
								switch( _fade-- )
								{
									case 4:
										SetTexture("Tile_Break4", engine );
										return null;
									case 3:
										SetTexture("Tile_Break3", engine );
										return null;
									case 2:
										SetTexture("Tile_Break2", engine );
										return null;
									case 1:
										SetTexture("Tile_Break1", engine );
										return null;
									default://5,6
										return null;										
								}
							}
							
							return fsm.States.Enable;					
						},
						onExit: function():void
						{
							SetTexture("Tile_Normal", engine );
							_open = true;
						}
						
					},
					TileBlocked: // state
					{
						onStartUp: function():void // handler
						{
							_open = false;
							SetTexture("Tile_Blocked", engine );							
						},
						onReset: function():Object
						{
							return fsm.States.Init;
						},
						onExit: function():void
						{
							_open = true;
						}
					}
				});	
			
			// handle mouse messages
			AddMouseOverEvent( function ( event:MouseEvent3D ):void
			{
				fsm.Fire("onMouseOver");
			});					
			AddMouseOutEvent( function( event:MouseEvent3D ):void
			{
				fsm.Fire("onMouseOut");				
			});			
			AddMouseClickEvent( function( event:MouseEvent3D ):void
			{
				fsm.Fire("onMouseClick");	
			});

			fsm.Start();
			//trace( _count );			
		}		
		public function isOpen():Boolean
		{
			return this._open;
		}		
		public function GetData():Object
		{
			return this._data;
		}
		public function SetVisited( vis:int ):void
		{
			this._visited = vis;
		}
		public function GetVisited():int
		{
			return this._visited;
		}
		public function SetLink( nw:Tile, ne:Tile, e:Tile, se:Tile, sw:Tile, w:Tile ):void
		{
			if( nw != null ) { this.northWest = nw; nw.southEast = this; }
			if( ne != null ) { this.northEast = ne; ne.southWest = this; }
			if( e != null ) { this.east = e; e.west = this; }
			if( se != null ) { this.southEast = se; se.northWest = this; }
			if( sw != null ) { this.southWest = sw; sw.northEast = this; }
			if( w != null ) { this.west = w; w.east = this; }
		}
		public function CheckNeighbors( find:Tile ):Boolean
		{	
			return  ( this.northWest == find ) ||
				( this.northEast == find ) ||
				( this.east == find ) ||
				( this.southEast == find ) ||
				( this.southWest == find ) ||
				( this.west == find );
		}
		public function FindNextPath( distance:int ):Tile
		{			
			if( this.northWest != null && this.northWest._visited == distance ) {
				return this.northWest;
			}
			if( this.northEast != null && this.northEast._visited == distance ) {
				return this.northEast;
			}
			if( this.east != null && this.east._visited == distance ) {
				return this.east;
			}
			if( this.southEast != null && this.southEast._visited == distance ) {
				return this.southEast;
			}
			if( this.southWest != null && this.southWest._visited == distance ) {
				return this.southWest;
			}
			if( this.west != null && this.west._visited == distance ) {
				return this.west;
			}
			
			trace("could not find next path node");
			return null;
		}
	}
}