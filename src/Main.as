package  {
	
	import flash.display.Sprite;	
	import flash.display.Shape;	
	import com.montenichols.utils.Scrollbar;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	///////////////////
	//* Description *//
	///////////////////
	/**
	 * The Main Class is the Document Class
	 *
	 * Note: This Class is considered "root" by Unrealscipt
	 *
	 * @category   root
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.1 (12/20/2014)
	 */

	//////////////////
	//* Main Class *//
	//////////////////	
	public class Main extends Sprite {
		
		//Stage Objects
		var menu:Menu;
		var icon:Icon;
			
		//Main initializes objects and gives them values
		public function Main()  {
			//Create a new admin panel		
			//menu width and height
			menu = new Menu(300, stage.stageHeight);
			
			menu.x = stage.stageWidth-48;
			menu.y = 0;
			menu.openX = stage.stageWidth - menu.width;
			menu.closeX = menu.x;
			
			//Create a new tab
			
			//Call init 
			init();
		}
		
		//Init Adds resources to stage and sets up initial event listeners
		private function init():void {
			addChild(menu);			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, open);		
		}
		
		//The menu handles its own opening and closing, but the Main decides when and how this happens
		//This is a function to be called by unrealscript in order to open the Menu
		public function open(e:MouseEvent = null):void {
			menu.addEventListener(Event.ENTER_FRAME, menu.onEnterFrameOpen);
			menu.removeEventListener(Event.ENTER_FRAME, menu.onEnterFrameClose);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, open);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, close);
		}
		
		//This is a function to be called by unrealscript in order to close the Menu
		public function close(e:MouseEvent = null):void {
			menu.addEventListener(Event.ENTER_FRAME, menu.onEnterFrameClose);
			menu.removeEventListener(Event.ENTER_FRAME, menu.onEnterFrameOpen);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, close);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, open);
		}	
		
	}	
}