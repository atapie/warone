package logic.soldier 
{
	import common.Constants;
	import common.FloatingText;
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
		public var lane:int;
		public var health:int;
		public var damage:int;
		public var moveSpeed:int;
		public var attackSpeed:int;
		public var attackRange:int;
		
		private var lastAttack:int;
		
		public function BaseSoldier(team:int, cell:int, startAnim:String) 
		{
			this.layer = Constants.LAYER_GAME;
			this.state = STATE_NORMAL;
			this.team = team;
			this.lane = Math.floor(cell / Constants.CELL_COLUMN);
			(graphic as Spritemap).play(startAnim);
			
			var pos:Point = getPosFromCell(cell);
			this.x = pos.x;
			this.y = pos.y;
			
			var cell_column:int = cell % Constants.CELL_COLUMN;			
			if (cell_column >= Constants.CELL_COLUMN / 2) graphic.x -= ((graphic as Spritemap).scaledWidth - Constants.CELL_SIZE);
			graphic.y -= ((graphic as Spritemap).scaledHeight - Constants.CELL_SIZE);
			
			BattleLogic.instance().addTroop(this);
		}
		
		public function getPosFromCell(cell:int):Point
		{
			var result:Point = new Point();
			var cell_column:int = cell % Constants.CELL_COLUMN;
			result.x = START_POINT.x + cell_column * Constants.CELL_SIZE;
			if (cell_column >= Constants.CELL_COLUMN / 2) result.x += 50;
			result.y = START_POINT.y + Math.floor(cell / Constants.CELL_COLUMN) * Constants.CELL_SIZE;
			return result;
		}
		
		override public function update():void
		{
			if (BattleLogic.instance().state == BattleLogic.BATTLE_STATE_STARTED) 
			{
				switch(state)
				{
					case STATE_NORMAL:
						var enemy:Object = canAttack();
						if (enemy != null) attack(enemy);
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
				var comrades:Array = BattleLogic.instance().getTroops(this.team, this.lane);
				for (var i:int = 0; i < comrades.length; i++)
				{
					if (comrades[i] == this)
					{
						var nextCompareIdx:int = i + team;
						if (nextCompareIdx < 0 || nextCompareIdx >= comrades.length) return true;
						else if (distanceFrom(comrades[i + team]) >= moveSpeed + Constants.CELL_SIZE) return true;
					}
				}
			}
			return false;
		}
		
		private function attack(enemy:Object):void
		{
			if (BattleLogic.instance().time - lastAttack >= attackSpeed)
			{
				// View
				(graphic as Spritemap).play(ANIM_ATTACK, true);				
				
				// Logic
				lastAttack = BattleLogic.instance().time;
				
				if (enemy is BaseSoldier)
				{
					(world.create(FloatingText) as FloatingText).reset(enemy.x + Constants.CELL_SIZE / 2, enemy.y, ( -damage).toString(), 0xFF0000, 10);
					enemy.health -= damage;
					if (enemy.health <= 0)
					{
						enemy.state = STATE_DEAD;
					}
				}
				else
				{
					BattleLogic.instance().castleHealth[ -team] -= damage;
					(world as BattleScene).updateHpInfo( -team, (BattleLogic.instance().castleHealth[ -team] * 100 / BattleLogic.instance().castleHealthOrigin[ -team]));
				}
			}
		}
		
		private function canAttack():Object
		{
			// Find enemy in attack range
			var enemies:Array = BattleLogic.instance().getTroops(-this.team, this.lane);
			for (var i:int = 0; i < enemies.length; i++)
			{
				var enemy:BaseSoldier = enemies[i] as BaseSoldier;
				if (distanceFrom(enemy) <= attackRange) return enemy;
			}
			
			// Check castle in range
			if  (	
					(team == Constants.TEAM_1 && (x + attackRange) >= (FP.width - 60)) ||
				 	(team == Constants.TEAM_2 && (x - attackRange) <= 60)
				)
				{
					return new Object();
				}
			
			return null;
		}
	}

}