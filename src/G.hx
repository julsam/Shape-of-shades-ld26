package ;
import control.Level;
import entitites.Player;
import entitites.Monster;

/**
 * ...
 * @author julsam
 */
class G
{
	// level
	public static var currentLevel:Int = 0;
	public static var levels:Array<String> = new Array<String>();
	
	// keys
	public static var currentKeysCount:Int = 0;
	public static var totalKeysCount:Int = 0;
	
	// global access
	public static var level:Level;
	public static var player:Player;
	public static var monstersList:Array<Monster> = new Array<Monster>();
	
	
	public static var transition:Bool = false;
	
	// const
	public static inline var GRID_SIZE:Int = 16;
	public static inline var MARGIN:Int = 64;
}