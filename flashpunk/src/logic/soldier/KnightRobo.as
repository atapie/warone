package logic.soldier 
{
	import common.Config;
	import common.Constants;
	import common.Utils;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
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
		[Embed(source = "../../../assets/robo_knight.png")] private static const KNIGHT_ROBO_SRC:Class;
		private static const KNIGHT_ROBO_IMG:BitmapData = FP.getBitmap(KNIGHT_ROBO_SRC);
		private static const KNIGHT_ROBO_IMG_FLIPPED:BitmapData = Utils.getFlippedBitmap(KNIGHT_ROBO_IMG);
		public static const DISPLAY_IMG:Image = new Image(KNIGHT_ROBO_IMG_FLIPPED, new Rectangle(KNIGHT_ROBO_IMG_FLIPPED.width - 72, 0, 72, 68));

		public function KnightRobo(team:int, cell:int, startAnim:String) 
		{
			// Init sprite map
			var sprKnightRobo:Spritemap = new Spritemap(KNIGHT_ROBO_IMG, 72, 68);
			sprKnightRobo.add(ANIM_STAND, [0, 1], 0.11, true);
			sprKnightRobo.add(ANIM_WALK, [11, 12], 0.2, true);
			sprKnightRobo.add(ANIM_ATTACK, [33, 34, 35, 36, 37, 38], 0.4, false);
			//sprKnightRobo.add(ANIM_ATTACK, [22,23,24,25,26,27,28,29,30,31,32], 0.4, false);
			if (team == Constants.TEAM_1) sprKnightRobo.setFlipped(true, KNIGHT_ROBO_IMG_FLIPPED);
			graphic = sprKnightRobo;
			
			offsetX = -25 * team;
			offsetY = + 3;
			
			// Init base info
			config = Config.instance().getConfig(BaseSoldier.SOLDIER_KNIGHT_ROBO_ID);
			health = config.baseHealth;
			
			super(team, cell, startAnim);
		}
	}
}