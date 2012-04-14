package logic 
{
	import common.Constants;
	import common.Utils;
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
			castleHealth[Constants.TEAM_1] = 1000;
			castleHealth[Constants.TEAM_2] = 1000;
			castleHealthOrigin[Constants.TEAM_1] = 1000;
			castleHealthOrigin[Constants.TEAM_2] = 1000;
		}
		
		public function cellAvailable(team:int, row:int, col:int):Boolean
		{
			if (row < 0 || row >= Constants.CELL_ROW) return false;
			if (col <0 || col >= Constants.CELL_COLUMN) return false;
			if (team == Constants.TEAM_1 && col >= Constants.CELL_COLUMN / 2) return false;
			if (team == Constants.TEAM_2 && col < Constants.CELL_COLUMN / 2) return false;
			
			for (var c:int = col - Constants.MAX_SOLDIER_SIZE + 1; c < col + Constants.MAX_SOLDIER_SIZE; c++)
			{
				for (var r:int = row - Constants.MAX_SOLDIER_SIZE + 1; r < row + Constants.MAX_SOLDIER_SIZE; r++)
				{
					var soldier:BaseSoldier = troops[Utils.getCellFrom(r, c)];
					if (soldier != null)
					{
						if (soldier.row <= row && row < soldier.row + soldier.sizeHeight &&
							soldier.column <= col && col < soldier.column + soldier.sizeWidth)
							return false;
					}
				}
			}
			return true;
		}
		
		public function addTroop(troop:BaseSoldier):Boolean
		{
			for (var c:int = troop.column; c < troop.column + troop.sizeWidth; c++)
			{
				for (var r:int = troop.row; r < troop.row + troop.sizeHeight; r++)
				{
					if (!cellAvailable(troop.team, r, c)) return false;
				}
			}
			troops[troop.cell] = troop;
			return true;
		}	
		
		public function removeTroop(troop:BaseSoldier):Boolean
		{
			if (troops[troop.cell] == troop)
			{
				troops[troop.cell] = null;
				return true;
			}
			return false;
		}
		
		public function getTroop(cell:int):BaseSoldier
		{
			return troops[cell];
		}
	}

}