package logic.soldier 
{
	import common.Constants;
	import common.Utils;
	import flash.display.BitmapData;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author ...
	 */
	public class KnightLance extends BaseSoldier
	{
		[Embed(source = "../../../assets/dragon_knight.png")] private static const KNIGHT_LANCE_SRC:Class;
		private static const KNIGHT_LANCE_IMG:BitmapData = FP.getBitmap(KNIGHT_LANCE_SRC);
		private static const KNIGHT_LANCE_IMG_FLIPPED:BitmapData = Utils.getFlippedBitmap(KNIGHT_LANCE_IMG);
		
		public function KnightLance(team:int, cell:int, startAnim:String) 
		{
			// Init sprite map
			var sprKnightLance:Spritemap = new Spritemap(KNIGHT_LANCE_IMG, 64, 64);
			sprKnightLance.add(ANIM_STAND, [4], 1, false);
			sprKnightLance.add(ANIM_WALK, [0,1,2,3], 0.4, true);
			sprKnightLance.add(ANIM_ATTACK, [4,5,6,7], 0.6, false);
			if (team == Constants.TEAM_2) sprKnightLance.setFlipped(true, KNIGHT_LANCE_IMG_FLIPPED);
			graphic = sprKnightLance;
			
			// Init base info
			sizeWidth = 2;
			sizeHeight = 1;
			health = 200;
			damage = 40;
			moveSpeed = 1;						// px per frame
			attackSpeed = 25;					// frame per hit
			attackRange = 0;	// attack range in pixels
			rowAttack = 2;						// number of unit can attack in a row
			
			super(team, cell, startAnim);
		}
		
	}

}