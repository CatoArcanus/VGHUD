package  {
	
	import flash.display.Sprite;		
	import com.montenichols.utils.Scrollbar;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;	
	import flash.text.TextField;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
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
	 * @version    1.4 (12/27/2014)
	 */

	//////////////////
	//* Main Class *//
	//////////////////	
	public class Main extends Sprite {
		
		//Consts
		//This number actually controls the entire size of the menu. 
		//It is the measure in pixels of the tab width/height
		var TAB_SIZE:Number = 48;
		
		//Stage Objects
		var menu:Menu;
		var icon:Icon;
		var tabNames:Array = new Array("Chat", "Kick", "Avatars", "Possess", "Scenario");
		//var tabNames:Array = new Array("Avatars", "Avatars", "Avatars", "Avatars", "Avatars");
		
		//Main initializes objects and gives them values
		public function Main()  {
			//Create a new admin panel
			//menu width and height
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = TAB_SIZE/2;
			myFormat.font = "Arial";
			
			var myWidth:int = 0;
			//TODO: this 300 is arbitrary. Let's calculate a value using tab_height and the longest
			//Word in tabNames
			for each (var tabName:String in tabNames) {
				var info:TextField = new TextField();
				info.border = false;
				info.multiline = false;
				info.wordWrap = false;
				info.selectable = false;
				//get it to be auto size
				info.autoSize = TextFieldAutoSize.LEFT;
								
				//apply the format
				info.defaultTextFormat = myFormat;
				//set the color
				info.textColor = 0xFFFFFF;
				//set the text
				info.text = (tabName);
				if(info.width > myWidth)
				{
					myWidth = info.width;
				}
			}
			
			//Create menu
			menu = new Menu((myWidth + TAB_SIZE), stage.stageHeight, tabNames, TAB_SIZE);
			
			menu.x = stage.stageWidth-TAB_SIZE*.75;
			menu.y = 0;
			menu.openX = stage.stageWidth - menu.myWidth;
			menu.closeX = menu.x;
			menu.moveX = menu.openX;
			
			//Call init 
			init();
		}
		
		//Init Adds resources to stage and sets up initial event listeners
		private function init():void {
			addChild(menu);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
		}
		
		private	function reportKeyDown(event:KeyboardEvent):void { 
    		trace("Key Pressed: " + String.fromCharCode(event.charCode) +         " (character code: " + event.charCode + ")"); 
			if (event.charCode == 111/*o*/) open(); 
			else if (event.charCode == 99/*c*/) close(); 
		} 
				
		//The menu handles its own opening and closing, but the Main decides when and how this happens
		//This is a function to be called by unrealscript in order to open the Menu
		public function open(e:MouseEvent = null):void {
			menu.moveX = menu.openX;
			addEventListener(Event.ENTER_FRAME, onEase);
		}
		
		//This is a function to be called by unrealscript in order to close the Menu
		public function close(e:MouseEvent = null):void {
			menu.moveX = menu.closeX;
			addEventListener(Event.ENTER_FRAME, onEase);
		}
		
		//This handles opening the Menu frame by frame, until is it done 
		//This is arbitrary X movement, but could allow for any type of movement
		public function onEase(e:Event):void {
			trace(menu.frameCounter + " -- " + (menu.openX - menu.x) * menu.easing);
			//My distance = (where I want to go) - where I am
			menu.dx = ( menu.moveX - menu.x);
			//If where I want to go is less than 1, I will stay there
			//Otherwise move a proportional distance to my target "easing" my way there
			if(Math.abs(menu.dx) < 1) {
				removeEventListener(Event.ENTER_FRAME, onEase);
				menu.frameCounter = 0;
			} else {
				menu.x += menu.dx * menu.easing;
			}
			menu.frameCounter++;
		}
	}
}