package entitites;

import com.haxepunk.graphics.Backdrop;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.tweens.misc.NumTween;
import com.haxepunk.utils.Ease;
import nme.display.BitmapData;
import nme.display.Sprite;

/**
 * ...
 * @author julsam
 */

enum BORDER_TYPE {
	BORDER_TOP;
	BORDER_RIGHT;
	BORDER_BOTTOM;
	BORDER_LEFT;
}

class BorderLimit extends Entity
{
	public static inline var minimumDistance:Float = 100;
	
	public function new(borderType:BORDER_TYPE) 
	{
		switch (borderType) {
			case BORDER_TOP:
				super(-32, -32);
				width = G.level.width + 64;
				height = 32;
			case BORDER_RIGHT:
				super(G.level.width, -32);
				width = 32;
				height = G.level.height + 64;
			case BORDER_BOTTOM:
				super(-32, G.level.height);
				width = G.level.width + 64;
				height = 32;
			case BORDER_LEFT:
				super(-32, -32);
				width = 32;
				height = G.level.height + 64;
		}
		
		var spr:Sprite = new Sprite();
		spr.graphics.beginBitmapFill(HXP.getBitmap("gfx/border_d3.png"));
		spr.graphics.drawRect(0, 0, width, height);
		spr.graphics.endFill();
		
		var source = new BitmapData(width, height, false, 0);
		source.draw(spr);
		
		backdrop = new Image(source);
		backdrop.alpha = 0;
		graphic = backdrop;
		
		justBeenActivated = false;
		addTween(alphaTween = new NumTween(inverse));
		inverse();
		
		collidable = false;
	}
	
	private function inverse(?_):Void
	{
		if (isPlayerClose() || alphaTween.value > 0)
		{
			if (alphaTween.value == 0) {
				alphaTween.tween(0, 1, justBeenActivated ? 1.5 : 0.75, Ease.backInOut);
			} else {
				alphaTween.tween(1, 0, justBeenActivated ? 1.5 : 0.75, Ease.backInOut);
			}
			alphaTween.start();
			justBeenActivated = true;
		}
	}
	
	override public function update():Void 
	{
		if (alphaTween.active) {
			backdrop.alpha = alphaTween.value;
		} else {
			justBeenActivated = false;
		}
		
		if (isPlayerClose() && !alphaTween.active) {
			inverse();
		}
		super.update();
	}
	
	public function isPlayerClose():Bool
	{
		return HXP.distanceRectPoint(G.player.x, G.player.y, x, y, width, height) <= BorderLimit.minimumDistance;
	}
	
	private var alphaTween:NumTween;
	private var backdrop:Image;
	private var justBeenActivated:Bool;
}