package  
{
	import org.flixel.*;
	import com.greensock.*;
	
	/**
	 * ...
	 * @author yibojiang
	 */
	public class LevelHole extends FlxSprite 
	{
		[Embed(source = "data/nextdoor.png")] private var ImgLevelhole:Class;
		[Embed(source = "data/jet.png")] protected var ImgJet:Class;
		[Embed(source = "data/createBlackhole.mp3")] protected var SndCreateBH:Class;
		
		public var scaleX:Number=1;
		public var scaleY:Number = 1;
		public var available:Boolean = false;
		protected var _particles:FlxEmitter;
		
		
		public function LevelHole(X:Number,Y:Number) 
		{
			super(X, Y, ImgLevelhole);
			immovable = true;
			centerOffsets(true);
		}
		
		public function show():void
		{
			
			exists = true;
			FlxG.play(SndCreateBH);
			scale.x = 0;
			scale.y = 0;
			scaleX = 0;
			scaleY = 0;
			
			_particles = new FlxEmitter();
			_particles.setRotation();
			_particles.makeParticles(ImgJet, 150, 0, false, 0);
			
			_particles.start(false, 1, 0.005);
			
			_particles.setXSpeed(-30,30);
			_particles.setYSpeed( -30, 30);
			
		
			
			
			TweenMax.to(this, 0.5, { scaleX:1, scaleY:1, onComplete:setAvailable } );
		}
		
		override public function update():void
		{
			super.update();
			_particles.at(this);
			_particles.update();
			
		
			scale.x = scaleX;
			scale.y = scaleY;
		}
		
		override public function draw():void
		{
			_particles.draw();
			super.draw();
			
			
			
		}
		
		public function setAvailable():void
		{
			available = true;
		}
		
		
	}

}