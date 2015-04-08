package com.vrl.controls {
	
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
	
	//////////////////////
	// SureWindow Class //
	//////////////////////
	public class SureWindow extends Window {
		
		//Objects
		public var text:TextField;
		public var buttonGrid:Sprite;
		public var yesButton:TextButton;
		public var noButton:TextButton;
		public var yesClick:Function;
		//public var backDrop:Sprite = new Array();
		public var backDrop:Sprite;// = new Array();
			
		/**
		* Chat windows are very specific in their functionality and are layed out based on the 
		* TAB_SIZE variable
		*/
		public function SureWindow(windowName:String, TAB_SIZE:Number, leftSide:Boolean, stageRef:Stage):void {
			super(windowName, TAB_SIZE*6, TAB_SIZE*3, TAB_SIZE, leftSide, stageRef);
						
			//Format for text
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = TAB_SIZE/2;
			myFormat.font = "Arial";
			var myFont = new Arial();
			myFormat.font = myFont.fontName;
						
			//Chat Log Background
			text = new TextField();
			text.height = TAB_SIZE*2;//chatLogBG.height;// - TAB_SIZE/2;
			text.width = myWidth - TAB_SIZE/2;//chatLogBG.width - TAB_SIZE/8;
			text.x = TAB_SIZE/2;
			text.y = TAB_SIZE/4;
			text.textColor = 0xFFFFFF; 
			text.multiline = true;
			text.wordWrap = true;
			text.embedFonts = true;
			text.text = "Are you sure you want to kick superadmin 250?";
			text.setTextFormat(myFormat);
			
						
			buttonGrid = new Sprite();
			
			yesButton = new TextButton("YES", "placeholder", TAB_SIZE/2); 
			//yesButton.x = text.x + TAB_SIZE;
			//yesButton.y = text.y + text.height;//this.myWidth - button.myWidth - TAB_SIZE/4;
						
			noButton = new TextButton("NO", "close", TAB_SIZE/2); 
			noButton.x = yesButton.x + yesButton.myWidth+TAB_SIZE; //TAB_SIZE/4;
			noButton.y = yesButton.y;//text.y + text.height + TAB_SIZE/2;//this.myWidth - button.myWidth - TAB_SIZE/4;
			
			buttonGrid.addChild(yesButton);
			buttonGrid.addChild(noButton);
			
			buttonGrid.x = this.myWidth/2 - buttonGrid.width/2;
			buttonGrid.y = text.y + text.height;
			bg.x = stageRef.stageWidth/2 - width/2;
			bg.y = stageRef.stageHeight/2 - height/2;
			
			//var backDropColor = 0x000000;
			//var backDropAlpha = .4;
			
			
 			backDrop = new Sprite();
			backDrop.graphics.beginFill(0x000000, .4);
			backDrop.graphics.drawRect(0, 0, stageRef.stageWidth, stageRef.stageHeight); 
			backDrop.graphics.endFill();
			
			
			/*
			//left													X:				Y:				Width:								Height:
			backDrop.push(newBackDrop(backDropColor, backDropAlpha, 0, 				0, 				bg.x, 								stageRef.stageHeight));
			//up
			backDrop.push(newBackDrop(backDropColor, backDropAlpha, bg.x, 			0, 				bg.width, 							bg.y));
			//down
			backDrop.push(newBackDrop(backDropColor, backDropAlpha, bg.x, 			bg.y+bg.height, bg.width, 							stageRef.stageHeight-bg.y-bg.height));
			//right
			backDrop.push(newBackDrop(backDropColor, backDropAlpha, bg.x+bg.width, 	0, 				stageRef.stageWidth-bg.x-bg.width,	stageRef.stageHeight));
			*/			
			initialize();
		}
		
		//Add objects to stage
		private function initialize():void {
			/*
			for(var key:String in backDrop) {
				addChild(backDrop[key]);
			}
			*/
			addChildAt(backDrop, 0);
			bg.addChild(text);
			bg.addChild(buttonGrid);
			bg.addEventListener(MouseEvent.MOUSE_OVER, removeHandleClose);
 			backDrop.addEventListener(MouseEvent.CLICK, hide);
 			yesButton.addEventListener(MouseEvent.CLICK, hide);
			noButton.addEventListener(MouseEvent.CLICK, hide);
			this.draw();
 		}
 		
 		public function show(onClick:Function, target:String, action:String):void {
 			//this.addEventListener(MouseEvent.CLICK, hide);
 			//Format for text
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = 24;
			myFormat.font = "Arial";
			var myFont = new Arial();
			myFormat.font = myFont.fontName;
			
 			this.yesClick = onClick;
 			this.yesButton.context = target;
 			this.text.text = "Are you sure you want to " + action + " " + target + "?";
			text.setTextFormat(myFormat);
 			this.yesButton.addEventListener(MouseEvent.CLICK, yesClick);
 			this.visible = true;
 		}
 		
 		public function hide(e:MouseEvent):void {
 			this.yesButton.removeEventListener(MouseEvent.CLICK, yesClick);
 			this.visible = false;
 		}
 		
 		public function removeHandleClose(e:MouseEvent):void {
 			trace("remove");
 			backDrop.removeEventListener(MouseEvent.CLICK, hide);
 			
 			bg.removeEventListener(MouseEvent.MOUSE_OVER, removeHandleClose);
 			bg.addEventListener(MouseEvent.MOUSE_OUT, addHandleClose)
 		}
 		
 		
 		public function addHandleClose(e:MouseEvent):void {
 			trace("addBack");
 			backDrop.addEventListener(MouseEvent.CLICK, hide);
 			
 			bg.removeEventListener(MouseEvent.MOUSE_OUT, addHandleClose)
 			bg.addEventListener(MouseEvent.MOUSE_OVER, removeHandleClose)
 		}
 		/*
 		private function newBackDrop(color:int, alpha:Number, x:int, y:int, width:int, height:int):Sprite {
			return temp;
 		}
 		*/		
	}
}