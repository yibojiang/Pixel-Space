package  
{
	import org.flixel.*;
	
	
	/**
	 * ...
	 * @author yibojiang
	 */
	public class Item extends FlxSprite 
	{
		
		[Embed(source = "data/move_tiles.png")] private var ImgMVTile:Class;
		
		public static const Star:uint = 0;
		public static const Material:uint = 1;
		
		public var itemType:uint = 0;
		
		public function Item(X:Number,Y:Number,ItemTye:uint) 
		{
			super(X, Y);
			itemType = ItemTye;
			if (itemType == Item.Material)
			{
				loadGraphic(ImgMVTile, true);
				this.frame = 4;
				//this.flicker( -1);
				
				velocity.x = (FlxG.random()-0.5) *100;
				velocity.y = (FlxG.random() -0.5) * 100;
				maxVelocity.x = 80;
				maxVelocity.y = 80;
				angularVelocity = (FlxG.random() - 0.5)*200+100;
				angularDrag = angularVelocity*4;
				drag.x = 80 ;
				drag.y = 80;
				this.scale.x = FlxG.random()*0.5+0.5 ;
				this.scale.y = this.scale.x;
			}
			else if (itemType == Item.Star)
			{
				loadGraphic(ImgMVTile, true);
				this.frame = 3;
				
			}
		}
		
	}

}