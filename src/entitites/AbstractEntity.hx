package entitites;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import control.Level;

/**
 * ...
 * @author julsam
 */
class AbstractEntity extends Entity
{
	private var hollowTimer:Float;
	private var gonaBeInvisible:Bool;
	
	public function new(x:Float=0, y:Float=0) 
	{
		super(x, y);
		hollowTimer = 1;
		gonaBeInvisible = false;
	}
	
	override public function update():Void 
	{
		if (!visible) {
			gonaBeInvisible = false;
		}
		
		/*if (G.level.gridType == INVERTED && visible) {
			visible = false;
		} else if (G.level.gridType == NORMAL && !visible) {
			visible = true;
		}*/
		if (G.level.gridType == INVERTED && visible)
		{
			hollowTimer -= HXP.elapsed;
			gonaBeInvisible = true;
			//if (hollowTimer <= 0)
			{
				visible = false;
				hollowTimer = 1;
			}
		}
		else if (G.level.gridType == NORMAL)
		{
			gonaBeInvisible = false;
			hollowTimer = 1;
			var e = scene.collideLine("Solid", Std.int(x), Std.int(y), Std.int(G.player.x), Std.int(G.player.y), 15);
			if (e == null && !visible) {
				visible = true;
			} else if (e != null && visible) {
				visible = false;
			}
		}
		
		super.update();
	}
	
}