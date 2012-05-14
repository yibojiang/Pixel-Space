package  
{
	import org.flixel.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	/**
	 * ...
	 * @author yibojiang
	 */
	public class BlackHole extends FlxSprite 
	{
		[Embed(source = "data/jet.png")] protected var ImgJet:Class;
		[Embed(source = "data/blackhole.png")] private var ImgBlackhole:Class;
		
		[Embed(source = "data/createBlackhole.mp3")] protected var SndCreateBH:Class;
		protected var _particles:FlxEmitter;
		
		public var scaleX:Number=1;
		public var scaleY:Number = 1;
		public var available:Boolean=false;
		
		public function BlackHole(X:int,Y:int) 
		{
			super(X, Y);
			loadGraphic(ImgBlackhole, true, false, 32, 32);
	
			centerOffsets(true);

			_particles = new FlxEmitter();
			_particles.setRotation();
			_particles.makeParticles(ImgJet, 150, 0, false, 0);
			
			_particles.start(false, 1, 0.005);
			
			_particles.setXSpeed(-30,30);
			_particles.setYSpeed( -30, 30);
			
			immovable = true;
			
			
			
		}
		
		public function generate():void
		{
			//centerOffsets(true);
			
			x -= width/2;
			y -= height/2;
	
			available = false;
			scale.x = 0;
			scale.y = 0;
			scaleX = 0;
			scaleY = 0;
			TweenMax.to(this, 0.5, { scaleX:1, scaleY:1, onComplete:setAvailable } );
			FlxG.play(SndCreateBH);
		}
		
		public function setAvailable():void
		{
			available = true;
		}
		
		override public function update():void 
		{
			angle += 10;
			scale.x = scaleX;
			scale.y = scaleY;
			_particles.at(this);
			_particles.update();
		}
		
		override public function destroy():void
		{
			super.destroy();
	
			
			_particles.destroy();
			_particles = null;
		}
		
		override public function draw():void
		{
			_particles.draw();
			super.draw();
			
			
		}
		
	}

}