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
		
		var TAB_NUM:Object = new Object();
				
		var US_TOGGLE_SCENARIO = "asReceiveToggleScenario";
		var US_KICK_PLAYER = "asReceiveKickPlayer";
		var US_POSSESS_NPC = "asReceivePossessByName";
				
		var HUMAN_MODE:int = 0;
		var GHOST_MODE:int = 1;
		
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
		var playerState:int = HUMAN_MODE; 	
		
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
			//Create an enum to arbitrarily store the Tabular position. In this case order matters
			//This will allow us to change the order of the Tabs on the fly without us having
			// to modify other code
			for (var i:int = 0; i < tabNames.length; i++) {
				TAB_NUM[tabNames[i].tabName] = i;	
			}
			
			//Get menu width
			var myWidth:int = TAB_SIZE*5;//getMaxTextWidth(tabNames) + TAB_SIZE*2;
			
			//Create a menu with Tabs
			myMenu = new Menu((myWidth), stage.stageHeight, tabNames, TAB_SIZE, leftSide, stage);
			
			//Create a Cursor and hide it
			cursor = new Cursor("Cursor", TAB_SIZE*2, scaleForm);
			cursor.visible = false;
			
			//Create chat window. This is the best place to do this as the chat window
			//is an important part of the main class.
			//FIXME: See if we can't find a way to hide the chatwindow's functions in itself.
			//The idea would be to accept the Unrealscript call in the main, but then divert its tasks 
			//up the chain through a simple one-line method call with some params.
			chatWindow = new ChatWindow("chatWindow", TAB_SIZE, leftSide, stage);
			chatWindow.x = TAB_SIZE/2;
			chatWindow.y = stage.stageHeight - chatWindow.height - TAB_SIZE/2;
			chatWindow.visible = false;
			windows[CHAT] = chatWindow;
			
			//Create the Avatar Window
			//FIXME: This need to actually be set up as a panel that folds out and has avatar images
			avatarWindow = new AvatarWindow("avatarWindow", TAB_SIZE, leftSide, stage);
			avatarWindow.x = stage.stageWidth/2 - avatarWindow.myWidth/2;
			avatarWindow.y = stage.stageHeight/2 - avatarWindow.myHeight/2;
			avatarWindow.visible = false;
			windows[AVATARS] = avatarWindow;
			
			//FIXME: This section needs to go soon, it will eventually serve no purpose.
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
			
			//FIXME: Leftsidedness is depreicated and unsupported so far.
			//This change would cascade down and is really a nightmare for very little gain.
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
		
		//Init Adds resources to stage and sets up initial event listeners
		private function init():void {
			//Hide the mouse in flash. Not strictly necessary, but nice for testing.
			Mouse.hide();
			
			//Add our children now that they have been loaded in
			addChild(myMenu);
			addChild(chatWindow);
			addChild(avatarWindow);
			addChild(cursor);
			
			//If we are not in scaleform we want hotkeys to do certain things, otherwise
			//turn them off 
			if(!scaleForm) {
				stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
			}
			
			//FIXME: These variable names are artrocious, lets get some real code in here before someone sees this tripe
			var tc:Function = tabClick(AVATARS);
			myMenu.tabs[TAB_NUM[AVATARS]].addEventListener(MouseEvent.CLICK, tc);
			var tg:Function = tabClick(CHAT);
			myMenu.tabs[TAB_NUM[CHAT]].addEventListener(MouseEvent.CLICK, tg);
			//FIXME: MAYBE: Finding an object in a hash twice could be memory intensive. Saving it could save time.
			myMenu.tabs[TAB_NUM[GHOST]].addEventListener(MouseEvent.CLICK, ghostMode);
			myMenu.tabs[TAB_NUM[GHOST]].icon.loadOtherImage("human", scaleForm, false);
			
			//FIXME: This whole other image crap has to go. We need a solid way to toggle icons. Like a togglable icon class or something.
			myMenu.tabs[TAB_NUM[GHOST]].icon.other_image.visible = false;
			//open();
			
			//This actually isn't very descriptive, we might want to figure out a better way to do this
			addEventListener(Event.ENTER_FRAME, onLevelLoaded);
			addEventListener(Event.ENTER_FRAME, onLoop);
			
			//Ok, so here is something really weird. This is explained mored in depth on the level loaded event
			myMenu.x = stage.stageWidth-TAB_SIZE*.75;
			myMenu.openX = stage.stageWidth - myMenu.myWidth;
			myMenu.y = 0;
			myMenu.closeX = myMenu.x;
			myMenu.moveX = myMenu.openX;
			
			//set up toggle captureinput for the chatinput. We might be bale to do this in the chat window, 
			//FIXME: Put this in the chat window if at all possible, let's clean out this gigantor main file
			chatWindow.chatInput.addEventListener(MouseEvent.MOUSE_UP, toggleChat);
			chatWindow.chatInput.addEventListener(MouseEvent.MOUSE_OUT, enableToggleChatClickListener);
			chatWindow.chatInput.addEventListener(MouseEvent.MOUSE_OVER, disableToggleChatClickListener);
			
			//If we are in a testing env, but some dummy variables in to test how US will do things
			if(!scaleForm) {
				simulateUnrealScriptPolls();
			}
		}
		
		//I bet you are looking at this code and saying, "Ok, what?" 
		//well, I wrote it and I am too. Basically, the menu disappears if you don't move it 
		//around in the first couple frames. So, for a qtr of a second I make sure it is placed in
		//the right spot. I'm serious, get rid of this code and run a server and join it. The menu will
		//be gone. I'm not precisely sure why this duct tape works, but it does. This took a while to
		//figure out anyway. If I ever get the chance I will play around with a more elegant solution,
		//but for now I'll chalk it up to AS3, US, and Scaleform just being a big ball of shit. 
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
		
		//Move the cursor around each frame.		
		private function onLoop (evt:Event):void {
			cursor.y = mouseY;
			cursor.x = mouseX;
		}
				
		//Become a Human! and update the Tab. Send a call to US to tell it do it.
		public function humanMode(external:Boolean = true):void {
			//This isn't really used yet. We might use it. Lets see if we ever need to poll for this.
			playerState = HUMAN_MODE;
			//Now, I can't figure out why initialized formats outside of this function don't apply to
			//objects affected in this function or why I even have to embed the font every single time
			//FIXME: Let's look into that good old flex style font embedding some day and see if our 
			//actionscript woes can ever be solved, or if this will just continue to be hell forever
			var myFormat:TextFormat = new TextFormat();
			myFormat = new TextFormat();
			myFormat.size = TAB_SIZE/2;
			myFormat.font = "Arial";
				
			var text:TextField = myMenu.tabs[TAB_NUM[GHOST]].text;
			text.text = "Human Mode";
			text.embedFonts = true;
			text.setTextFormat(myFormat);
			
			//Getting these vars multiple times can be slow
			//FIXME: let's save this var for more readable code and so we don't access a hash multiple times
			myMenu.tabs[TAB_NUM[GHOST]].removeEventListener(MouseEvent.CLICK, humanMode);
			myMenu.tabs[TAB_NUM[GHOST]].addEventListener(MouseEvent.CLICK, ghostMode);
			myMenu.tabs[TAB_NUM[GHOST]].icon.other_image.visible = true;
			myMenu.tabs[TAB_NUM[GHOST]].icon.image.visible = false;
			if(external) {
				ExternalInterface.call("asReceiveBecomeHuman");
			}	
		}
		
		//Become a ghost! This isn't that DRY. To follow this code look above.
		public function ghostMode(external:Boolean = true):void {
			playerState = GHOST_MODE;
			var myFormat:TextFormat = new TextFormat();
			myFormat = new TextFormat();
			myFormat.size = TAB_SIZE/2;
			myFormat.font = "Arial";
				
			var text:TextField = myMenu.tabs[TAB_NUM[GHOST]].text;
			text.text = "Ghost Mode";
			text.embedFonts = true;
			text.setTextFormat(myFormat);
			myMenu.tabs[TAB_NUM[GHOST]].removeEventListener(MouseEvent.CLICK, ghostMode);
			myMenu.tabs[TAB_NUM[GHOST]].addEventListener(MouseEvent.CLICK, humanMode);
			myMenu.tabs[TAB_NUM[GHOST]].icon.other_image.visible = false;
			myMenu.tabs[TAB_NUM[GHOST]].icon.image.visible = true;
			ExternalInterface.call("asReceiveBecomeGhost");
		}
		
		//this is for normal toggle able tabs.
		private function tabClick(tabName:String):Function {
			//Return a dynamic way to hide a window in a hash
			return function(e:MouseEvent):void {
				windows[tabName].visible = !windows[tabName].visible;
			};
		}
		
		//FIXME: This needs to be taken out completely eventually
		public function addJulius(e:MouseEvent = null):void {
			var onClick:Function = onButtonSend(US_KICK_PLAYER);
			myMenu.addToList("Julius 251", KICK, "kick", onClick);
			myMenu.addToList("Julius 252", KICK, "kick", onClick);
		}
		
		//FIXME: This needs to be taken out completely eventually
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
		//This is arbitrary X movement, but could allow for any type of movement or easing.
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
		//It adds text to the chat-log and then format it after the fact, because as3 is a turd
		//FIXME: hide this crud in the Chat window
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
			//FIXME: Reimplement this
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
		
		//FIXME: hide this crud in the Chat window
		//When we are outside the textbox
		public function enableToggleChatClickListener(e:MouseEvent) {
			utrace("toggle chat enabled");
			stage.addEventListener(MouseEvent.MOUSE_DOWN, clickToggleChatListener);
		}
		
		//FIXME: hide this crud in the Chat window
		//When we are inside the textbox
		public function disableToggleChatClickListener(e:MouseEvent) {
			utrace("toggle chat disabled");
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, clickToggleChatListener);
		}
		
		//FIXME: hide this crud in the Chat window
		//toggleChat captures keys when you type
		public function toggleChat(e:MouseEvent) {	
			chatWindow.chatInput.removeEventListener(MouseEvent.MOUSE_UP, toggleChat);
			utrace("dissallow input");
			ExternalInterface.call("asReceiveToggleChatTrue");
		}
		
		//FIXME: hide this crud in the Chat window
		//this is needed for the toggling feature
		public function clickToggleChatListener(e:MouseEvent = null) {
			utrace("allow input, except esc");
			chatWindow.chatInput.addEventListener(MouseEvent.MOUSE_UP, toggleChat);
			stage.focus = stage;
			ExternalInterface.call("asReceiveToggleChatFalse");
		}
		
		//Start Player Stuff
		//This function is only ever called by UnrealScript
		//It adds a player to the list of players
		public function addPlayer(playerID:int, playerName:String, bIsMe:Boolean):void {
			utrace("AddingPlayer Start");
			var onClick:Function = onButtonSend(US_KICK_PLAYER);
			myMenu.addToList( (playerName + playerID), KICK, "kick", onClick);
			utrace("AddingPlayer End");
		}
		
		//This function is only ever called by UnrealScript
		//It removes a player from the list of players
		public function removePlayer(playerID:int, playerName:String):void {
			utrace("AddingPlayer Start");
			myMenu.deleteFromList( "Boop"/*(playerName + playerID)*/, KICK);
			utrace("AddingPlayer End");
		}
		//End Player Stuff
		
		//Start NPC stuff
		//This function is only ever called by UnrealScript
		//It adds an NPC to the possession menu
		//FIXME: Fix the unrealscript that updates NPCs based on if new NPCS spawn or die
		public function addNPC(npcName:String):void {
			utrace("AddingNPC Start");
			var onClick:Function = onButtonSend(US_POSSESS_NPC);
			myMenu.addToList( (npcName),POSSESS, "possess", onClick);
			utrace("AddingNPC End");
		}
		
		//TODO: add a way to remove NPCS from the list by unrealscript	
		
		//Start scenario stuff
		
		//This function is only ever called by UnrealScript
		//This adds an item to the scenario menu.
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
		//This is only ever called by unrealscript.
		//this changes the text of Scenario buttons to match their in-game state as they change
		public function receiveToggleScenarioButton(scenarioName:String, startOrStop:String):void {
			myMenu.panels[SCENARIO].labels[scenarioName].sureButton.text.text = startOrStop;
		}
				
		//this is a generic function that sends info to US
		public function onButtonSend(functionName:String):Function {
			return function(e:MouseEvent):void {
				var button:TextButton = TextButton(e.currentTarget);
				var label:String = button.context;//label;
				ExternalInterface.call(functionName, label);
			}
		}
		
		//this is a generic function that sends info to US, it is special in that it handles toggleable states
		public function onButtonSendToggle(functionName:String):Function {
			return function(e:MouseEvent):void {
				var button:TextButton = TextButton(e.currentTarget);
				var label:String = button.context;//label;
				var action:String = button.text.text;//data.toString();
				ExternalInterface.call(functionName, label, action);
			}
		}
		
		//Trace flash things in unreal while debugging. If we ever think we have a final final 
		// release (hah!) we will delete all of the utrace statements
		public function utrace(s:String) {
			if(debug){
				ExternalInterface.call("FlashToUDK", "say " + s);
			}
		}
		
		//FIXME: We want a Are you sure class that has some buttons that get assigned the real functions
		//of kicking.
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