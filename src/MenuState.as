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
		
		[Embed(source = "data/Action_Melody_Menu.mp3")] public var BgmMenu:Class;
		
		[Embed(source = "data/peterpan.png")] public var ImgPeterpan:Class;
		
		
		//Replay data for the "Attract Mode" gameplay demos
<<<<<<< HEAD
		//[Embed(source="data/attract1.fgr",mimeType="application/octet-stream")] public var Attract1:Class;
		//[Embed(source="data/attract2.fgr",mimeType="application/octet-stream")] public var Attract2:Class;
		
		
		[Embed(source = "data/titlebg.jpg")] public var ImgTitle:Class;
		
		
		[Embed(source = "data/JOKERMAN.ttf", embedAsCFF = "false", fontFamily = 'JOKERMAN')] private const FontJOKERMAN:Class;
=======

>>>>>>> d0a22988397dffec208eeca2c2037b8aca4cb5c3
		
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
		
		public static var maxLevel:int = 2;
		public static var starNeed:int = 10;
		
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

			gibs = new FlxEmitter(0,0,1000);
			gibs.setSize(FlxG.width, FlxG.height/10);
			//gibs.setYSpeed(-200,-20);
			gibs.setRotation( -360, 360);
			
			gibs.lifespan = 100;
			//gibs.gravity = 100;
			gibs.makeParticles(ImgGibs,30,20,true,0.8);
			add(gibs);
			gibs.setXSpeed (-20,20);
			gibs.setYSpeed (20,100);
			
			gibs.start(false, 15, 0.5, 20000);
			
			
			FlxG.playMusic(BgmMenu,0.8);
			
			var titlebg:FlxSprite = new FlxSprite(0, 0, ImgTitle);
			add(titlebg);
			
			title1 = new FlxText(FlxG.width / 2 - 150, FlxG.height / 3, 300, "NeverLand");
			title1.alignment =  "center";
			title1.font = "JOKERMAN";
			title1.size = 32;
			//title1.color = 0xff99cc;
			title1.color = 0x00736d;
			
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
			continueText = new FlxText(FlxG.width/2-100,FlxG.height/3+85,200,"Press 'Space' to continue");
			continueText.color = 0xffffff;
			continueText.size = 10;
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
		
		public function generatePeterpan():void
		{
			
			
			
			var timeline:TimelineMax = new TimelineMax({repeat:-1, repeat:true, repeatDelay:1.5});
			
			//timeline.insertMultiple( TweenMax.allFrom([logo, timelineWord, maxWord, byGreenSock], 0.5, {autoAlpha:0}, 0.25), 0.6);
			//timeline.insertMultiple( TweenMax.allFrom(lettersArray, 1, { y:"-30", alpha:0, ease:Elastic.easeOut }, 0.04), 1.4);
			
			var peterpan:FlxSprite = new FlxSprite(-50, 15);
			//peterpan.loadRotatedGraphic(ImgPeterpan, 30, 0,true);
			peterpan.loadGraphic(ImgPeterpan, true);
			peterpan.addAnimation("fly", [0,1], 15,true);
			peterpan.play("fly");
			peterpan.angle = 60;
			timeline.append( TweenMax.fromTo(peterpan, 5, { x: -50, y:15 }, { x:FlxG.width/2, y:50, ease:Quad.easeInOut } ) );
			timeline.append( TweenMax.to(peterpan, 5,{x:FlxG.width,y:15, ease:Quad.easeInOut } ) );
			//timeline.append( TweenMax.fromTo(peterpan, 1,{angle:0}, { angle:90,ease:Quad.easeInOut } ) );
			add(peterpan);
		}
		
		
		public function titleFinished():void
		{
			var text:FlxText;
			text = new FlxText(FlxG.width/2-51,FlxG.height/3+45,102,"Designed by Sunfish")
			text.alignment = "center";
			
			text.color = 0xffccff;
			text.shadow=0xccff;
			
			add(text);
			
			title1.shadow = 0xffff;
			generatePeterpan();
			
			
			/*
			text = new FlxText(FlxG.width/2-50,FlxG.height/3+135,100,"Music provided by IO & Gryzor")
			text.alignment = "center";
			
			text.color = 0xffccff;
			title1.shadow = 0xffff;
			add(text);
			*/
			
			
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
			FlxG.watch(this, "timer");
			//if(timer >= 10) //go into demo mode if no buttons are pressed for 10 seconds
				//attractMode = true;	
			
			arrow.y = menuIndex * 20 + FlxG.height / 3+69;
			if (menuState == 0)//Title
			{
				
				if (timer>=1	)
				{
					timer = 0;
					continueText.visible = !continueText.visible;
				}
				
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
		

	}
}
