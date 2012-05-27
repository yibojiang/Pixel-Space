package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author yibojiang
	 */
	public class EndStoryState extends FlxState 
	{
		[Embed(source = "data/Endstory1.png")] private var ImgStory1:Class;
		[Embed(source = "data/Endstory2.png")] private var ImgStory2:Class;

		[Embed(source = "data/JOKERMAN.ttf", embedAsCFF = "false", fontFamily = 'JOKERMAN')] private const FontJOKERMAN:Class;
		[Embed(source = "data/menu_hit_2.mp3")] public var SndHit2:Class;
		
		protected var storyText:FlxText;
		
		protected var story:Array;
		protected var storyImage:Array;
		
		protected var curStoryIndex:uint = 0;
		
		protected var fading:Boolean = false;
		
		override public function create():void
		{
			FlxG.bgColor = FlxG.BLACK;
			storyImage = new Array();
			story = new Array();
			storyImage[0] = new FlxSprite(FlxG.width / 2-100 , 50, ImgStory1); 
			storyImage[1] = new FlxSprite(FlxG.width / 2 - 100 , 50, ImgStory2); 
			
			story[0] = "Once upon a time,there was a boy named Peter Pan. He looked for a girl like Windy everywhere. He flied through London,Paris and so on.";
			story[1] = "Suddenly,there came a thunder from the sky, all the land became white. ";
			storyText = new FlxText(FlxG.width / 2 - 150, 150, 300, "");
			storyText.alignment =  "left";
			storyText.font = "JOKERMAN";
			storyText.size = 10;
			storyText.color = 0xffffff;
			storyText.antialiasing = true;
			
			add(storyText);
			
			FlxG.flash(0x000000, 1);
			
			storyText.text = story[curStoryIndex];
			add(storyImage[curStoryIndex]);
		}
		
		override public function destroy():void
		{
			storyText = null;
			super.destroy();
		}
		
		override public function update():void
		{
			super.update();
			if (FlxG.keys.justPressed("SPACE"))
			{

				if (curStoryIndex < story.length-1 )
				{
					curStoryIndex++;
					FlxG.flash(0x000000, 1);
					storyText.text = story[curStoryIndex];
					add(storyImage[curStoryIndex]);
				}
				else
				{
					if (!fading)
					{
						FlxG.play(SndHit2);
						FlxG.flash(0xffd8eba2, 0.5);
						FlxG.play(SndHit2);
						FlxG.fade(0xff131c1b, 1, gotoMenuState);
						fading = true;
					}
				}
			}
			
		}
		
		protected function gotoMenuState():void
		{
			FlxG.switchState(new MenuState());
		}
		
	}

}