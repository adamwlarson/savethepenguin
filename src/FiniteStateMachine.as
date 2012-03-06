package
{	
	
	public class FiniteStateMachine
	{
		// layout...
		// Default States are Init
		// Default Handlers are onStartUp and onExit
		
		private var DefaultStates:Object = 
		{			
			Init: // state, must have this
			{
				onStartUp: function():Object // handler, must have this atleast for the Init State
				{
					return States.NextState; // change state		
				},
				onExit: function():void // handler
				{
					
				}
			},
			NextState: // state
			{
				onStartUp: function():void // handler
				{
					
				},
				doSomething: function():Object // handler
				{
					return GetLastState(); // move back to last state
				}
			}
		};
		
		public var States:Object = DefaultStates;
		private var CurrentState:Object;
		private var LastState:Object;
		private var Started:Boolean = false;
		
		public function FiniteStateMachine( states:Object=null )
		{	
			if( states == null ) states = DefaultStates;
			this.States = states;			
		}
		public function Start( ):void
		{
			if( Started ) return; // exit			
			Started = true;
			
			if( States.propertyIsEnumerable( "Init" ) )
			{
				CurrentState = States["Init"];
				RunStateHandler( "onStartUp" );
				return; // exit
			}
			
			//trace("no Init State !!!");
		}
		public function Fire( handler:String ):void
		{
			RunStateHandler( handler );	
		}		
		public function GetLastState():Object
		{
			return LastState;
		}
		//------------------------------------------------------------------------------
		private function RunStateHandler( handler:String ):Boolean
		{			
			var result:Object = RunHandler( handler );
			
			if( result is Object ) // change state
			{
				LastState = CurrentState;
				RunHandler("onExit"); // can't change state onExit
				CurrentState = result;
				RunStateHandler("onStartUp"); // run next states startup
				return true;
			}
			
			return false;				
		}		
		private function RunHandler( handler:String ):Object
		{
			if( !CurrentState.propertyIsEnumerable( handler ))
				return null;
			
			return CurrentState[handler]();
		}		
	}
}