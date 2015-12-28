
/**		
 * 
 *	Demo
 *	
 *	@version 1.00 | Jul 22, 2010
 *	@author Justin Windle
 *  
 **/
 
package  
{
	import com.facebook.graph.examples.OAuthExample;
	import com.facebook.graph.examples.TabExample;

	import flash.display.Sprite;

	/**
	 * Demo
	 */
	public class Demo extends Sprite 
	{
		public function Demo()
		{
			//addChild(new TabExample());
			addChild(new OAuthExample());
		}
	}
}
