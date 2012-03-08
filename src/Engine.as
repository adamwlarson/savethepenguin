package
{
	import flare.basic.*;
	import flare.core.*;
	import flare.core.Texture3D;
	import flare.loaders.*;
	import flare.materials.*;
	import flare.materials.Shader3D;
	import flare.materials.filters.TextureFilter;
	import flare.system.*;
	
	import flash.display.*;
	
	//Wraps the engine interface into an easy to use and easy to replace class
	public class Engine
	{
		private var _scene:Scene3D; // Viewer3D for debug camera
		private var _modelList:Array = new Array(); // hold all the loaded models
		private var _textureList:Array = new Array(); // hold all the textures
		
		public function Engine()
		{
			
		}
		
		public function Initialize(container:DisplayObjectContainer, x:int, y:int):void
		{
			// creates a new 3d scene.
			_scene = new Scene3D( container ); // Viewer3D for debug camera
			_scene.antialias = 2;
		}
		
		public function GetScene( ):Scene3D // Viewer3D for debug camera
		{
			return _scene;
		}
		
		public function Render( ):void
		{

		}
		
		public function LoadTexture( src:String , name:String ):void
		{
			var material:Shader3D = new Shader3D( name );
			material.filters.push( new TextureFilter(new Texture3D( src ) ) );
			material.build();
			material.name;
			_textureList[_textureList.length] = { material: material };// other load texture values go in this object
			
		}
		
		public function GetTexture( name:String ):Shader3D
		{
			var material:Shader3D;
			if( _textureList.some( function( item:*, index:int, array:Array ):Boolean {
				// search for texture by name
				if( item.material.name == name )
				{
					material = item.material;
					return true;
				}
				return false;
			}) )
			{
				// material found
				return material;
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