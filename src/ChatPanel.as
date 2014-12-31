package {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*; 

	/////////////////
	// Description //
	/////////////////
	/**
	 * The ChatPanel is extended from the Panel class and is very specific in its
	 * implementation
	 *
	 * @category   root.menu.panel
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.2 (12/29/2014)
	 */

	/////////////////////
	// ChatPanel Class //
	/////////////////////
	public class ChatPanel extends Panel {
		
		var chatLog:TextField;
		var chatLogBG:Sprite;
		var chatInput:TextField;
		var chatInputBG:Sprite;
		//var chatScroller:DefaultScrollBar;
		var sendButton:IconButton;
			
		public function ChatPanel(panelName:String, menuWidth:int, panelWidth:int, height:int, TAB_SIZE:Number, leftSide:Boolean):void {
			super(panelName, menuWidth, panelWidth, height, TAB_SIZE, leftSide);
			
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = TAB_SIZE*.30;
			myFormat.font = "Arial";
			
			//Chat Log
			chatLog = new TextField();
			chatLogBG = new Sprite();
			chatLogBG.graphics.beginFill(0x000000, 0.8); 
			chatLogBG.graphics.drawRect(0, 0, width-TAB_SIZE, height-TAB_SIZE*4); 
			chatLogBG.graphics.endFill();
			chatLogBG.x = TAB_SIZE*.5;
			chatLogBG.y = TAB_SIZE*2;
			chatLog.width = menuWidth - TAB_SIZE*.75;
			chatLog.height = height - TAB_SIZE*.75;
			chatLog.x = TAB_SIZE*.75;
			chatLog.y = TAB_SIZE*2;
			
			//Chat Input
			chatInput = new TextField();
			chatInputBG = new Sprite();
			chatInputBG.graphics.beginFill(0x000000, 0.8); 
			chatInputBG.graphics.drawRect(0, 0, width-TAB_SIZE, TAB_SIZE/2); 
			chatInputBG.graphics.endFill();
			chatInputBG.x = chatLogBG.x;
			chatInputBG.y = chatLogBG.y+chatLogBG.height+TAB_SIZE*.5;
			chatInput.width = chatInputBG.width-TAB_SIZE/2;
			chatInput.height = TAB_SIZE;
			chatInput.x = chatInputBG.x;
			chatInput.y = chatInputBG.y;
			chatInput.type = TextFieldType.INPUT;
			chatInput.textColor = 0xFFFFFF; 
			chatInput.setTextFormat(myFormat); 
						
			sendButton = new IconButton("Avatars", TAB_SIZE/2);
			sendButton.y = chatInput.y;
			sendButton.x = chatInputBG.width;
			initialize();
		}
		
		private function initialize():void {
			addChild(chatLogBG);
			addChild(chatLog);
			addChild(chatInputBG);
			addChild(chatInput);
			addChild(sendButton)
			this.draw();
		}
	}
}