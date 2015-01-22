package {
	
	import flash.display.Sprite;		
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;	
	import flash.text.TextField;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	/////////////////
	// Description //
	/////////////////
	/**
	 * The Main Class is the Document Class
	 *
	 * Note: This Class is considered "root" by Unrealscipt
	 *
	 * @category   root
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.7 (01/16/2015)
	 */

	////////////////
	// Main Class //
	////////////////	
	public class Main extends Sprite {
		
		//Consts
		//This number actually controls the entire size of the menu. 
		//It is the measure in pixels of the tab width/height
		var TAB_SIZE:Number = 48;
		//This places the menu to the left or the right
		var leftSide:Boolean = false; 
		//This lets tabs be acordians or not
		var accordian:Boolean = true;
		//Stage Objects
		var menu:Menu;
		var chatWindow:ChatWindow;
		var avatarWindow:AvatarWindow;
		
		//Tabs
		var tabNames:Array = new Array(
			new TabInfo("Chat", 	!accordian),
			new TabInfo("Ghost", 	!accordian),
			new TabInfo("Avatars", 	!accordian),
			new TabInfo("Possess", 	accordian),
			new TabInfo("Kick", 	accordian),
			new TabInfo("Scenario", accordian),
			new TabInfo("yes", 	accordian),
			new TabInfo("no", 	!accordian),
			new TabInfo("roger", 	!accordian),
			new TabInfo("steven", 	!accordian),
			new TabInfo("poo", 	!accordian)
		);
			
		//Main initializes objects and gives them values
		public function Main()  {
			//Get menu width
			var myWidth:int = TAB_SIZE*5//getMaxTextWidth(tabNames) + TAB_SIZE*2;
					
			//Create menu
			menu = new Menu((myWidth), stage.stageHeight, tabNames, TAB_SIZE, leftSide, stage);
			
			//Create chat window
			chatWindow = new ChatWindow("chatWindow", TAB_SIZE, leftSide, stage);
			chatWindow.x = TAB_SIZE;
			chatWindow.y = stage.stageHeight - chatWindow.height - TAB_SIZE;
			
			avatarWindow = new AvatarWindow("avatarWindow", TAB_SIZE, leftSide, stage);
			avatarWindow.x = stage.stageWidth/2 - avatarWindow.myWidth/2;
			avatarWindow.y = stage.stageHeight/2 - avatarWindow.myHeight/2;
									
			var kickWindow = new Window("KickWindow", TAB_SIZE, 300, 100, leftSide, stage);
			kickWindow.x = 1200;
			kickWindow.y = 10;
			var addButton:TextButton = new TextButton("addKick", TAB_SIZE/2);
			addButton.x = 10;
			addButton.y = 10;
			var deleteButton:TextButton = new TextButton("deleteKick", TAB_SIZE/2);
			deleteButton.x = 100;
			deleteButton.y = 10;
			
			addButton.addEventListener(MouseEvent.CLICK, addJulius);
			deleteButton.addEventListener(MouseEvent.CLICK, deleteJulius);
			
			kickWindow.addChild(addButton);
			kickWindow.addChild(deleteButton);
			addChild(kickWindow);
						
			//This puts it on the left or right, depending on what we have decided
			if(leftSide) {
				menu.x = (0-myWidth)+TAB_SIZE*.75;
				menu.openX = 0;
			} else {
				menu.x = stage.stageWidth;//-TAB_SIZE*.75;
				menu.openX = stage.stageWidth - menu.myWidth;
			}			
			menu.y = 0;
			menu.closeX = menu.x;
			menu.moveX = menu.openX;
			
			//Call init 
			init();
		}
		
		
		//Init Adds resources to stage and sets up initial event listeners
		private function init():void {
			addChild(menu);
			addChild(chatWindow);
			addChild(avatarWindow);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
			simulateUnrealScriptPolls();
			open();
		}
		
		//This will eventutally be called by unrealscript
		public function addJulius(e:MouseEvent = null):void {
			menu.addToList("Julius 251", "Kick");
			menu.addToList("Julius 252", "Kick");
		}
		
		//This is a function to be called by unrealscript in order to open the Menu
		public function deleteJulius(e:MouseEvent = null):void {
			menu.deleteFromList("Julius 251", "Kick");
			menu.deleteFromList("Julius 252", "Kick");
		}			
		
		//This is primarily for debugging
		private	function reportKeyDown(event:KeyboardEvent):void { 
    		trace("Key Pressed: " + String.fromCharCode(event.charCode) + " (character code: " + event.charCode + ")"); 
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
		
		//This is primarily for testing
		public function simulateUnrealScriptPolls() {
			var playerNames:Array = new Array("Nope", "Boop", "Pompey253", "Cicero 254", "Publius");
			for each (var playerName:String in playerNames) {
				menu.addToList(playerName, "Kick");
			}
			
			var NPCNames:Array = new Array("Kirk", "Spock", "McCoy", "Chapel", "Scotty", "Sulu", "Chekov", "Uhura", "Red Shirt", "Khan", "Evil Spock", "Computer", "Hadley", "Brent", "Q", "Picard", "Riker", "Deanna", "Data");
			for each (var NPCName:String in NPCNames) {
				menu.addToList(NPCName, "Possess");
			}
			
			var scenarioNames:Array = new Array("BasketBall", "Coffee Shop");
			for each (var ScenarioName:String in scenarioNames) {
				menu.addToList(ScenarioName, "Scenario");
			}
		}
	}
}