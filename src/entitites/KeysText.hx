package entitites;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import nme.text.TextFormatAlign;

/**
 * ...
 * @author julsam
 */
class KeysText extends Entity
{
	private var text:Text;
	private var keysCount:Int;

	public function new(x:Float=0, y:Float=0) 
	{
		super(x, y);
		type = "KeysText";
		collidable = false;
		visible = false;
		
		text = new Text(G.currentKeysCount + " / " + G.totalKeysCount, 580, 32);
		text.font = "font/GOTHICB.TTF";
		text.size = 16;
		graphic = text;
		graphic.scrollX = 0;
		graphic.scrollY = 0;
		
		keysCount = G.currentKeysCount;
	}
        
	override public function update():Void 
	{
		if (keysCount != G.currentKeysCount)
		{
			text.text = G.currentKeysCount + " / " + G.totalKeysCount;
			text.updateBuffer();
			keysCount = G.currentKeysCount;
		}
		
		super.update();
	}	
}