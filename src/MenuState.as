package
{
	import com.greensock.plugins.AutoAlphaPlugin;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	
	import org.flixel.*;
	import org.flixel.plugin.DebugPathDisplay;

	
	import com.greensock.*;
	import com.greensock.easing.*;
	public class MenuState extends FlxState
	{
		//Some graphics and sounds
		[Embed(source="data/bot.png")] protected var ImgEnemy:Class;
		[Embed(source="data/heart.png")] public var ImgGibs:Class;
		[Embed(source="data/cursor.png")] public var ImgCursor:Class;
		[Embed(source="data/menu_hit.mp3")] public var SndHit:Class;
		[Embed(source = "data/menu_hit_2.mp3")] public var SndHit2:Class;
		[Embed(source = "data/menu_select.mp3")] public var SndMenuSelect:Class;
		
		
		//Replay data for the "Attract Mode" gameplay demos
		[Embed(source="data/attract1.fgr",mimeType="application/octet-stream")] public var Attract1:Class;
		[Embed(source="data/attract2.fgr",mimeType="application/octet-stream")] public var Attract2:Class;
		
		public var gibs:FlxEmitter;
		public var title1:FlxText;
		public var title2:FlxText;
		public var fading:Boolean;
		public var timer:Number;
		public var attractMode:Boolean;
		
		public var pathFollower:FlxSprite;
		public var testPath:FlxPath;
		
		//public static  var  currentLevel:String = "Map";
		
		public static var levelArray:Array;
		public static var currentLevelIndex:int = 0;
		
		public var continueText:FlxText;
		
		public var levelSelectText:FlxText;
		
		
		protected var menuState:int = -1;
		/*
		 * -1:Title Animation
		 * 0:Title
		 * 1:Main Menu
		 * 2:Editor Menu
		 * 3:Credits
		 */
		
		protected var mainMenuText:FlxGroup;
		
		protected var menuIndex:int;
		
		
		protected var mainMenuCall:Array;
		
		protected var arrow:FlxText;
		
		override public function create():void
		{
			
			mainMenuCall = new Array();
			mainMenuCall[0] = gotoPlay;
			mainMenuCall[1] = gotoEditorMenu;
			
			menuState = -1;
			levelArray = new Array();
			levelArray[0] = "Map";
			levelArray[1] = "Map1";
			levelArray[2] = "Map2";
			levelArray[3] = "Map3";
			levelArray[4] = "Map4";
			
			FlxG.bgColor = 0xff000000;
			
			//Simple use of flixel save game object.
			//Tracks number of times the game has been played.
			var save:FlxSave = new FlxSave();
			if(save.bind("Mode"))
			{
				if(save.data.plays == null)
					save.data.plays = 0 as Number;
				else
					save.data.plays++;
				FlxG.log("Number of plays: "+save.data.plays);
				//save.erase();
				save.close();
			}

			//All the bits that blow up when the text smooshes together
			gibs = new FlxEmitter(FlxG.width/2-50,FlxG.height/2-10);
			gibs.setSize(100,30);
			gibs.setYSpeed(-200,-20);
			gibs.setRotation(-360,360);
			gibs.gravity = 100;
			gibs.makeParticles(ImgGibs,30,32,true,0);
			add(gibs);

			title1 = new FlxText(FlxG.width + 16,FlxG.height/3,64,"Lo");
			title1.size = 32;
			title1.color = 0xff99cc;
			title1.antialiasing = true;
			add(title1);
			
			TweenMax.to(title1, 0.8, {x:FlxG.width/2-40, ease:Quad.easeIn,onComplete:titleFinished});
			title2 = new FlxText(-60,title1.y,title1.width+8,"ve");
			title2.size = title1.size;
			title2.color = title1.color;
			title2.antialiasing = title1.antialiasing;
			//title2.velocity.x = FlxG.width;
			add(title2);
			TweenMax.to(title2, 0.8, {x:FlxG.width/2, ease:Quad.easeIn});
			
			
			fading = false;
			timer = 0;
			attractMode = false;
			
			initMenu();
		}
		
		override public function destroy():void
		{
			super.destroy();
			gibs = null;
			
			title1 = null;
			title2 = null;
			continueText = null;
		}

		
		public function initMenu():void
		{	
			continueText = new FlxText(FlxG.width/2-75,FlxG.height/3+69,150,"Press 'Space' to continue");
			continueText.color = 0xffffff;
			continueText.alignment = "center";
			add(continueText);
			continueText.exists = false;
			
			mainMenuText = new FlxGroup();
			var playMode:FlxText = new FlxText(FlxG.width/2-75,FlxG.height/3+69,150,"Play Mode");
			playMode.color = 0xffffff;
			playMode.alignment = "center";
			mainMenuText.add(playMode);
			
			var editMode:FlxText = new FlxText(FlxG.width/2-75,FlxG.height/3+89,150,"Edit Mode");
			editMode.color = 0xffffff;
			editMode.alignment = "center";
			mainMenuText.add(editMode);
			
			
			add(mainMenuText);
			mainMenuText.exists = false;
			
			arrow = new FlxText(FlxG.width / 2 - 115, FlxG.height / 3 + 89, 150, "->");
			arrow.color = 0xffffff;
			arrow.alignment = "center";
			add(arrow);
			arrow.exists = false;
			
			levelSelectText = new FlxText(FlxG.width / 2 - 75, FlxG.height / 3 + 89, 150, currentLevelIndex.toString());
			levelSelectText.color = 0xffffff;
			levelSelectText.alignment = "center";
			add(levelSelectText);
			levelSelectText.exists = false;
		}
		
		public function titleFinished():void
		{
			var text:FlxText;
			text = new FlxText(FlxG.width/2-50,FlxG.height/3+39,100,"by Sunfish")
			text.alignment = "center";
			text.color = 0xffccff;
			add(text);
			
			FlxG.play(SndHit);
			//FlxG.flash(0xffd8eba2,0.5);
			FlxG.shake(0.035,0.5);
			title1.color = 0xff99cc;
			title2.color = 0xff99cc;
			gibs.start(true,5);
			//title1.angle = FlxG.random()*30-15;
			//title2.angle = FlxG.random()*30-15;
			gotoTitle();
		}
		
		public function gotoMainMenu():void
		{
			
			menuState = 1;
			continueText.exists = false;
			mainMenuText.exists = true;
			levelSelectText.exists = false;
			arrow.exists = true;
			
		}
		
		public function gotoTitle():void
		{
			menuState = 0;
			continueText.exists = true;
			mainMenuText.exists = false;
			arrow.exists = false;
		}
		
		public function gotoPlay():void
		{
			FlxG.play(SndHit2);
			FlxG.flash(0xffd8eba2,0.5);
		}
		
		public function gotoEditorMenu():void
		{
			menuState = 2;
			mainMenuText.exists = false;
			arrow.exists = false;
			levelSelectText.exists = true;
		}
		
		public function gotoEditor():void
		{
			fading = true;
			FlxG.play(SndHit2);
			FlxG.flash(0xffd8eba2,0.5);
			FlxG.fade(0xff131c1b,1,onFade);
		}
		
		override public function update():void
		{

			
			super.update();
			
			timer += FlxG.elapsed;
			//if(timer >= 10) //go into demo mode if no buttons are pressed for 10 seconds
				//attractMode = true;	
			
			arrow.y = menuIndex * 20 + FlxG.height / 3+69;
			if (menuState == 0)//Title
			{
				if(!fading && (FlxG.keys.justPressed("SPACE") || attractMode)) 
				{
					FlxG.flash(0xffd8eba2,0.5);
					FlxG.play(SndHit2);
					gotoMainMenu();
				}
			}
			else if (menuState == 1)//Main Menu
			{
				if (!fading && (FlxG.keys.justPressed("ESCAPE")))
				{
					gotoTitle();
				}
				
				if (!fading && (FlxG.keys.justPressed("SPACE")))
				{
					mainMenuCall[menuIndex]();
				}
				
				if (FlxG.keys.justPressed("UP"))
				{
					if (menuIndex > 0)
					{
						FlxG.play(SndMenuSelect);
						menuIndex--;
					}
				}
				
				if (FlxG.keys.justPressed("DOWN"))
				{
					if (menuIndex < mainMenuCall.length-1)
					{
						FlxG.play(SndMenuSelect);
						menuIndex++;
					}
				}
				
				//menuIndex = clamp(menuIndex, 0, mainMenuCall.length-1);
			}
			else if (menuState == 2)//Editor Menu
			{
				if (!fading && (FlxG.keys.justPressed("ESCAPE")))
				{
					gotoMainMenu();
				}
				
				if (!fading && (FlxG.keys.justPressed("SPACE")))
				{
					gotoEditor();
				}
				
				if (FlxG.keys.justPressed("LEFT"))
				{
					if (currentLevelIndex > 0)
					{
						FlxG.play(SndMenuSelect);
						currentLevelIndex--;
					}
				}
				
				if (FlxG.keys.justPressed("RIGHT"))
				{
					if (currentLevelIndex <levelArray.length - 1)
					{
						FlxG.play(SndMenuSelect);
						currentLevelIndex++;
					}
				}
				
				//currentLevelIndex = clamp(currentLevelIndex, 0,  levelArray.length - 1);
				levelSelectText.text ="Level: " +currentLevelIndex;
			}
		}
		
		protected function clamp(Value:int,Min:int,Max:int):int
		{
			if (Value < Min)
				return Min;
			
			if (Value > Max)
				return Max;
			
			return Value;
		}
		
		//This function is passed to FlxG.fade() when we are ready to go to the next game state.
		//When FlxG.fade() finishes, it will call this, which in turn will either load
		//up a game demo/replay, or let the player start playing, depending on user input.
		protected function onFade():void
		{
			if (attractMode)
			{
				FlxG.loadReplay((FlxG.random() < 0.5)?(new Attract1()):(new Attract2()), new PlayState(), ["ANY"], 22, onDemoComplete);
			}
			else
			{
				//FlxG.switchState(new PlayState());
				FlxG.switchState(new EditorState());
			}
		}
		
		//This function is called by FlxG.loadReplay() when the replay finishes.
		//Here, we initiate another fade effect.
		protected function onDemoComplete():void
		{
			FlxG.fade(0xff131c1b,1,onDemoFaded);
		}
		
		//Finally, we have another function called by FlxG.fade(), this time
		//in relation to the callback above.  It stops the replay, and resets the game
		//once the gameplay demo has faded out.
		protected function onDemoFaded():void
		{
			FlxG.stopReplay();
			FlxG.resetGame();
		}
	}
}
