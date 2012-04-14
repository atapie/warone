package logic.soldier 
{
	import common.Constants;
	import common.FloatingText;
	import common.Utils;
	import flash.geom.Point;
	import logic.BattleLogic;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import scene.BattleScene;
	/**
	 * ...
	 * @author 
	 */
	public class BaseSoldier extends Entity
	{
		public static const START_POINT:Point = new Point(60, 230);
		public static const ANIM_STAND:String = "stand";
		public static const ANIM_WALK:String = "walk";
		public static const ANIM_ATTACK:String = "attack";
		
		public static const STATE_NORMAL:int = 0;
		public static const STATE_DEAD:int = 1;
		
		public var state:int;
		public var team:int;
		
		public var cell:int;
		public var row:int;
		public var column:int;
		
		public var sizeWidth:int;
		public var sizeHeight:int;
		public var health:int;
		public var damage:int;
		public var moveSpeed:int;
		public var attackSpeed:int;
		public var attackRange:int;
		public var rowAttack:int;
		
		private var lastAttack:int;
		
		public function BaseSoldier(team:int, cell:int, startAnim:String) 
		{
			this.layer = Constants.LAYER_GAME;
			this.state = STATE_NORMAL;
			this.team = team;
			this.cell = cell;
			this.row = cell / Constants.CELL_COLUMN;
			this.column = cell % Constants.CELL_COLUMN;
			(graphic as Spritemap).play(startAnim);
			
			var pos:Point = getPosFromCell();
			this.x = pos.x;
			this.y = pos.y;
			
			if (column >= Constants.CELL_COLUMN / 2) graphic.x -= ((graphic as Spritemap).scaledWidth - Constants.CELL_SIZE / 2);
			else graphic.x -= Constants.CELL_SIZE / 2;
			graphic.y -= ((graphic as Spritemap).scaledHeight - Constants.CELL_SIZE);
		}
		
		public function getPosFromCell():Point
		{
			var result:Point = new Point();
			result.x = START_POINT.x + column * Constants.CELL_SIZE + Constants.CELL_SIZE / 2;
			if (column >= Constants.CELL_COLUMN / 2) result.x += 50;
			result.y = START_POINT.y + row * Constants.CELL_SIZE;
			return result;
		}
		
		override public function update():void
		{
			if (BattleLogic.instance().state == BattleLogic.BATTLE_STATE_STARTED) 
			{
				switch(state)
				{
					case STATE_NORMAL:
						var enemies:Array = canAttack();
						if (enemies != null) attack(enemies);
						else move();
						break;
					case STATE_DEAD:
						world.remove(this);
						BattleLogic.instance().removeTroop(this);
						break;
				}				
			}
		}
		
		private function move():void 
		{
			if (BattleLogic.instance().time - lastAttack >= attackSpeed)
			{
				if (canMove())
				{					
					if (team == Constants.TEAM_1) x += moveSpeed;
					else x -= moveSpeed;
					(graphic as Spritemap).play(ANIM_WALK);
				}
				else 
				{
					(graphic as Spritemap).play(ANIM_STAND);
				}
			}
		}
		
		private function canMove():Boolean
		{
			if (BattleLogic.instance().time - lastAttack >= attackSpeed)
			{
				var startCol:int = column + 1;
				var endCol:int = Constants.CELL_COLUMN / 2 - 1;
				var direction:int = 1;
				if (team == Constants.TEAM_2)
				{
					startCol = column - 1;
					endCol = Constants.CELL_COLUMN / 2;
					direction = -1;
				}
				for (var c:int = startCol; c * direction <= endCol * direction; c += direction)
				{
					for (var r:int = row; r < row + sizeHeight; r++)	
					{
						var comrade:BaseSoldier = BattleLogic.instance().getTroop(Utils.getCellFrom(r, c));
						if (comrade == null) continue;
						var minDistance:Number;
						if (team == Constants.TEAM_1) minDistance = Constants.CELL_SIZE * sizeWidth;
						else minDistance = Constants.CELL_SIZE * comrade.sizeWidth;
						if (Math.abs(comrade.x - x) < moveSpeed + minDistance)
						{
							return false;
						}
					}
				}
				return true;
			} else return false;
		}
		
		private function attack(enemies:Array):void
		{
			if (BattleLogic.instance().time - lastAttack >= attackSpeed)
			{
				// View
				(graphic as Spritemap).play(ANIM_ATTACK, true);				
				
				// Logic
				lastAttack = BattleLogic.instance().time;
				
				if (enemies.length > 0)
				{
					for (var i:int = 0; i < enemies.length; i++)
					{
						var enemy:BaseSoldier = enemies[i] as BaseSoldier;
						(world.create(FloatingText) as FloatingText).reset(enemy.x, enemy.y, ( -damage).toString(), 10, 0xFF0000);
						enemy.health -= damage;
						if (enemy.health <= 0)
						{
							enemy.state = STATE_DEAD;
						}
					}					
				}
				else
				{
					BattleLogic.instance().castleHealth[ -team] -= damage;
					(world as BattleScene).updateHpInfo( -team, (BattleLogic.instance().castleHealth[ -team] * 100 / BattleLogic.instance().castleHealthOrigin[ -team]));
					
					if (BattleLogic.instance().castleHealth[ -team] <= 0)
					{
						BattleLogic.instance().state = BattleLogic.BATTLE_STATE_STOPPED;
						var str:String = (team == Constants.TEAM_1) ? "Congratulation, you win!!!" : "Sorry, game over!!!";
						(world.create(FloatingText) as FloatingText).reset(FP.halfWidth, 100, str, 200, 0xFF0000, 36, 30);
					}
				}
			}
		}
		
		private function canAttack():Array
		{
			var result:Array = new Array();
			
			// Find enemy in attack range
			var startCol:int = Constants.CELL_COLUMN / 2;
			var endCol:int = Constants.CELL_COLUMN - 1;
			var direction:int = 1;
			if (team == Constants.TEAM_2)
			{
				startCol = Constants.CELL_COLUMN / 2 - 1;
				endCol = 0;
				direction = -1;
			}
			var targetRow:int = -1;
			var lastTargetX:Number = -1;
			for (var c:int = startCol; c*direction <= endCol*direction; c+=direction)
			{
				for (var r:int = row; r < row + sizeHeight; r++)
				{
					var enemy:BaseSoldier = BattleLogic.instance().getTroop(Utils.getCellFrom(r, c));
					if (enemy != null)
					{
						var distance:Number;
						if (team == Constants.TEAM_1) distance = Math.abs(enemy.x - x) - Constants.CELL_SIZE * sizeWidth;
						else distance = Math.abs(enemy.x - x) - Constants.CELL_SIZE * enemy.sizeWidth;
						if (distance <= attackRange || (lastTargetX >= 0 && Math.abs(enemy.x - lastTargetX) <= Constants.CELL_SIZE))
						{
							if (targetRow == -1 || r == targetRow)
							{
								targetRow = r;
								lastTargetX = enemy.x;
								result.push(enemy);5
								if (result.length == rowAttack) return result;
							}
						}
					}
				}
			}
			
			// Check castle in range
			if (result.length == 0)
			{
				if  (
					(team == Constants.TEAM_1 && (x + attackRange + Constants.CELL_SIZE * sizeWidth) >= (FP.width - 60)) ||
				 	(team == Constants.TEAM_2 && (x - attackRange - Constants.CELL_SIZE/2) <= 60)
				)
				{
					return result;
				}
				else return null;
			}
			else return result;
		}
	}

}