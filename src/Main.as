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
	import com.vrl.labels.AlertLabel;
	import com.vrl.buttons.TextButton;
	import com.vrl.buttons.IconButton;
	import com.vrl.utils.Cursor;
	import com.vrl.utils.AvatarImage;
	import com.vrl.utils.Icon;
	import com.vrl.windows.SureWindow;
	import com.vrl.windows.Window;
	//import com.vrl.windows.ChatWindow;
	import com.vrl.panels.ChatPanel;
	import com.vrl.TabInfo;
	import com.vrl.UIElement;
	
	////////////////
	// Main Class //
	////////////////
	/**
	* The Main class is also known as the Document class and the root path.
	* All unrelascript calls must be routed through this file, so it can get
	* a little bloated. We will try to designate as much responsibility to 
	* component classes, but this class will usually still be large.	
	*/	
	public class Main extends Sprite {
		
		//set to true if you want debug output
		var debug:Boolean = false;
		//set to true if pushing live to scaleform, false if testing in the launcher
		var scaleForm:Boolean = true;
		
		//Consts
		//This number actually controls the entire size of the menu.
		//It is the measure in pixels of the tab width/height
		var TAB_SIZE:Number = 48;
		
		//FIXME: We could have this designated through a config file at some point
		var CHAT:String = "Chat";
		var SURE:String = "Sure";
		var GHOST:String = "Ghost";
		var AVATARS:String = "Avatars";
		var POSSESS:String = "Possess";
		var KICK:String = "Kick";
		var SCENARIO:String = "Scenario";
		var CLOSE:String = "exit";
		
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
		var peek:Boolean = true;
		
		//Stage Objects
		var myMenu:Menu;
		//var chatWindow:ChatWindow;
		var sureWindow:SureWindow;
						
		var windows:Array = new Array();
		var cursor:Cursor;	
		var playerState:int = HUMAN_MODE;
		
		//Tabs
		var tabNames:Array = new Array(
			new TabInfo(CHAT, 		CHAT,			!peek,	accordian,	scaleForm, leftSide),
			new TabInfo(GHOST, 		"Ghost Menu",	!peek,	accordian,	scaleForm, leftSide),
			new TabInfo(AVATARS, 	AVATARS,		peek,	!accordian,	scaleForm, leftSide),
			new TabInfo(POSSESS, 	"NPCs",			!peek,	accordian, 	scaleForm, leftSide),
			new TabInfo(KICK, 		"Players",		!peek,	accordian, 	scaleForm, leftSide),
			new TabInfo(SCENARIO, 	"Scenarios",	!peek,	accordian, 	scaleForm, leftSide),
			new TabInfo(CLOSE,	 	"Close",		!peek,	!accordian,	scaleForm, leftSide)
		);
		
		//Main initializes objects and gives them values
		public function Main() {
			//Font.registerFont("Arial");
			//Create an enum to arbitrarily store the Tabular position. In this case order matters
			//This will allow us to change the order of the Tabs on the fly without us having
			// to modify other code
			for (var i:int = 0; i < tabNames.length; i++) {
				TAB_NUM[tabNames[i].name] = i;
			}
			
			//Get menu width
			var myWidth:int = TAB_SIZE*8;//getMaxTextWidth(tabNames) + TAB_SIZE*2;
			
			//Create a menu with Tabs
			myMenu = new Menu((myWidth), stage.stageHeight, tabNames, TAB_SIZE, leftSide, stage);
			myMenu.visible = false;
			
			//Create a Cursor and hide it
			cursor = new Cursor("Cursor", TAB_SIZE*2, scaleForm);
			cursor.visible = false;
			
			//FIXME: See if we can't find a way to hide the chatwindow's functions in itself.
			//The idea would be to accept the Unrealscript call in the main, but then divert its tasks 
			//up the chain through a simple one-line method call with some params.
			/*
			chatWindow = new ChatWindow("chatWindow", TAB_SIZE, leftSide, stage);
			chatWindow.x = TAB_SIZE/2;
			chatWindow.y = stage.stageHeight - chatWindow.height - TAB_SIZE/2;
			chatWindow.visible = false;
			windows[CHAT] = chatWindow;
			*/
			sureWindow = new SureWindow("sureWindow", TAB_SIZE, leftSide, stage);
			sureWindow.x = 0;//stage.stageWidth/2 - sureWindow.width/2;
			sureWindow.y = 0;//stage.stageHeight/2 - sureWindow.height/2;
			sureWindow.visible = false;
			windows[SURE] = sureWindow;
			/*
			var testButton:Sprite = new Sprite();
			testButton.graphics.beginFill(0x000000, 0.8);
			testButton.graphics.drawRect(0, 0, 300, 100); 
			testButton.graphics.endFill();
			testButton.x = stage.stageWidth/2;
			testButton.y = stage.stageHeight/2;
			testButton.addEventListener(MouseEvent.CLICK, testMessage);
			addChild(testButton);			
			*/
			//Call init 
			init();
		}
		
		//Init Adds resources to stage and sets up initial event listeners
		private function init():void {
			//Hide the mouse in flash. Not strictly necessary, but nice for testing.
			Mouse.hide();
			
			//This lets fonts get loaded
			//stage.focus = this;
			
			//Add our children now that they have been loaded in
			addChild(myMenu);
			//addChild(chatWindow);
			addChild(sureWindow);
			addChild(cursor);
			
			//If we are not in scaleform we want hotkeys to do certain things, otherwise
			//turn them off 
			if(!scaleForm) {
				stage.addEventListener(KeyboardEvent.KEY_UP, reportKeyUp);
			}
			
			//FIXME: These variable names are artrocious, lets get some real code in here before someone sees this tripe
			//var tc:Function = tabClick(AVATARS);
			//myMenu.tabs[TAB_NUM[AVATARS]].addEventListener(MouseEvent.CLICK, tc);
			//var tg:Function = tabClick(CHAT);
			//myMenu.tabs[TAB_NUM[CHAT]].addEventListener(MouseEvent.CLICK, tg);
			//FIXME: MAYBE: Finding an object in a hash twice could be memory intensive. Saving it could save time.
			setUpGhostButton();
			//setUpChatPanel();
			myMenu.tabs[TAB_NUM[CLOSE]].addEventListener(MouseEvent.CLICK, close);
			//open();
			
			//This actually isn't very descriptive, we might want to figure out a better way to do this
			addEventListener(Event.ENTER_FRAME, onLevelLoaded);
			//FIXME: Have the cursor class do this instead.
			addEventListener(Event.ENTER_FRAME, onLoop);
			
			//set up toggle captureinput for the chatinput. We might be bale to do this in the chat window, 
			//FIXME: Put this in the chat window if at all possible, let's clean out this main file
			myMenu.panels[CHAT].chatInput.addEventListener(MouseEvent.MOUSE_UP, toggleChat);
			myMenu.panels[CHAT].chatInput.addEventListener(MouseEvent.MOUSE_OUT, enableToggleChatClickListener);
			myMenu.panels[CHAT].chatInput.addEventListener(MouseEvent.MOUSE_OVER, disableToggleChatClickListener);
						
			//If we are in a testing env, put some dummy variables in to test how US will do things
			if(!scaleForm) {
				simulateUnrealScriptPolls();
			} else {
				ExternalInterface.call("asReceiveData");
			}
		}
		
		//This is some duct tape used, because the video disapears if we don't do stuff with it.
		public function onLevelLoaded(e:Event):void {
			myMenu.x = stage.stageWidth-TAB_SIZE*.75;
			myMenu.openX = (stage.stageWidth - myMenu.myWidth);
			myMenu.y = 0;
			myMenu.closeX = myMenu.x;
			myMenu.moveX = myMenu.closeX;
			if(myMenu.frameCounter > 15) {
				removeEventListener(Event.ENTER_FRAME, onLevelLoaded);
				myMenu.visible = true;
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
		
		//Called by init to set up the ghost buttons. this happens once when the video loads
		//and is a static panel
		public function setUpGhostButton() {
			var iconButton:IconButton = new IconButton("ghost", TAB_SIZE*2);
			iconButton.x = myMenu.myWidth/2 - iconButton.myWidth/2 - myMenu.panels[GHOST].labelContainer.x;//TAB_SIZE;
			iconButton.y = myMenu.panels[GHOST].nextY;
			iconButton.openY = iconButton.y;
			iconButton.addEventListener(MouseEvent.CLICK, ghostMode);
			iconButton.icon.loadOtherImage("human", scaleForm, false);
			//FIXME: This whole other image crap has to go. We need a solid way to toggle icons. Like a togglable icon class or something.
			iconButton.icon.other_image.visible = false;
			//FIXME: let's save this var for more readable code and so we don't access a hash multiple times
			myMenu.panels[GHOST].nextY = iconButton.y + iconButton.myHeight + TAB_SIZE/4;
			myMenu.panels[GHOST].myHeight += iconButton.myHeight + TAB_SIZE/4;//TAB_SIZE*5/4;
			myMenu.panels[GHOST].closeY -= iconButton.myHeight + TAB_SIZE/4;
			myMenu.panels[GHOST].y -= iconButton.myHeight + TAB_SIZE/4;
			myMenu.panels[GHOST].labels[GHOST] = iconButton;
			myMenu.panels[GHOST].labelContainer.addChild(iconButton);			
			myMenu.panels[GHOST].mask.height += iconButton.height;//= myMenu.panels[GHOST].labelContainer.height-TAB_SIZE;			
		}
		
		//Called by init to set up the ghost buttons. this happens once when the video loads
		//and is a static panel
		//FIXME: This and setUpGhostButton should be merged to be more DRY
		public function setUpChatButton() {
			var iconButton:IconButton = new IconButton("chat", TAB_SIZE*2);
			iconButton.x = myMenu.myWidth/2 - iconButton.myWidth/2 - myMenu.panels[GHOST].labelContainer.x;//TAB_SIZE;
			iconButton.y = myMenu.panels[CHAT].nextY;
			iconButton.openY = iconButton.y;
			var tg:Function = tabClick(CHAT);
			iconButton.addEventListener(MouseEvent.CLICK, tg);
			//FIXME: let's save this var for more readable code and so we don't access a hash multiple times
			myMenu.panels[CHAT].nextY = iconButton.y + iconButton.myHeight + TAB_SIZE/4;
			myMenu.panels[CHAT].myHeight += iconButton.myHeight + TAB_SIZE/4;//TAB_SIZE*5/4;
			myMenu.panels[CHAT].closeY -= iconButton.myHeight + TAB_SIZE/4;
			myMenu.panels[CHAT].y -= iconButton.myHeight + TAB_SIZE/4;
			myMenu.panels[CHAT].labels[CHAT] = iconButton;
			myMenu.panels[CHAT].labelContainer.addChild(iconButton);
			myMenu.panels[CHAT].mask.height += iconButton.height;//= myMenu.panels[GHOST].labelContainer.height-TAB_SIZE;			
		}
	
		//Become a Human! and update the Tab. Send a call to US to tell it do it.
		public function humanMode(external:Boolean = true):void {
			if(playerState != HUMAN_MODE) {
				playerState = HUMAN_MODE;

				//FIXME: let's save this var for more readable code and so we don't access a hash multiple times
				myMenu.panels[GHOST].labels[GHOST].removeEventListener(MouseEvent.CLICK, humanMode);
				myMenu.panels[GHOST].labels[GHOST].addEventListener(MouseEvent.CLICK, ghostMode);
				myMenu.panels[GHOST].labels[GHOST].icon.other_image.visible = false;
				myMenu.panels[GHOST].labels[GHOST].icon.image.visible = true;
				if(external) {
					ExternalInterface.call("asReceiveBecomeHuman");
				}
			}
		}
		
		//Become a ghost! This isn't that DRY. To follow this code look above.
		public function ghostMode(external:Boolean = true):void {
			if(playerState != GHOST_MODE) {
				playerState = GHOST_MODE;

				//FIXME: let's save this var for more readable code and so we don't access a hash multiple times
				myMenu.panels[GHOST].labels[GHOST].removeEventListener(MouseEvent.CLICK, ghostMode);
				myMenu.panels[GHOST].labels[GHOST].addEventListener(MouseEvent.CLICK, humanMode);
				myMenu.panels[GHOST].labels[GHOST].icon.other_image.visible = true;
				myMenu.panels[GHOST].labels[GHOST].icon.image.visible = false;
				ExternalInterface.call("asReceiveBecomeGhost");
			}
		}
		
		//this is for toggleable tabs.
		//FIXME: this will go away. Everything will be a panel in the future. It is more consisitent
		private function tabClick(tabName:String):Function {
			//Return a dynamic way to hide a window in a hash
			return function(e:MouseEvent):void {
				windows[tabName].visible = !windows[tabName].visible;
			};
		}
		
		public function chatBeginTalk():void {
			if(tabNames[0].name != myMenu.currentPanel) {
				showTab(1);//windows[CHAT].visible = !windows[CHAT].visible;
			}
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = TAB_SIZE*.30;
			myFormat.font = "Arial";
			var myFont = new Arial();
			myFormat.font = myFont.fontName;
			myMenu.panels[CHAT].chatInput.setTextFormat(myFormat); 
			myMenu.panels[CHAT].chatInput.embedFonts = true;
			stage.addEventListener(KeyboardEvent.KEY_UP, changeFocus);
			myMenu.panels[CHAT].chatInput.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		public function changeFocus(e:KeyboardEvent= null):void {
			stage.focus = myMenu.panels[CHAT].chatInput;
			stage.removeEventListener(KeyboardEvent.KEY_UP, changeFocus);
			ExternalInterface.call("asReceiveToggleChatTrue");
		}
		
		//FIXME: This needs to be taken out completely eventually
		public function addJulius(e:MouseEvent = null):void {
			var onClick:Function = onButtonSend(US_KICK_PLAYER);
			myMenu.addToList("251", "Julius 251", KICK, "kick", onClick);
			myMenu.addToList("252", "Julius 252", KICK, "kick", onClick);
		}
		
		//FIXME: This needs to be taken out completely eventually
		public function deleteJulius(e:MouseEvent = null):void {
			myMenu.deleteFromList("Boop", "Boop", KICK);
			//myMenu.deleteFromList("Julius 252", KICK);
		}
		
		//This is primarily for debugging when not in UDK
		private	function reportKeyUp(event:KeyboardEvent):void { 
			trace("Key Pressed: " + String.fromCharCode(event.charCode) + " (character code: " + event.charCode + ")"); 
			if (event.charCode == 111/*o*/) open(); 
			else if (event.charCode == 99/*c*/) close(); 
			else if (event.charCode == 116/*t*/) chatBeginTalk(); 
			else if (event.charCode == 49/*1*/) showTab(1);
			else if (event.charCode == 51/*3*/) showTab(3);
			else if (event.charCode == 50/*2*/) showTab(2);
			else if (event.charCode == 52/*4*/) showTab(4);
			else if (event.charCode == 53/*5*/) showTab(5);
			else if (event.charCode == 54/*6*/) showTab(6);
			else if (event.charCode == 55/*7*/) showTab(7);
			else if (event.charCode == 56/*8*/) showTab(8);
			else if (event.charCode == 57/*9*/) showTab(9);
		}
		
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
			//myMenu.animateOut(myMenu.currentPanel);
			myMenu.tabs[TAB_NUM[myMenu.currentPanel]].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		//Unrealscript asks this to see if the menu is open or not.
		public function isOpen():int {
			if (myMenu.moveX == myMenu.openX) {
				//open
				return 1;
			} else {
				//closed
				return 0;
			}
		}
		
		//Unrealscript asks this to see if the chatpanel is open or not.
		public function isChatWindowOpen():int {
			if (stage.focus == myMenu.panels[CHAT].chatInput) {
				//open
				return 1;
			} else {
				//closed
				return 0;
			}
		}
		
		//This shows a tab based on a number
		public function showTab(option:int):void {
			//Create an enum to arbitrarily store the Tabular position. In this case order matters
			//This will allow us to change the order of the Tabs on the fly without us having
			// to modify other code
			//an index, so decrement;
			option--;
			//if(!isOpen() && !windows.hasOwnProperty([tabNames[option].name])) {
			/*
			for (var key:String in windows){
   				//This says
   					//if closed AND the key is not a window
   				if( !isOpen() && !(key == tabNames[option].name) ) {
					open();
				} else {

				}
			}*/
			/*	
			*/
			if(!isOpen()) {
				open();
				myMenu.tabs[option].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			} else {
				if(tabNames[option].name == myMenu.currentPanel) {
					close();
				} else {
					myMenu.tabs[option].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}				
			}
			//spoof a click
		}
		
		//This handles opening the myMenu frame by frame, until is it done 
		//This is arbitrary X movement, but could allow for any type of movement or easing.
		public function onEase(e:Event):void {
			//utrace(myMenu.frameCounter + " -- " + (myMenu.openX - myMenu.x) * myMenu.easing);
			//utrace("myX is now: " + myMenu.x);
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
			var playerID:int = 251;//s:Array = new Array(251, 252, 253, 254, 255);
			var playerNames:Array = new Array("Me");//, "Boop", "Pompey", "Cicero", "Publius");
			for each (var playerName:String in playerNames) {
				addMe(playerID, playerName+" "+playerID);
				playerID++;
			}
			
			onClick = onButtonSend(US_POSSESS_NPC);
			var NPCNames:Array = new Array("Kirk", "Spock", "McCoy", "Chapel", "Scotty", "Sulu", "Chekov", "Uhura", "Red Shirt", "Khan", "Evil Spock", "Computer", "Hadley", "Brent", "Q", "Picard", "Riker", "Deanna", "Data");
			//CreateAvatarChoiceDisplay(NPCNames);
			for each (var NPCName:String in NPCNames) {
				myMenu.addToList(NPCName, NPCName, POSSESS, "posses", onClick);
			}
			
			onClick = onButtonSendToggle(US_TOGGLE_SCENARIO);
			var scenarioNames:Array = new Array("BasketBall", "Coffee Shop");
			for each (var ScenarioName:String in scenarioNames) {
				myMenu.addToList(ScenarioName, ScenarioName, SCENARIO, "start", onClick);
			}
			getTextMessage("me", "Hello", true);
			getTextMessage("you", "World", false);
			receiveToggleScenarioButton("BasketBall", "stop");
			changePlayerFaces(251, true);
			//changePlayerFaces(254, "Cicero ", false);
			//changePlayerFaces(255, "Publius", true);
			//changePlayerFaces(255, "Publius", false);
			//changePlayerFaces(255, "Pompey", true);
			changeNameOfPlayer(0, "player1");
			changeNameOfPlayer(252, "changed_once");
			changeNameOfPlayer(252, "changed_twice");
			changeNameOfPlayer(252, "changed_thrice");
			//removePlayer(253, "Cicero");
			//removePlayer(251, "Boop");
			//changeNameOfPlayer(252, "changed_1");
			//removePlayer(254, "Publius");
			//removePlayer(250, "Nope");
			//changeNameOfPlayer(252, "changed_1");
			//changeNameOfPlayer(253, "changed_2");
			//changeNameOfPlayer(252, "changed_love");
			//changeNameOfPlayer(252, "changed_love_to_wrong");
			//changeNameOfPlayer(256, "changed_new_insert");
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
			var chatPanel:ChatPanel = myMenu.panels[CHAT];
			//get the current length
			var oldLength = chatPanel.chatLog.length;
			//Update flash textfield. We might override this later
			chatPanel.chatLog.appendText( "\n\n" + playerName + ":\n\t" + textMessage );
			//FIXME: Reimplement this
			/*
				alertPlayer(playerName);
			*/
			if(!isOpen() && !bIsMe) {
				var alertLabel:AlertLabel = new AlertLabel("You received a message", ("From: " + playerName), TAB_SIZE);
				myMenu.addChild(alertLabel);
				alertLabel.intro(0, TAB_SIZE*2);
			}
			
			//get the new length
			var newLength = chatPanel.chatLog.length;
			
			//Format just the newest added section
			chatPanel.chatLog.setTextFormat(myFormat, oldLength, newLength);
			
			//Update textfield to always scroll to bottom
			chatPanel.chatLog.scrollV = chatPanel.chatLog.maxScrollV;
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
			myMenu.panels[CHAT].chatInput.removeEventListener(MouseEvent.MOUSE_UP, toggleChat);
			utrace("dissallow input");
			ExternalInterface.call("asReceiveToggleChatTrue");
		}
		
		//FIXME: hide this crud in the Chat window
		//this is needed for the toggling feature
		public function clickToggleChatListener(e:MouseEvent = null) {
			utrace("allow input, capture esc");
			if(e != null) {
				myMenu.panels[CHAT].chatInput.addEventListener(MouseEvent.MOUSE_UP, toggleChat);
			}
			stage.focus = stage;
			ExternalInterface.call("asReceiveToggleChatFalse");
		}
								
		//Start Player Stuff
		//This function is only ever called by UnrealScript
		//It adds a player to the list of players
		public function addPlayer(playerID:int, playerName:String):void {
			trace("AddingPlayer Start");
			if( (playerID != 0) ) {
				var onClick:Function = onSureClick(US_KICK_PLAYER);//onButtonSend(US_KICK_PLAYER);
				myMenu.addToList( (""+playerID), (playerName + " " + playerID), KICK, "kick", onClick);
			}
			trace("AddingPlayer End");
		}
		
		//This function is only ever called by UnrealScript
		//It removes a player from the list of players
		public function removePlayer(playerID:int, playerName:String):void {
			trace("RemovingPlayer Start");
			myMenu.deleteFromList( playerID.toString(), (playerName + " " + playerID), KICK);
			trace("RemovingPlayer End");
		}
		
		public function addMe(playerID:int, playerName:String):void {
			trace("AddingPlayer Start");
			if( (playerID != 0) ) {
				myMenu.addToList( (""+playerID), (playerName + " " + playerID), KICK, "", null);
			}
			trace("AddingPlayer End");
		}
		
		//This function is only ever called by UnrealScript
		//It removes a player from the list of players
		public function changeNameOfPlayer(playerID:int, playerName:String):void {
			utrace("ChangingPlayer Start");
			var playerThere:Boolean = myMenu.isInList( (""+playerID), (playerName + " " + playerID), KICK);
			if(!playerThere) {
				addPlayer(playerID, playerName);
			} else {
				removePlayer(playerID, playerName + " " + playerID);
				addPlayer(playerID, playerName);
			}
			utrace("ChangingPlayer End");
		}
		//End Player Stuff
		
		//Start NPC stuff
		//This function is only ever called by UnrealScript
		//It adds an NPC to the possession menu
		//FIXME: Fix the unrealscript that updates NPCs based on if new NPCS spawn or die
		public function addNPC(npcName:String):void {
			utrace("AddingNPC Start");
			var onClick:Function = onButtonSend(US_POSSESS_NPC);
			myMenu.addToList( (npcName), (npcName), POSSESS, "possess", onClick);
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
			myMenu.addToList( scenarioName, (scenarioName), SCENARIO, "start", onClick);
			utrace("AddingScenario End");
		}
		//This is only ever called by unrealscript.
		//this changes the text of Scenario buttons to match their in-game state as they change
		public function receiveToggleScenarioButton(scenarioName:String, startOrStop:String):void {
			myMenu.panels[SCENARIO].labels[scenarioName].button.text.text = startOrStop;
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
		
		//this is a generic function that sends info to US
		public function onSureClick(functionName:String):Function {
			return function(e:MouseEvent):void {
				var button:TextButton = TextButton(e.currentTarget);
				var label:String = button.context;//label;
				var action:String = button.text.text;//action
				var onClick:Function = onButtonSend(functionName);
				sureWindow.show(onClick, label, action);
			}
		}		
		
		public function CreateAvatarChoiceDisplay(avatarImageStrings:Array) {
			var i:int = 0;
			var j:int = 0;
			for each (var img in avatarImageStrings) {
				trace( i + "," + j);
				if (i >= 5) {
					i = 0;
					j++;
				}
			
				var avatarImage:AvatarImage = new AvatarImage("", TAB_SIZE, (j*5+i));
				avatarImage.loadAvatarImage(img);
				avatarImage.x = i*(TAB_SIZE*3+(TAB_SIZE/4));
				avatarImage.y = j*(TAB_SIZE*3+(TAB_SIZE/4));
				myMenu.panels[AVATARS].labelContainer.addChild(avatarImage);
				i++;
			}
			j++;
			
			var bg:UIElement = new UIElement();
			bg.color = 0x000000;
			bg.alpha = 0.0;
			bg.x = 0;
			bg.y = 0;
			bg.myWidth = myMenu.panels[AVATARS].myWidth; 
			bg.myHeight = j*(TAB_SIZE*3+(TAB_SIZE/4));
			trace(bg.myWidth + "," + bg.myHeight);
			bg.draw();
			//myMenu.panels[AVATARS].bg = bg;
			myMenu.panels[AVATARS].labelContainer.addChildAt(bg, 0);
		}
		
		public function changePlayerFaces(playerID:int, faceshiftIsTracking:Boolean) {
			utrace("Changing Player Face");
			var playerIDString:String = ""+playerID;
			for (var key:String in myMenu.panels[KICK].labels) {
				if(key == playerIDString) {
					utrace("Player found");
					if(myMenu.panels[KICK].labels[playerIDString].icon == null) {
						utrace("Icon created");
						myMenu.panels[KICK].labels[playerIDString].icon = new Icon("smileFace", TAB_SIZE, scaleForm);
						myMenu.panels[KICK].labels[playerIDString].icon.x = TAB_SIZE*4;
						myMenu.panels[KICK].labels[playerIDString].icon.y = TAB_SIZE*.25;
						myMenu.panels[KICK].labels[playerIDString].icon.loadOtherImage("frownFace", scaleForm);
						myMenu.panels[KICK].labels[playerIDString].addChild(myMenu.panels[KICK].labels[playerIDString].icon);
					}
					myMenu.panels[KICK].labels[playerIDString].icon.other_image.visible = !faceshiftIsTracking;
					myMenu.panels[KICK].labels[playerIDString].icon.image.visible = faceshiftIsTracking;
					utrace("Icon toggled");
				}
			}
			utrace("Changing Player FaceEnd");
		}
		
		public function showPauseMenu(e:MouseEvent): void {
			ExternalInterface.call("AsReceiveShowPauseMenu");
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