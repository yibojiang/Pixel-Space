package
{
	import org.flixel.*;

	public class Bullet extends FlxSprite implements ITransportable
	{
		[Embed(source="data/bot_bullet.png")] private var ImgBullet:Class;
		[Embed(source="data/jump.mp3")] private var SndHit:Class;
		[Embed(source="data/shoot.mp3")] private var SndShoot:Class;
		
		public var speed:Number;
		public var vx:Number;
		public var vy:Number;
		
		public function Bullet()
		{
			super();
			loadGraphic(ImgBullet, true);
			
			
			addAnimation("idle",[0, 1], 50);
			addAnimation("poof",[2, 3, 4], 50, false);
			
			speed = 360;
		}
		
		override public function update():void
		{
			vx = velocity.x;
			vy = velocity.y;
			if(!alive)
			{
				if(finished)
					exists = false;
			}
			//else if (touching)
			//	kill();
			
		}
		
		override public function kill():void
		{
			if(!alive)
				return;
			velocity.x = 0;
			velocity.y = 0;
			if(onScreen())
				FlxG.play(SndHit);
			alive = false;
			solid = false;
			play("poof");
		}
		
		public function shoot(Location:FlxPoint, Angle:Number):void
		{
			FlxG.play(SndShoot);
			super.reset(Location.x-width/2,Location.y-height/2);
			FlxU.rotatePoint(0,speed,0,0,Angle,_point);
			velocity.x = _point.x;
			velocity.y = _point.y;
			solid = true;
			play("idle");
		}
		
		/* INTERFACE ITransportable */
		
		public function transfer(_blackhole1:BlackHole, _blackHole2:BlackHole, _time:Number):void 
		{
			this.x = _blackHole2.x + 16;
			this.y = _blackHole2.y + 16;
			velocity.x = vx;
			velocity.y = vy;
			//velocity.x = 100;
			
		}
		
		public function setTargetPos(_blackHole2:BlackHole, _time:Number):void 
		{
			
		}
		
		public function transferFinished():void 
		{
			
		}
		
	}
}