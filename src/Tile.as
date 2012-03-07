package
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	
	public class Tile
	{
		static private var _count:int = 0; // debug
		
		//static private var _matUnselected:ColorMaterial = new ColorMaterial( 0x0000FF );
		//static private var _matSelected:ColorMaterial = new ColorMaterial(  0x000000 );
		//static private var _matBlocked:ColorMaterial = new ColorMaterial(  0xFF0000 );
		
		public var northWest:Tile = null; // TODO make gets for these public directions
		public var northEast:Tile = null;
		public var east:Tile = null;
		public var southEast:Tile = null;
		public var southWest:Tile = null;
		public var west:Tile = null;
		private var _data:Object = null;
		private var _open:Boolean = true;
		private var _visited:int = 0;
		public var ed:EventDispatcher = new EventDispatcher(); // TODO make public raper function, not the best way?
		public var fsm:FiniteStateMachine; // not the best way?
		
		public function Tile( xPos:int, yPos:int, data:Object=null, radius:int=60 )
		{
			_count++; // debug count for tiles
			
			_data = data; // tile specific data, TODO move directional data here
			
			//var polygon:RegularPolygon = new RegularPolygon({ radius:radius, sides: 6 });
			//polygon.rotationY = 90;
			//polygon.position = new Vector3D( xPos-(radius>>1), 0, yPos+(radius>>1));
			
			fsm = new FiniteStateMachine(
				{
					Init: // state
					{
						onStartUp: function():Object // handler
						{
							//polygon.material = _matUnselected;
							//polygon.ownCanvas = true;
							//polygon.alpha = 1.00;
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
							//polygon.material = _matUnselected;
						},
						onMouseOver: function():void
						{
							//polygon.material = _matSelected;
						},
						onMouseClick: function():Object
						{
							// fire event
							ed.dispatchEvent(new Event( "Touched", false));
							return fsm.States.TileBlocked;
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
					/*TileUsed: // state
					{
						onStartUp: function():void // handler
						{
							
						},
						onClear: function():Object
						{
							return fsm.States.Enable;
						},
						onReset: function():Object
						{
							return fsm.States.Init;
						}
						
					},*/
					TileBlocked: // state
					{
						onStartUp: function():void // handler
						{
							_open = false;
							//polygon.material = _matBlocked;
						},
						onClear: function():Object
						{
							return fsm.States.Enable;
						},
						onFade: function():void
						{
							//polygon.alpha =polygon.alpha-0.10;
						},
						onReset: function():Object
						{
							return fsm.States.Init;
						}
					}
				});
			
			/*polygon.addOnMouseOut( function( event:MouseEvent3D ):void {
				fsm.Fire("onMouseOut");				
			});
			polygon.addOnMouseOver( function( event:MouseEvent3D ):void {
				fsm.Fire("onMouseOver");
				//trace( polygon.position.x + ", " + polygon.position.y + ", " + polygon.position.z );				
			});
			polygon.addOnMouseDown( function( event:MouseEvent3D ):void {					
				fsm.Fire("onMouseClick");
				//trace( "click" );				
			});			
			
			scene.addChild(polygon);*/
			fsm.Start();
			//trace( count );			
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