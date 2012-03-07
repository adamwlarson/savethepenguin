package
{			
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flare.events.MouseEvent3D;	
	
	public class Tile
	{
		static private var _count:int = 0; // debug
		
		public var northWest:Tile = null; // TODO make gets for these public directions
		public var northEast:Tile = null;
		public var east:Tile = null;
		public var southEast:Tile = null;
		public var southWest:Tile = null;
		public var west:Tile = null;
		public var ed:EventDispatcher = new EventDispatcher(); // TODO make public wrapper function, not the best way?
		public var fsm:FiniteStateMachine;// TODO not the best way? should this be pulic
		
		private var _data:Object = null;
		private var _open:Boolean = true;
		private var _visited:int = 0;
		
		private var _model:StaticModel = new StaticModel();		
		
		public function Tile( engine:Engine, xPos:int, yPos:int, data:Object=null )
		{
			_count++; // debug count for tiles
						
			_model.GetModel( "TilePiece01.f3d", engine );			
			_model.SetPosition( xPos, 0, yPos );	
			
			_model.AddMouseOverEvent( function ( event:MouseEvent3D ):void
			{
				fsm.Fire("onMouseOver");
			});
					
			_model.AddMouseOutEvent( function( event:MouseEvent3D ):void
			{
				fsm.Fire("onMouseOut");				
			});
			
			_model.AddMouseClickEvent( function( event:MouseEvent3D ):void
			{
				fsm.Fire("onMouseClick");	
			});
			
			_data = data; // tile specific data, TODO move directional data here
			
			fsm = new FiniteStateMachine(
				{
					Init: // state
					{
						onStartUp: function():Object // handler
						{
							_model.SetTexture("Assets/IcePiece.jpg");
							_visited = 0;
							_open = true;
							return fsm.States.Enable;
						}
					},
					Enable: // state
					{
						onStartUp: function():void // handler
						{
							
						},
						onMouseOut: function():void
						{
							_model.SetTexture("Assets/IcePiece.jpg");							
						},
						onMouseOver: function():void
						{
							_model.SetTexture("Assets/Tile_Select.jpg");
						},
						onMouseClick: function():Object
						{
							// fire event
							ed.dispatchEvent(new Event( "Touched", false));
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
							_model.SetTexture("Assets/Tile_break_Lv5.jpg");
						},
						onClear: function():Object
						{
							return fsm.States.Enable;
						},
						onReset: function():Object
						{
							return fsm.States.Init;
						},
						onFade: function():void
						{
							_model.SetTexture("Assets/Tile_break_Lv1.jpg");
						}
						
					},
					TileBlocked: // state
					{
						onStartUp: function():void // handler
						{
							_open = false;
							_model.SetTexture("Assets/Tile_Block.jpg");
							
						},
						onClear: function():Object
						{
							return fsm.States.Enable;
						},
						onReset: function():Object
						{
							return fsm.States.Init;
						}
					}
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