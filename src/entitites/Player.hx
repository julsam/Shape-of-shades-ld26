package entitites;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import control.Level;

import nme.display.BitmapData;
import nme.geom.Point;

/**
 * ...
 * @author julsam
 */
class Player extends Entity
{
	public var transparent(default, null):Bool;
	public var dead(default, null):Bool;
	public var velocity:Point;
	public var previousVelocity:Point;
	public var moved(default, null):Bool;
	
	public function new(x:Float=0, y:Float=0) 
	{
		super(x, y);
		type = "Player";
		graphic = new Image(new BitmapData(2, 2, false, 0xffffff));
		/*var img:Image = new Image(HXP.getBitmap("gfx/gradient.png"));
		//img.centerOO();
		img.centerOrigin();
		graphic = img;*/
		layer = 5;
		setHitbox(2, 2, 1, 1);
		centerOrigin();
		
		velocity = new Point();
		previousVelocity = new Point();
		transparent = false;
		dead = false;
		moved = true;
	}
	
	override public function update():Void 
	{
		if (Input.check("transparent")) {
			transparent = true;
		} else {
			transparent = false;
		}
			
		// if we collide into a wall while transparent, we switch grid
		if (collideTypes(["Solid"], x, y) != null) {
			G.level.switchGrid();
		}
		
		move();
		
		if (Input.released("transparent"))
		{
			while (collide("Solid", x, y) != null)
			{
				if (HXP.sign(previousVelocity.x) > 0) {
					x -= 1;
				}
				if (HXP.sign(previousVelocity.x) < 0) {
					x += 1;
				}
				if (HXP.sign(previousVelocity.y) > 0) {
					y -= 1;
				}
				if (HXP.sign(previousVelocity.y) < 0) {
					y += 1;
				}
			}
			/*if (G.level.gridType == INVERTED)
			{
				if (!G.level.collideMask(this, NORMAL)) {
					G.level.switchGrid();
				}
			}
			else 
			{
				if (!G.level.collideMask(this, INVERTED)) {
					G.level.switchGrid();
				}
			}*/
		}
		
		var key = collide("Key", x, y);
		if (key != null) {
			cast(key, Key).destroy();
			G.currentKeysCount++;
		}
		
		// Emit particles
		G.emitter.emit(x, y);
		
		super.update();
	}
	
	private function move():Void
	{
		var movement:Point = new Point();
		
		if (Input.check("up")) movement.y = -1;
		if (Input.check("down")) movement.y = 1;
		if (Input.check("left")) movement.x = -1;
		if (Input.check("right")) movement.x = 1;
		
		var margin:Int = 5;
		if (x <= margin && HXP.sign(movement.x) == -1) 					movement.x = 0;
		if (x >= G.level.width - margin && HXP.sign(movement.x) == 1) 	movement.x = 0;
		if (y <= margin && HXP.sign(movement.y) == -1) 					movement.y = 0;
		if (y >= G.level.height - margin && HXP.sign(movement.y) == 1) 	movement.y = 0;
		
		movement.normalize(1);
		velocity.x = HXP.elapsed * 110 * movement.x;
		velocity.y = HXP.elapsed * 110 * movement.y;
		
		if (velocity.x != 0 || velocity.y != 0) {
			previousVelocity = velocity.clone();
			moved = true;
		} else {
			moved = false;
		}
		
		moveBy(velocity.x, velocity.y, transparent ? null : "Solid", true);
	}
	
	public function kill():Void
	{
		dead = true;
	}
	
}