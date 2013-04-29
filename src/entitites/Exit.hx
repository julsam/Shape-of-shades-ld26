package entitites;
import com.haxepunk.graphics.Image;
import nme.display.BitmapData;

/**
 * ...
 * @author julsam
 */
class Exit extends AbstractEntity
{

	public function new(x:Float=0, y:Float=0) 
	{
		super(x, y);
		graphic = new Image(new BitmapData(16, 16, false, 0x8000ff));
		setHitbox(16, 16);
		type = "Exit";
	}
	
}