package entitites;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Backdrop;
import nme.geom.Matrix;
import nme.display.GradientType;
import nme.display.BitmapData;
import nme.display.Sprite;
import scenes.GameScene;

/**
 * ...
 * @author julsam
 */
class GradientBackdrop extends Entity
{
	public var source(default, null):BitmapData;
	public var backdrop(default, null):Image;
	
	public function new() 
	{
		width = HXP.screen.width + G.MARGIN;
		height = HXP.screen.width + G.MARGIN;
		
		var gType = GradientType.RADIAL; 
		var gColors:Array<Int> = [0xFFFFFF, 0x000000];  
		var gAlphas:Array<Float> = [1, 1];  
		var gRatio:Array<Int> = [0, 188]; 
		
		var matrix:Matrix = new Matrix();  
		matrix.createGradientBox(width, height);  
		
		var light:Sprite = new Sprite();
		light.graphics.beginGradientFill(gType, gColors, gAlphas, gRatio, matrix);  
		light.graphics.drawRect(0, 0, width, height);
		light.graphics.endFill();
		
		source = new BitmapData(width, height, false, 0xffffff);
		source.draw(light);
		
		
		super();
		backdrop = new Image(source);
		backdrop.centerOO();
		graphic = backdrop;
		layer = 100;
		collidable = false;
	}
	
	override public function update():Void 
	{
		backdrop.x = xPosition;
		backdrop.y = yPosition;
		backdrop.color = GameScene.tweenBgColor.color;
		super.update();
	}
	
	public var xPosition(get_xPosition, null):Int;
	private function get_xPosition():Int
	{
		return Std.int(G.player.x);
	}
	
	public var yPosition(get_yPosition, null):Int;
	private function get_yPosition():Int
	{
		return Std.int(G.player.y);
	}
	
}