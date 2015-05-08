package {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.external.ExternalInterface;
	import flash.ui.Mouse;

	import com.vrl.UIElement;
	import com.vrl.TabInfo;	
	import com.vrl.windows.Window;
	import com.vrl.windows.PauseWindow;
	import com.vrl.utils.Cursor;
	
	/////////////////////
	// PauseMenu Class //
	/////////////////////
	/**
	* The PauseMenu class is also known as the Document class and the root path.
	* All unrelascript calls must be routed through this file, so it can get
	* a little bloated. We will try to designate as much responsibility to 
	* component classes, but this class will usually still be large.	
	*/	
	public class PauseMenu extends Sprite {
		
		//set to true if you want debug output
		var debug:Boolean = false;
		//set to true if pushing live to scaleform, false if testing in the launcher
		var scaleForm:Boolean = true;
		
		var RESUME:String = "gamePad";
		var EXIT:String = "Exit";
		var VIRTUAL_GEMINI:String = "VIRTUAL GEMINI";

		//Consts
		//This number actually controls the entire size of the menu.
		//It is the measure in pixels of the tab width/height
		var TAB_SIZE:Number = 48;
		var pauseWindow:PauseWindow;
		var cursor:Cursor;	

		var TAB_NUM:Object = new Object();

		//Tabs
		var keys:Array = [];
		var tabNames:Array = new Array(
			new TabInfo(RESUME,	"Resume",	false,	false,	scaleForm, false),
			new TabInfo(EXIT,	EXIT,	false,	false,	scaleForm, false)
		);

		var currentTabNum:int;
		var noMouseMode:Boolean = false;
		
		//FIXME: We could have this designated through a config file at some point
		public function PauseMenu() {
			//Font.registerFont("Arial");
			//Create an enum to arbitrarily store the Tabular position. In this case order matters
			//This will allow us to change the order of the Tabs on the fly without us having
			// to modify other code
			for (var i:int = 0; i < tabNames.length; i++) {
				TAB_NUM[tabNames[i].name] = i;
			}						
			
			//Create a Cursor and hide it
			cursor = new Cursor("Cursor", TAB_SIZE*2, scaleForm);
			cursor.visible = false;
			
			//FIXME: See if we can't find a way to hide the chatwindow's functions in itself.
			//The idea would be to accept the Unrealscript call in the main, but then divert its tasks 
			//up the chain through a simple one-line method call with some params.
			pauseWindow = new PauseWindow(VIRTUAL_GEMINI, TAB_SIZE, tabNames, false, stage);
			pauseWindow.x = stage.stageWidth/2 - pauseWindow.width/2;
			pauseWindow.y = stage.stageHeight/2 - pauseWindow.height/2;
			pauseWindow.visible = true;
			currentTabNum = pauseWindow.tabs.length-1; 
			//Call init
			init();
		}
		
		//Init Adds resources to stage and sets up initial event listeners
		private function init():void {
			//Hide the mouse in flash. Not strictly necessary, but nice for testing.
			Mouse.hide();
			
			//This lets fonts get loaded
			stage.tabChildren = false;
			//stage.focus = this;
			
			//Add our children now that they have been loaded in
			addChild(pauseWindow);
			addChild(cursor);
			
			//If we are not in scaleform we want hotkeys to do certain things, otherwise
			//turn them off 
			if(!scaleForm) {
			//	stage.addEventListener(KeyboardEvent.KEY_UP, reportKeyUp);
			}
						
			pauseWindow.tabs[TAB_NUM[RESUME]].addEventListener(MouseEvent.CLICK, close);
			pauseWindow.tabs[TAB_NUM[EXIT]].addEventListener(MouseEvent.CLICK, exit);
			addEventListener(Event.ENTER_FRAME, update);
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown1);
			stage.addEventListener(KeyboardEvent.KEY_UP, onUp);
			//open();
						
			//FIXME: Have the cursor class do this instead.
			addEventListener(Event.ENTER_FRAME, onLoop);
												
			//If we are in a testing env, put some dummy variables in to test how US will do things
			if(!scaleForm) {
			
			} else {
				//ExternalInterface.call("asReceiveData");
			}
		}

		//This is a function to be called by unrealscript in order to close the myMenu
		public function close(e:MouseEvent = null):void {
			trace("close");
			ExternalInterface.call("ASSendPlayCloseAnimation");		
		}

		public function receiveClose():void {
			pauseWindow.outtro();
			//pauseWindow.visible = false;
			cursor.visible = false;
			noMouseMode = false;
			currentTabNum = pauseWindow.tabs.length-1; 
			for (var i:int = 0; i < pauseWindow.tabs.length; i++) {
				pauseWindow.tabs[i].dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
			}
		}

		//This is a function to be called by unrealscript in order to close the myMenu
		public function open(e:MouseEvent = null):void {
			pauseWindow.visible = true;
			cursor.visible = true;
			pauseWindow.intro();
		}

		//This is a function to be called by unrealscript in order to close the myMenu
		public function exit(e:MouseEvent = null):void {
			close();
			trace("exit");
			ExternalInterface.call("ASReceiveExit");
		}

		//Move the cursor around each frame.		
		private function onLoop (evt:Event):void {
			cursor.y = mouseY;
			cursor.x = mouseX;
		}

		private function update(e:Event):void {		
			if(keys[Keyboard.UP]) {
				trace(currentTabNum);
				pauseWindow.tabs[currentTabNum].dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
				currentTabNum--;
				if (currentTabNum < 0) {
					currentTabNum = pauseWindow.tabs.length-1;
				}
				pauseWindow.tabs[currentTabNum].dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
				keys=[];
				noMouseMode = true;
			}
			if(keys[Keyboard.DOWN]) {
				trace(currentTabNum);
				pauseWindow.tabs[currentTabNum].dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
				currentTabNum++;
				if (currentTabNum == pauseWindow.tabs.length) {
					currentTabNum = 0;
				}
				pauseWindow.tabs[currentTabNum].dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));				
				keys=[];
				noMouseMode = true;
			}
		}		
		 
		private function onUp(event:KeyboardEvent):void {
			keys[event.keyCode] = true;
			trace("Key Pressed: " + String.fromCharCode(event.charCode) + " (character code: " + event.charCode + ")"); 
			trace("Key Pressed: (key code: " + event.keyCode + ")"); 
			if (event.charCode == 111/*o*/) open(); 
			else if (event.charCode == 99/*c*/) close();
			else if (event.keyCode == 13 && noMouseMode) pauseWindow.tabs[currentTabNum].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}		
	}
}