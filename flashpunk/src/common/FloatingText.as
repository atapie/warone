package common
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.NumTween;
	import net.flashpunk.utils.Ease;

	/**
	 * ...
	 * @author Konstantinos Egarhos
	 */
	public class FloatingText extends Entity
	{
		public var title:Text;
		public var speed:int;
		public var duration:Number;
		public var alpha:NumTween;
		public var maxFloat:int;
		
		private var startY:Number;

		/**
		 * Creates a floating text.
		 */
		public function FloatingText()
		{
			title = new Text("");
			speed = 50;
			super();
		}

		/**
		 * Fades the floating text, and lifts it up.
		 */
		override public function update():void
		{
			title.alpha = alpha.value;			
			if (maxFloat < 0 || (startY - y) < maxFloat)
			{
				this.y -= speed * FP.elapsed;
			}
		}

		/**
		 * Recycles the floating text.
		 */
		public function disappeared():void
		{
			FP.world.recycle(this);
		}

		/**
		 * Resets the floating text.
		 * @param	x Location in the x (right-left) axis.
		 * @param	y Location in the y (top-bottom) axis.
		 * @param	text The number concatenated with a '+' in front.
		 * @param	duration The time it takes to fade out.
		 */
		public function reset(x:Number, y:Number, text:String, duration:Number = 0.6, color:uint = 0, size:int = 18, maxFloat:int = -1):void
		{
			title.text = String(text);
			this.duration = duration;
			this.maxFloat = maxFloat;
			title.color = color;
			title.size = size;
			alpha = new NumTween(disappeared);
			alpha.tween(1, 0, duration, Ease.cubeIn);
			addTween(alpha);
			graphic = title;
			this.x = x - title.width / 2;
			this.y = y - title.height / 2;
			this.startY = this.y;
		}
	}
}
