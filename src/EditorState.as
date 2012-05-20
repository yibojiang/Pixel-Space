package  
{

	import com.greensock.easing.Quad;
	import org.flixel.*;
	import org.flixel.system.FlxTile;
	import flash.net.*;
	 
	public class EditorState extends FlxState 
	{
		
		[Embed(source="data/mode.mp3")] protected var SndMode:Class;
		[Embed(source="data/countdown.mp3")] protected var SndCount:Class;
		[Embed(source="data/heart.png")] public var ImgGibs:Class;
		[Embed(source="data/heart.png")] public var ImgSpawnerGibs:Class;
		[Embed(source = "data/miniframe.png")] private var ImgMiniFrame:Class;
		
		[Embed(source = "data/blackhole.png")] private var ImgBlackhole:Class;
		
		[Embed(source = "data/custom_tiles.png")] private var ImgCustomTile:Class;
		[Embed(source = "data/background_tiles.png")] private var ImgNCTile:Class;
		[Embed(source = "data/move_tiles.png")] private var ImgMVTile:Class;
		
		[Embed(source = 'data/selection.png')]private var ImgSelection:Class;
		
		[Embed(source = "data/Pickup_Coin.mp3")] protected var SndCoin:Class;
		
		
		
		
		protected var _blocks:FlxGroup;
		protected var _bullets:FlxGroup;
		protected var _player:Player;
		protected var _enemies:FlxGroup;
		protected var _spawners:FlxGroup;
		protected var _enemyBullets:FlxGroup;
		protected var _littleGibs:FlxEmitter;
		protected var _bigGibs:FlxEmitter;
		protected var _items:FlxGroup;
		
		//meta groups, to help speed up collisions
		protected var _objects:FlxGroup;
		protected var _hazards:FlxGroup;
		protected var _hud:FlxGroup;
		protected var _fading:Boolean;
		
		private var highlightBox:FlxSprite;
		
		private const TILE_WIDTH:uint = 16;
		private const TILE_HEIGHT:uint = 16;
		private var mapWidth:uint = 640;
		private var mapHeight:uint = 640;
		
		private var collisionMap:FlxTilemap;
		private var nonCollisionMap:FlxTilemap;
		private var backgroundMap:FlxTilemap;
		private var moveMap:FlxTilemap;
		
	
		
		private var toolIndex:int;
		protected var toolSelection:FlxSprite;
		protected var toolBox:FlxGroup;
		protected var tools:FlxGroup;
		
		protected var blackholes:FlxGroup;
		
		protected var blackhole01:BlackHole;
		protected var blackhole02:BlackHole;
		
		protected var currentTools:Array;
		
		
		protected var paused:Boolean=false;
		
		protected var editorUI:FlxGroup;
		
		protected var playButton:FlxButton;
		
		//editor mode or playmode
		protected var isPlaying:Boolean = false;
		
		override public function create():void
		{
			FlxG.framerate = 60;
			FlxG.flashFramerate = 60;
			//Here we are creating a pool of 100 little metal bits that can be exploded.
			//We will recycle the crap out of these!
			_littleGibs = new FlxEmitter();
			_littleGibs.setXSpeed(-150,150);
			_littleGibs.setYSpeed(-200,0);
			_littleGibs.setRotation(-720,-720);
			_littleGibs.gravity = 30;
			_littleGibs.bounce = 0.5;
			_littleGibs.makeParticles(ImgGibs, 50, 10, true);
			
			
			//Next we create a smaller pool of larger metal bits for exploding.
			_bigGibs = new FlxEmitter();
			_bigGibs.setXSpeed(-200,200);
			_bigGibs.setYSpeed(-300,0);
			_bigGibs.setRotation(-720,-720);
			_bigGibs.gravity = 30;
			_bigGibs.bounce = 0.35;
			_bigGibs.makeParticles(ImgSpawnerGibs,50,20,true);
			
			currentTools = new Array();
			//FlxG.mouse.show();
			FlxG.bgColor = FlxG.BLACK;
			
			_blocks = new FlxGroup();
			_enemies = new FlxGroup();
			_spawners = new FlxGroup();
			_enemyBullets = new FlxGroup();
			_bullets = new FlxGroup();
			_hud = new FlxGroup();
			_items = new FlxGroup();
			
			
			blackholes = new FlxGroup();
			editorUI = new FlxGroup();
			
			
			collisionMap = new FlxTilemap();
			nonCollisionMap = new FlxTilemap();
			backgroundMap = new FlxTilemap();
			moveMap=new FlxTilemap()
			//backgroundMap.scrollFactor = new FlxPoint(0.1, 0.1);
			
			
			//_blocks.add(backgroundMap);
			_blocks.add(nonCollisionMap);
			_blocks.add(collisionMap);
			_blocks.add(moveMap);
			
			
			_player = new Player(100,100,_bullets,_littleGibs);
			
			add(_blocks);
			addTool();
			add(_spawners);
			add(blackholes);
			add(_littleGibs);
			add(_bigGibs);
			add(_player);
			add(_enemies);
			add(_items);
			add(_enemyBullets);
			add(_bullets);

			
			FlxG.camera.setBounds( 0, 0, mapWidth, mapHeight, true);
			//FlxG.camera.follow(_player, FlxCamera.STYLE_PLATFORMER);
			FlxG.camera.follow(_player, FlxCamera.STYLE_LOCKON);

			add(_hud);
			
			_hazards = new FlxGroup();
			_hazards.add(_enemyBullets);
			_hazards.add(_spawners);
			_hazards.add(_enemies);
			_objects = new FlxGroup();
			_objects.add(_enemyBullets);
			_objects.add(_bullets);
			_objects.add(_enemies);
			_objects.add(_player);
			_objects.add(_littleGibs);
			_objects.add(_bigGibs);
			
			
			_hud.setAll("scrollFactor",new FlxPoint(0,0));
			_hud.setAll("cameras", [FlxG.camera]);
			
			FlxG.flash(0xff131c1b);
			_fading = false;
			FlxG.watch(_player,"x");
			FlxG.watch(_player, "y")
			FlxG.watch(_player, "material");
			FlxG.watch(_player,"key");
			
			var levelString:String = getLevelString();
			
			var levelArray:Array = levelString.split( '*');
			
			var save:FlxSave = new FlxSave();
			if(save.bind(MenuState.levelArray[MenuState.currentLevelIndex]))
			{
				
				if (save.data.maps == null)
				{
					//collisionMap.loadMap(initMaps(), ImgCustomTile, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.OFF);
					collisionMap.loadMap(levelArray[0], ImgCustomTile, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.OFF);
				}
				else
				{
					collisionMap.loadMap(save.data.maps, ImgCustomTile, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.OFF);
				}
				
				
				
				if (save.data.ncmaps == null)
				{
					//nonCollisionMap.loadMap(initMaps(), ImgNCTile, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.OFF);
					nonCollisionMap.loadMap(levelArray[1], ImgNCTile, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.OFF);
				}
				else
				{
					nonCollisionMap.loadMap(save.data.ncmaps, ImgNCTile, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.OFF);
				}
				
				if (save.data.mvmaps == null)
				{
					//moveMap.loadMap(initMaps(), ImgMVTile, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.OFF);
					moveMap.loadMap(levelArray[2], ImgMVTile, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.OFF);
				}
				else
				{
					
					moveMap.loadMap(save.data.mvmaps, ImgMVTile, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.OFF);
				}
				
				if (save.data.player != null)
				{
					_player.x = save.data.player[0].x;
					_player.y = save.data.player[0].y;	
				}
				else
				{
					_player.x = 100;
					_player.y = 100;
				}
				save.close();
			}
			
			
		}
		
		private function generateStar():void
		{
			var save:FlxSave = new FlxSave();
			if (save.bind(MenuState.levelArray[MenuState.currentLevelIndex]))
			{
				var stars:Array = save.data.star;
				if (save.data.star!=null)
				{
					for (var i:int = 0; i < stars.length; i++ )
					{
						var star:Item = new Item(stars[i].x, stars[i].y, Item.Star);
						_items.add(star);
					}
				}
			
			}
			save.close();
		}
		
		private function generateEnemy():void
		{
			var save:FlxSave = new FlxSave();
			if (save.bind(MenuState.levelArray[MenuState.currentLevelIndex]))
			{
				
				if (save.data.spawner!=null)
				{
					var spawners:Array = save.data.spawner;
					for (var i:int = 0; i < spawners.length; i++ )
					{
						var sp:Spawner = new Spawner(spawners[i].x,spawners[i].y,_bigGibs,_enemies,_enemyBullets,_littleGibs,_player); 
						_spawners.add(sp);
						
						//Then create a dedicated camera to watch the spawner
						//_hud.add(new FlxSprite(3 + (_spawners.length-1)*16, 3, ImgMiniFrame));
						//var camera:FlxCamera = new FlxCamera(10 + (_spawners.length-1)*32,10,24,24,1);
						//camera.follow(sp);
						//FlxG.addCamera(camera);
					}
				}
				
				
				if (save.data.enemytower!=null)
				{
					var enemytowers:Array = save.data.enemytower;
					for ( i = 0; i < enemytowers.length; i++ )
					{
						var tower:EnemyTower = new EnemyTower(enemytowers[i].x, enemytowers[i].y,_enemies, _enemyBullets,_littleGibs, _player); 
						_enemies.add(tower);
					}
				}
			
			}
			save.close();
		}
		
		private function addTool():void
		{
			tools = new FlxGroup();
			toolBox = new FlxGroup();
			toolIndex = 0;
			toolSelection = new FlxSprite();
			toolSelection.loadGraphic(ImgSelection, true, false, 16, 16);
			toolSelection.addAnimation("available",[0], 50,false);
			toolSelection.addAnimation("unavailable", [1], 50, false);
			toolSelection.x = 16;
			toolSelection.y = 16;
			
			
			highlightBox = new FlxSprite();
			highlightBox.loadGraphic(ImgSelection, true, false, 16, 16);
			highlightBox.addAnimation("available",[0], 50,false);
			highlightBox.addAnimation("unavailable",[1], 50, false);
			
			
			_hud.add(toolBox);
			toolBox.add(tools);
			var c:CustomTile=new CustomTile(TileType.CollisionTile,1, "grass");
			c.x = 16;
			c.y = 16;
			currentTools.push(c);
			tools.add(c);
			toolBox.add(new FlxSprite(c.x, c.y, ImgMiniFrame));
			
			c=new CustomTile(TileType.CollisionTile,2, "brick");
			c.x = 16;
			c.y = 16+tools.length*16;
			currentTools.push(c);
			tools.add(c);
			toolBox.add(new FlxSprite(c.x, c.y, ImgMiniFrame));
			
			c=new CustomTile(TileType.CollisionTile, 3, "default");
			c.x = 16;
			c.y = 16+tools.length*16;
			currentTools.push(c);
			tools.add(c);
			toolBox.add(new FlxSprite(c.x, c.y, ImgMiniFrame));
			
			c=new CustomTile(TileType.CollisionTile, 4, "dirt");
			c.x = 16;
			c.y = 16+tools.length*16;
			currentTools.push(c);
			tools.add(c);
			toolBox.add(new FlxSprite(c.x, c.y, ImgMiniFrame));
			
			c=new CustomTile(TileType.NonCollisionTile, 1, "light_blue");
			c.x = 16;
			c.y = 16+tools.length*16;
			currentTools.push(c);
			tools.add(c);
			toolBox.add(new FlxSprite(c.x, c.y, ImgMiniFrame));
			
			c=new CustomTile(TileType.NonCollisionTile, 2, "dark_blue");
			c.x = 16;
			c.y = 16+tools.length*16;
			currentTools.push(c);
			tools.add(c);
			toolBox.add(new FlxSprite(c.x, c.y, ImgMiniFrame));
			
			c=new CustomTile(TileType.NonCollisionTile, 3, "green");
			c.x = 16;
			c.y = 16+tools.length*16;
			currentTools.push(c);
			tools.add(c);
			toolBox.add(new FlxSprite(c.x, c.y, ImgMiniFrame));
			
			c=new CustomTile(TileType.NonCollisionTile, 4, "black");
			c.x = 16;
			c.y = 16+tools.length*16;
			currentTools.push(c);
			tools.add(c);
			toolBox.add(new FlxSprite(c.x, c.y, ImgMiniFrame));
			
			c=new CustomTile(TileType.MoveTile, 1, "spawner");
			c.x = 16;
			c.y = 16+tools.length*16;
			currentTools.push(c);
			tools.add(c);
			toolBox.add(new FlxSprite(c.x, c.y, ImgMiniFrame));
			
			c=new CustomTile(TileType.MoveTile, 2, "player");
			c.x = 16;
			c.y = 16+tools.length*16;
			currentTools.push(c);
			tools.add(c);
			toolBox.add(new FlxSprite(c.x, c.y, ImgMiniFrame));
			
			c=new CustomTile(TileType.MoveTile, 3, "star");
			c.x = 16;
			c.y = 16+tools.length*16;
			currentTools.push(c);
			tools.add(c);
			toolBox.add(new FlxSprite(c.x, c.y, ImgMiniFrame));
			
			c=new CustomTile(TileType.MoveTile, 5, "enemytower");
			c.x = 16;
			c.y = 16+tools.length*16;
			currentTools.push(c);
			tools.add(c);
			toolBox.add(new FlxSprite(c.x, c.y, ImgMiniFrame));
			
			var saveButton:FlxButton = new FlxButton(FlxG.width / 2-40, FlxG.height / 3, "Save", onSave);

			saveButton.color = 0xff729954;
			saveButton.label.color = 0xffd8eba2;
			editorUI.add(saveButton);
			
			var resetButton:FlxButton = new FlxButton(FlxG.width / 2 - 40, FlxG.height / 3 + 30, "Reset", onReset);
			
			resetButton.color = 0xff729954;
			resetButton.label.color = 0xffd8eba2;
			editorUI.add(resetButton);
			
			playButton = new FlxButton(FlxG.width / 2 - 40 , FlxG.height / 3 + 60, "Play", onPlay);
			playButton.color = 0xff729954;
			playButton.label.color = 0xffd8eba2;
			editorUI.add(playButton);
			
			var quitButton:FlxButton= new FlxButton(FlxG.width / 2 - 40 , FlxG.height / 3 + 90, "Quit", FlxG.resetGame);
			quitButton.color = 0xff729954;
			quitButton.label.color = 0xffd8eba2;
			editorUI.add(quitButton);
			
			add(highlightBox);
			
			toolBox.add(toolSelection);
			_hud.add(toolBox);
			_hud.add(editorUI);
			
			editorUI.exists = false;


		}
		
		protected function onFade():void
		{
			moveMap.visible = false;
			onSave();
			generateEnemy();
			generateStar();
			paused = false;
			_fading = false;

		}
		
		protected function onPlay():void
		{
			if (!_fading)
			{
				if (isPlaying)
				{
					FlxG.resetState();
				}
				FlxG.mouse.hide();
				playButton.exists = false;
				editorUI.exists = false;
				_fading = true;
				isPlaying = true;
				//trace("call");
				FlxG.flash(0xff000000,0.2,onFade);
			}
		}
		
		protected function getLevelString():String
		{
			if (MenuState.currentLevelIndex == 0)
			{
				return new Levels.Level0();
			}
			else if (MenuState.currentLevelIndex == 1)
			{
				return new Levels.Level1();
			}
			
			return "";
		}
		
		protected function onReset():void
		{
			var levelString:String = getLevelString();
			
			var levelArray:Array = levelString.split( '*');
			
			collisionMap.kill();
			nonCollisionMap.kill();
			moveMap.kill();
			collisionMap = new FlxTilemap();
			nonCollisionMap = new FlxTilemap();
			moveMap = new FlxTilemap();
			
			_blocks.add(nonCollisionMap);
			_blocks.add(collisionMap);
			_blocks.add(moveMap);
			
			collisionMap.loadMap(levelArray[0], ImgCustomTile, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.OFF);
			nonCollisionMap.loadMap(levelArray[1], ImgNCTile, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.OFF);
			moveMap.loadMap(levelArray[2], ImgMVTile, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.OFF);
			
			/*
			for (var i:int = 0; i <  mapWidth/TILE_WIDTH ; i++)
			{
				for (var j:int = 0; j <  mapWidth/TILE_HEIGHT ; j++)
				{
					if (i == 0 || i == mapWidth/TILE_WIDTH-1 || j == 0 || j == mapWidth/TILE_HEIGHT-1 )
					{
						collisionMap.setTile(i, j, 3);
						
					}
					else
					{
						collisionMap.setTile(i, j, 0);
						nonCollisionMap.setTile(i, j, 0);
						moveMap.setTile(i, j, 0);
					}	
				}
			}
			*/
			
		}
		
		protected function initMaps():String
		{
			var maps:String="";
			var index:uint = 0;
			
			for (var i:int = 0; i <  mapWidth/TILE_WIDTH ; i++)
			{
				for (var j:int = 0; j <  mapWidth/TILE_HEIGHT ; j++)
				{
					if (i == 0 || i == mapWidth/TILE_WIDTH-1 || j == 0 || j == mapWidth/TILE_HEIGHT-1 )
					{
						maps = maps +  "0,";
					}
					else
					{
						maps = maps +  "0,";
					}
				}
				maps += "\n";
			}
			
			return maps;
		}
		
		protected function onSave():void
		{
			
			
			var save:FlxSave = new FlxSave();
			
			if(save.bind(MenuState.levelArray[MenuState.currentLevelIndex]))
			{
				var a:Array=collisionMap.getData();
				var maps:String;
				var index:uint = 0;
				for (var i:int = 0; i <  collisionMap.heightInTiles ; i++)
				{
					for (var j:int = 0; j <  collisionMap.widthInTiles ; j++)
					{
						maps = maps + a[index] + ",";
						index++;
						
					}
					maps += "\n";
				}
				save.data.maps = maps;
				
				maps = "";
				index = 0;
				a = nonCollisionMap.getData();
				for ( i = 0; i <  nonCollisionMap.heightInTiles ; i++)
				{
					for ( j = 0; j <  nonCollisionMap.widthInTiles ; j++)
					{
						maps = maps + a[index] + ",";
						index++;
						
					}
					maps += "\n";
				}
				save.data.ncmaps = maps;
				
				maps = "";
				index = 0;
				
				a = moveMap.getData();
				for ( i = 0; i <  moveMap.heightInTiles ; i++)
				{
					for ( j = 0; j <  moveMap.widthInTiles ; j++)
					{
						maps = maps + a[index] + ",";
						
						index++;
						
					}
					maps += "\n";
				}
				
				save.data.player=moveMap.getTileCoords(2,false);
				save.data.spawner = moveMap.getTileCoords(1, false);
				save.data.star = moveMap.getTileCoords(3, false);
				save.data.enemytower=moveMap.getTileCoords(5, false);
				save.data.mvmaps = maps;
				
				if (!isPlaying)
				{
					var saveString:String = "";
					saveString += save.data.maps;
					saveString += "*";
					saveString += save.data.ncmaps;
					saveString += "*";
					saveString += save.data.mvmaps;
					
					var MyFile:FileReference = new FileReference();
					MyFile.save(saveString, "level" + MenuState.currentLevelIndex + ".txt");
				}

				save.close();
			}
		}
		
		
		override public function destroy():void
		{
			super.destroy();
			
			_blocks = null;
			_bullets = null;
			_player = null;
			_enemies = null;
			_spawners = null;
			_enemyBullets = null;
			_littleGibs = null;
			_bigGibs = null;
			_hud = null;
			_items = null;
			
			//meta groups, to help speed up collisions
			_objects = null;
			_hazards = null;

		}
		
		
		
		protected function toolSelectionUpdate():void
		{
			if(FlxG.keys.justPressed("ONE"))
			{
				toolIndex = 0;
			}
			
			if(FlxG.keys.justPressed("TWO"))
			{
				toolIndex = 1;
			}
			
			if(FlxG.keys.justPressed("THREE"))
			{
				toolIndex = 2;
			}
			
			if(FlxG.keys.justPressed("FOUR"))
			{
				toolIndex = 3;
			}
			
			if(FlxG.keys.justPressed("FIVE"))
			{
				toolIndex = 4;
			}
			
			if(FlxG.keys.justPressed("T"))
			{
				toolBox.visible = !toolBox.visible;
			}
			
			toolIndex -= FlxG.mouse.wheel/3;
			toolIndex = FlxU.bound(toolIndex, 0, tools.length - 1);
			toolSelection.y = toolIndex * 16 + 16;
			
			
			if (highlightBox.x>=0 && highlightBox.x<=mapWidth &&  highlightBox.y>=0 && highlightBox.y<=mapHeight )
			{
				highlightBox.x = Math.floor(FlxG.mouse.x / TILE_WIDTH) * TILE_WIDTH;
				highlightBox.y = Math.floor(FlxG.mouse.y / TILE_HEIGHT) * TILE_HEIGHT;
				highlightBox.play("available");
				
				if (FlxG.mouse.pressed())
				{	
					if (FlxG.keys.SHIFT)
					{
						collisionMap.setTile(FlxG.mouse.x / TILE_WIDTH, FlxG.mouse.y / TILE_HEIGHT, 0);
						nonCollisionMap.setTile(FlxG.mouse.x / TILE_WIDTH, FlxG.mouse.y / TILE_HEIGHT, 0);
						moveMap.setTile(FlxG.mouse.x / TILE_WIDTH, FlxG.mouse.y / TILE_HEIGHT, 0);
					}
					else 
					{
						if ( currentTools[toolIndex].type == TileType.CollisionTile)
						{
							collisionMap.setTile(FlxG.mouse.x / TILE_WIDTH, FlxG.mouse.y / TILE_HEIGHT, FlxG.keys.SHIFT?0: currentTools[toolIndex].index );
						}
						else if ( currentTools[toolIndex].type == TileType.BackgroundTile)
						{
							//backgroundMap.setTile(FlxG.mouse.x / TILE_WIDTH, FlxG.mouse.y / TILE_HEIGHT, FlxG.keys.SHIFT?0: currentTools[toolIndex].index );
						}
						else if ( currentTools[toolIndex].type == TileType.NonCollisionTile)
						{
							nonCollisionMap.setTile(FlxG.mouse.x / TILE_WIDTH, FlxG.mouse.y / TILE_HEIGHT, FlxG.keys.SHIFT?0: currentTools[toolIndex].index );
						}
						else if ( currentTools[toolIndex].type == TileType.MoveTile)
						{
							moveMap.setTile(FlxG.mouse.x / TILE_WIDTH, FlxG.mouse.y / TILE_HEIGHT, FlxG.keys.SHIFT?0: currentTools[toolIndex].index );
						}
					}
				}
			}
			else
			{
				highlightBox.x = Math.floor(FlxG.mouse.x / TILE_WIDTH) * TILE_WIDTH;
				highlightBox.y = Math.floor(FlxG.mouse.y / TILE_HEIGHT) * TILE_HEIGHT;
				highlightBox.play("unavailable");
			}
		}
		
		override public function update():void
		{
			if(FlxG.keys.justPressed("ESCAPE"))
			{
				if (!paused)
				{
					FlxG.mouse.show();
					playButton.exists = true;
					editorUI.exists = true;
					paused = true;
				}
				else
				{	
					FlxG.mouse.hide();
					editorUI.exists = false;
					paused = false;
				}
			}
			
			if (paused)
			{
				editorUI.update();
				return;
			}
			super.update();
			
		
			toolSelectionUpdate();
			
			FlxG.collide(_bullets, collisionMap, createBlackhole);
			FlxG.collide(_enemyBullets, collisionMap, createBlackhole);
			
			FlxG.collide(_bullets, nonCollisionMap, destroyBlock);
			FlxG.collide(_enemyBullets, nonCollisionMap, destroyBlock);
			
			FlxG.collide(collisionMap, _objects);
			FlxG.collide(nonCollisionMap, _objects);
			
			FlxG.overlap(_hazards,_player,overlapped);
			FlxG.overlap(_bullets, _hazards, overlapped);
			
			FlxG.overlap(_player, _items, getItem);
			
			
			if  (blackhole01 != null && blackhole02 != null && blackhole01.available &&  blackhole02.available )
			{
				FlxG.overlap(blackholes, _player, transfer,FlxObject.separate);
				FlxG.overlap(blackholes, _enemies, transfer, FlxObject.separate);
				FlxG.overlap(blackholes, _bullets, transfer, FlxObject.separate);
				FlxG.overlap(blackholes, _enemyBullets, transfer, FlxObject.separate);
				
			}
		}
		
		protected function getItem(Sprite1:Player, Sprite2:Item):void
		{
			if (Sprite2.itemType == Item.Star)
			{
				Sprite1.key++;
				FlxG.play(SndCoin);
				Sprite2.kill();
			}
			else if (Sprite2.itemType == Item.Material)
			{
				Sprite1.material++;
				FlxG.play(SndCoin);
				Sprite2.kill();
				
			}
		}
		
		protected function transfer(Sprite1:FlxSprite,Sprite2:FlxSprite):void
		{
			if (Sprite1 == blackhole01 )
			{
				(Sprite2 as ITransportable).transfer(blackhole01,blackhole02,1);
			}
			else if (Sprite1 == blackhole02 )
			{
				(Sprite2 as ITransportable).transfer(blackhole02,blackhole01,1);
			}
		}
		
		protected function destroyBlock(Sprite1:FlxSprite, Sprite2:FlxTilemap):void
		{
			if ((Sprite1 is Bullet|| Sprite1 is EnemyBullet) && (Sprite2 is FlxTilemap) )
			{
		
				var tilex:Number =  Sprite1.x / TILE_WIDTH;
				var tiley:Number =  Sprite1.y / TILE_HEIGHT; 
				if (Sprite1.justTouched(FlxObject.DOWN))
				{
					tiley = Math.ceil(tiley);
				}
				else if (Sprite1.justTouched(FlxObject.UP))
				{
					tiley = Math.ceil(tiley)-1;
				}
				else if (Sprite1.justTouched(FlxObject.LEFT))
				{
					tilex = Math.ceil(tilex)-1;
				}
				else if (Sprite1.justTouched(FlxObject.RIGHT))
				{
					tilex = Math.ceil(tilex);
				}
				var material:Item;
				if (Sprite2.getTile(tilex, tiley) != 0)
				{
					Sprite2.setTile( tilex, tiley , 0);
					material = new Item(tilex*TILE_WIDTH, tiley*TILE_HEIGHT, Item.Material);
					_items.add(material);	
				}
				else 
				{
					if (Sprite2.getTile(tilex - 1, tiley - 1) != 0)
					{
						Sprite2.setTile( tilex-1, tiley-1 , 0);
						material = new Item(tilex*TILE_WIDTH, tiley*TILE_HEIGHT, Item.Material);
						_items.add(material);
					}
					else if (Sprite2.getTile(tilex - 1, tiley ) != 0)
					{
						Sprite2.setTile( tilex-1, tiley , 0);
						material = new Item(tilex*TILE_WIDTH, tiley*TILE_HEIGHT, Item.Material);
						_items.add(material);
					}
					else if (Sprite2.getTile(tilex - 1, tiley+1 ) != 0)
					{
						Sprite2.setTile( tilex-1, tiley+1 , 0);
						material = new Item(tilex*TILE_WIDTH, tiley*TILE_HEIGHT, Item.Material);
						_items.add(material);
					}
					else if (Sprite2.getTile(tilex , tiley-1 ) != 0)
					{
						Sprite2.setTile( tilex, tiley-1 , 0);
						material = new Item(tilex*TILE_WIDTH, tiley*TILE_HEIGHT, Item.Material);
						_items.add(material);
					}
					else if (Sprite2.getTile(tilex , tiley+1 ) != 0)
					{
						Sprite2.setTile( tilex, tiley+1 , 0);
						material = new Item(tilex*TILE_WIDTH, tiley*TILE_HEIGHT, Item.Material);
						_items.add(material);
					}
					else if (Sprite2.getTile(tilex+1 , tiley-1 ) != 0)
					{
						Sprite2.setTile( tilex+1, tiley-1 , 0);
						material = new Item(tilex*TILE_WIDTH, tiley*TILE_HEIGHT, Item.Material);
						_items.add(material);
					}
					else if (Sprite2.getTile(tilex+1 , tiley ) != 0)
					{
						Sprite2.setTile( tilex+1, tiley , 0);
						material = new Item(tilex*TILE_WIDTH, tiley*TILE_HEIGHT, Item.Material);
						_items.add(material);
					}
					else if (Sprite2.getTile(tilex+1 , tiley+1 ) != 0)
					{
						Sprite2.setTile( tilex+1, tiley+1 , 0);
						material = new Item(tilex*TILE_WIDTH, tiley*TILE_HEIGHT, Item.Material);
						_items.add(material);
					}
			
				}

				Sprite1.kill();
				
			}
			else if (Sprite1 is PortalBullet)
			{
				Sprite1.kill();
			}
		}
		
		
		protected function createBlackhole(Sprite1:FlxSprite,Sprite2:FlxTilemap):void
		{
			//trace("black hole!" );
			if ((Sprite1 is PortalBullet) && (Sprite2 is FlxTilemap) )
			{
				var pBullet:PortalBullet = Sprite1 as PortalBullet;
				/*
				var tilex:Number =  Sprite1.x/ TILE_WIDTH;
				var tiley:Number =  Sprite1.y/ TILE_HEIGHT; 
				if (Sprite1.justTouched(FlxObject.DOWN))
				{
					tiley = Math.ceil(tiley)-2;
				}
				else if (Sprite1.justTouched(FlxObject.UP))
				{
					tiley = Math.ceil(tiley);
				}
				else if (Sprite1.justTouched(FlxObject.LEFT))
				{
					tilex = Math.ceil(tilex);
				}
				else if (Sprite1.justTouched(FlxObject.RIGHT))
				{
					tilex = Math.ceil(tilex)-2;
				}
				*/
				if (pBullet.type == 1 && blackhole01 ==null)
				{
					blackhole01 = new BlackHole(Sprite1.x,Sprite1.y );
					//blackhole01 = new BlackHole(tilex*TILE_WIDTH,tiley*TILE_HEIGHT);
					blackhole01.generate();
					blackholes.add (blackhole01);
				}
				else if (pBullet.type == 1)
				{
					blackhole01.x = Sprite1.x// TILE_WIDTH * TILE_WIDTH;
					blackhole01.y = Sprite1.y// TILE_HEIGHT * TILE_HEIGHT;

					blackhole01.generate();
				}
				
				if (pBullet.type == 2 && blackhole02 == null)
				{
					blackhole02 = new BlackHole(Sprite1.x,Sprite1.y );
					blackhole02.generate();
					blackholes.add (blackhole02);
				}
				if (pBullet.type == 2)
				{
					blackhole02.x = Sprite1.x// TILE_WIDTH * TILE_WIDTH;
					blackhole02.y = Sprite1.y// TILE_HEIGHT * TILE_HEIGHT;
					blackhole02.generate();
				}
				
			}
			else if (Sprite1 is Bullet)
			{
				(Sprite1 as Bullet).kill();
			}
			else if (Sprite1 is EnemyBullet)
			{
				(Sprite1 as EnemyBullet).kill();
			}

		}
		
		protected function overlapped(Sprite1:FlxSprite,Sprite2:FlxSprite):void
		{
			//if((Sprite1 is EnemyBullet) || (Sprite1 is Bullet))
			//	Sprite1.kill();
				
			Sprite1.kill();
			Sprite2.hurt(1);
		}
		
		public override function draw():void
		{
			super.draw();
			
			
		}
		
	}
	
	

}