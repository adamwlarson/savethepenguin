package
{
	public class Level
	{
		private var _running:Boolean = false;
		protected var _engine:Engine;
		
		public function Level()
		{
		}
		
		public function Initialize( engine:Engine ):void
		{
			_engine = engine;
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