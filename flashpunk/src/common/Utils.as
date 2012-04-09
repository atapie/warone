package common 
{
	import flash.display.BitmapData;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author ...
	 */
	public class Utils 
	{
		public static function getFlippedBitmap(source:BitmapData):BitmapData
		{
			var flip:BitmapData = new BitmapData(source.width, source.height, true, 0);
			FP.matrix.identity();
			FP.matrix.a = -1;
			FP.matrix.tx = source.width;
			flip.draw(source, FP.matrix);
			return flip;
		}
	}

}