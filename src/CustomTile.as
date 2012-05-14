package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author yibojiang
	 */
	
	
	public class CustomTile extends FlxSprite 
	{
		public var type:int;
		public var index:int;
		public var tileName:String;
		[Embed(source = "data/custom_tiles.png")] private var ImgCustomTile:Class;
		[Embed(source = "data/background_tiles.png")] private var ImgNCTile:Class;
		[Embed(source = "data/move_tiles.png")] private var ImgMVTile:Class;
		public function CustomTile(Type:int,Index:int,TileName:String) 
		{
			super();
			type=Type;
			index = Index;
			tileName = TileName;
			if (Type == TileType.CollisionTile)
			{
				loadGraphic(ImgCustomTile,true,false,16,16);
				addAnimation("empty", [0], 50, false);
				addAnimation("grass", [1], 50, false);
				addAnimation("brick", [2], 50, false);
				addAnimation("default", [3], 50, false);
				addAnimation("dirt", [4], 50, false);
			}
			else if (Type == TileType.BackgroundTile)
			{
				
			}
			else if (Type == TileType.NonCollisionTile)
			{
				loadGraphic(ImgNCTile,true,false,16,16);
				addAnimation("empty", [0], 50, false);
				addAnimation("light_blue", [1], 50, false);
				addAnimation("dark_blue", [2], 50, false);
				addAnimation("green", [3], 50, false);
				addAnimation("black", [4], 50, false);
			}
			else if (Type == TileType.MoveTile)
			{
				loadGraphic(ImgMVTile,true,false,16,16);
				addAnimation("empty", [0], 50, false);
				addAnimation("spawner", [1], 50, false);
				addAnimation("player", [2], 50, false);
			}
			play(TileName);
			
			
		}
		
	}

}