package logic 
{
	import common.Constants;
	import logic.soldier.BaseSoldier;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	/**
	 * ...
	 * @author 
	 */
	public class BattleLogic 
	{
		private static var _instance:BattleLogic;
		public static const BATTLE_STATE_STOPPED:int = 0;
		public static const BATTLE_STATE_STARTED:int = 1;
		
		public var state:int;
		public var time:int;			// by frames
		public var castleHealth:Object = new Object();
		public var castleHealthOrigin:Object = new Object();
		
		private var troops:Object = new Object();		
		
		private function init():void
		{
			state = BATTLE_STATE_STOPPED;			
			troops[Constants.TEAM_1] = new Object();
			troops[Constants.TEAM_2] = new Object();
			for (var i:int = 0; i < Constants.CELL_ROW; i++)
			{
				troops[Constants.TEAM_1][i] = new Array();
				troops[Constants.TEAM_2][i] = new Array();
			}
		}
		
		public static function instance():BattleLogic
		{
			if (_instance == null)
			{
				_instance = new BattleLogic();
				_instance.init();
			}
			return _instance;
		}
		
		public function update():void 
		{
			switch(state)
			{
				case BATTLE_STATE_STOPPED:
					if (Input.released(Key.ENTER))
					{
						reset();
						state = BATTLE_STATE_STARTED;
						trace("Battle started!");
					}
					break;
				case BATTLE_STATE_STARTED:
					time++;
					break;
			}
			
		}
		
		private function reset():void 
		{
			time = 0;
			castleHealth[Constants.TEAM_1] = 5000;
			castleHealth[Constants.TEAM_2] = 5000;
			castleHealthOrigin[Constants.TEAM_1] = 5000;
			castleHealthOrigin[Constants.TEAM_2] = 5000;
		}
		
		public function addTroop(troop:BaseSoldier):void
		{
			(troops[troop.team][troop.lane] as Array).push(troop);
		}	
		
		public function removeTroop(troop:BaseSoldier):void
		{
			var troopList:Array = troops[troop.team][troop.lane] as Array;
			for (var i:int = 0; i < troopList.length; i++)
			{
				if (troopList[i] == troop)
				{
					troopList.splice(i, i+1);
					return;
				}
			}
		}
		
		public function getTroops(team:int, lane:int):Array
		{
			return troops[team][lane] as Array;
		}
	}

}