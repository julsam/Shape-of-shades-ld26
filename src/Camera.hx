package ;

import nme.geom.Point;

import com.haxepunk.Entity;
import com.haxepunk.HXP;

/**
 * Virtual camera that manage FP.camera
 */	
class Camera extends Entity
{
	public var _lookAt:Entity;
	public var movedX:Float;
	
	/**
	 * Constructor.
	 * @param	lookAt		The entity to follow. Example : the player
	 */
	public function new(lookAt:Entity) 
	{
		_lookAt = lookAt;
		
		x = _lookAt.x - (HXP.screen.width / 2);
		y = _lookAt.y - (HXP.screen.height / 2);
		
		//HXP.camera.x = Math.floor(x);
		//HXP.camera.y = Math.floor(y);
		
		super(x, y);
	}
	
	override public function update():Void
	{	
		var dist:Float = HXP.distance(_lookAt.x - (HXP.screen.width / 2), _lookAt.y - (HXP.screen.height / 2), HXP.camera.x, HXP.camera.y);
		var spd:Float = dist / 10;
		
		HXP.stepTowards(this, _lookAt.x - (HXP.screen.width / 2), _lookAt.y - (HXP.screen.height / 2), spd);
		HXP.camera.x = x;
		HXP.camera.y = y;
		/*if (HXP.camera.x < 0) { HXP.camera.x = 0; }
		if (HXP.camera.x + HXP.screen.width > HXP.width) { HXP.camera.x = HXP.width - HXP.screen.width; }
		if (HXP.camera.y < 0) { HXP.camera.y = 0; }
		if (HXP.camera.y + HXP.screen.height > HXP.height) { HXP.camera.y = HXP.height - HXP.screen.height; }*/
	}		
}