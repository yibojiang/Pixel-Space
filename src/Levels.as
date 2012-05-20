package  
{
	/**
	 * ...
	 * @author yibojiang
	 */
	public class Levels 
	{
		[Embed(source = 'data/levels/level0.txt', mimeType = "application/octet-stream")] public static const Level0:Class; 
		
		[Embed(source = 'data/levels/level1.txt', mimeType = "application/octet-stream")] public static const Level1:Class; 
		
		[Embed(source = 'data/levels/level2.txt', mimeType = "application/octet-stream")] public static const Level2:Class; 
		[Embed(source = 'data/levels/level3.txt', mimeType = "application/octet-stream")] public static const Level3:Class; 
		[Embed(source = 'data/levels/level4.txt', mimeType = "application/octet-stream")] public static const Level4:Class; 
		
		public function Levels() 
		{
			
		}
		
	}

}