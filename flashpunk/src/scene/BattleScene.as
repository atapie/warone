package scene 
{
	import common.Config;
	import common.config.SoldierConfig;
	import common.Constants;
	import common.Utils;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import logic.BattleLogic;
	import logic.soldier.BaseSoldier;
	import logic.soldier.BossStrength;
	import logic.soldier.KnightLance;
	import logic.soldier.KnightRobo;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import org.aswing.AbstractButton;
	import org.aswing.AssetIcon;
	import org.aswing.event.DragAndDropEvent;
	import org.aswing.FlowLayout;
	import org.aswing.Icon;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	
	/**
	 * ...
	 * @author 
	 */
	public class BattleScene extends World 
	{
		private var avatarImg:Image = null;
		private var myHp:Canvas = null;
		private var enemyHp:Canvas = null;
		private var groundGrid:Image = null;
		
		// choose soldier by drag & drop action
		private var choosingSoldierEntity:Entity;
		private var cellStatusEntity:Entity;
		private var choosingSoldier:SoldierConfig;
		private var lastOveringCell:int;
		private var canPlaceSoldier:Boolean;
		
		public function BattleScene() 
		{
			addAvatars();
			addHpInfo();
			addBattleGround();
			addLogicEngities();
			initGUI();
			initChoosingSoldier();
		}
		
		private function initChoosingSoldier():void 
		{
			cellStatusEntity = this.addGraphic(null, Constants.LAYER_MOUSE);
			cellStatusEntity.visible = false;
			choosingSoldierEntity = this.addGraphic(null, Constants.LAYER_MOUSE);
			choosingSoldierEntity.visible = false;			
		}
		
		[Embed(source = "../../assets/battle_icon_knightrobo.png")] private static const KNIGHT_ROBO_ICON_SRC:Class;
		private static const KNIGHT_ROBO_ICON:BitmapData = FP.getBitmap(KNIGHT_ROBO_ICON_SRC);
		[Embed(source = "../../assets/battle_icon_knightlance.png")] private static const KNIGHT_LANCE_ICON_SRC:Class;
		private static const KNIGHT_LANCE_ICON:BitmapData = FP.getBitmap(KNIGHT_LANCE_ICON_SRC);
		[Embed(source = "../../assets/battle_icon_boss_strength.png")] private static const BOSS_STRENGTH_ICON_SRC:Class;
		private static const BOSS_STRENGTH_ICON:BitmapData = FP.getBitmap(BOSS_STRENGTH_ICON_SRC);
		private function initGUI():void
		{			
			// create components
			var bottomGUI:JFrame = new JFrame(FP.engine);			
			
			// size the frame
			bottomGUI.setSizeWH(FP.width, 100);
			bottomGUI.y = FP.height - bottomGUI.getHeight();
			
			// frame config
			bottomGUI.setClosable(false);
			bottomGUI.setDragable(false);
			bottomGUI.setResizable(false);
			bottomGUI.setBackgroundDecorator(null);
			
			// add the panel to the frame
			var panel:JPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
			var knightRoboButton:JButton = new JButton("", new AssetIcon(new Bitmap(KNIGHT_ROBO_ICON)));
			knightRoboButton.name = "knightRoboButton";
			knightRoboButton.setDragEnabled(true);
			knightRoboButton.addEventListener(DragAndDropEvent.DRAG_RECOGNIZED, onChooseSoldier);
			var knightLanceButton:JButton = new JButton("", new AssetIcon(new Bitmap(KNIGHT_LANCE_ICON)));
			knightLanceButton.name = "knightLanceButton";
			knightLanceButton.setDragEnabled(true);
			knightLanceButton.addEventListener(DragAndDropEvent.DRAG_RECOGNIZED, onChooseSoldier);
			var bossStrengthButton:JButton = new JButton("", new AssetIcon(new Bitmap(BOSS_STRENGTH_ICON)));
			bossStrengthButton.name = "bossStrengthButton";
			bossStrengthButton.setDragEnabled(true);
			bossStrengthButton.addEventListener(DragAndDropEvent.DRAG_RECOGNIZED, onChooseSoldier);
			panel.appendAll(knightRoboButton, knightLanceButton, bossStrengthButton);
			bottomGUI.getContentPane().append(panel);
			
			// display the frame
			bottomGUI.show();
		}
		
		private function onChooseSoldier(e:DragAndDropEvent):void 
		{
			if (BattleLogic.instance().state != BattleLogic.BATTLE_STATE_NORMAL) return;
			BattleLogic.instance().state = BattleLogic.BATTLE_STATE_CHOOSE_SOLDIER;
			lastOveringCell = -1;
			canPlaceSoldier = false;
			switch(e.target.name)
			{
				case "knightRoboButton":
					choosingSoldierEntity.graphic = KnightRobo.DISPLAY_IMG;
					choosingSoldier = Config.instance().getConfig(BaseSoldier.SOLDIER_KNIGHT_ROBO_ID);
					break;
				case "knightLanceButton":
					choosingSoldierEntity.graphic = KnightLance.DISPLAY_IMG;
					choosingSoldier = Config.instance().getConfig(BaseSoldier.SOLDIER_KNIGHT_LANCE_ID);
					break;
				case "bossStrengthButton":
					choosingSoldierEntity.graphic = BossStrength.DISPLAY_IMG;
					choosingSoldier = Config.instance().getConfig(BaseSoldier.SOLDIER_BOSS_STRENGTH_ID);
					break;					
				default:
					break;
			}
			(choosingSoldierEntity.graphic as Image).centerOrigin();
			choosingSoldierEntity.x = mouseX;
			choosingSoldierEntity.y = mouseY;
			choosingSoldierEntity.visible = true;
			
			cellStatusEntity.graphic = new Canvas(choosingSoldier.sizeWidth * Constants.CELL_SIZE, choosingSoldier.sizeHeight * Constants.CELL_SIZE);
		}
		
		override public function update():void
		{
			BattleLogic.instance().update();
			super.update();
			
			switch(BattleLogic.instance().state)
			{
				case BattleLogic.BATTLE_STATE_CHOOSE_SOLDIER:
					// Check finish choose soldier
					if (Input.mouseReleased)
					{
						choosingSoldierEntity.visible = false;
						cellStatusEntity.visible = false;
						
						if (canPlaceSoldier)
						{
							var soldier:BaseSoldier;
							switch(choosingSoldier.id)
							{
								case BaseSoldier.SOLDIER_KNIGHT_ROBO_ID:
									soldier = new KnightRobo(Constants.TEAM_1, lastOveringCell, BaseSoldier.ANIM_STAND);
									break;
								case BaseSoldier.SOLDIER_KNIGHT_LANCE_ID:
									soldier = new KnightLance(Constants.TEAM_1, lastOveringCell, BaseSoldier.ANIM_STAND);
									break;
								case BaseSoldier.SOLDIER_BOSS_STRENGTH_ID:
									soldier = new BossStrength(Constants.TEAM_1, lastOveringCell, BaseSoldier.ANIM_STAND);
									break;
							}
							if (BattleLogic.instance().addTroop(soldier))
							{
								add(soldier);
							}
						}
						
						BattleLogic.instance().state = BattleLogic.BATTLE_STATE_NORMAL;
					}
					else 
					{
						choosingSoldierEntity.x = mouseX;
						choosingSoldierEntity.y = mouseY;
						
						// Detect overing cell
						var cell:int = Utils.getCellFromPos(mouseX, mouseY);
						if (cell != lastOveringCell)
						{
							lastOveringCell = cell;
							if (cell == -1) 
							{
								cellStatusEntity.visible = false;
								canPlaceSoldier = false;
							}
							else 
							{
								var cellStatusCanvas:Canvas = cellStatusEntity.graphic as Canvas;
								// clear canvas
								cellStatusCanvas.fill(new Rectangle(0, 0, cellStatusCanvas.width, cellStatusCanvas.height), 0, 0);
								
								var row:int = cell / Constants.CELL_COLUMN;
								var col:int = cell % Constants.CELL_COLUMN;
								var cellPos:Point = Utils.getPosFrom(row, col);
								cellStatusEntity.x = cellPos.x - Constants.CELL_SIZE / 2;
								cellStatusEntity.y = cellPos.y;
								// Check cell available
								canPlaceSoldier = true;
								for (var i:int = 0; i < choosingSoldier.sizeWidth; i++)
								{
									for (var j:int = 0; j < choosingSoldier.sizeHeight; j++)
									{
										var color:uint = 0x00FF00;
										if (!BattleLogic.instance().cellAvailable(Constants.TEAM_1, row + j, col + i))
										{
											color = 0xFF0000;
											canPlaceSoldier = false;
										}
										cellStatusCanvas.drawRect(new Rectangle(i * Constants.CELL_SIZE, j * Constants.CELL_SIZE, Constants.CELL_SIZE, Constants.CELL_SIZE), color, 0.5);
									}
								}
								cellStatusEntity.visible = true;
							}							
						}						
					}
					break;
				default:
					break;
			}
		}
		
		private function addLogicEngities():void 
		{
			//var bossStrength:BossStrength = new BossStrength(Constants.TEAM_1, 5, BaseSoldier.ANIM_STAND);
			//if (BattleLogic.instance().addTroop(bossStrength)) add(bossStrength);
			//var knightLance2:KnightLance = new KnightLance(Constants.TEAM_1, 3, BaseSoldier.ANIM_STAND);
			//if (BattleLogic.instance().addTroop(knightLance2)) add(knightLance2);			
			//var knightLance1:KnightLance = new KnightLance(Constants.TEAM_1, 5, BaseSoldier.ANIM_STAND);
			//if (BattleLogic.instance().addTroop(knightLance1)) add(knightLance1);
			//var knightLance3:KnightLance = new KnightLance(Constants.TEAM_2, 21, BaseSoldier.ANIM_STAND);
			//if (BattleLogic.instance().addTroop(knightLance3)) add(knightLance3);
			//var knightLance4:KnightLance = new KnightLance(Constants.TEAM_2, 23, BaseSoldier.ANIM_STAND);
			//if (BattleLogic.instance().addTroop(knightLance4)) add(knightLance4);
			
			for (var row:int = 0; row < 6; row++)
			{
				for (var col:int = 7; col < 14; col++)
				{
					var cell:int = row * 14 + col;
					var knightRobo:KnightRobo;
					if (col > 6)
						knightRobo = new KnightRobo(Constants.TEAM_2, cell, BaseSoldier.ANIM_STAND);
					else
						knightRobo = new KnightRobo(Constants.TEAM_1, cell, BaseSoldier.ANIM_STAND);
						
					if (BattleLogic.instance().addTroop(knightRobo))
						add(knightRobo);
				}
			}
		}
		
		private function addBattleGround():void 
		{
			var bitmap:BitmapData = new BitmapData(800, 270, true, 0x00000000);
			Draw.setTarget(bitmap);
			Draw.line(0, 0, FP.width, 0, 0x00FF00);			// Top line		
			Draw.line(60, 45, 375, 45, 0x00FF00);
			Draw.line(60, 90, 375, 90, 0x00FF00);
			Draw.line(60, 135, 375, 135, 0x00FF00);
			Draw.line(60, 180, 375, 180, 0x00FF00);
			Draw.line(60, 225, 375, 225, 0x00FF00);			
			Draw.line(425, 45, 740, 45, 0x00FF00);
			Draw.line(425, 90, 740, 90, 0x00FF00);
			Draw.line(425, 135, 740, 135, 0x00FF00);
			Draw.line(425, 180, 740, 180, 0x00FF00);
			Draw.line(425, 225, 740, 225, 0x00FF00);			
			Draw.line(0, 269, FP.width, 269, 0x00FF00);		// Bottom line
			
			Draw.line(0, 0, 0, 270, 0x00FF00);
			Draw.line(60, 0, 60, 270, 0x00FF00);
			Draw.line(105, 0, 105, 270, 0x00FF00);
			Draw.line(150, 0, 150, 270, 0x00FF00);
			Draw.line(195, 0, 195, 270, 0x00FF00);
			Draw.line(240, 0, 240, 270, 0x00FF00);
			Draw.line(285, 0, 285, 270, 0x00FF00);
			Draw.line(330, 0, 330, 270, 0x00FF00);
			Draw.line(375, 0, 375, 270, 0x00FF00);
			Draw.line(425, 0, 425, 270, 0x00FF00);
			Draw.line(470, 0, 470, 270, 0x00FF00);
			Draw.line(515, 0, 515, 270, 0x00FF00);
			Draw.line(560, 0, 560, 270, 0x00FF00);
			Draw.line(605, 0, 605, 270, 0x00FF00);
			Draw.line(650, 0, 650, 270, 0x00FF00);
			Draw.line(695, 0, 695, 270, 0x00FF00);
			Draw.line(740, 0, 740, 270, 0x00FF00);
			addGraphic(new Image(bitmap), Constants.LAYER_BG2, 0, 230);
		}
		
		private function addHpInfo():void 
		{
			myHp = new Canvas(100, 10);
			myHp.fill(new Rectangle(0, 0, 100, 10), 0x00FF00);
			enemyHp = new Canvas(100, 10);
			enemyHp.fill(new Rectangle(0, 0, 100, 10), 0x00FF00);
			addGraphic(myHp, Constants.LAYER_GUI, avatarImg.width, 0).name = "TEAM_"+Constants.TEAM_1+"_HP";
			addGraphic(enemyHp, Constants.LAYER_GUI, FP.width - avatarImg.width - 100, 0).name = "TEAM_"+Constants.TEAM_2+"_HP";
		}
		
		public function updateHpInfo(team:int, hp:int):void
		{
			var hpEntity:Entity = getInstance("TEAM_" + team.toString() + "_HP");
			if (hpEntity != null)
			{
				if(team == Constants.TEAM_1)
					(hpEntity.graphic as Canvas).fill(new Rectangle(hp, 0, 100, 10), 0xFF0000);
				else
					(hpEntity.graphic as Canvas).fill(new Rectangle(0, 0, 100-hp, 10), 0xFF0000);
			}
		}
		
		[Embed(source = "../../assets/avatar.jpg")] private const AVATAR_IMG:Class;
		private function addAvatars():void 
		{
			avatarImg = new Image(AVATAR_IMG);
			addGraphic(avatarImg, Constants.LAYER_GUI, 0, 0);
			addGraphic(avatarImg, Constants.LAYER_GUI, FP.width - avatarImg.width, 0);
		}
		
	}

}