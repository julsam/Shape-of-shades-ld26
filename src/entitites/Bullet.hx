package entitites;

import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import nme.display.BitmapData;

/**
 * ...
 * @author julsam
 */
class Bullet extends AbstractEntity
{
	public var direction(default, null):Int;
	private var speed:Float;
	
	public function new() 
	{
		super();
		graphic = new Image(new BitmapData(8, 8, false, 0xffaaaa));
		type = "Bullet";
		setHitbox(8, 8);
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