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

	public function new(x:Float=0, y:Float=0) 
	{
		super(x, y);
		
		text = new Text("", 580, 32);
		text.font = "font/CantoraOne-Regular.ttf";
		text.size = 16;
		graphic = text;
		graphic.scrollX = 0;
		graphic.scrollY = 0;
	}
        
	override public function update():Void 
	{
		text.text = G.currentKeysCount + " / " + G.totalKeysCount;
		text.updateBuffer();
		
		super.update();
	}	
}