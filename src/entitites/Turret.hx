package entitites;

import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import nme.display.BitmapData;

/**
 * ...
 * @author julsam
 */
class Turret extends AbstractEntity
{
	public var direction(default, null):Int;
	private var shootTime:Float;
	private var timer:Float;
	private var bulletSpeed:Float;
	
	public function new(x:Float=0, y:Float=0, direction:Int=0) 
	{
		super(x, y);
		graphic = new Image(new BitmapData(16, 16, false, 0xffaaaa));
		setHitbox(16, 16, 8, 8);
		this.direction = direction;
		shootTime = 1;
		timer = 0;
		bulletSpeed = 100;
	}
	
	override public function update():Void
	{
		timer += HXP.elapsed; 
		if (timer >= shootTime)
		{
			switch (direction)
			{
				// up
				case 0:
					scene.create(Bullet).spawn(x + halfWidth, y - 8, direction, bulletSpeed);
				// right
				case 1:
					scene.create(Bullet).spawn(x + width + 2, y + halfHeight, direction, bulletSpeed);
				// down
				case 2:
					scene.create(Bullet).spawn(x + halfWidth, y + height + 2, direction, bulletSpeed);
				// left
				case 3:
					scene.create(Bullet).spawn(x - 8, y + halfHeight, direction, bulletSpeed);
			}
			timer -= shootTime;
		}
		
		super.update();	
	}
	
}