package entitites;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.tweens.misc.NumTween;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.geom.Matrix;
import scenes.GameScene;

/**
 * ...
 * @author julsam
 */
class DiamondShape extends Entity
{
	private var scaleTween:NumTween;
	private var alphaTween:NumTween;

	public function new() 
	{
		super();
		type = "DiamondShape";
		
		visible = false;
		collidable = false;
	}

	public function spawn(x:Float=0, y:Float=0, timeBeforeStart:Float=0.1, catchUpTime:Bool=true):Void
	{
		this.x = x;
		this.y = y;
		
		if (catchUpTime) {
			_duration = 3 - timeBeforeStart;
		} else {
			_duration = 3;
		}
		
		addTween(new Alarm(timeBeforeStart, startTweens, TweenType.OneShot), true);
		
		_diamond = new Sprite();
		_diamondMatrix = new Matrix();
	}
	
	private function startTweens(_):Void
	{
		addTween(scaleTween = new NumTween(removeScaleTween));
		scaleTween.tween(1, 100, _duration);
		scaleTween.start();
		
		var d = _duration - 0.5 <= 0 ? 0 : _duration - 0.5;
		addTween(alphaTween = new NumTween(removeAlphaTween));
		alphaTween.tween(1, 0, d);
		alphaTween.start();
	}
	
	private function removeScaleTween(_):Void
	{
		removeTween(scaleTween);
		scene.recycle(this);
	}
	
	private function removeAlphaTween(_):Void
	{
		removeTween(alphaTween);
	}
	
	override public function render():Void 
	{
		if (scaleTween != null && alphaTween != null) {
			renderDiamond();
		}
	}
	
	public function renderDiamond():Void
	{
		_diamondMatrix.tx = x - HXP.camera.x - 9 * scaleTween.value / 2;
		_diamondMatrix.ty = y - HXP.camera.y - 16 * scaleTween.value / 2;
		drawDiamond(9 * scaleTween.value, 16 * scaleTween.value, alphaTween.value);
		HXP.buffer.draw(_diamond, _diamondMatrix);
	}
	
	private function drawDiamond(width:Float, height:Float, alpha:Float):Void
	{
		_diamond.graphics.clear();
		_diamond.graphics.lineStyle(2, 0xffffff, alpha);
		_diamond.graphics.moveTo(width / 2, 0);			// up
		_diamond.graphics.lineTo(width, height / 2);	// right
		_diamond.graphics.lineTo(width / 2, height);	// down
		_diamond.graphics.lineTo(0, height / 2);		// left
		_diamond.graphics.lineTo(width / 2, 0);			// up
	}
	
	public function destroy():Void
	{
		scene.remove(this);
	}
	
	private var _duration:Float;
	private var _diamond:Sprite;
	private var _diamondMatrix:Matrix;	
}
