﻿package {
	
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
	import com.vrl.buttons.IconButton;
	import com.vrl.utils.Cursor;
	import com.vrl.utils.*;
	import com.vrl.TabInfo;	
	
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
		var scaleForm:Boolean = false;
		
		//Consts
		//This number actually controls the entire size of the menu.
		//It is the measure in pixels of the tab width/height
		var TAB_SIZE:Number = 48;
		
		//FIXME: We could have this designated through a config file at some point
		var CHAT:String = "Chat";
		var GHOST:String = "Ghost";
		var AVATARS:String = "Avatars";
		var POSSESS:String = "Possess";
		var KICK:String = "Kick";
		var SCENARIO:String = "Scenario";
		var EXIT:String = "Exit";
		
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
		var chatWindow:ChatWindow;
		var avatarWindow:AvatarWindow;
		
		var windows:Array = new Array();
		var cursor:Cursor;	
		var playerState:int = HUMAN_MODE;
		
		//Tabs
		var tabNames:Array = new Array(
			new TabInfo(CHAT, 		CHAT,			!peek,	!accordian,	scaleForm, leftSide),
			new TabInfo(GHOST, 		"Ghost Menu",	!peek,	accordian,	scaleForm, leftSide),
			new TabInfo(AVATARS, 	AVATARS,		peek,	!accordian,	scaleForm, leftSide),
			new TabInfo(POSSESS, 	"NPCs",			!peek,	accordian, 	scaleForm, leftSide),
			new TabInfo(KICK, 		"Players",		!peek,	accordian, 	scaleForm, leftSide),
			new TabInfo(SCENARIO, 	"Scenarios",	!peek,	accordian, 	scaleForm, leftSide),
			new TabInfo(EXIT,	 	EXIT,			!peek,	!accordian,	scaleForm, !leftSide)
		);
		
		//Main initializes objects and gives them values
		public function Main() {
			//Create an enum to arbitrarily store the Tabular position. In this case order matters
			//This will allow us to change the order of the Tabs on the fly without us having
			// to modify other code
			for (var i:int = 0; i < tabNames.length; i++) {
				TAB_NUM[tabNames[i].name] = i;
			}
			
			//Get menu width
			var myWidth:int = TAB_SIZE*5;//getMaxTextWidth(tabNames) + TAB_SIZE*2;
			
			//Create a menu with Tabs
			myMenu = new Menu((myWidth), stage.stageHeight, tabNames, TAB_SIZE, leftSide, stage);
			
			//Create a Cursor and hide it
			cursor = new Cursor("Cursor", TAB_SIZE*2, scaleForm);
			cursor.visible = false;
						
			//FIXME: See if we can't find a way to hide the chatwindow's functions in itself.
			//The idea would be to accept the Unrealscript call in the main, but then divert its tasks 
			//up the chain through a simple one-line method call with some params.
			chatWindow = new ChatWindow("chatWindow", TAB_SIZE, leftSide, stage);
			chatWindow.x = TAB_SIZE/2;
			chatWindow.y = stage.stageHeight - chatWindow.height - TAB_SIZE/2;
			chatWindow.visible = false;
			windows[CHAT] = chatWindow;
						
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
			addChild(cursor);
			
			//If we are not in scaleform we want hotkeys to do certain things, otherwise
			//turn them off 
			if(!scaleForm) {
				stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
			}
			
			//FIXME: These variable names are artrocious, lets get some real code in here before someone sees this tripe
			//var tc:Function = tabClick(AVATARS);
			//myMenu.tabs[TAB_NUM[AVATARS]].addEventListener(MouseEvent.CLICK, tc);
			var tg:Function = tabClick(CHAT);
			myMenu.tabs[TAB_NUM[CHAT]].addEventListener(MouseEvent.CLICK, tg);
			//FIXME: MAYBE: Finding an object in a hash twice could be memory intensive. Saving it could save time.
			setUpGhostButton();
			myMenu.tabs[TAB_NUM[EXIT]].addEventListener(MouseEvent.CLICK, showPauseMenu);
			//open();
			
			//This actually isn't very descriptive, we might want to figure out a better way to do this
			addEventListener(Event.ENTER_FRAME, onLevelLoaded);
			//FIXME: Have the cursor class do this instead.
			addEventListener(Event.ENTER_FRAME, onLoop);
						
			//set up toggle captureinput for the chatinput. We might be bale to do this in the chat window, 
			//FIXME: Put this in the chat window if at all possible, let's clean out this main file
			chatWindow.chatInput.addEventListener(MouseEvent.MOUSE_UP, toggleChat);
			chatWindow.chatInput.addEventListener(MouseEvent.MOUSE_OUT, enableToggleChatClickListener);
			chatWindow.chatInput.addEventListener(MouseEvent.MOUSE_OVER, disableToggleChatClickListener);
			
			//If we are in a testing env, put some dummy variables in to test how US will do things
			if(!scaleForm) {
				simulateUnrealScriptPolls();
			}
		}
				
		//This is some duct tape used, because the video disapears if we don't do stuff with it.
		public function onLevelLoaded(e:Event):void {
			myMenu.x = stage.stageWidth;//-TAB_SIZE*.75;
			myMenu.openX = stage.stageWidth - myMenu.myWidth;
			myMenu.y = 0;
			myMenu.closeX = myMenu.x;
			myMenu.moveX = myMenu.closeX;
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
			myMenu.panels[GHOST].labelContainer.addChild(iconButton);
			myMenu.panels[GHOST].mask.height += iconButton.height;//= myMenu.panels[GHOST].labelContainer.height-TAB_SIZE;			
		}
		
		//Become a Human! and update the Tab. Send a call to US to tell it do it.
		public function humanMode(external:Boolean = true):void {
			//This isn't really used yet. We might use it. Lets see if we ever need to poll for this.
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
		
		//Become a ghost! This isn't that DRY. To follow this code look above.
		public function ghostMode(external:Boolean = true):void {
			playerState = GHOST_MODE;

			//FIXME: let's save this var for more readable code and so we don't access a hash multiple times
			myMenu.panels[GHOST].labels[GHOST].removeEventListener(MouseEvent.CLICK, ghostMode);
			myMenu.panels[GHOST].labels[GHOST].addEventListener(MouseEvent.CLICK, humanMode);
			myMenu.panels[GHOST].labels[GHOST].icon.other_image.visible = true;
			myMenu.panels[GHOST].labels[GHOST].icon.image.visible = false;
			ExternalInterface.call("asReceiveBecomeGhost");
		}
				
		//this is for toggleable tabs.
		//FIXME: this will go away. Everything will be a panel in the future. It is more consisitent
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
		
		//This is primarily for debugging when not in UDK
		private	function reportKeyDown(event:KeyboardEvent):void { 
			trace("Key Pressed: " + String.fromCharCode(event.charCode) + " (character code: " + event.charCode + ")"); 
			if (event.charCode == 111/*o*/) open(); 
			else if (event.charCode == 99/*c*/) close(); 
			else if (event.charCode == 49/*1*/) showTab(1);
			else if (event.charCode == 50/*2*/) showTab(2);
			else if (event.charCode == 51/*3*/) showTab(3);
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
			myMenu.animateOut(myMenu.currentPanel);
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
		
		//This shows a tab based on a number
		public function showTab(option:int) {
			//Create an enum to arbitrarily store the Tabular position. In this case order matters
			//This will allow us to change the order of the Tabs on the fly without us having
			// to modify other code
			//an index, so decrement;
			option--;
			if(!isOpen() && !windows.hasOwnProperty([tabNames[option].name])) {
				open();
			}
			//spoof a click
			myMenu.tabs[option].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
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
			var playerNames:Array = new Array("Nope", "Boop", "Pompey253", "Cicero 254", "Publius255");
			//CreateAvatarChoiceDisplay(playerNames);
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
			changePlayerFaces("Pompey", 253, true);
			changePlayerFaces("Cicero ", 254, false);
			changePlayerFaces("Publius", 255, true);
			changePlayerFaces("Publius", 255, false);
			changePlayerFaces("Pompey", 255, true);
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
		public function addPlayer(playerID:int, playerName:String, faceshiftIsTracking:Boolean):void {
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
		
		
		public function CreateAvatarChoiceDisplay(avatarImageStrings:Array) {
			var i:int = 0;
			var j:int = 0;
			for each (var img in avatarImageStrings) {
				
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
			myMenu.panels[AVATARS].bg = myMenu.panels[AVATARS].labelContainer.height;
		}
		
		public function changePlayerFaces(playerName:String, playerID:int, faceshiftIsTracking:Boolean) {
			utrace("Changing Player Face");
			if(myMenu.panels[KICK].labels.hasOwnProperty(playerName + playerID)) {
				utrace("Player found");
				if(myMenu.panels[KICK].labels[playerName + playerID].sureButton.icon == null) {
					utrace("Icon created");
					myMenu.panels[KICK].labels[playerName + playerID].sureButton.icon = new Icon("smileFace", TAB_SIZE, scaleForm);
					myMenu.panels[KICK].labels[playerName + playerID].sureButton.icon.x = -TAB_SIZE;
					myMenu.panels[KICK].labels[playerName + playerID].sureButton.icon.loadOtherImage("frownFace", scaleForm);
					myMenu.panels[KICK].labels[playerName + playerID].sureButton.addChild(myMenu.panels[KICK].labels[playerName + playerID].sureButton.icon);
				}
				myMenu.panels[KICK].labels[playerName + playerID].sureButton.icon.other_image.visible = faceshiftIsTracking;
				myMenu.panels[KICK].labels[playerName + playerID].sureButton.icon.image.visible = !faceshiftIsTracking;
				utrace("Icon toggled");
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