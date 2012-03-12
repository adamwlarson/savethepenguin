package
{
	public class Water extends AnimatedModel
	{
		public function Water( engine:Engine )
		{
			
			SetModel("WaterTest", engine );
			_obj.setLayer(10); // alpha layer
			SetPosition(-40, -24, 200 );
			//SetPosition(-40, 10, 200 );
			AddAnimation("wave", 0, 44 );
			_PlayAnimation("wave", 5, true );
			
		}
	}
}