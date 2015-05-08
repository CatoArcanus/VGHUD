package com.vrl.windows {
	
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
	import com.vrl.TabInfo;
	import com.vrl.buttons.Tab; 
	import com.vrl.buttons.TextButton; 
	import com.vrl.utils.Icon; 
	
	///////////////////////
	// PauseWindow Class //
	///////////////////////
	public class PauseWindow extends Window {
		
		//Objects
		public var topBox:UIElement;
		public var vgLogo:Icon;
		public var vgTitle:TextField;
		public var tabs:Array = new Array();
		public var stageRef:Stage;
		public var bottomBox:UIElement;
		private var currentTab:int = 0;
		private var logoStart:int;
		private var titleStart:int;
			
		/**
		* Pause windows are very specific in their functionality and are layed out based on the 
		* TAB_SIZE variable
		*/
		public function PauseWindow(windowName:String, TAB_SIZE:Number, tabInfos:Array, leftSide:Boolean, stageRef:Stage):void {
			var h:int = 0+TAB_SIZE*1.5 + (tabInfos.length)*(TAB_SIZE) + TAB_SIZE/2 - TAB_SIZE/4;
			super(windowName, TAB_SIZE*10, h, TAB_SIZE, leftSide, stageRef);
			this.stageRef = stageRef;
			this.bg.visible = false;

			//Format for text
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = TAB_SIZE*1.0;
			//myFormat.font = "Arial";
			var myFont = new Museo();
			myFormat.font = myFont.fontName;
			
			//Pause topBox
			topBox = new UIElement();
			topBox.x = 0;
			topBox.y = 0;
			topBox.myWidth = TAB_SIZE*10;
			topBox.myHeight = TAB_SIZE*1.5;
			topBox.maxAlpha = .7; 
			topBox.minAlpha = 0.0; 
			topBox.color = 0x000000;
			topBox.currentAlpha = 0.7;
			topBox.easing = 0.1;
			topBox.draw();
			
			//Logo is an image
			vgLogo = new Icon("logo", TAB_SIZE*2.66, true);
			vgLogo.x = TAB_SIZE*.15625*1.5;
			vgLogo.y = TAB_SIZE*.15625/1.5;

			//title is the text next to the logo
			vgTitle = new TextField();
			vgTitle.text = windowName;
			vgTitle.textColor = 0xFFFFFF;
			vgTitle.x = TAB_SIZE*.875*2.0;
			vgTitle.y = TAB_SIZE*.15625;
			vgTitle.width = width-vgTitle.x;
			vgTitle.embedFonts = true;
			vgTitle.setTextFormat(myFormat);
			vgTitle.selectable = false;

			//tabs
			var tabY:Number = topBox.y+topBox.height;
			var tabNumber = 1;
			for each(var tabInfo:TabInfo in tabInfos) {
				//A series of tabs is generated based on the list of tab names
				var tab = new Tab(tabInfo.name, tabInfo.title, tabInfo.name, width, TAB_SIZE, tabInfo.leftSide, tabInfo.scaleForm, tabInfo.accordian);
				tab.x = 0;
				tab.y = tabY;
				
				tabs.push(tab);
				tabY += TAB_SIZE+1;
				tabNumber++;
			}

			//Pause bottomBox
			bottomBox = new UIElement();
			bottomBox.x = 0;
			bottomBox.y = tabY;
			bottomBox.myWidth = TAB_SIZE*10;
			bottomBox.myHeight = TAB_SIZE*.5;
			bottomBox.maxAlpha = .7; 
			bottomBox.minAlpha = 0.0; 
			bottomBox.color = 0x000000;
			bottomBox.currentAlpha = 0.7;
			topBox.easing = 0.1;
			bottomBox.draw();
			
			//Some values for animation
			var topNum:int = topBox.height; 
			var bottomNum:int = bottomBox.y;
			var halfWay = (bottomNum-topNum)/2 + topNum;
			topBox.closeY = halfWay - topBox.height;
			topBox.openY = topBox.y;
			bottomBox.closeY = halfWay;
			bottomBox.openY = bottomBox.y;
			logoStart = vgLogo.x+100;
			titleStart = vgTitle.x+100;
		
			initialize();
		}
		
		//Add objects to stage
		private function initialize():void {
			addChild(topBox);
			addChild(vgLogo);
			addChild(vgTitle);
			for (var key:String in tabs){
				//trace(key);
				addChild(tabs[key]);
				tabs[key].minAlpha = .4;
				tabs[key].currentAlpha = .4;
				tabs[key].draw();
			}
			addChild(bottomBox);
			this.draw();
			intro();
 		} 	

		private function closeWindow(e:MouseEvent):void {
			outtro();
			//this.visible = false;
		}

		public function intro():void {
			this.visible = true;
			topBox.y = topBox.closeY;
			topBox.moveY = topBox.openY;
			bottomBox.y = bottomBox.closeY;
			bottomBox.moveY = bottomBox.openY;
			this.alpha = 0.0;
			this.easing = 0.1;
			this.fade = 1.0;
			vgLogo.x = logoStart;
			vgTitle.x = titleStart;
			addEventListener(Event.ENTER_FRAME, moveApart);
			addEventListener(Event.ENTER_FRAME, fadeIn);
		}

		public function outtro():void {
			topBox.y = topBox.openY;
			topBox.moveY = topBox.closeY;
			bottomBox.y = bottomBox.openY;
			bottomBox.moveY = bottomBox.closeY;
			this.alpha = 1.0;
			this.easing = 0.1;
			this.fade = 0.0;
			addEventListener(Event.ENTER_FRAME, moveApart);
			addEventListener(Event.ENTER_FRAME, fadeIn);
		}

		//This handles opening the myMenu frame by frame, until is it done 
		//This is arbitrary X movement, but could allow for any type of movement or easing.
		public function moveApart(e:Event):void {
			//utrace(myMenu.frameCounter + " -- " + (myMenu.openX - myMenu.x) * myMenu.easing);
			//utrace("myX is now: " + myMenu.x);
			//My distance = (where I want to go) - where I am
			topBox.dy = ( topBox.moveY - topBox.y);
			bottomBox.dy = ( bottomBox.moveY - bottomBox.y);
			//If where I want to go is less than 1, I will stay there
			//Otherwise move a proportional distance to my target "easing" my way there
			if(Math.abs(topBox.dy) < 1) {
				removeEventListener(Event.ENTER_FRAME, moveApart);
				topBox.frameCounter = 0;
				//addEventListener(Event.ENTER_FRAME, fadeTabsIn);
			} else {
				topBox.y += topBox.dy * topBox.easing;
				bottomBox.y += bottomBox.dy * bottomBox.easing;
			}
			topBox.frameCounter++;
		}

		//handle alpha changes, positive or negative
		private function fadeIn(e:Event):void {
			//trace(frameCounter + "fade: "+fade+" -- da:" + (da)+ "currentAlpha: "+currentAlpha+ " abs " + (Math.abs(da *10)));
			//My distance = (where I want to go) - where I am	
			this.da = this.fade - this.alpha;		
			if(Math.abs(this.da *10) < .01) {
				removeEventListener(Event.ENTER_FRAME, fadeIn);
				if(Math.abs(topBox.y - topBox.closeY) < 1) {
					//closeWindow();
					this.visible = false;
					ExternalInterface.call("ASReceiveCloseAnimationComplete");
				}
			} else {				
				vgTitle.x -= (this.da * this.easing)*100;
				vgLogo.x -= (this.da * this.easing)*100;
				this.alpha += this.da * this.easing;
			}
		}	
	}
}