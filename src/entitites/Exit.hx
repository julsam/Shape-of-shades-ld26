package entitites;

import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Image;
import nme.display.BitmapData;
import scenes.GameScene;

/**
 * ...
 * @author julsam
 */
class Exit extends AbstractEntity
{
	private var sprite:Spritemap;
	private var bgImage:Image;

	public function new(x:Float=0, y:Float=0) 
	{
		super(x, y);
		setHitbox(16, 16);
		type = "Exit";
		
		bgImage = new Image(new BitmapData(16, 16, false));
		bgImage.centerOrigin();
		
		sprite = new Spritemap("gfx/exit_t.png", 16, 16);
		sprite.add("anim", [0, 1], 5);
		sprite.play("anim");
		sprite.centerOrigin();
		
		graphic = new Graphiclist([bgImage, sprite]);
		centerOrigin();
	}
	
	override public function update():Void 
	{
		bgImage.color = GameScene.tweenBgColor.color;
		
		super.update();
	}
	
}