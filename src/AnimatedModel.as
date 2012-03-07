package
{

	import flare.core.Label3D;
	import flare.core.Pivot3D;
	
	public class AnimatedModel extends Model
	{
		public function AnimatedModel()
		{
			super();
		}
		
		public function PlayAnimation( src:String, blend:int ):void
		{
			_obj.gotoAndPlay( src, blend );
		}
		
		public function AddAnimation( src:String, start:Number, end:Number, loop:Boolean ):void
		{
			_obj.addLabel( new Label3D( src, start, end ) );
		}
	}
}