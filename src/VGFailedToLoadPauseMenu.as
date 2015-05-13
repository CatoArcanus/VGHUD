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
	public class VGFailedToLoadPauseMenu extends Sprite {
		
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
			new TabInfo(RESUME,	"Virtual Gemini has disconnected.",	false,	false,	scaleForm, false),
			new TabInfo(EXIT,	"Press any key to exit...", 		false,	false,	scaleForm, false)
		);
				
		//FIXME: We could have this designated through a config file at some point
		public function VGFailedToLoadPauseMenu() {
			for (var i:int = 0; i < tabNames.length; i++) {
				TAB_NUM[tabNames[i].name] = i;
			}						
			
			pauseWindow = new PauseWindow(VIRTUAL_GEMINI, TAB_SIZE, tabNames, false, stage);
			pauseWindow.x = stage.stageWidth/2 - pauseWindow.width/2;
			pauseWindow.y = stage.stageHeight/2 - pauseWindow.height/2;
			pauseWindow.visible = true;
		
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
			stage.addEventListener(KeyboardEvent.KEY_UP, onUp);
		
		}

		//This is a function to be called by unrealscript in order to close the myMenu
		public function exit(e:MouseEvent = null):void {
			ExternalInterface.call("ASReceiveExit");
		}

		private function onUp(event:KeyboardEvent):void {
			keys[event.keyCode] = true;
			exit();
		}		
	}
}