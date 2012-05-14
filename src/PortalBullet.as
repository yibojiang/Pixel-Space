package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author yibojiang
	 */
	public class PortalBullet extends FlxSprite 
	{
		[Embed(source="data/portal_bullet.png")] private var ImgBullet:Class;
		[Embed(source="data/jump.mp3")] private var SndHit:Class;
		[Embed(source = "data/shoot.mp3")] private var SndShoot:Class;
		
		public var speed:Number;
		public var type:int;
		
		public function PortalBullet() 
		{
			super();
			loadGraphic(ImgBullet, true);
			centerOffsets();
			
			addAnimation("idle",[0, 1], 50);
			addAnimation("poof",[2, 3, 4], 50, false);
			
			speed = 360;
		}
		
		
		override public function update():void
		{
			if(!alive)
			{
				if(finished)
					exists = false;
			}
			else if(touching)
				kill();
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
		
		public function shoot(Location:FlxPoint, Angle:Number,Type:int):void
		{
			FlxG.play(SndShoot);
			super.reset(Location.x-width/2,Location.y-height/2);
			FlxU.rotatePoint(0,speed,0,0,Angle,_point);
			velocity.x = _point.x;
			velocity.y = _point.y;
			solid = true;
			type = Type;
			play("idle");
		}
		
	}

}