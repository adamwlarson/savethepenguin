package
{
	public class Water extends Entity
	{
		public function Water( engine:Engine )
		{
			super(engine);
			
			SetModel("WaterTest", engine );
			//SetTexture("Water", engine );
			_obj.setLayer(10);
			SetPosition(-40, -24, 200 );
			AddAnimation("wave", 0, 44 );
			_PlayAnimation("wave", 5, true );
			
		}
	}
}