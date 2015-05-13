package com.vrl.panels {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.text.*;
	import flash.events.TimerEvent;	
	import flash.utils.Timer;
	import flash.external.ExternalInterface;
	
	import com.vrl.UIElement;
	import com.vrl.buttons.IconButton; 
	import com.vrl.buttons.TextButton; 
	import com.vrl.utils.Scroller;
	
	/////////////////////
	// ChatPanel Class //
	/////////////////////
	public class ChatPanel extends Panel {
		
		//Objects
		public var chatLog:TextField;
		public var chatLogBG:Sprite;
		public var chatInput:TextField;
		public var chatInputBG:Sprite;
		public var textScroller:Scroller;
		public var sendButton:IconButton;
		//public var xButton:TextButton;
		public var stageRef:Stage;

		private var focusChange:Boolean = true;
			
		/**
		* Chat windows are very specific in their functionality and are layed out based on the 
		* TAB_SIZE variable
		*/
		public function ChatPanel(panelName:String, width:int, height:int, TAB_SIZE:Number, leftSide:Boolean, verticalMover:Boolean, stageRef:Stage):void {
			super(panelName, width, height, TAB_SIZE, leftSide, verticalMover, stageRef, height);
			this.myHeight = height;
			//Format for text
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = TAB_SIZE*.30;
			myFormat.font = "Arial";
			var myFont = new Arial();
			myFormat.font = myFont.fontName;
			this.stageRef = stageRef;
			
			//Chat Log Background
			chatLog = new TextField();
			chatLogBG = new Sprite();
			chatLogBG.graphics.beginFill(0x000000, 0.5); 
			chatLogBG.graphics.drawRect(0, 0, this.width-TAB_SIZE, this.height-TAB_SIZE*2.0); 
			chatLogBG.graphics.endFill();
			chatLogBG.x = TAB_SIZE*.5;
			chatLogBG.y = TAB_SIZE*.5;
			
			//Chat Log textfield
			chatLog.height = chatLogBG.height;// - TAB_SIZE/2;
			chatLog.width = chatLogBG.width - TAB_SIZE/8;
			chatLog.x = chatLogBG.x + TAB_SIZE/4;
			chatLog.y = chatLogBG.y;//TAB_SIZE*.75;
			chatLog.textColor = 0xFFFFFF; 
			chatLog.setTextFormat(myFormat); 
			chatLog.multiline = true;
			chatLog.wordWrap = true;
			chatLog.embedFonts = true;
			
			//Chat Input Background
			chatInput = new TextField();
			chatInputBG = new Sprite();
			chatInputBG.graphics.beginFill(0x000000, 0.5); 
			chatInputBG.graphics.drawRect(0, 0, chatLogBG.width-TAB_SIZE/2, TAB_SIZE/2); 
			chatInputBG.graphics.endFill();
			chatInputBG.x = chatLogBG.x;
			chatInputBG.y = chatLogBG.y+chatLogBG.height+TAB_SIZE*.5;
			
			//Chat Input textfield
			chatInput.width = chatInputBG.width-TAB_SIZE/8;
			chatInput.height = TAB_SIZE;
			chatInput.x = chatInputBG.x;
			chatInput.y = chatInputBG.y;
			chatInput.type = TextFieldType.INPUT;
			chatInput.textColor = 0xFFFFFF; 
			chatInput.defaultTextFormat = myFormat;
			chatInput.setTextFormat(myFormat); 
			chatInput.embedFonts = true;
			
			//Send button			
			sendButton = new IconButton("send", TAB_SIZE/2);
			sendButton.y = chatInput.y;
			sendButton.x = chatInputBG.width+TAB_SIZE/2;
			
			//X button			
			/*
			xButton = new TextButton("X", "X", TAB_SIZE/2);
			xButton.y = 0;
			xButton.x = bg.width-xButton.width;//chatInputBG.width+TAB_SIZE/2;
			xButton.addEventListener(MouseEvent.CLICK, closeWindow);
			*/			
			//Scroller
			textScroller = new Scroller(chatLog, TAB_SIZE, stageRef);
			textScroller.x = chatLogBG.width;
			textScroller.y = chatLogBG.y;
			initialize();
		}
		
		//Add objects to stage
		private function initialize():void {
			addChild(chatLogBG);
			addChild(chatLog);
			addChild(chatInputBG);
			addChild(chatInput);
			addChild(sendButton);
			addChild(textScroller);
			//addChild(xButton);
			this.draw();
			
			var myTimer:Timer = new Timer(500, 1); // 2 seconds
			myTimer.addEventListener(TimerEvent.TIMER, appendText);
			//myTimer.start();
			
			// sets up a callback for the send button's 'click' event
			//chatSendBtn.addEventListener(MouseEvent.CLICK, this.submitText);

			// Add keyboard referenced event listener to Input text
			chatInput.addEventListener( KeyboardEvent.KEY_UP, checkInputKeyForSubmit, false, 0, true);
			sendButton.addEventListener(MouseEvent.CLICK, submitText);
			addEventListener(MouseEvent.MOUSE_OVER, captureScroll);
 		}
 		
 		//FIXME, not dry
 		//Captures scrolling input
		private function captureScroll( event:Event ):void {
			removeEventListener(MouseEvent.MOUSE_OVER, captureScroll);
			addEventListener(MouseEvent.MOUSE_OUT, removeCaptureScroll);
			ExternalInterface.call("asReceiveRemoveScroll");
		}
 		
 		//Captures scrolling input
 		private function removeCaptureScroll( event:Event ):void {
			addEventListener(MouseEvent.MOUSE_OVER, captureScroll);
			removeEventListener(MouseEvent.MOUSE_OUT, removeCaptureScroll);
			ExternalInterface.call("asReceiveAddScroll");
		}
 		
		//Submits the current text of the appropraite TextInput
		private function submitText( event:Event ):void {	
			//trace("sendButton clicked");	
			if (chatInput.text != "") {
				//this.stage.focus = chatSendBtn;
				//ExternalInterface.call("asReceiveToggleChatFalse");
				submitToUDK();	
			}
		}
		        
		// Checks whether the input key was "Enter". If it was, submit it
		private function checkInputKeyForSubmit( event:KeyboardEvent ):void {         
			trace("beep");
			if ( event.keyCode ==  13 ) {
				if (chatInput.text != "") {
					if(focusChange) {
						this.stageRef.focus = stageRef;
					}
					ExternalInterface.call("asReceiveToggleChatFalse");
					submitToUDK();
				}
			}
		}

		//This updates the scene and sends a message to UDK.
		private function submitToUDK():void {
			//US Call to push this message out to others and back to yourself
			ExternalInterface.call("asReceiveTextMessage", chatInput.text);
			// Clear the textField for next message
			chatInput.text = ""; 
		}
		
		//This is a slow method for testing
		//FIXME: delete this code
		private function appendText():void {
			chatLog.text += "G\n";
			var myTimer:Timer = new Timer(500, 1); // 2 seconds
			myTimer.addEventListener(TimerEvent.TIMER, appendText);
			myTimer.start();
		}
		
		private function closeWindow(e:MouseEvent):void {
			this.visible = false;
		}
		
	}
}