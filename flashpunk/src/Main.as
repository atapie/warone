package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import org.aswing.AsWingManager;
	import scene.BattleScene;

	/**
	 * ...
	 * @author 
	 */
	[Frame(factoryClass="Preloader")]
	public class Main extends Engine 
	{

		public function Main():void 
		{
			super(800, 600, 30, true);
			FP.screen.color = 0xFFFFFF;
			FP.world = new BattleScene();
		}

		override public function init():void 
		{
			trace("Engine has started!");
			AsWingManager.setRoot(FP.engine);
		}

	}

}