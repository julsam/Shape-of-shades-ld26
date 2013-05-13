package scenes;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.masks.Polygon;
import com.haxepunk.Sfx;
import com.haxepunk.tweens.misc.ColorTween;
import com.haxepunk.utils.Draw;
import control.Level;
import entitites.BorderLimit;
import entitites.EmitterEntity;
import entitites.GradientBackdrop;
import entitites.KeysText;
import entitites.Monster;
import entitites.Player;
import nme.display.BitmapData;
import nme.display.Shape;
import nme.display.BlendMode;
import nme.display.Sprite;
import nme.filters.BitmapFilterQuality;
import nme.filters.BlurFilter;
import nme.geom.ColorTransform;
import nme.geom.Point;
import nme.display.GradientType;  
import nme.geom.Matrix;  
import nme.geom.Rectangle;

import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

/**
 * ...
 * @author julsam
 */
class GameScene extends Scene
{
	public var v:Visibility;
	public var blocks:Array<Visibility.Block>;
		
	public var backdrop:GradientBackdrop;
	public static var tweenBgColor:ColorTween;
	private var twColorTimer:Float;
	
	private var transitionAlpha:Float;
	private var transitionType:String;
	
	private var music:Sfx;
	private var currentSongName:String;
	
	//										   		skyblue,   peach,   deepblue, orange,   purple,   deepgreen
	//public static inline var bgColors:Array<Int> = [0x4C2B2F, 0xE57152, 0xE8DE67, 0xFFEFC3, 0xC0CCAB];
	
	//public static inline var bgColors:Array<Int> = [0x4C2B2F, 0xE57152, 0xE8DE67, 0xFFEFC3, 0xC0CCAB]; //
	
	//public static inline var bgColors:Array<Int> = [0x00A19A, 0x04BF9D, 0xF2E85C, 0xF53D54, 0x404040]; // MGswatch2
	
	//public var bgColors:Array<Int> = [0xC90337, 0xFF4A35, 0xEBAF64, 0xFFF691, 0x05BC87]; // Island Vibes
	
	//public static inline var bgColors:Array<Int> = [0x470D3A, 0x664670, 0x7C8399, 0x9DD1C6, 0xBCFFAD]; // Dublin airport
	
	public var bgColors:Array<Int>;
	private var backgroundPattern:BitmapData;
	private var borderLimitList:Array<BorderLimit>;
	
	public function new() 
	{
		super();
		
		Input.define("up", [Key.UP, Key.W, Key.Z]);
        Input.define("down", [Key.DOWN, Key.S]);
        Input.define("left", [Key.LEFT, Key.A, Key.Q]);
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("transparent", [Key.SPACE]);
		
		G.currentLevel = 0;
		G.levels.push("levels/level03.oel"); // 1
		G.levels.push("levels/level04.oel"); // 2
		G.levels.push("levels/level05.oel"); // 3
		G.levels.push("levels/level01.oel"); // 4
		G.levels.push("levels/level02.oel"); // 5
		G.levels.push("levels/level06.oel"); // 6
		G.levels.push("levels/level07.oel"); // 7
		G.levels.push("levels/level08.oel"); // 8
		
		selectColorPalette();
		
		tweenBgColor = new ColorTween(changeBgColor);
		twColorTimer = 7.0;
		tweenBgColor.color = 0x383747;
		addTween(tweenBgColor);
		changeBgColor(null);
		
		transitionAlpha = 0;
		transitionType = "";
		
		currentSongName = HXP.choose(["sfx/track01.mp3", "sfx/track02.mp3"]);
		music = new Sfx(currentSongName, musicComplete);
		music.play();
	}
		
	private function changeBgColor(_):Void
	{	
		tweenBgColor.tween(twColorTimer, tweenBgColor.color, HXP.choose(bgColors));
		tweenBgColor.start();
	}
	
	private function selectColorPalette():Void
	{
		//                        skyblue,   peach,   deepblue, orange,   purple,   deepgreen
		var myColors:Array<Int> = [0x4C2B2F, 0xE57152, 0xE8DE67, 0xFFEFC3, 0xC0CCAB];
		var myColors2:Array<Int> = [0x4C2B2F, 0xE57152, 0xE8DE67, 0xFFEFC3, 0xC0CCAB];
		var mgswatch2:Array<Int> = [0x00A19A, 0x04BF9D, 0xF2E85C, 0xF53D54, 0x404040];
		var islandVibes:Array<Int> = [0xC90337, 0xFF4A35, 0xEBAF64, 0xFFF691, 0x05BC87];
		var dublinAirport:Array<Int> = [0x470D3A, 0x664670, 0x7C8399, 0x9DD1C6, 0xBCFFAD];
		bgColors = HXP.choose([myColors, myColors2, mgswatch2, islandVibes, dublinAirport]);
	}
	
	override public function begin():Dynamic 
	{
		loadLevel();
	}
	
	public function loadLevel():Void
	{
		resetData();
		
		selectColorPalette();
		backgroundPattern = HXP.choose([HXP.getBitmap("gfx/dotted2.png"), HXP.getBitmap("gfx/dotted3.png"), null]);
		
		add(G.level = new Level(G.levels[G.currentLevel]));
		add(backdrop = new GradientBackdrop());
		
		var fgTiles:Tilemap = G.level.normalTiles;
		var blurData:BitmapData = new BitmapData(G.level.width, G.level.height, true, 0);
		Draw.setTarget(blurData);
		fgTiles.blend = BlendMode.SUBTRACT;
		fgTiles.relative = false;
		Draw.graphic(fgTiles, 0, 0);
		fgTiles.blend = BlendMode.NORMAL;
		Draw.resetTarget();
		blurData.applyFilter(blurData, blurData.rect, HXP.zero, new BlurFilter(8, 8, BitmapFilterQuality.HIGH));
		var bgBlur = new Image(blurData);
		//bgBlur.alpha = 0.5;
		addGraphic(bgBlur, 95);
		
		// Border limit
		borderLimitList = new Array<BorderLimit>();
		borderLimitList.push(new BorderLimit(BORDER_TOP));
		borderLimitList.push(new BorderLimit(BORDER_RIGHT));
		borderLimitList.push(new BorderLimit(BORDER_BOTTOM));
		borderLimitList.push(new BorderLimit(BORDER_LEFT));
		for (el in borderLimitList) {
			add(el);
		}

		blocks = new Array<Visibility.Block>();
		var segs:Array<Visibility.Segment> = new Array<Visibility.Segment>();
		
		v = new Visibility();
		v.loadMap(G.level.width, G.level.height, 0, blocks, segs);
		v.setLightLocation(G.player.x, G.player.y);
		v.sweep();
		
		add(new KeysText());

		add(G.emitter = new EmitterEntity());
	}
	
	override public function update():Dynamic 
	{
		if (Math.floor(transitionAlpha) >= 1) {
			if (transitionType == "reload") {
				reload();
			} else {
				nextLevel();
			}
		}
		HXP.screen.color = tweenBgColor.color;
		if (Input.pressed(Key.R)) {
			G.transition = true;
			transitionType = "reload";
		}
		
#if debug
		if (Input.pressed(Key.T)) {
			var monster:Monster = new Monster(HXP.scene.mouseX, HXP.scene.mouseY);
			add(monster);
			//walls.push(monster);
		}
#end
		blocks = new Array<Visibility.Block>();
		
		/*for (w in G.monstersList) {
			//w.x -= 25 * HXP.elapsed;
			blocks.push( { x: w.x + w.halfWidth, y: w.y + w.halfHeight, r: w.halfWidth } );
			
			//if (w.x < -16) {
				//remove(w);
				//walls.remove(w);
			//}
		}*/
		
		//if (G.player.moved)
		{
			var segs:Array<Visibility.Segment> = new Array<Visibility.Segment>();
			v.loadMap(G.level.width, G.level.height, 0, blocks, segs);
			G.level.loadSegmentsInScene(v);
			v.setLightLocation(G.player.x, G.player.y);
			v.sweep();
		}
		
		/* Win Conditions */
		
		if (G.currentKeysCount == G.totalKeysCount)
		{
			if (G.player.collide("Exit", G.player.x, G.player.y) != null)
			{
				G.transition = true;
				transitionType = "nextLevel";
			}
		}
		
		if (G.player.dead)
		{
			G.transition = true;
			transitionType = "reload";
		}
		
		super.update();
	}
	
	override public function render():Void
	{
		if (G.transition) {
			//fade out
			//Draw.rect(0, 0, Std.int(HXP.camera.x + HXP.screen.width), Std.int(HXP.camera.y + HXP.screen.height), 0x000000, transitionAlpha);
			//var canvas:BitmapData = new BitmapData(HXP.width, HXP.height, true, transitionAlpha);
			/*HXP.buffer.draw(canvas);*/
			transitionAlpha += HXP.elapsed * 1;
			var tr:Sprite = new Sprite();
			tr.graphics.beginFill(0x000000);
			tr.graphics.lineStyle(0);
			tr.graphics.drawRect(0, 0, Std.int(HXP.screen.width), Std.int(HXP.screen.height));
			tr.graphics.endFill();
			HXP.buffer.draw(tr, null, new ColorTransform(1, 1, 1, transitionAlpha));
		}
		else
		{
			super.render();
			
			var canvas:BitmapData = new BitmapData(HXP.width, HXP.height, false, tweenBgColor.color);
			var colorTransform:ColorTransform = new ColorTransform(1, 1, 1, 1);
			
			var light:Sprite = new Sprite();
			if (backgroundPattern != null) {
				light.graphics.beginBitmapFill(backgroundPattern);
			} else {
				light.graphics.beginFill(0x000000);
			}
			
			light.graphics.lineStyle(1, 0xffffff);
			light.graphics.moveTo(v.output[0].x - HXP.camera.x, v.output[0].y - HXP.camera.y);
			for (i in 1...v.output.length) {
				// hacky bugfix, without it, sometimes, a point has an offset of ~ (0,0) and just kill the dynamic shadows feature...
				if (v.output[i].x >= 0 && v.output[i].y >= 0) {
					//trace((v.output[i].x) + " " + (v.output[i].y));
					light.graphics.lineTo(v.output[i].x - HXP.camera.x, v.output[i].y - HXP.camera.y);
				}
			}
			light.graphics.lineTo(v.output[0].x - HXP.camera.x, v.output[0].y - HXP.camera.y);
			light.graphics.endFill();
			canvas.draw(light);
			if (G.level.gridType == INVERTED) {
				HXP.buffer.draw(canvas, null, colorTransform, BlendMode.SUBTRACT);
				backdrop.backdrop.visible = false;
			} else {
				HXP.buffer.draw(canvas, null, colorTransform, BlendMode.LIGHTEN);
				backdrop.backdrop.visible = true;
			}
			// ADD
			// LIGHTEN	// murs non visibles
			// SCREEN - pareil que ADD et LIGHTEN ? // murs un poil visibles
			// SUBTRACT

			// draw particles
			var entitiesTypeArray:Array<Dynamic> = new Array<Dynamic>();
			HXP.scene.getType("EmitterEntity", entitiesTypeArray);
			for (el in entitiesTypeArray) {
				cast(el, Entity).render();
			}
			// draw monsters
			entitiesTypeArray = [];
			HXP.scene.getType("Monster", entitiesTypeArray);
			for (el in entitiesTypeArray) {
				var e = cast(el, Entity);
				if (e.visible) {
					e.render();
				}
			}
			// draw bullets
			entitiesTypeArray = [];
			HXP.scene.getType("Bullet", entitiesTypeArray);
			for (el in entitiesTypeArray) {
				var e = cast(el, Entity);
				if (e.visible) {
					e.render();
				}
			}
			// draw key
			entitiesTypeArray = [];
			HXP.scene.getType("Key", entitiesTypeArray);
			for (el in entitiesTypeArray) {
				var e = cast(el, Entity);
				if (e.visible) {
					e.render();
				}
			}
			// draw exit
			entitiesTypeArray = [];
			HXP.scene.getType("Exit", entitiesTypeArray);
			for (el in entitiesTypeArray) {
				var e = cast(el, Entity);
				if (e.visible) {
					e.render();
				}
			}
			// draw diamond
			entitiesTypeArray = [];
			HXP.scene.getType("DiamondShape", entitiesTypeArray);
			for (el in entitiesTypeArray) {
				cast(el, Entity).render();
			}
			// draw player
			cast(G.player, Entity).render();
		}
	}
	
	public function nextLevel():Void
	{
		removeAll();
		
		if (G.currentLevel < G.levels.length - 1) {
			G.currentLevel++;
			loadLevel();
		} else {
			// load credits
			music.stop();
			removeAll();
			resetData();
			HXP.scene = new GameOver();
		}
	}
	
	public function reload():Void
	{
		removeAll();
		loadLevel();
	}
	
	public function resetData():Void
	{
		transitionAlpha = 0;
		transitionType = "";
		G.transition = false;
		G.monstersList = new Array<Monster>();
		G.currentKeysCount = 0;
		G.totalKeysCount = 0;
		HXP.camera.x = 0;
		HXP.camera.y = 0;
	}
	
	private function musicComplete():Void
	{
		if (currentSongName == "sfx/track01.mp3") {
			music = new Sfx("sfx/track02.mp3", musicComplete);
		} else {
			music = new Sfx("sfx/track01.mp3", musicComplete);
		}
		music.play();
	}
}