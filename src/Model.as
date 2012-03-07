package
{
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.core.Texture3D;
	import flare.events.MouseEvent3D;
	import flare.materials.Shader3D;
	import flare.materials.filters.TextureFilter;
	
	
	public class Model
	{
		protected var _obj:Pivot3D;
		
		public function Model()
		{
		}
		
		//Load the Mesh
		public function GetModel( src:String, engine:Engine ):void
		{
			_obj = engine.GetClone( src );			
		}
		
		public function Hide( ):void
		{
			_obj.visible = false;
		}			
		
		public function Show( ):void
		{
			_obj.visible = true;
		}
		
		public function SetPosition( x:Number, y:Number, z:Number ):void
		{
			_obj.x = x;
			_obj.y = y;
			_obj.z = z;
		}
		
		public function SetRotation( x:Number, y:Number, z:Number ):void
		{
			_obj.rotateX( x );
			_obj.rotateY( y );
			_obj.rotateZ( z );
		}
		
		public function SetScale( x:Number, y:Number, z:Number ):void
		{
			_obj.scaleX = x;
			_obj.scaleY = y;
			_obj.scaleZ = z;
		}
		
		public function AddMouseOverEvent( fun:Function ):void
		{
			_obj.forEach( function addEvent( mesh:Mesh3D ):void
			{
				mesh.addEventListener( MouseEvent3D.MOUSE_OVER, fun );
			}, Mesh3D );			
		}
				
		public function AddMouseOutEvent( fun:Function ):void
		{
			_obj.forEach( function addEvent( mesh:Mesh3D ):void
			{
				mesh.addEventListener( MouseEvent3D.MOUSE_OUT, fun );
			}, Mesh3D );			
		}
		
		public function AddMouseClickEvent( fun:Function ):void
		{
			_obj.forEach( function addEvent( mesh:Mesh3D ):void
			{
				mesh.addEventListener( MouseEvent3D.CLICK, fun );
			}, Mesh3D );
		}
		
		public function SetTexture( src:String ):void // for now we load the texture over and over again...
		{
			var material:Shader3D = new Shader3D( "mat");
			material.filters.push( new TextureFilter(new Texture3D( src ) ) );
			material.build();
			_obj.setMaterial( material );
		}
	}
}