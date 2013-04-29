package scenes;

import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;

/**
 * ...
 * @author julsam
 */
class Menu extends Scene
{

	public function new() 
	{
		super();
	}
	
	override public function begin():Dynamic 
	{
		HXP.screen.color = 0xffffff;
		
		var title:Text = new Text("Shape of shades");
		title.font = "font/CantoraOne-Regular.ttf";
		title.size = 48;
		title.color = 0x000000;
		title.x = 640 / 2 - title._field.textWidth / 2;
		title.y = 480 / 2 - title._field.textHeight / 2 - 100;
		addGraphic(title);
		
		var ld:Text = new Text("Ludum Dare #26 - @allinlabs");
		ld.font = "font/CantoraOne-Regular.ttf";
		ld.size = 32;
		ld.color = 0x000000;
		ld.x = 640 / 2 - ld._field.textWidth / 2;
		ld.y = 480 / 2 - ld._field.textHeight / 2;
		addGraphic(ld);
		
		var click:Text = new Text("Click to start.");
		click.font = "font/CantoraOne-Regular.ttf";
		click.size = 32;
		click.color = 0x000000;
		click.x = 640 / 2 - click._field.textWidth / 2;
		click.y = 480 / 2 - click._field.textHeight / 2 + 75;
		addGraphic(click);
	}
	
	override public function update():Dynamic 
	{
		if (Input.mousePressed) {
			HXP.scene = new GameScene();
		}
		
		super.update();
	}
	
}