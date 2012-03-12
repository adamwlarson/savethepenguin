package
{
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.events.MouseEvent3D;
	import flare.materials.Material3D;
	import flare.materials.Shader3D;
	
	import flash.events.Event;
	
	public class Model
	{
		protected var _obj:Pivot3D;
		
		public function Model()
		{
				
		}		
		
		public function SetModel( src:String, engine:Engine ):void
		{
			_obj = engine.GetModel( src );			
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
		
		public function GetXPosition( ):Number
		{
			return _obj.x;
		}
		public function GetYPosition( ):Number
		{
			return _obj.y;
		}
		public function GetZPosition( ):Number
		{
			return _obj.z;
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
			_obj.children[0].addEventListener( MouseEvent3D.MOUSE_MOVE, fun );
			/*_obj.forEach( function addEvent( mesh:Mesh3D ):void
			{
				mesh.addEventListener( MouseEvent3D.MOUSE_MOVE, fun );
			}, Mesh3D );*/		
		}
				
		public function AddMouseOutEvent( fun:Function ):void
		{
			_obj.children[0].addEventListener( MouseEvent3D.MOUSE_OUT, fun );
			/*_obj.forEach( function addEvent( mesh:Mesh3D ):void
			{
				mesh.addEventListener( MouseEvent3D.MOUSE_OUT, fun );
			}, Mesh3D );*/			
		}
		
		public function AddMouseClickEvent( fun:Function ):void
		{
			_obj.children[0].addEventListener( MouseEvent3D.CLICK, fun );
			/*_obj.forEach( function addEvent( mesh:Mesh3D ):void
			{
				mesh.addEventListener( MouseEvent3D.CLICK, fun );
			}, Mesh3D );*/
		}
		
		public function SetTexture( src:String, engine:Engine ):void
		{
			_obj.setMaterial( engine.GetTexture( src ) );
		}
	}
}