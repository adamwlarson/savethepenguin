package
{
	
	public class StaticModel
	{
		private var _func:Function;
		private var _loaded:Boolean = false;
		
		public function StaticModel()
		{
		}
		
		//Load the Mesh
		public function LoadOBJ( src:String, engine:Engine, func:Function ):void
		{
			_func = func;
		}
	}
}