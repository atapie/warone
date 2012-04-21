package common 
{
	import common.config.SoldierConfig;
	import logic.soldier.BaseSoldier;
	import logic.soldier.KnightRobo;
	/**
	 * ...
	 * @author ...
	 */
	public class Config 
	{
		private static var _instance:Config;
		
		private var soldierConfig:Array;		
		
		public function Config() 
		{
			soldierConfig = new Array();
			
			var knightRoboConfig:SoldierConfig = new SoldierConfig();
			knightRoboConfig.id = BaseSoldier.SOLDIER_KNIGHT_ROBO_ID;
			knightRoboConfig.sizeWidth = 1;
			knightRoboConfig.sizeHeight = 1;
			knightRoboConfig.baseHealth = 100;
			knightRoboConfig.damage = 25;
			knightRoboConfig.moveSpeed = 1;						// px per frame
			knightRoboConfig.attackSpeed = 25;					// frame per hit
			knightRoboConfig.attackRange = 0;					// attack range in pixels
			knightRoboConfig.rowAttack = 1;
			soldierConfig[knightRoboConfig.id] = knightRoboConfig;
			
			var knightLanceConfig:SoldierConfig = new SoldierConfig();
			knightLanceConfig.id = BaseSoldier.SOLDIER_KNIGHT_LANCE_ID;
			knightLanceConfig.sizeWidth = 2;
			knightLanceConfig.sizeHeight = 1;
			knightLanceConfig.baseHealth = 200;
			knightLanceConfig.damage = 40;
			knightLanceConfig.moveSpeed = 1;						// px per frame
			knightLanceConfig.attackSpeed = 25;					// frame per hit
			knightLanceConfig.attackRange = 0;					// attack range in pixels
			knightLanceConfig.rowAttack = 2;						// number of unit can attack in a row
			soldierConfig[knightLanceConfig.id] = knightLanceConfig;
			
			var bossStrengthConfig:SoldierConfig = new SoldierConfig();
			bossStrengthConfig.id = BaseSoldier.SOLDIER_BOSS_STRENGTH_ID;
			bossStrengthConfig.sizeWidth = 2;
			bossStrengthConfig.sizeHeight = 2;
			bossStrengthConfig.baseHealth = 1000;
			bossStrengthConfig.damage = 20;
			bossStrengthConfig.moveSpeed = 1;						// px per frame
			bossStrengthConfig.attackSpeed = 25;					// frame per hit
			bossStrengthConfig.attackRange = 0;					// attack range in pixels
			bossStrengthConfig.rowAttack = 1;						// number of unit can attack in a row
			soldierConfig[bossStrengthConfig.id] = bossStrengthConfig;
		}
		
		public static function instance():Config
		{
			if (_instance == null) _instance = new Config();
			return _instance;
		}
		
		public function getConfig(soldierId:int):SoldierConfig
		{
			return soldierConfig[soldierId] as SoldierConfig;
		}
		
	}

}