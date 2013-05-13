package entitites;

import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.Alarm;
import scenes.GameScene;

/**
 * ...
 * @author julsam
 */
class Key extends AbstractEntity
{
	private var sprite:Spritemap;
	private var bgSprite:Spritemap;

	public function new(x:Float=0, y:Float=0) 
	{
		super(x, y);
		setHitbox(16, 16);
		type = "Key";
		
		bgSprite = new Spritemap("gfx/key3_inner_t.png", 16, 20);
		bgSprite.add("anim", [0, 1, 2, 3, 4, 5, 6, 7], 5);
		bgSprite.play("anim");
		bgSprite.centerOrigin();
		
		sprite = new Spritemap("gfx/key3_t.png", 16, 20);
		sprite.add("anim", [0, 1, 2, 3, 4, 5, 6, 7], 5);
		sprite.play("anim");
		sprite.centerOrigin();
		
		graphic = new Graphiclist([bgSprite, sprite]);
		centerOrigin();
	}
	
	override public function added():Void 
	{
		super.added();
		addTween(new Alarm(Math.random() * 10, removeAlarm, TweenType.OneShot), true);
	}
	
	private function removeAlarm(_):Void
	{
		var j:Int = HXP.choose([1, 2, 3]);
		for (i in 0...j) {
			scene.create(DiamondShape).spawn(x, y, (i + 1) * 0.5, false);
		}
		addTween(new Alarm(10 + Math.random() * 10, removeAlarm, TweenType.OneShot), true);
	}
	
	override public function update():Void 
	{
		bgSprite.color = GameScene.tweenBgColor.color;
		
		super.update();
	}
	
	public function destroy():Void
	{
		scene.create(DiamondShape).spawn(x, y, 0.01);
		scene.create(DiamondShape).spawn(x, y, 0.20);
		scene.create(DiamondShape).spawn(x, y, 0.40);
		scene.remove(this);
	}
}