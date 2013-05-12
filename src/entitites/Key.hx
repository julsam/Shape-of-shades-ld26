package entitites;

import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
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
	
	override public function update():Void 
	{
		bgSprite.color = GameScene.tweenBgColor.color;
		
		super.update();
	}
	
	public function destroy():Void
	{
		scene.remove(this);
	}
}