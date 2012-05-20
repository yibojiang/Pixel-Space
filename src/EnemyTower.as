package  
{
	import org.flixel.*;
	
	
	/**
	 * ...
	 * @author yibojiang
	 */
	public class EnemyTower extends FlxSprite 
	{
		[Embed(source = "data/towerhead.png")] protected var ImgHead:Class;
		[Embed(source = "data/towerbody.png")] protected var ImgBody:Class;
		[Embed(source="data/asplode.mp3")] protected var SndExplode:Class;
		[Embed(source="data/hit.mp3")] protected var SndHit:Class;
		
		public var head:FlxSprite;
		protected var shotTimer:Number=0;
		protected var shotTimerLimit:Number = 3;
		
		protected var _player:Player;		
		protected var _bullets:FlxGroup;	
		protected var _gibs:FlxEmitter;	
		
		
		public function EnemyTower(X:Number,Y:Number,Enemies:FlxGroup,Bullets:FlxGroup,Gibs:FlxEmitter,ThePlayer:Player)
		{
			
			super(X,Y);
			loadGraphic(ImgBody);
			
			
			
			_gibs = Gibs;
			_bullets = Bullets;
			_player = ThePlayer;
			

			
			health = 5;
			
			
			head = new FlxSprite(X + width / 2 , Y + height / 2 , ImgHead);
			head.y -= 16;
			head.x -= 2;
			head.origin.y = 16;
			head.angularDrag = 400;
			//Enemies.add(head);
			
		}
		override public function destroy():void
		{
			super.destroy();
			head = null;
		}
		
		override public function hurt(Damage:Number):void
		{
			FlxG.play(SndHit);
			flicker(0.2);
			FlxG.score += 30;
			super.hurt(Damage);
		}
		
		override public function kill():void
		{
			if(!alive)
				return;
			FlxG.play(SndExplode);
			super.kill();
			flicker(0);
			
			_gibs.at(this);
			_gibs.start(true,3,0,20);
			
			FlxG.score += 200;
		}
		
		override public function update():void
		{
			super.update();
			
			head.update();
			
			
			var da:Number = angleTowardPlayer();
			//trace(da);
			head.angle += da - head.angle;
			/*
			if(da < head.angle)
				head.angularAcceleration =-head.angularDrag;
			else if(da > head.angle)
				head.angularAcceleration =head.angularDrag;
			else
				head.angularAcceleration = 0;
			*/
			if (onScreen())
			{
			
				if (shotTimer > 0)
				{
					shotTimer -= FlxG.elapsed;
				}
				else
				{
					var b:EnemyBullet = _bullets.recycle(EnemyBullet) as EnemyBullet;
					b.shoot(this.getMidpoint(),head.angle);
					shotTimer = shotTimerLimit;
				}
				
			}
		}
		override public function draw():void
		{
			
			super.draw();
			head.draw();
		}
		
		protected function angleTowardPlayer():Number
		{
			
			return FlxU.getAngle(head.getMidpoint(),_player.getMidpoint());
		}
	}
		

}