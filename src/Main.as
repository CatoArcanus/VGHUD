package {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.external.ExternalInterface;
	import flash.ui.Mouse;
	
	import com.vrl.controls.Menu;
	import com.vrl.controls.Window;
	import com.vrl.controls.ChatWindow;
	import com.vrl.controls.AvatarWindow;
	import com.vrl.buttons.TextButton;
	import com.vrl.utils.Cursor;
	import com.vrl.TabInfo;	
	
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
		
		var debug:Boolean = true;
		var scaleForm:Boolean = false;
		
		//Consts
		//This number actually controls the entire size of the menu.
		//It is the measure in pixels of the tab width/height
		var TAB_SIZE:Number = 48;
		var CHAT:String = "Chat";
		var GHOST:String = "Ghost";
		var AVATARS:String = "Avatars";
		var POSSESS:String = "Possess";
		var KICK:String = "Kick";
		var SCENARIO:String = "Scenario";
		
		var US_TOGGLE_SCENARIO = "asReceiveToggleScenario";
		var US_KICK_PLAYER = "asReceiveKickPlayer";
		var US_POSSESS_NPC = "asReceivePossessByName";
		
		//This places the menu to the left or the right
		var leftSide:Boolean = false; 
		//This lets tabs be acordians or not
		var accordian:Boolean = true;
		
		//Stage Objects
		var myMenu:Menu;
		var chatWindow:ChatWindow;
		var avatarWindow:AvatarWindow;
		
		var windows:Array = new Array();
		var cursor:Cursor;		
		
		//Tabs
		var tabNames:Array = new Array(
			new TabInfo(CHAT, 		!accordian,	scaleForm),
			new TabInfo(GHOST, 		!accordian,	scaleForm),
			new TabInfo(AVATARS, 	!accordian,	scaleForm),
			new TabInfo(POSSESS, 	accordian, 	scaleForm),
			new TabInfo(KICK, 		accordian, 	scaleForm),
			new TabInfo(SCENARIO, 	accordian, 	scaleForm)
		);
			
		//Main initializes objects and gives them values
		public function Main() {
			//Get menu width
			var myWidth:int = TAB_SIZE*5//getMaxTextWidth(tabNames) + TAB_SIZE*2;
			
			//Create menu
			myMenu = new Menu((myWidth), stage.stageHeight, tabNames, TAB_SIZE, leftSide, stage);
			
			cursor = new Cursor("Cursor", TAB_SIZE*2, scaleForm);
			cursor.visible = false;
			
			//Create chat window
			chatWindow = new ChatWindow("chatWindow", TAB_SIZE, leftSide, stage);
			chatWindow.x = TAB_SIZE/2;
			chatWindow.y = stage.stageHeight - chatWindow.height - TAB_SIZE/2;
			chatWindow.visible = false;
			windows[CHAT] = chatWindow;
			
			//Create the Avatar Window
			avatarWindow = new AvatarWindow("avatarWindow", TAB_SIZE, leftSide, stage);
			avatarWindow.x = stage.stageWidth/2 - avatarWindow.myWidth/2;
			avatarWindow.y = stage.stageHeight/2 - avatarWindow.myHeight/2;
			avatarWindow.visible = false;
			windows[AVATARS] = avatarWindow;
			
			//This section is purely for testing
			var kickWindow = new Window("KickWindow", TAB_SIZE, 300, 100, leftSide, stage);
			kickWindow.x = 1200;
			kickWindow.y = 10;
			var addButton:TextButton = new TextButton("addKick", "addKick", TAB_SIZE/2);
			addButton.x = 10;
			addButton.y = 10;
			var deleteButton:TextButton = new TextButton("deleteKick", "deleteKick", TAB_SIZE/2);
			deleteButton.x = 100;
			deleteButton.y = 10;
			
			addButton.addEventListener(MouseEvent.CLICK, addJulius);
			deleteButton.addEventListener(MouseEvent.CLICK, deleteJulius);
			
			kickWindow.addChild(addButton);
			kickWindow.addChild(deleteButton);
			addChild(kickWindow);
			//
			
			//This puts it on the left or right, depending on what we have decided
			//if(leftSide) {
			//	myMenu.x = (0-myWidth)+TAB_SIZE*.75;
			//	myMenu.openX = 0;
			//} else {
			//	myMenu.x = stage.stageWidth-TAB_SIZE*.75;
			//	myMenu.openX = stage.stageWidth - myMenu.myWidth;
			//}
			//myMenu.y = 0;
			//myMenu.closeX = myMenu.x;
			//myMenu.moveX = myMenu.openX;
			
			//Call init 
			init();
		}
		
		public function onLevelLoaded(e:Event):void {
			myMenu.x = stage.stageWidth-TAB_SIZE*.75;
			myMenu.openX = stage.stageWidth - myMenu.myWidth;
			myMenu.y = 0;
			myMenu.closeX = myMenu.x;
			myMenu.moveX = myMenu.openX;
			if(myMenu.frameCounter > 15) {
				removeEventListener(Event.ENTER_FRAME, onLevelLoaded);
				myMenu.frameCounter = 0;
			} else {
				//utrace(""+myMenu.frameCounter);
			}
			myMenu.frameCounter++;
		}
		
		//Init Adds resources to stage and sets up initial event listeners
		private function init():void {
			Mouse.hide();
			addChild(myMenu);
			addChild(chatWindow);
			addChild(avatarWindow);
			addChild(cursor);
			
			if(!scaleForm) {
				stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
			}
			
			for (var key:String in myMenu.tabs){
				//trace(key);
				if(!myMenu.tabs[key].accordian) {
					myMenu.tabs[key].addEventListener(MouseEvent.CLICK, tabClick(myMenu.tabs[key].buttonName));
				}
				
			}
			//open();
			addEventListener(Event.ENTER_FRAME, onLevelLoaded);
			addEventListener(Event.ENTER_FRAME, onLoop);
			myMenu.x = stage.stageWidth-TAB_SIZE*.75;
			myMenu.openX = stage.stageWidth - myMenu.myWidth;
			myMenu.y = 0;
			myMenu.closeX = myMenu.x;
			myMenu.moveX = myMenu.openX;
			
			//set up toggle captureinput
			chatWindow.chatInput.addEventListener(MouseEvent.MOUSE_UP, toggleChat);
			chatWindow.chatInput.addEventListener(MouseEvent.MOUSE_OUT, enableToggleChatClickListener);
			chatWindow.chatInput.addEventListener(MouseEvent.MOUSE_OVER, disableToggleChatClickListener);
			
			if(!scaleForm) {
				simulateUnrealScriptPolls();
			}
		}
		
		private function onLoop (evt:Event):void {
			cursor.y = mouseY;
			cursor.x = mouseX;
		}
		
		//this is for normal toggleable tabs
		private function tabClick(tabName:String):Function {
			return function(e:MouseEvent):void {
				windows[tabName].visible = !windows[tabName].visible;
			};
		}
		
		//This will eventutally be called by unrealscript in a different way
		public function addJulius(e:MouseEvent = null):void {
			var onClick:Function = onButtonSend(US_KICK_PLAYER);
			myMenu.addToList("Julius 251", KICK, "kick", onClick);
			myMenu.addToList("Julius 252", KICK, "kick", onClick);
		}
		
		//This will eventutally be called by unrealscript in a different way
		public function deleteJulius(e:MouseEvent = null):void {
			myMenu.deleteFromList("Boop", KICK);
			//myMenu.deleteFromList("Julius 252", KICK);
		}			
		
		//This is primarily for debugging
		private	function reportKeyDown(event:KeyboardEvent):void { 
			trace("Key Pressed: " + String.fromCharCode(event.charCode) + " (character code: " + event.charCode + ")"); 
			if (event.charCode == 111/*o*/) open(); 
			else if (event.charCode == 99/*c*/) close(); 
		} 
		
		//The myMenu handles its own opening and closing, but the Main decides when and how this happens
		//This is a function to be called by unrealscript in order to open the myMenu
		public function open(e:MouseEvent = null):void {
			myMenu.moveX = myMenu.openX;
			addEventListener(Event.ENTER_FRAME, onEase);
			cursor.visible = true;
		}
		
		//This is a function to be called by unrealscript in order to close the myMenu
		public function close(e:MouseEvent = null):void {
			myMenu.moveX = myMenu.closeX;
			addEventListener(Event.ENTER_FRAME, onEase);
			cursor.visible = false;
		}
				
		//This handles opening the myMenu frame by frame, until is it done 
		//This is arbitrary X movement, but could allow for any type of movement
		public function onEase(e:Event):void {
			utrace(myMenu.frameCounter + " -- " + (myMenu.openX - myMenu.x) * myMenu.easing);
			utrace("myX is now: " + myMenu.x);
			//My distance = (where I want to go) - where I am
			myMenu.dx = ( myMenu.moveX - myMenu.x);
			//If where I want to go is less than 1, I will stay there
			//Otherwise move a proportional distance to my target "easing" my way there
			if(Math.abs(myMenu.dx) < 1) {
				removeEventListener(Event.ENTER_FRAME, onEase);
				myMenu.frameCounter = 0;
			} else {
				myMenu.x += myMenu.dx * myMenu.easing;
			}
			myMenu.frameCounter++;
		}
		
		//This is primarily for testing
		public function simulateUnrealScriptPolls() {
			var onClick:Function = onButtonSend(US_KICK_PLAYER);
			var playerNames:Array = new Array("Nope", "Boop", "Pompey253", "Cicero 254", "Publius");
			for each (var playerName:String in playerNames) {
				myMenu.addToList(playerName, KICK, "kick", onClick);
			}
			
			onClick = onButtonSend(US_POSSESS_NPC);
			var NPCNames:Array = new Array("Kirk", "Spock", "McCoy", "Chapel", "Scotty", "Sulu", "Chekov", "Uhura", "Red Shirt", "Khan", "Evil Spock", "Computer", "Hadley", "Brent", "Q", "Picard", "Riker", "Deanna", "Data");
			for each (var NPCName:String in NPCNames) {
				myMenu.addToList(NPCName,POSSESS, "posses", onClick);
			}
			
			onClick = onButtonSendToggle(US_TOGGLE_SCENARIO);
			var scenarioNames:Array = new Array("BasketBall", "Coffee Shop");
			for each (var ScenarioName:String in scenarioNames) {
				myMenu.addToList(ScenarioName, SCENARIO, "start", onClick);
			}
			getTextMessage("me", "Hello", true);
			getTextMessage("you", "World", false);
			receiveToggleScenarioButton("BasketBall", "stop");
		}
		
		//This function is only ever called by UnrealScript
		public function getTextMessage(playerName:String, textMessage:String, bIsMe:Boolean):void {
			//change format
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = TAB_SIZE*.30;
			myFormat.font = "Arial";
			
			if(bIsMe) {
				myFormat.color = 0x12c2e7;	
			} else {
				myFormat.color = 0x13e87d;
			}
			var chatWindow:ChatWindow = windows[CHAT];
			//get the current length
			var oldLength = chatWindow.chatLog.length;	
			//Update flash textfield. We might override this later
			chatWindow.chatLog.appendText( "\n\n" + playerName + ":\n\t" + textMessage );
			//TODO: Reimplement this
			/*
			if(!cursor_mc.visible) {		
				alertPlayer(playerName);		
			}
			*/
			
			//get the new length
			var newLength = chatWindow.chatLog.length;
				
			//Format just the newest added section
			chatWindow.chatLog.setTextFormat(myFormat, oldLength, newLength);
			
			//Update textfield to always scroll to bottom
			chatWindow.chatLog.scrollV = chatWindow.chatLog.maxScrollV;
		}
		
		//This function is only ever called by UnrealScript
		public function addPlayer(playerID:int, playerName:String, bIsMe:Boolean):void {
			utrace("AddingPlayer Start");
			var onClick:Function = onButtonSend(US_KICK_PLAYER);
			myMenu.addToList( (playerName + playerID), KICK, "kick", onClick);
			utrace("AddingPlayer End");
		}
		
		//This function is only ever called by UnrealScript
		public function removePlayer(playerID:int, playerName:String):void {
			utrace("AddingPlayer Start");
			myMenu.deleteFromList( "Boop"/*(playerName + playerID)*/, KICK);
			utrace("AddingPlayer End");
		}
		
		
		//This function is only ever called by UnrealScript
		public function addNPC(npcName:String):void {
			utrace("AddingNPC Start");
			var onClick:Function = onButtonSend(US_POSSESS_NPC);
			myMenu.addToList( (npcName),POSSESS, "possess", onClick);
			utrace("AddingNPC End");
		}
		
		//Trace flash things in unreal
		public function utrace(s:String) {
			if(debug){
				ExternalInterface.call("FlashToUDK", "say " + s);
			}
		}
		//When we are outside the textbox
		public function enableToggleChatClickListener(e:MouseEvent) {
			utrace("toggle chat enabled");
			stage.addEventListener(MouseEvent.MOUSE_DOWN, clickToggleChatListener);
		}

		//When we are inside the textbox
		public function disableToggleChatClickListener(e:MouseEvent) {
			utrace("toggle chat disabled");
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, clickToggleChatListener);
		}

		//toggleChat captures keys when you type
		public function toggleChat(e:MouseEvent) {	
			chatWindow.chatInput.removeEventListener(MouseEvent.MOUSE_UP, toggleChat);
			utrace("dissallow input");
			ExternalInterface.call("asReceiveToggleChatTrue");
		}

		//this is needed for the toggling feature
		public function clickToggleChatListener(e:MouseEvent = null) {
			utrace("allow input, except esc");
			chatWindow.chatInput.addEventListener(MouseEvent.MOUSE_UP, toggleChat);
			stage.focus = stage;
			ExternalInterface.call("asReceiveToggleChatFalse");
		}
		
		//Start screnario stuff
		
		//This function is only ever called by UnrealScript
		public function addScenario(scenarioName:String, isRunning:Boolean):void {
			utrace("AddingScenario Start");
			var startOrStop:String = "start";
			if(isRunning) {
				startOrStop = "stop";
			}
			var onClick:Function = onButtonSendToggle(US_TOGGLE_SCENARIO);
			myMenu.addToList( (scenarioName), SCENARIO, "start", onClick);
			utrace("AddingScenario End");
		}
		
		public function onButtonSend(functionName:String):Function {
			return function(e:MouseEvent):void {
				var button:TextButton = TextButton(e.currentTarget);
				var label:String = button.context;//label;
				ExternalInterface.call(functionName, label);
			}
		}
		
		public function onButtonSendToggle(functionName:String):Function {
			return function(e:MouseEvent):void {
				var button:TextButton = TextButton(e.currentTarget);
				var label:String = button.context;//label;
				var action:String = button.text.text;//data.toString();
				ExternalInterface.call(functionName, label, action);
			}
		}
		
		public function receiveToggleScenarioButton(scenarioName:String, startOrStop:String):void {
			myMenu.panels[SCENARIO].labels[scenarioName].sureButton.text.text = startOrStop;
		}
		
		
		/*
		//Start Kick stuff
		//Show the "Are you sure?" window
		function kickPlayer(e:MouseEvent):void {	
			var player_ID:String = Button(e.currentTarget).data.toString();	
			chat_window.sure_mc.gotoAndPlay("sureIn");
			chat_window.sure_mc.questionText.text = ("Kick player?");	
			chat_window.sure_mc.yes_btn.data = player_ID;	
			chat_window.sure_mc.yes_btn.addEventListener(MouseEvent.CLICK, this.sendKick);
			chat_window.sure_mc.no_btn.addEventListener(MouseEvent.CLICK, this.sendBack);
		}

		function sendKick(e:MouseEvent):void {
			ExternalInterface.call("asReceiveKickPlayer", chat_window.sure_mc.yes_btn.data);
			sendBack();
		}

		function sendBack(e:MouseEvent = null):void {
			chat_window.sure_mc.gotoAndPlay("sureOut");
			utrace("this might be where it messes up... let's see...");
			chat_window.sure_mc.yes_btn.removeEventListener(MouseEvent.CLICK, this.sendKick);
			chat_window.sure_mc.no_btn.removeEventListener(MouseEvent.CLICK, this.sendBack);
		}

		function removedPlayer(playerName:String):void {
			for (var i = 0; i < chat_window.adminPanel_mc.numChildren; i++) {
				if(chat_window.adminPanel_mc.getChildAt(i).data.toString() == playerName) {
					chat_window.adminPanel_mc.getChildAt(i).visible = false;
				}
			}
		}
		
		function kickPlayer(playerName:String) {
			ExternalInterface.call("asReceiveToggleChatFalse");
		}
		*/
	}
}