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
		[Embed(source = "../../../assets/dragon_knight.png")] private static const KNIGHT_ROBO_SRC:Class;
		private static const KNIGHT_ROBO_IMG:BitmapData = FP.getBitmap(KNIGHT_ROBO_SRC);
		private static const KNIGHT_ROBO_IMG_FLIPPED:BitmapData = Utils.getFlippedBitmap(KNIGHT_ROBO_IMG);

		public function KnightRobo(team:int, cell:int, startAnim:String) 
		{
			// Init sprite map
			var sprKnightRobo:Spritemap = new Spritemap(KNIGHT_ROBO_IMG, 64, 64);
			sprKnightRobo.add(ANIM_STAND, [4], 1, false);
			sprKnightRobo.add(ANIM_WALK, [0,1,2,3], 0.4, true);
			sprKnightRobo.add(ANIM_ATTACK, [4,5,6,7], 0.6, false);
			if (team == Constants.TEAM_2) sprKnightRobo.setFlipped(true, KNIGHT_ROBO_IMG_FLIPPED);
			graphic = sprKnightRobo;
			
			// Init base info
			sizeWidth = 1;
			sizeHeight = 1;
			health = 100;
			damage = 25;
			moveSpeed = 1;						// px per frame
			attackSpeed = 25;					// 10 frame per hit
			attackRange = 0;	// attack range in pixels
			rowAttack = 1;
			
			super(team, cell, startAnim);
		}
	}

}