package control;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.masks.Grid;
import com.haxepunk.masks.Polygon;
import entitites.Exit;
import entitites.Key;
import entitites.Monster;
import entitites.Player;
import entitites.Turret;
import nme.Assets;
import nme.display.BitmapData;
import nme.geom.Point;
import haxe.xml.Fast;
import com.haxepunk.HXP;

/**
 * ...
 * @author julsam
 */

enum GRID_TYPE {
	NORMAL;
	INVERTED;
}

class Level extends Entity
{
	private var xml:Xml;
	
	public var grid(default, null):Grid;
	public var invertedGrid(default, null):Grid;
	public var gridType(default, null):GRID_TYPE;
	
	public var normalTiles:Tilemap;
	public var invertedTiles:Tilemap;
	public var normalTilemapEntity:Entity;
	public var invertedTilemapEntity:Entity;
	
	public var filename(default, null):String;
	public var id(default, null):Int;
	public var segments(default, null):Array<Dynamic>;
	
	public function new(filename:String) 
	{
		super();
		type = "Solid";
		layer = 100;
		active = false;
		visible = false;
		
		this.filename = filename;
		xml = Xml.parse(Assets.getText(filename));
		var fast = new haxe.xml.Fast(xml.firstElement());
		
		width = Std.parseInt(fast.att.width);
		height = Std.parseInt(fast.att.height);
		
		/* Segments */
		segments = new Array<Dynamic>();
		var prev:Fast = null;
		for (o in fast.node.Walls.nodes.WallNode)
		{
			prev = o;
			for (oo in o.nodes.node)
			{
				//trace(o.att.x + " " + o.att.y);
				addSegment(prev, oo);
				addPolygon(prev, oo);
				prev = oo;
			}
		}
		
		/* Keys */
		for (o in fast.node.Objects.nodes.Key)
		{
			HXP.scene.add(new Key(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			G.totalKeysCount++;
		}
		
		/* Exit */
		for (o in fast.node.Objects.nodes.Exit)
		{
			HXP.scene.add(new Exit(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
		}
		
		/* Turrets */
		for (o in fast.node.Objects.nodes.Turret)
		{
			HXP.scene.add(new Turret(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.direction)));
		}
		
		/* Player */
		for (o in fast.node.Objects.nodes.Player)
		{
			HXP.scene.add(G.player = new Player(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			HXP.scene.add(new Camera(G.player));
		}
		
		/* Exit */
		for (o in fast.node.Objects.nodes.Monster)
		{
			HXP.scene.add(new Monster(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
		}
		
		
		/* Grid */
		this.grid = new Grid(width, height, G.GRID_SIZE, G.GRID_SIZE);
		this.invertedGrid = new Grid(width, height, G.GRID_SIZE, G.GRID_SIZE);
		this.mask = this.grid;
		gridType = NORMAL;
		
		this.normalTiles = new Tilemap(HXP.getBitmap("gfx/tileset.png"), width, height, G.GRID_SIZE, G.GRID_SIZE);
		this.invertedTiles = new Tilemap(HXP.getBitmap("gfx/tileset.png"), width, height, G.GRID_SIZE, G.GRID_SIZE);
		
		loadMap();
	}
	
	public function collideMask(e:Entity, ?gridType:GRID_TYPE):Bool
	{
		if (gridType == null) gridType = NORMAL;
		var result:Bool;
		
		if (gridType == NORMAL) {
			this.mask = this.grid;
			result = mask.collide(e.HITBOX);
			this.mask = this.invertedGrid;
		} else {
			this.mask = this.invertedGrid;
			result = mask.collide(e.HITBOX);
			this.mask = this.grid;
		}
		return result;
	}
	
	public function useNormalGrid():Void
	{
		this.mask = this.grid;
		gridType = NORMAL;
	}
	
	public function useInvertedGrid():Void
	{
		this.mask = this.invertedGrid;
		gridType = INVERTED;
	}
	
	public function switchGrid():Void
	{
		if (gridType == NORMAL) {
			useInvertedGrid();
		} else {
			useNormalGrid();
		}
	}
	
	private function loadMap():Void
	{
		var fast:Fast = new haxe.xml.Fast(xml.firstElement());
		
		//trace(fast.node.grid.innerData.split("\n"));
		var row:Array<String> = fast.node.Grid.innerData.split("\n"),
			rows:Int = row.length,
			col:Array<String>, cols:Int, x:Int, y:Int;
		for (y in 0...rows)
		{
			if (row[y] == '') continue;
			col = row[y].split('');
			cols = col.length;
			for (x in 0...cols)
			{
				if (col[x] == '') continue;
				
				if (col[x] == '1') {
					this.grid.setTile(x, y, true);
					this.normalTiles.setTile(x, y, 0);
					this.invertedTiles.setTile(x, y, 1);
				}
				if (col[x] == '0') {
					this.invertedGrid.setTile(x, y, true);
					this.normalTiles.setTile(x, y, 1);
					this.invertedTiles.setTile(x, y, 0);
				}
			}
		}
	}
	
	private function addSegment(node1:Fast, node2:Fast):Void
	{
		var p1 = new Point(Std.parseInt(node1.att.x), Std.parseInt(node1.att.y));
		var p2 = new Point(Std.parseInt(node2.att.x), Std.parseInt(node2.att.y));
		segments.push( { p1: p1, p2: p2 } );
	}
	
	private function addPolygon(node1:Fast, node2:Fast):Void
	{
		var p1 = new Point(Std.parseInt(node1.att.x), Std.parseInt(node1.att.y));
		var p2 = new Point(Std.parseInt(node2.att.x), Std.parseInt(node2.att.y));
		HXP.scene.addMask(new Polygon([p1, p2]), "Solid");
	}
	
	public function loadSegmentsInScene(v:Visibility):Void
	{
		for (el in segments) {
			/*if (	el.p1.x > HXP.camera.x && el.p1.x < HXP.camera.x + HXP.screen.width
				&&  el.p2.x > HXP.camera.x && el.p2.x < HXP.camera.x + HXP.screen.width
				&&  el.p1.y > HXP.camera.y && el.p1.y < HXP.camera.y + HXP.screen.height
				&&  el.p2.y > HXP.camera.y && el.p2.y < HXP.camera.y + HXP.screen.height)*/
			{
				v.addSegment(el.p1.x, el.p1.y, el.p2.x, el.p2.y);
			}
		}
	}
	
	public function isTileEmpty(x:Float, y:Float):Bool
	{
		return !grid.getTile(Std.int(x / G.GRID_SIZE), Std.int(y / G.GRID_SIZE));
	}
	
}