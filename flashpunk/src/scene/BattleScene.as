package scene 
{
	import common.Constants;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import logic.BattleLogic;
	import logic.soldier.BaseSoldier;
	import logic.soldier.KnightLance;
	import logic.soldier.KnightRobo;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.World;
	import org.aswing.AbstractButton;
	import org.aswing.FlowLayout;
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
		
		// AsWingGUI
		private var closeDialog:JFrame;
		
		public function BattleScene() 
		{
			addAvatars();
			addHpInfo();
			addBattleGround();
			addLogicEngities();
			//initGUI();
		}
		
		private function initGUI():void
		{			
			// create components
			closeDialog = new JFrame(FP.engine, "Close Dialog");
			var panel:JPanel = new JPanel(new FlowLayout(FlowLayout.CENTER));
			var label:JLabel = new JLabel("This is a dialog with one close button only");
			var button:JButton = new JButton("                   Đóng                   ");
			
			// size the frame
			closeDialog.setSizeWH(300, 150);
			closeDialog.x = FP.halfWidth - closeDialog.width / 2;
			closeDialog.y = FP.halfHeight - closeDialog.height;
			
			// frame config
			closeDialog.setClosable(false);
			closeDialog.setDragable(false);
			closeDialog.setResizable(false);
			
			// button config
			button.addEventListener(MouseEvent.CLICK, onCloseDialog);
			
			// add the label and button to the panel
			panel.appendAll(label, button);
			
			// add the panel to the frame
			closeDialog.getContentPane().append(panel);
			
			// display the frame
			closeDialog.show();
		}
		
		private function onCloseDialog(e:Event):void 
		{
			closeDialog.hide();
		}
		
		override public function update():void
		{
			BattleLogic.instance().update();
			super.update();			
		}
		
		private function addLogicEngities():void 
		{
			var knightLance1:KnightLance = new KnightLance(Constants.TEAM_1, 5, BaseSoldier.ANIM_STAND);
			if (BattleLogic.instance().addTroop(knightLance1)) add(knightLance1);
			var knightLance2:KnightLance = new KnightLance(Constants.TEAM_1, 3, BaseSoldier.ANIM_STAND);
			if (BattleLogic.instance().addTroop(knightLance2)) add(knightLance2);
			var knightLance3:KnightLance = new KnightLance(Constants.TEAM_2, 21, BaseSoldier.ANIM_STAND);
			if (BattleLogic.instance().addTroop(knightLance3)) add(knightLance3);
			var knightLance4:KnightLance = new KnightLance(Constants.TEAM_2, 23, BaseSoldier.ANIM_STAND);
			if(BattleLogic.instance().addTroop(knightLance4)) add(knightLance4);
			
			for (var row:int = 0; row < 6; row++)
			{
				for (var col:int = 0; col < 14; col++)
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