package  
{

	/**
	 * ...
	 * @author yibojiang
	 */
	public interface ITransportable 
	{
		function transfer(_blackhole1:BlackHole,_blackHole2:BlackHole,_time:Number):void;
		function setTargetPos(_blackHole2:BlackHole, _time:Number):void;
		function transferFinished():void;
	}
	
}