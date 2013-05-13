package entitites;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.tweens.misc.MultiVarTween;
import com.haxepunk.tweens.misc.VarTween;
import nme.display.BitmapData;
import nme.text.TextFormatAlign;
import scenes.GameScene;

/**
 * ...
 * @author julsam
 */
class HelpText extends Entity
{
	private var text:Text;
	private var bg:Image;

	public function new() 
	{
		super();
		type = "HelpText";
		collidable = false;
		visible = false;
		
		text = new Text("Press <Space> to go through walls.\nCollect keys and go to the exit.");
		text.font = "font/GOTHIC.TTF";
		text.size = 16;
		text.color = 0;
		text.x = HXP.screen.width / 2 - text.textWidth / 2;
		text.y = HXP.screen.height - text.height - 30;
		
		bg = new Image(new BitmapData(text.textWidth + 32, text.height, false, 0xffffffff));
		bg.x = text.x - 16;
		bg.y = text.y;
		
		graphic = new Graphiclist([bg, text]);
		graphic.scrollX = 0;
		graphic.scrollY = 0;
		
		addTween(new Alarm(12, onAlarmComplete, TweenType.OneShot), true);
	}
	
	private function onAlarmComplete(_):Void
	{
		var textAlpha:VarTween = new VarTween(onFadeComplete, TweenType.OneShot);
		addTween(textAlpha);
		textAlpha.tween(text, "alpha", 0, 2);
		textAlpha.start();
		
		var bgAlpha:VarTween = new VarTween(null, TweenType.OneShot);
		addTween(bgAlpha);
		bgAlpha.tween(bg, "alpha", 0, 2);
		bgAlpha.start();
	}
	
	private function onFadeComplete(_):Void
	{
		scene.remove(this);
	}
        
	/*override public function update():Void 
	{	
		bg.color = GameScene.tweenBgColor.color;
		
		super.update();
	}*/	
}