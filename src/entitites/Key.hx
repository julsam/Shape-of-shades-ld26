package entitites;

import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import nme.display.BitmapData;

/**
 * ...
 * @author julsam
 */
class Key extends AbstractEntity
{

	public function new(x:Float=0, y:Float=0) 
	{
		super(x, y);
		graphic = new Image(new BitmapData(16, 16, false, 0x0000ff));
		setHitbox(16, 16);
		type = "Key";
	}
	
	public function destroy():Void
	{
		scene.remove(this);
	}
}