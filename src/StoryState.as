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
		[Embed(source = "data/msyh.ttf", embedAsCFF="false", fontFamily = 'msyh')] private const Fontmayh:Class;
		
		protected var storyText:FlxText;
		
		protected var story:Array;
		protected var storyImage:Array;
		
		protected var curStoryIndex:uint=0;
		
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
			story[0] = "又是一天华灯初上的时候，我们的彼得潘在寻找适合永无岛的新的母亲。他穿过了巴黎，穿过了伦敦，趴在了每一扇家里躺着小女孩的窗户外，想找到和温迪相似的人。";
			story[1] = "正在他苦苦寻找之际，突然天空中滑过一阵闪电，整片大地瞬间变成了亮白色，一时没注意到如此变故的彼得潘被亮光照耀的睁不开双眼。";
			story[2] = "他只听得一声巨响，他看不到天空中出现了一架彩色的UFO，上面印有P.A.N的字母。";
			story[3] = "等彼得潘眼睛视力恢复的时候，他发现他居然无法控制自己的飞行，因为他被飞船强大的吸力给困住，吸进了飞船里！";
			story[4] = "等彼得潘眼睛视力恢复的时候，他发现他居然无法控制自己的飞行，因为他被飞船强大的吸力给困住，吸进了飞船里！";
			story[5] = "飞船抓了彼得潘后霎时便又飞走了。天空又恢复了一片安静。好像什么都没有发生。";
			
			storyText = new FlxText(FlxG.width / 2 - 150, 150, 300, "");
			storyText.alignment =  "left";
			storyText.font = "msyh";
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
			super.destroy();
		}
		
		public function StoryState() 
		{
			
		}
		
		override public function update():void
		{
			super.update();
			if (FlxG.keys.justPressed("Z"))
			{

				if (curStoryIndex < story.length-1 )
				{
					curStoryIndex++;
					FlxG.flash(0x000000, 1);
					storyText.text = story[curStoryIndex];
					add(storyImage[curStoryIndex]);
				}
			}
			
		}
		
		
		
	}

}