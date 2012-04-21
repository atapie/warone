package logic.soldier 
{
	import common.Config;
	import common.Constants;
	import common.Utils;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author ...
	 */
	public class BossStrength extends BaseSoldier 
	{
		[Embed(source = "../../../assets/dragon_knight.png")] private static const BOSS_STRENGTH_SRC:Class;
		private static const BOSS_STRENGTH_IMG:BitmapData = FP.getBitmap(BOSS_STRENGTH_SRC);
		private static const BOSS_STRENGTH_IMG_FLIPPED:BitmapData = Utils.getFlippedBitmap(BOSS_STRENGTH_IMG);
		public static const DISPLAY_IMG:Image = new Image(BOSS_STRENGTH_IMG, new Rectangle(0, 0, 64, 64));
		
		public function BossStrength(team:int, cell:int, startAnim:String) 
		{
			// Init sprite map
			var sprBossStrength:Spritemap = new Spritemap(BOSS_STRENGTH_IMG, 64, 64);
			sprBossStrength.add(ANIM_STAND, [4], 1, false);
			sprBossStrength.add(ANIM_WALK, [0,1,2,3], 0.4, true);
			sprBossStrength.add(ANIM_ATTACK, [4,5,6,7], 0.6, false);
			if (team == Constants.TEAM_2) sprBossStrength.setFlipped(true, BOSS_STRENGTH_IMG_FLIPPED);
			graphic = sprBossStrength;
			
			// Init base info
			config = Config.instance().getConfig(BaseSoldier.SOLDIER_BOSS_STRENGTH_ID);
			health = config.baseHealth;
			
			super(team, cell, startAnim);
		}
		
	}

}