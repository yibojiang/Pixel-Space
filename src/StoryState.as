package  
{
	import org.flixel.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	/**
	 * ...
	 * @author yibojiang
	 */
	public class StoryState extends FlxState 
	{
		
		[Embed(source = "data/story1.jpg")] private var ImgStory1:Class;
		[Embed(source = "data/story2.jpg")] private var ImgStory2:Class;
		[Embed(source = "data/story3.jpg")] private var ImgStory3:Class;
		[Embed(source = "data/story4.jpg")] private var ImgStory4:Class;
		[Embed(source = "data/story5.jpg")] private var ImgStory5:Class;
		[Embed(source = "data/story6.jpg")] private var ImgStory6:Class;
		
		
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
			storyImage[1] = new FlxSprite(FlxG.width / 2-100 , 50, ImgStory2); 
			storyImage[2] = new FlxSprite(FlxG.width / 2-100 , 50, ImgStory3); 
			storyImage[3]= new FlxSprite(FlxG.width / 2 -100, 50, ImgStory4); 
			storyImage[4] = new FlxSprite(FlxG.width / 2 -100, 50, ImgStory5); 
			storyImage[5] = new FlxSprite(FlxG.width / 2 -100, 50, ImgStory6); 
			story[0] = "Once upon a time,there was a boy named Peter Pan. He looked for a girl like Windy everywhere. He flied through London,Paris and so on.";
			story[1] = "Suddenly,there came a thunder from the sky, all the land became white. ";
			story[2] = "Peter Pan could't open his eyes.He heard a loud crash.What he couldn't see was that a colorful UFO in the deep blue sky.On the UFO there were three letters \"p,a,n\"";
			story[3] = "When Peter Pan could see it was too late. He couldn't fly any more as he was involved in the UFO.";
			story[4] = "When Peter Pan could see it was too late. He couldn't fly any more as he was involved in the UFO.";
			story[5] = "The UFO disappeared in several seconds after that.The sky was quite again as there was nothing happened before.";
			
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
		
		public function StoryState() 
		{
			
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
						FlxG.fade(0xff131c1b, 1, gotoGameState);
						fading = true;
					}
				}
			}
			
		}
		
		protected function gotoGameState():void
		{
			FlxG.switchState(new PlayState());
		}
		
	}

}