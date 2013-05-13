package entitites;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import nme.display.BitmapData;
import nme.geom.Point;

/**
 * ...
 * @author julsam
 */
class Monster extends AbstractEntity
{
	public var speed(default, null):Float;
	public var runSpeed(default, null):Float;
	public var walkSpeed(default, null):Float;
	public var angle(default, null):Float;
	public var velocity(default, null):Point;
	
	private var sprite:Spritemap;
	
	public function new(x:Float=0, y:Float=0) 
	{
		super(x, y);
		type = "Monster";
		setHitbox(16, 16);
		
		var img:BitmapData = HXP.getBitmap("gfx/monster2b_t.png");
		sprite = new Spritemap(img, 16, 16, changeAnimation);
		//sprite.scale = 1.5;
		sprite.add("anim0", [0, 4], 7, true);
		sprite.add("anim1", [5, 1], 7, true);
		sprite.add("anim2", [6, 2], 7, true);
		sprite.add("anim3", [7, 3], 7, true);
		sprite.play("anim0");
		sprite.centerOrigin();
		graphic = sprite;
		centerOrigin();
		
		velocity = new Point();
		angle = 0;
		speed = 50;
		walkSpeed = 50;
		runSpeed = 80;
		timer = randomTargetTime = 5;
		G.monstersList.push(this);
	}
	
	private function changeAnimation():Void
	{
		sprite.play(HXP.choose(["anim0", "anim1", "anim2", "anim3"]));
	}
	
	override public function update():Void 
	{
		if (collideWith(G.player, x, y) != null) {
			velocity.x = 0;
			velocity.y = 0;
			G.player.kill();
		}
		
		move();
		
		super.update();
	}
		
	private function move():Void
	{
		if (distanceFrom(G.player) <= 300 && scene.collideLine("Solid", Std.int(x), Std.int(y), Std.int(G.player.x), Std.int(G.player.y), G.GRID_SIZE) == null)
		{
			speed = runSpeed;
			updateDirection(new Point(G.player.x, G.player.y));	
			moveBy(velocity.x, velocity.y, ["Solid", "Monster", "Turret"], true);
			target = null;
		}
		else
		{
			speed = walkSpeed;
			timer += HXP.elapsed;
			if (timer > randomTargetTime) {
				timer -= randomTargetTime;
				target = pickRandomPosition();
			}
			if (target != null) {
				updateDirection(target);	
				moveBy(velocity.x, velocity.y, ["Solid", "Monster", "Turret", "Player"], true);
			}
		}
	}
	
	private function updateDirection(p:Point):Void
	{
		angle = HXP.angle(x, y, p.x, p.y);
		HXP.angleXY(this.velocity, this.angle, this.speed * HXP.elapsed);
	}
		
	private function pickRandomPosition():Point
	{
		var p:Point = pickRandomTile();
		if (G.level.isTileEmpty(p.x, p.y)/* && scene.collideLine("Solid", Std.int(x), Std.int(y), Std.int(p.x), Std.int(p.y), G.GRID_SIZE) == null*/) {
			return p;
		}
		return null;
	}
		
	private function pickRandomTile():Point
	{
		return new Point(HXP.random * G.level.width, HXP.random * G.level.height);
	}
	
	public function kill():Void
	{
		scene.remove(this);
	}
	
	override public function removed():Void 
	{
		G.monstersList.remove(this);
		super.removed();
	}
	
	private var target:Point;
	private var randomTargetTime:Float;
	private var timer:Float;
	
}