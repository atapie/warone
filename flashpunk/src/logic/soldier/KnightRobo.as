package logic.soldier 
{
	import common.Constants;
	import common.Utils;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import logic.BattleLogic;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author 
	 */
	public class KnightRobo extends BaseSoldier 
	{
		[Embed(source = "../../../assets/meerkat.png")] private static const KNIGHT_ROBO_SRC:Class;
		private static const KNIGHT_ROBO_IMG:BitmapData = FP.getBitmap(KNIGHT_ROBO_SRC);
		private static const KNIGHT_ROBO_IMG_FLIPPED:BitmapData = Utils.getFlippedBitmap(KNIGHT_ROBO_IMG);

		public function KnightRobo(team:int, cell:int, startAnim:String) 
		{
			// Init sprite map
			var sprKnightRobo:Spritemap = new Spritemap(KNIGHT_ROBO_IMG, 204, 187);
			sprKnightRobo.add(ANIM_STAND, [0], 1, false);
			sprKnightRobo.add(ANIM_WALK, [1, 2, 3, 4, 5, 6, 7, 8], 0.4, true);
			sprKnightRobo.add(ANIM_ATTACK, [33, 34, 35, 36, 37, 38, 39, 40], 0.6, false);
			sprKnightRobo.scale = 0.5;
			if (team == Constants.TEAM_2) sprKnightRobo.setFlipped(true, KNIGHT_ROBO_IMG_FLIPPED);
			graphic = sprKnightRobo;
			
			// Init base info
			health = 100;
			damage = 25;
			moveSpeed = 1;						// px per frame
			attackSpeed = 25;					// 10 frame per hit
			attackRange = Constants.CELL_SIZE;	// attack range in pixels
			
			super(team, cell, startAnim);
		}
	}

}