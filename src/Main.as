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
		var adminPanel:AdminPanel;
			
		//Main initializes object
		public function Main()  {		
			//load resources here
			adminPanel = new AdminPanel(300, stage.stageHeight);
			adminPanel.alpha = .75;
			adminPanel.x = stage.stageWidth;
			adminPanel.y = 0;
			adminPanel.openX = adminPanel.x - adminPanel.width;
			adminPanel.closeX = adminPanel.x;
			init();
		}
		
		//Init Adds resources to stage and sets up event listeners
		private function init():void {
			addChild(adminPanel);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, open);
			//open();			
		}
		
		//This is a function to be called by unrealscript in order to open the AdminPanel
		public function open(e:MouseEvent = null):void {
			adminPanel.addEventListener(Event.ENTER_FRAME, adminPanel.onEnterFrameOpen);
			adminPanel.removeEventListener(Event.ENTER_FRAME, adminPanel.onEnterFrameClose);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, open);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, close);
		}
		
		//This is a function to be called by unrealscript in order to close the AdminPanel
		public function close(e:MouseEvent = null):void {
			adminPanel.addEventListener(Event.ENTER_FRAME, adminPanel.onEnterFrameClose);
			adminPanel.removeEventListener(Event.ENTER_FRAME, adminPanel.onEnterFrameOpen);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, close);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, open);
		}	
		
	}	
}