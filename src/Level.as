package
{
	public class Level
	{
		public var _running:Boolean = false;
		
		public function Level()
		{
		}
		
		public function Initialize( engine:Engine ):void
		{
			_running = true;
		}
		
		public function IsLoading( ):Boolean
		{
			return _running;
		}
		
		public function DoneLoading( ):void
		{
			_running = false;
		}
		
		public function Update( ):void
		{
			
		}
	}
}