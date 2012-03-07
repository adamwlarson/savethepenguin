package
{	
	import flare.core.Texture3D;
	import flare.materials.Material3D;
	import flare.materials.Shader3D;
	import flare.materials.filters.TextureFilter;
	import flare.primitives.Plane;
		
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	
	import flashx.textLayout.conversion.PlainTextExporter;
	
	public class Tile// extends StaticModel
	{
		static private var _count:int = 0; // debug
		
		public var northWest:Tile = null; // TODO make gets for these public directions
		public var northEast:Tile = null;
		public var east:Tile = null;
		public var southEast:Tile = null;
		public var southWest:Tile = null;
		public var west:Tile = null;
		public var ed:EventDispatcher = new EventDispatcher(); // TODO make public raper function, not the best way?
		public var fsm:FiniteStateMachine; // not the best way?
		
		private var _data:Object = null;
		private var _open:Boolean = true;
		private var _visited:int = 0;
		
		private var _model:StaticModel = new StaticModel();
		
		///// TEMP////////////////////////////////////////////////////////////////////////////////
		/*static private var _unSelected:Shader3D = new Shader3D("test1");
		static private var _selected:Shader3D = new Shader3D("test2");
		private var _polygon:Plane;*/
		///// TEMP////////////////////////////////////////////////////////////////////////////////
		
		public function Tile( engine:Engine, xPos:int, yPos:int, data:Object=null, radius:int=60 )
		{
			_count++; // debug count for tiles
			///// TEMP////////////////////////////////////////////////////////////////////////////////
			/*var bmp1:BitmapData = new BitmapData( 1, 1, false, 0x0000FF ); // just for test, but this is making a new bitmap for each tile and overwriting my static var BAD!
			var bmp2:BitmapData = new BitmapData( 1, 1, false, 0xFF0000 );
			
			_unSelected = new Shader3D( "Basic" );
			_unSelected.filters.push( new TextureFilter( new Texture3D(bmp1) ) );
			_unSelected.build();
			
			_selected = new Shader3D( "Basic" );
			_selected.filters.push( new TextureFilter( new Texture3D(bmp2) ) );
			_selected.build();
			
			_polygon = new Plane("tile", radius*2, radius*2, 1, _unSelected, "+xz");
			engine.view.addChild( _polygon );
			
			//_polygon.setMaterial( _selected );
			
			_polygon.x = xPos;
			_polygon.z = yPos;*/
			///// TEMP////////////////////////////////////////////////////////////////////////////////
			
			_model.LoadOBJ("Assets/TilePiece01.f3d", engine, function():void {
				//trace("done");
				//_model._mesh.setScale( 0.50, 0.50, 0.50 );
				_model._mesh.x = xPos;
				_model._mesh.y = 0;
				_model._mesh.z = yPos;
				trace("x: " + xPos + ", y: " + yPos );
				
			});
			
			
			_data = data; // tile specific data, TODO move directional data here
			
			fsm = new FiniteStateMachine(
				{
					Init: // state
					{
						onStartUp: function():Object // handler
						{
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

						},
						onMouseOver: function():void
						{
							
						},
						onMouseOver: function():void
						{
							
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
						},
						onClear: function():Object
						{
							return fsm.States.Enable;
						},
						onFade: function():void
						{
							
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
			});*/

			fsm.Start();
			trace( _count );			
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