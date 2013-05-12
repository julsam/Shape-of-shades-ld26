package entitites;

import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import nme.display.BitmapData;
import nme.geom.Point;
import scenes.GameScene;

/**
 * ...
 * @author julsam
 */
class Bullet extends AbstractEntity
{
	private var bgSprite:Spritemap;
	private var sprite:Spritemap;
	public var direction(default, null):Int;
	private var speed:Float;
	
	public function new() 
	{
		super();
		//graphic = new Image(new BitmapData(8, 8, false, 0xffaaaa));
		type = "Bullet";
		setHitbox(8, 8);
		
		bgSprite = new Spritemap("gfx/bullet_inner.png", 16, 16);
		bgSprite.add("anim", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 8);
		bgSprite.play("anim");
		bgSprite.centerOrigin();
		
		sprite = new Spritemap("gfx/bullet.png", 16, 16);
		sprite.alpha = 0.5;
		sprite.add("anim", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 8 );
		sprite.play("anim");
		sprite.centerOrigin();
		graphic = new Graphiclist([bgSprite, sprite]);
		
		centerOrigin();
	}

	public function spawn(x:Float=0, y:Float=0, direction:Int=0, speed:Float=100):Void
	{
		this.x = x;
		this.y = y;
		this.direction = direction;
		this.speed = speed;
	}
	
	override public function update():Void
	{
		bgSprite.color = GameScene.tweenBgColor.color;
		
		switch (direction)
		{
			case 0:
				moveBy(0, HXP.elapsed * -speed);
			case 1:
				moveBy(HXP.elapsed * speed, 0);
			case 2:
				moveBy(0, HXP.elapsed * speed);
			case 3:
				moveBy(-(HXP.elapsed * speed), 0);
		}
		
		bgSprite.angle += 120 * HXP.elapsed;
		sprite.angle += 120 * HXP.elapsed;
		//graphic = new Graphiclist([bgSprite, sprite]);
		
		if (x <= 0 + halfWidth) 					destroy();
		else if (x >= G.level.width - halfWidth) 	destroy();
		else if (y <= 0 + halfHeight) 				destroy();
		else if (y >= G.level.height - halfHeight) 	destroy();
		
		var m:Entity = null;
		if (collide("Solid", x, y) != null)
		{
			scene.recycle(this);
		}
		else if ((m = collide("Monster", x, y)) != null)
		{
			scene.recycle(this);
			cast(m, Monster).kill();
		}
		else if (collideWith(G.player, x, y) != null)
		{
			scene.recycle(this);
			G.player.kill();
		}
		
		super.update();	
	}
	
	public function destroy():Void
	{
		scene.remove(this);
	}
	
}