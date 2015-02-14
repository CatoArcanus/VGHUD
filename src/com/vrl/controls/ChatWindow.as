package com.vrl.controls {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	import flash.events.TimerEvent;	
	import flash.utils.Timer;
	
	import com.vrl.UIElement;
	import com.vrl.buttons.IconButton; 

	/////////////////
	// Description //
	/////////////////
	/**
	 * The ChatWindow is extended from the Window class and is very specific in its
	 * implementation
	 *
	 * @category   root.menu.panel
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.3 (01/13/2015)
	 */

	//////////////////////
	// ChatWindow Class //
	//////////////////////
	public class ChatWindow extends Window {
		
		//Objects
		var chatBG:Sprite;
		var chatLog:TextField;
		var chatLogBG:Sprite;
		var chatInput:TextField;
		var chatInputBG:Sprite;
		var scroller:Scroller;
		var sendButton:IconButton;
			
		public function ChatWindow(windowName:String, TAB_SIZE:Number, leftSide:Boolean, stageRef:Stage):void {
			super(windowName, TAB_SIZE*10, TAB_SIZE*7, TAB_SIZE, leftSide, stageRef);
			
			//Format for text
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = TAB_SIZE*.30;
			myFormat.font = "Arial";
			
			//Chat Log BG
			chatBG = new Sprite();
			chatBG.graphics.beginFill(0x000000, 0.2); 
			chatBG.graphics.drawRect(0, 0, this.myWidth, this.myHeight); 
			chatBG.graphics.endFill();
			chatBG.x = 0;
			chatBG.y = 0;
			
			//Chat Log Background
			chatLog = new TextField();
			chatLogBG = new Sprite();
			chatLogBG.graphics.beginFill(0x000000, 0.6); 
			chatLogBG.graphics.drawRect(0, 0, this.width-TAB_SIZE, this.height-TAB_SIZE*2); 
			chatLogBG.graphics.endFill();
			chatLogBG.x = TAB_SIZE*.5;
			chatLogBG.y = TAB_SIZE*.5;
			
			//Chat Log textfield
			chatLog.height = chatLogBG.height// - TAB_SIZE/2;
			chatLog.x = chatLogBG.x + TAB_SIZE/4;
			chatLog.y = chatLogBG.y;//TAB_SIZE*.75;
			chatLog.textColor = 0xFFFFFF; 
			chatLog.setTextFormat(myFormat); 
			chatLog.multiline = true;
			chatLog.wordWrap = true;
			chatLog.text = "1\n2\n3\n4\n5\n6\n7\n8\n9\n10";
			
			//Chat Input Background
			chatInput = new TextField();
			chatInputBG = new Sprite();
			chatInputBG.graphics.beginFill(0x000000, 0.8); 
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
			chatInput.setTextFormat(myFormat); 
			
			//Send button			
			sendButton = new IconButton("send", TAB_SIZE/2);
			sendButton.y = chatInput.y;
			sendButton.x = chatInputBG.width+TAB_SIZE/2;
						
			//Scroller
			scroller = new Scroller(chatLog, TAB_SIZE, stageRef);
			scroller.x = chatLogBG.width;
			scroller.y = chatLogBG.y;
			initialize();
		}
		
		private function appendText():void {
			chatLog.text += "G\n";
			var myTimer:Timer = new Timer(500, 1); // 2 seconds
			myTimer.addEventListener(TimerEvent.TIMER, appendText);
			myTimer.start();
		}
		
		//Add objects to stage
		private function initialize():void {
			addChild(chatBG);
			addChild(chatLogBG);
			addChild(chatLog);
			addChild(chatInputBG);
			addChild(chatInput);
			addChild(sendButton);
			addChild(scroller);
			this.draw();
			
			var myTimer:Timer = new Timer(500, 1); // 2 seconds
			myTimer.addEventListener(TimerEvent.TIMER, appendText);
			//myTimer.start();
 		}
	}
}