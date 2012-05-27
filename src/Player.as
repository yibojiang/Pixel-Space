package
{
	import org.flixel.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	public class Player extends FlxSprite implements ITransportable
	{
		[Embed(source="data/spaceship.png")] protected var ImgBot:Class;
		[Embed(source="data/jump.mp3")] protected var SndJump:Class;
		[Embed(source="data/land.mp3")] protected var SndLand:Class;
		[Embed(source="data/asplode.mp3")] protected var SndExplode:Class;
		[Embed(source="data/menu_hit_2.mp3")] protected var SndExplode2:Class;
		[Embed(source="data/hurt.mp3")] protected var SndHurt:Class;
		[Embed(source = "data/jam.mp3")] protected var SndJam:Class;
		[Embed(source = "data/jet.mp3")] protected var SndJet:Class;
		[Embed(source="data/jet.png")] protected var ImgJet:Class;
		
		protected var _jumpPower:int;
		protected var _bullets:FlxGroup;

		
		protected var _aim:uint;
		protected var _restart:Number;
		protected var _gibs:FlxEmitter;
		
		protected var _jets:FlxEmitter;
		
		public var isTransfering:Boolean;
		
		public var scaleX:Number=1;
		public var scaleY:Number = 1;
		
		public var material:uint = 0;
		public var key:uint = 0;
		
		public var cameraRotateMdoe:Boolean = false;
		
		public var shipAngleAdd:Number = 0;
		
		public var isGod:Boolean=false;
		[Embed(source="data/title.mp3")] public var SndHit:Class;
		
		//This is the player object class.  Most of the comments I would put in here
		//would be near duplicates of the Enemy class, so if you're confused at all
		//I'd recommend checking that out for some ideas!
		public function Player(X:int,Y:int,Bullets:FlxGroup,Gibs:FlxEmitter)
		{
			super(X, Y);
			
			loadRotatedGraphic(ImgBot,64,0,false,true);

			_restart = 0;
			
			//bounding box tweaks
			width = 12;
			height = 12;
			centerOffsets();
	
			drag.x = 80;
			drag.y = 80;

			maxVelocity.x = 80;
			maxVelocity.y = 80;
			
			_bullets = Bullets;

			_gibs = Gibs;
			
			_jets = new FlxEmitter();
			_jets.setRotation();
			_jets.makeParticles(ImgJet,15,0,false,0);
			
		}
		
		override public function destroy():void
		{
			super.destroy();
			_bullets = null;
			_gibs = null;
			
			_jets.destroy();
			_jets = null;
		}
		
		public function setTargetPos(_blackhole2:BlackHole,_time:Number):void
		{
			angle = angle%360;
			this.x = _blackhole2.x+8;
			this.y = _blackhole2.y+8;

			var newX:Number =  32 * Math.sin((angle)/180*Math.PI);
			var newY:Number = - 32 * Math.cos((angle)/180*Math.PI);
			TweenMax.to(this, _time, {scaleX:1,scaleY:1,  angle:angle+720, ease:Quad.easeOut,onComplete:transferFinished});
		}
		
		public function transferToNextLevel(X:Number,Y:Number):void
		{
			isGod = true;
			TweenMax.to(this, 1, {x:X,y:Y,scaleX:0,scaleY:0, angle:angle+720, ease:Quad.easeIn,onComplete:flashToNextLevel} );
		}
		
		public function flashToNextLevel():void
		{
			FlxG.play(SndHit);
			FlxG.shake();
			FlxG.flash(0xffffff, 1, nextLevel);
		}
		
		public function nextLevel():void
		{
			if (MenuState.currentLevelIndex <MenuState.maxLevel)
			{
				MenuState.currentLevelIndex++;
			}
			else
			{
				FlxG.switchState(new EndStoryState());
				return;
			}
			FlxG.resetState();
		}
		
		public function transferFinished():void
		{
			isTransfering = false;
		}
		
		public function transfer(_blackhole1:BlackHole,_blackHole2:BlackHole,_time:Number):void
		{
		
			isTransfering = true;
			angle = angle%360;
			var params:Array = new Array();
			params[0] = _blackHole2;
			params[1] = _time;
			
			//TweenMax.to(this, _time/2, {(scale.x):0,(scale.y):0, onComplete:setTargetPos,onCompleteParams:params});
			TweenMax.to(this, _time, {x:_blackhole1.x+8,y:_blackhole1.y+8,scaleX:0,scaleY:0, angle:angle+720, ease:Quad.easeIn, onComplete:setTargetPos, onCompleteParams:params } );
		}
		
		override public function update():void
		{
			
			scale.x = scaleX;
			scale.y = scaleY;
			var jetsOn:Boolean = false;
			//game restart timer
			if(!alive)
			{
				_restart += FlxG.elapsed;
				if(_restart > 2)
					FlxG.resetState();
				return;
			}
			
			//make a little noise if you just touched the floor
			if(justTouched(FLOOR) && (velocity.y > 50))
				FlxG.play(SndLand);
			
			//MOVEMENT
			acceleration.x = 0;
			acceleration.y = 0;
		
			
			var deltaAngle :Number= shipAngleAdd * FlxG.elapsed * 3;
			shipAngleAdd -= deltaAngle;
			
			FlxG.camera.angle += deltaAngle;
			
			FlxG.watch(FlxG.camera,"angle");
			FlxG.watch(this,"angle");
			if(FlxG.keys.LEFT)
			{
				
				if (cameraRotateMdoe)
				{
					shipAngleAdd += 5;
					//FlxG.camera.angle += 5;
				}
				
				angle -= 5;

			}
			else if(FlxG.keys.RIGHT)
			{
				
				if (cameraRotateMdoe)
				{
					shipAngleAdd -= 5;
					//FlxG.camera.angle -= 5;
				}
				
				angle += 5;
			}
			
			
			if (FlxG.keys.UP)
			{
				FlxU.rotatePoint(0,150,0,0,angle,_point);
				acceleration.x = _point.x;
				acceleration.y = _point.y;
				jetsOn = true;
			}
			
			if (FlxG.keys.DOWN)
			{
				FlxU.rotatePoint(0,-150,0,0,angle,_point);
				acceleration.x = _point.x;
				acceleration.y = _point.y;
			
			}
			
			if(FlxG.keys.justPressed("R") )
			{
				FlxG.camera.angle = -angle;
				cameraRotateMdoe = !cameraRotateMdoe;
				
			}
			
			
			//SHOOTING
			if(FlxG.keys.justPressed("Z") )
			{
				getMidpoint(_point);
				(_bullets.recycle(Bullet) as Bullet).shoot(_point,angle);
				
			}
			
			if(FlxG.keys.justPressed("X") )
			{
				getMidpoint(_point);
				(_bullets.recycle(PortalBullet) as PortalBullet).shoot(_point,angle,1);
				
			}
			
			if(FlxG.keys.justPressed("C") )
			{
				getMidpoint(_point);
				(_bullets.recycle(PortalBullet) as PortalBullet).shoot(_point,angle,2);
				
			}
			
			
			//Finally, update the jet particles shooting out the back of the ship.
			if(jetsOn)
			{
				if(!_jets.on)
				{
					//If they're supposed to be on and they're not,
					//turn em on and play a little sound.
					_jets.start(false,0.5,0.01);
					if(onScreen())
						FlxG.play(SndJet);
				}
				//Then, position the jets at the center of the Enemy,
				//and point the jets the opposite way from where we're moving.
				_jets.at(this);
				_jets.setXSpeed(-velocity.x-30,-velocity.x+30);
				_jets.setYSpeed(-velocity.y-30,-velocity.y+30);
			}
			else	//If jets are supposed to be off, just turn em off.
				_jets.on = false;
			//Finally, update the jet emitter and all its member sprites.
			_jets.update();
		}
		
		//Even though we updated the jets after we updated the Enemy,
		//we want to draw the jets below the Enemy, so we call _jets.draw() first.
		override public function draw():void
		{
			_jets.draw();
			super.draw();
		}
		
		override public function hurt(Damage:Number):void
		{
			if (isGod)
			{
				return;
			}
			Damage = 0;
			
			FlxG.play(SndHurt);
			//flicker(1.3);
			//if (FlxG.score > 1000) FlxG.score -= 1000;
			
			kill();
		}
		
		override public function kill():void
		{
			if(!alive)
				return;
			solid = false;
			FlxG.play(SndExplode);
			FlxG.play(SndExplode2);
			super.kill();
			flicker(0);
			exists = true;
			visible = false;
			velocity.make();
			acceleration.make();
			FlxG.camera.shake(0.005,0.35);
			FlxG.camera.flash(0xffd8eba2,0.35);
			if(_gibs != null)
			{
				_gibs.at(this);
				_gibs.start(true,5,0,50);
			}
		}
	}
}