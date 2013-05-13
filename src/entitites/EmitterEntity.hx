package entitites;

import com.haxepunk.graphics.Image;
import nme.display.BitmapData;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.utils.Ease;

/**
 * ...
 * @author julsam
 */
class EmitterEntity extends Entity
{
	public var emitter(default, null):Emitter;

	public function new() 
	{
		super();
		this.type = "EmitterEntity";
		collidable = false;
		visible = false;
		
		emitter = new Emitter("gfx/explosion.png", 16, 16);
		emitter.newType('explosion', [0, 1, 2, 3, 4, 5, 6]);
		emitter.setMotion('explosion', 0, 15, 1.5, 360, 16, 0.8);
		emitter.setAlpha("explosion", 1, 0.3);
		emitter.setGravity('explosion', 0);
		emitter.setColor('explosion', 0x5a5566, 0x0a0011, Ease.backOut);
		graphic = emitter;
	}
	
	public function emit(x:Float, y:Float, amount:Int=1):Void
	{
		for (i in 0...amount) {
			// 8 == "gfx/explosion.png"'s size / 2
			emitter.emit('explosion', x - 8, y - 8);
		}
	}
	
	public var particle(get_particle, null):Image;
	private function get_particle():Image
	{
		var data:Image = new Image(new BitmapData(16, 16, false, 0xffffff));
		return data;
	}
}
