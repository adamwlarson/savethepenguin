package
{
	import flare.basic.*;
	import flare.core.*;
	import flare.core.Texture3D;
	import flare.loaders.*;
	import flare.materials.*;
	import flare.materials.Shader3D;
	import flare.materials.filters.*;
	import flare.materials.filters.AlphaMaskFilter;
	import flare.materials.filters.EnvironmentFilter;
	import flare.materials.filters.NormalMapFilter;
	import flare.materials.filters.SpecularFilter;
	import flare.materials.filters.TextureFilter;
	import flare.system.*;
	
	import flash.display.*;
	
	//Wraps the engine interface into an easy to use and easy to replace class
	public class Engine
	{
		private var _scene:Scene3D; // Viewer3D for debug camera
		private var _modelList:Array = new Array(); // hold all the loaded models
		private var _shaderList:Array = new Array(); // hold all the textures
		
		public function Engine()
		{
			
		}
		
		public function Initialize(container:DisplayObjectContainer, x:int, y:int, debug:Boolean=false):void
		{
			// creates a new 3d scene.
			_scene = new Scene3D( container ); // Viewer3D for debug camera
			_scene.antialias = 2;
			_scene.setLayerSortMode(10, Scene3D.SORT_BACK_TO_FRONT); // alpha layer
			if(debug)
			{
				//test lines
				var xline:Lines3D = new Lines3D("x");
				xline.lineStyle( 3, 0xff0000 );//red
				var yline:Lines3D = new Lines3D("y");
				yline.lineStyle( 3, 0x00ff00 );//green
				var zline:Lines3D = new Lines3D("z");
				zline.lineStyle( 3, 0x0000ff );//blue
				
				xline.moveTo(0, 0, 0);
				xline.lineTo(100, 0, 0 );
				yline.moveTo(0, 0, 0);
				yline.lineTo(0, 100, 0 );
				zline.moveTo(0, 0, 0);
				zline.lineTo(0, 0, 100 );
				
				_scene.addChild( xline );
				_scene.addChild( yline );
				_scene.addChild( zline );
			}
		}
		
		public function GetScene( ):Scene3D // Viewer3D for debug camera
		{
			return _scene;
		}
		
		public function Render( ):void
		{

		}
		
		public function LoadTexture( src:String, name:String ):void
		{
			var shader:Shader3D = new Shader3D( name );
			shader.filters.push( new TextureFilter(new Texture3D( src ) ) );
			shader.build();
			_shaderList[_shaderList.length] = { shader: shader };// other load texture values go in this object
			
		}
		
		public function LoadNormalTexture( src:String, normal:String, name:String ):void
		{
			var shader:Shader3D = new Shader3D(  name, null, false);
			shader.filters.push( new TextureFilter(new Texture3D( src ) ) );
			//shader.filters.push( new NormalMapFilter(new Texture3D( normal ) ) );
			//shader.filters.push( new SpecularFilter( ) );
			//shader.filters.push( new EnvironmentFilter( new Texture3D( "http://wiki.flare3d.com/demos/resources/reflections.jpg" ), BlendMode.MULTIPLY, 1.5 ) );
			//shader.filters[1].repeatX = 4;
			//shader.filters[1].repeatY = 4;
			shader.build();
			_shaderList[_shaderList.length] = { shader: shader };// other load texture values go in this object
			
		}
		
		public function LoadAlphaTexture( src:String, name:String, alpha:Number=1.0 ):void
		{
			var shader:Shader3D = new Shader3D( name, null, false, Shader3D.VERTEX_SKIN );
			shader.filters.push( new TextureFilter(new Texture3D( src ) ) );
			shader.filters.push( new AlphaMaskFilter( alpha ) );
			shader.build();
			shader.twoSided = true;
			_shaderList[_shaderList.length] = { shader: shader };// other load texture values go in this object
		}
		
		public function GetTexture( name:String ):Material3D
		{
			var shader:Shader3D;
			if( _shaderList.some( function( item:*, index:int, array:Array ):Boolean {
				// search for texture by name
				if( item.shader.name == name )
				{
					shader = item.shader;
					return true;
				}
				return false;
			}) )
			{
				// material found
				var mat:Material3D = shader.clone();
				return mat;
			}
			
			// no texture found
			return null;
		}
		
		public function LoadModel( src:String, name:String ):void
		{
			
			var model:Pivot3D = new Pivot3D( );
			model = this.GetScene().addChildFromFile( src );
			model.visible = false;
			model.name = name;
			_modelList[_modelList.length] = { model: model }; // other load model values go in this object
		}
		
		public function GetModel( name:String ):Pivot3D
		{
			var model:Pivot3D;
			if( _modelList.some( function( item:*, index:int, array:Array ):Boolean {
				// search for model by name
				if( item.model.name == name )
				{
					model = item.model;
					return true;
				}
				return false;
			}) )
			{
				// model found, clone it
				model = model.clone();
				model.visible = true;
				this.GetScene().addChild( model );
				return model;
			}
			
			// no model found
			return null;
		}
		
		public function SetLoadedCallback( func:Function ):void
		{
			_scene.addEventListener( Scene3D.COMPLETE_EVENT, func );
			
		}
	}
}