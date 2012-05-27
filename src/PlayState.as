package
{
	import org.flixel.*;

	public class PlayState extends EditorState
	{
		override public function create():void
		{
			super.create();
			moveMap.visible = false;
			generateEnemy();
			generateStar();
			paused = false;
			_fading = false;
			
			
			
			var save:FlxSave = new FlxSave();
			if (save.bind(MenuState.levelArray[MenuState.currentLevelIndex]))
			{
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
				
				if (save.data.endlevel != null)
				{
					endLevel = new LevelHole(save.data.endlevel[0].x, save.data.endlevel[0].y);
					endLevel.exists = false;
					add(endLevel );
				}
				else
				{
					endLevel = new LevelHole(0, 0);
					endLevel.exists = false;
					add(endLevel );
				}
				save.close();
			}
			toolSelection.exists = false;
			toolBox.exists = false;
			highlightBox.exists = false;
			isPlaying = true;
			
			
			
			
		}
		
		override public function destroy():void
		{
			super.destroy();
			
		}

		override public function update():void
		{			
			//save off the current score and update the game state
			
			super.update();
			
		}

		
		
	}
}
