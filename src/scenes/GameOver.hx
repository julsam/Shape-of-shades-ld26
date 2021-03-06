package scenes;

import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import nme.text.TextFormatAlign;

/**
 * ...
 * @author julsam
 */
class GameOver extends Scene
{

	public function new() 
	{
		super();
		
	}
	
	override public function begin():Dynamic 
	{
		HXP.screen.color = 0xffffff;
		
		var title:Text = new Text("End.");
		title.font = "font/GOTHIC.TTF";
		title.size = 48;
		title.color = 0x000000;
		title.x = 640 / 2 - title._field.textWidth / 2;
		title.y = 480 / 2 - title._field.textHeight / 2 - 100;
		addGraphic(title);
		
		var click:Text = new Text("Thanks for playing !\nClick anywhere if you want to play again.", 0, 0, 0, 0, { "align": TextFormatAlign.CENTER });
		click.font = "font/GOTHIC.TTF";
		click.size = 16;
		click.color = 0x000000;
		click.x = 640 / 2 - click._field.textWidth / 2;
		click.y = 480 / 2 - click._field.textHeight / 2;
		addGraphic(click);
	}
	
	override public function update():Dynamic 
	{
		if (Input.mousePressed) {
			HXP.scene = new Menu();
		}
		
		super.update();
	}
	
}