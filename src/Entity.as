package
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Entity extends AnimatedModel
	{
		private var moveToCallBack:Function; // TODO roll this into a class
		private var moveToX:Number;
		private var moveToY:Number;
		private var moveToZ:Number;
		private var startX:Number;
		private var startY:Number;
		private var startZ:Number;
		private var tic:Timer;
		private var step:Number;
		
		public function Entity()
		{
			super();
			tic = new Timer(30);			
		}		
		
		public function MoveTo( x:Number, y:Number, z:Number, ms:Number=250, callback:Function=null ):void
		{
			moveToCallBack = callback;			
			moveToX = x;
			moveToY = y;
			moveToZ = z;
			
			startX = GetXPosition();
			startY = GetYPosition();
			startZ = GetZPosition();
			
			step = 10/ms;			
			tic.start();
			tic.repeatCount = ms/10 + 1;
			
			tic.addEventListener(TimerEvent.TIMER, Update);
			tic.addEventListener(TimerEvent.TIMER_COMPLETE, End);	
			
		}
		public function Update( event:TimerEvent ):void
		{
			trace("update");
			this.SetPosition(	startX+(moveToX-startX)*step*tic.currentCount,
								startY+(moveToY-startY)*step*tic.currentCount,
								startZ+(moveToZ-startZ)*step*tic.currentCount );
			
		}
		public function End( event:TimerEvent ):void
		{
			
			this.SetPosition( moveToX, moveToY, moveToZ );
			trace("end");
			if(moveToCallBack!=null) moveToCallBack();
			tic.reset();
			tic.removeEventListener(TimerEvent.TIMER, Update);
			tic.removeEventListener(TimerEvent.TIMER_COMPLETE, End);
		}
		
		
	}
}