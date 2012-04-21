package logic.soldier 
{
	import common.config.SoldierConfig;
	import common.Constants;
	import common.FloatingText;
	import common.Utils;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import logic.BattleLogic;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import scene.BattleScene;
	/**
	 * ...
	 * @author 
	 */
	public class BaseSoldier extends Entity
	{
		public static const SOLDIER_KNIGHT_ROBO_ID:int = 0;
		public static const SOLDIER_KNIGHT_LANCE_ID:int = 1;
		public static const SOLDIER_BOSS_STRENGTH_ID:int = 2;
		
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
		
		public var config:SoldierConfig;
		public var health:int;
		
		private var lastAttack:int;
		
		// View related
		protected var offsetX:int;
		protected var offsetY:int;
		
		public function BaseSoldier(team:int, cell:int, startAnim:String) 
		{
			this.layer = Constants.LAYER_GAME;
			this.state = STATE_NORMAL;
			this.team = team;
			this.cell = cell;
			this.row = cell / Constants.CELL_COLUMN;
			this.column = cell % Constants.CELL_COLUMN;
			(graphic as Spritemap).play(startAnim);
			
			var pos:Point = Utils.getPosFrom(row, column);
			this.x = pos.x;
			this.y = pos.y;
			
			if (team == Constants.TEAM_2) graphic.x -= ((graphic as Spritemap).scaledWidth - Constants.CELL_SIZE / 2);
			else graphic.x -= Constants.CELL_SIZE / 2;
			graphic.y -= ((graphic as Spritemap).scaledHeight - Constants.CELL_SIZE);
			graphic.x += offsetX;
			graphic.y += offsetY;
			layer = Constants.LAYER_GAME - cell;
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
			if (BattleLogic.instance().time - lastAttack >= config.attackSpeed)
			{
				if (canMove())
				{					
					if (team == Constants.TEAM_1) x += config.moveSpeed;
					else x -= config.moveSpeed;
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
			if (BattleLogic.instance().time - lastAttack >= config.attackSpeed)
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
					for (var r:int = row - Constants.MAX_SOLDIER_SIZE + 1; r <= row; r++)	
					{
						if (r < 0) continue;
						var comrade:BaseSoldier = BattleLogic.instance().getTroop(Utils.getCellFrom(r, c));
						if (comrade == null || (comrade.row + comrade.config.sizeHeight - 1) < row) continue;
						var minDistance:Number;
						if (team == Constants.TEAM_1) minDistance = Constants.CELL_SIZE * config.sizeWidth;
						else minDistance = Constants.CELL_SIZE * comrade.config.sizeWidth;
						if (Math.abs(comrade.x - x) < config.moveSpeed + minDistance)
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
			if (BattleLogic.instance().time - lastAttack >= config.attackSpeed)
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
						(world.create(FloatingText) as FloatingText).reset(enemy.x, enemy.y, ( -config.damage).toString(), 10, 0xFF0000);
						enemy.health -= config.damage;
						if (enemy.health <= 0)
						{
							enemy.state = STATE_DEAD;
						}
					}					
				}
				else
				{
					BattleLogic.instance().castleHealth[ -team] -= config.damage;
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
				for (var r:int = row - Constants.MAX_SOLDIER_SIZE + 1; r < row + config.sizeHeight; r++)
				{
					if (r < 0) continue;
					var enemy:BaseSoldier = BattleLogic.instance().getTroop(Utils.getCellFrom(r, c));
					if (enemy == null || (enemy.row + enemy.config.sizeHeight - 1) < row) continue;
					var distance:Number;
					if (team == Constants.TEAM_1) distance = Math.abs(enemy.x - x) - Constants.CELL_SIZE * config.sizeWidth;
					else distance = Math.abs(enemy.x - x) - Constants.CELL_SIZE * enemy.config.sizeWidth;
					if (distance <= config.attackRange || (lastTargetX >= 0 && Math.abs(enemy.x - lastTargetX) <= Constants.CELL_SIZE))
					{
						if (targetRow == -1 || r == targetRow)
						{
							targetRow = r;
							lastTargetX = enemy.x;
							result.push(enemy);5
							if (result.length == config.rowAttack) return result;
						}
					}
				}
			}
			
			// Check castle in range
			if (result.length == 0)
			{
				if  (
					(team == Constants.TEAM_1 && (x + config.attackRange + Constants.CELL_SIZE * config.sizeWidth - Constants.CELL_SIZE / 2) >= (FP.width - 60)) ||
				 	(team == Constants.TEAM_2 && (x - config.attackRange - Constants.CELL_SIZE / 2) <= 60)
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