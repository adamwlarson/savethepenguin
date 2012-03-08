package
{	
	
	public class FiniteStateMachine
	{
		// layout...
		// Default States are Init
		// Default Handlers are onStartUp and onExit
		
		private var _DefaultStates:Object = 
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
		
		public var States:Object = _DefaultStates;
		private var _CurrentState:Object = null;
		private var _LastState:Object = null;
		private var _Started:Boolean = false;
		
		public function FiniteStateMachine( states:Object=null )
		{	
			if( states == null ) states = _DefaultStates;
			this.States = states;			
		}
		public function Start( ):void
		{
			if( _Started ) return; // exit			
			_Started = true;
			
			if( States.propertyIsEnumerable( "Init" ) )
			{
				_CurrentState = States["Init"];
				RunStateHandler( "onStartUp" );
				return; // exit
			}
			
			trace("no Init State !!!");
		}
		public function Fire( handler:String ):void
		{
			RunStateHandler( handler );	
		}		
		public function GetLastState():Object
		{
			return _LastState;
		}
		//------------------------------------------------------------------------------
		private function RunStateHandler( handler:String ):Boolean
		{			
			var result:Object = RunHandler( handler );
			
			if( result is Object ) // change state
			{
				_LastState = _CurrentState;
				RunHandler("onExit"); // can't change state onExit
				_CurrentState = result;
				RunStateHandler("onStartUp"); // run next states startup
				return true;
			}
			
			return false;				
		}		
		private function RunHandler( handler:String ):Object
		{
			if( _CurrentState == null) 
			{
				trace("Make sure you start first");
				return null;
			}
			
			if( !_CurrentState.propertyIsEnumerable( handler ))
				return null;
			
			return _CurrentState[handler]();
		}		
	}
}