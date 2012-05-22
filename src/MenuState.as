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
		[Embed(source="data/title.mp3")] public var SndHit:Class;
		[Embed(source = "data/menu_hit_2.mp3")] public var SndHit2:Class;
		[Embed(source = "data/menu_select.mp3")] public var SndMenuSelect:Class;
		
		
		//Replay data for the "Attract Mode" gameplay demos

		
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
			FlxG.mouse.hide();
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

			gibs = new FlxEmitter(FlxG.width/2-50,FlxG.height/2-10);
			gibs.setSize(100,30);
			gibs.setYSpeed(-200,-20);
			gibs.setRotation(-360,360);
			gibs.gravity = 100;
			gibs.makeParticles(ImgGibs,30,32,true,0);
			add(gibs);

			
			
			title1 = new FlxText(FlxG.width / 2 - 150, FlxG.height / 3, 300, "NeverLand");
			title1.alignment =  "center";
			title1.size = 32;
			title1.color = 0xff99cc;
			title1.alpha = 0;
			title1.antialiasing = true;
			
			
			add(title1);
			TweenMax.to(title1, 0.8, {alpha:1, ease:Quad.easeIn, onComplete:titleFinished } );
	
			
			
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
			text = new FlxText(FlxG.width/2-50,FlxG.height/3+45,100,"by Sunfish")
			text.alignment = "center";
			
			text.color = 0xffccff;
			add(text);
			
			title1.shadow = 0xffff;
			
			FlxG.play(SndHit);
			FlxG.flash(0xffd8eba2,0.5);
			FlxG.shake(0.035,0.5);
	
			//gibs.start(true,5);
	
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
			FlxG.flash(0xffd8eba2, 0.5);
			FlxG.fade(0xff131c1b, 1, gotoGameState);
			fading = true;
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
			FlxG.fade(0xff131c1b, 1, gotoEditorState);
			fading = true;
		}
		
		override public function update():void
		{

			
			super.update();
			
			if (fading)
			{
				return;
			}
			timer += FlxG.elapsed;
			//if(timer >= 10) //go into demo mode if no buttons are pressed for 10 seconds
				//attractMode = true;	
			
			arrow.y = menuIndex * 20 + FlxG.height / 3+69;
			if (menuState == 0)//Title
			{
				if(!fading && (FlxG.keys.justPressed("SPACE") )) 
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
		
		
		protected function gotoEditorState():void
		{
			FlxG.switchState(new EditorState());
		}
		
		protected function gotoGameState():void
		{
			FlxG.switchState(new StoryState());
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
