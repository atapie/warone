package common 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author ...
	 */
	public class Utils 
	{
		public static const CELL_START_POINT:Point = new Point(60, 230);
		public static const BASE_ZONE_DISTANCE:int = 50;
		
		public static function getFlippedBitmap(source:BitmapData):BitmapData
		{
			var flip:BitmapData = new BitmapData(source.width, source.height, true, 0);
			FP.matrix.identity();
			FP.matrix.a = -1;
			FP.matrix.tx = source.width;
			flip.draw(source, FP.matrix);
			return flip;
		}
		
		public static function getCellFrom(row:int, col:int):int
		{
			if (row < 0 || row >= Constants.CELL_ROW || col < 0 || col >= Constants.CELL_COLUMN) return -1;
			else return row * Constants.CELL_COLUMN + col;
		}
		
		public static function getCellFromPos(x:Number, y:Number):int
		{
			var col:int = Math.floor((x - CELL_START_POINT.x) / Constants.CELL_SIZE);
			var row:int = Math.floor((y - CELL_START_POINT.y) / Constants.CELL_SIZE);
			
			if (col >= Constants.CELL_COLUMN / 2)
			{
				var newCol:int = Math.floor((x - CELL_START_POINT.x - BASE_ZONE_DISTANCE) / Constants.CELL_SIZE);
				if (newCol >= Constants.CELL_COLUMN / 2) col = newCol;
				else col = -1;
			}
			
			return getCellFrom(row, col);
		}
		
		public static function getPosFrom(row:int, col:int):Point
		{
			var result:Point = new Point();
			result.x = CELL_START_POINT.x + col * Constants.CELL_SIZE + Constants.CELL_SIZE / 2;
			if (col >= Constants.CELL_COLUMN / 2) result.x += BASE_ZONE_DISTANCE;
			result.y = CELL_START_POINT.y + row * Constants.CELL_SIZE;
			return result;
		}
	}

}