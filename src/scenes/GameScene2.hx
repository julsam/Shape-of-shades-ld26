package scenes;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import entitites.Player;
import nme.display.BitmapData;
import nme.display.Shape;
import nme.display.BlendMode;
import nme.geom.ColorTransform;
import nme.geom.Point;

import com.haxepunk.graphics.Backdrop;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

/**
 * ...
 * @author julsam
 */
class GameScene2 extends Scene
{
	public var player:Player;
	
	private var lightsVec:Array<Point>;
		
	private var torch_power:Float;
	private var torch_angle:Float;
	private var torch_angle_step:Float;
	private var walk_speed:Float;
	private var radius:Float;
	
	public function new() 
	{
		super();
		
		Input.define("up", [Key.UP, Key.W, Key.Z]);
        Input.define("down", [Key.DOWN, Key.S]);
        Input.define("left", [Key.LEFT, Key.A, Key.Q]);
		Input.define("right", [Key.RIGHT, Key.D]);
		
		lightsVec = new Array<Point>();
		torch_power = 150;
		torch_angle = 360;
		torch_angle_step = 50;
	}
	
	override public function begin():Dynamic 
	{
		add(player = new Player(300, 300));
		
		//addGraphic(new Backdrop("gfx/floor.png"));
		addGraphic(new Backdrop(new BitmapData(HXP.width, HXP.height, false, 0xffffff)));
		
		for (i in 0...20)
		{
			var wall:Entity = new Entity(Math.random() * 400, Math.random() * 300, new Image(new BitmapData(16, 16, false, 0xff335555)));
			wall.setHitbox(16, 16);
			wall.type = "solid";
			add(wall);
		}
	}
	
	override public function update():Dynamic 
	{
		calculateLightPoints();
		
		super.update();
	}
	private function calculateLightPoints():Void
	{
		lightsVec = new Array<Point>();
		var dist_x:Float = player.x - HXP.camera.x;
		var dist_y:Float = player.y - HXP.camera.y;
		var angle:Float = -Math.atan2(dist_x, dist_y);
		var _rotation:Float = angle / (Math.PI / 180);
		var ppoint:Point = new Point();
		
		var x:Int = 0;
		while (x <= torch_angle) 
		{
			var ray_angle:Float = angle/(Math.PI/180)-90-(torch_angle/2)+x;
			ray_angle = ray_angle * (Math.PI / 180);
			
			var e:Entity = HXP.world.collideLine("solid", Std.int(player.x), Std.int(player.y), 
				Std.int(player.x + (torch_power) * Math.cos(ray_angle)),
				Std.int(player.y + (torch_power) * Math.sin(ray_angle)),
				1, ppoint);
			var p:Point;
			if (e != null) {
				p = new Point(ppoint.x - HXP.camera.x, ppoint.y - HXP.camera.y);
				lightsVec.push(p);
			}
			else
			{
				p = new Point(player.x - HXP.camera.x + (torch_power) * Math.cos(ray_angle),
							  player.y - HXP.camera.y + (torch_power) * Math.sin(ray_angle));
				lightsVec.push(p);
			}
			x += Std.int(torch_angle / torch_angle_step);
		}
	}
	
	override public function render():Void
	{
		super.render();
			
		var canvas:BitmapData = new BitmapData(HXP.width, HXP.height, false, 0xffffff);
		var colorTransform:ColorTransform = new ColorTransform(1, 1, 1, 1);
		//canvas.fillRect(canvas.rect, 0xffffff);
		//canvas.draw(HXP.getBitmap("gfx/dotted.png"));
		
		var light:Shape = new Shape();
		light.graphics.beginFill(0x000000);
		light.graphics.lineStyle(0);
		light.graphics.moveTo(player.x - HXP.camera.x, player.y - HXP.camera.y);
		for (el in lightsVec) {
			light.graphics.lineTo(el.x, el.y);
		}
		light.graphics.lineTo(player.x - HXP.camera.x, player.y - HXP.camera.y);
		light.graphics.endFill();
		canvas.draw(light);
		HXP.buffer.draw(canvas, null, colorTransform, BlendMode.SUBTRACT);
		
		/*var canvas:BitmapData = new BitmapData(HXP.width, HXP.height, false, 0xFFFFFF);
		var colorTransform:ColorTransform = new ColorTransform(1, 1, 1, 1);
		
		var light:Shape = new Shape();
		light.graphics.beginFill(0x000000);
		light.graphics.lineStyle(0);
		light.graphics.moveTo(player.x - HXP.camera.x, player.y - HXP.camera.y);
		light.graphics.lineTo(50, 50);
		light.graphics.lineTo(150, 50);
		light.graphics.lineTo(150, 150);
		light.graphics.lineTo(50, 150);
		light.graphics.lineTo(player.x - HXP.camera.x, player.y - HXP.camera.y);
		light.graphics.endFill();
		canvas.draw(light);
		HXP.buffer.draw(canvas, null, colorTransform, BlendMode.SUBTRACT);*/
	}	
}