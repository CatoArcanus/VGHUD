package com.vrl.controls {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Shape;	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	import flash.events.TimerEvent;	
	import flash.utils.Timer;
	
	import com.vrl.UIElement;
	import com.vrl.TabInfo;	
	import com.vrl.buttons.Tab;	
	/////////////////
	// Description //
	/////////////////
	/**
	 * The Menu is the main window that is loaded for the HuD
	 *
	 * @namespace  root.menu
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.3 (01/08/2015)
	 */

	////////////////
	// Menu Class //
	////////////////
	public class Menu extends UIElement {
		
		//Properties
		public var menuPeekX:int; 
		public var menuPeekY:int;
		//variables
		public var currentPanel:String = "";
		var outPanel:String = "";
		var activePanel:String="";
		var TAB_SIZE:Number;
		var addOne:Function;
		var deleteOne:Function;
		
		//Objects
		public var tabs:Array = new Array();
		public var panels:Array = new Array();
		var panelMasks:Array = new Array();
		
		//Menu initializes objects and gives them values
		public function Menu(width:int, height:int, tabInfos:Array, TAB_SIZE:Number, leftSide:Boolean, stageRef:Stage):void {
			//Set up paramaters that differ from the default
			this.easing = .25;
			this.myWidth = width;
			this.myHeight = height;
			this.currentAlpha = .5;
			this.TAB_SIZE = TAB_SIZE;
						
			//This variable is used with the menu is on the left or right. 
			//It isn't very elegant. Maybe we can do away with the Bool all together
			//FIXME: Time permiting, try to make this more elegant 
			var pos:int = -1;
			if(leftSide) {
				pos = 1;
			}
			
			draw();
			//This variable will be incremented to put the tabs in vertical order						
			var tabY:Number = 0;
			var tabNumber = 1;
			for each(var tabInfo:TabInfo in tabInfos) {
				
				//A series of tabs is generated based on the list of tab names
				var tab = new Tab(tabInfo.title, tabInfo.name, width, TAB_SIZE, tabInfo.leftSide, tabInfo.scaleForm, tabInfo.accordian);
				tab.x = 0;
				tab.y = tabY;
				
				tabs.push(tab);
				
				//Accordians need panels
				if(tabInfo.accordian) {
					//add event listener for tabs with accordians
					tab.addEventListener(MouseEvent.CLICK, tabAccordian(tabInfo.name));
					//set up a panel mask
					var panelMask:Sprite = new Sprite();
					panelMask.graphics.beginFill(0xffFF00, .5); 
					panelMask.graphics.drawRect(0, 0, width, height-TAB_SIZE*tabInfos.length); 
					panelMask.graphics.endFill(); 
					panelMask.x = 0;
					panelMask.y = tab.y + tab.myHeight;
					 
					//set up a panel
					var panel = new Panel(tabInfo.name, width, TAB_SIZE, TAB_SIZE, tabInfo.leftSide, true, stageRef, panelMask.height);
					panel.x = 0;
					panel.y = tab.y + tab.myHeight - panel.myHeight;
					panel.closeY = panel.y;
					panel.openY = panel.y + panel.myHeight;
					panel.tabNumber = tabNumber;
					panel.mask = panelMask;
					panelMasks[tabInfo.name] = panelMask;
					panels[tabInfo.name] = panel;
				}
				
				if(tabInfo.peek) {
					//Add Event Listen
					tab.addEventListener(MouseEvent.CLICK, tabAccordian(tabInfo.name));
					//A mask for the panels
					panelMask = new Sprite();
					panelMask.graphics.beginFill(0xffFF00); 
					panelMask.graphics.drawRect(0, 0, TAB_SIZE*16, height); 
					panelMask.graphics.endFill(); 
					panelMask.x = panelMask.width*(-1);
					panelMask.y = 0;

					
					//This creates a series of panels. 				
					var panel = new AvatarPanel(tabInfo.name, TAB_SIZE*16, height, TAB_SIZE, tabInfo.leftSide, false, stageRef, panelMask.height);			
					panel.x = 0;
					panel.y = 0;
					panel.closeX = panel.x;
					panel.openX = panel.x - panelMask.width;
					panel.tabNumber = tabNumber;
					panel.mask = panelMask;
					panelMasks[tabInfo.name] = panelMask;
					panels[tabInfo.name] = panel;
					
				}
				
				tab.maxOpenY = tab.y+height-TAB_SIZE*tabInfos.length;
				tab.minCloseY = tab.y;
				tabY += TAB_SIZE+1;
				tabNumber++;
			}
			
			init();
		}
		
		//Init Adds resources to stage and sets up initial event listeners
		private function init():void {
			for (var ke:String in panelMasks){
				addChild(panelMasks[ke]);
			}
			for (var key:String in tabs){
				//trace(key);
				addChild(tabs[key]);
				tabs[key].draw();
			}
			for (var k:String in panels){
				addChild(panels[k]);
			}
		}
		
		//Accordian tabs do some very special things, so this is our function for that
		private function tabAccordian(panelName:String):Function {
			return function(e:MouseEvent):void {
				for each(var tab:Tab in tabs) {
					//If the tab -> currentPanel, we close it
					if(tab.buttonName == currentPanel) {
						tab.minAlpha = 0.0;
						//tab.setShadow = true;
						tab.unHighlight();
						tab.rotateIconUp();
					}
					//If the tab -> is our panel, let's open the panel
					if(tab.buttonName == panelName) {
						tab.minAlpha = 0.5;
						tab.rotateIconDown();
					}
					//If we have another tab open, let's unhighlight it.
					if(currentPanel == panelName)  {
						tab.minAlpha = 0.0;
						tab.unHighlight();
						tab.rotateIconUp();
					}
				}
				//Try to animate something out, before we animate something in
				animateOut(panelName);
			};
		}
		
		public function animateOut(panelName:String):void {
			//If no current panel, just open the panel and make it the current
			if(currentPanel == "") {
				currentPanel = panelName;
				animateIn();
			} else {
				outPanel = currentPanel;
				panels[outPanel].moveY = panels[outPanel].closeY;
				panels[outPanel].moveX = panels[outPanel].closeX;
				trace("AA");
				if(!hasEventListener(Event.ENTER_FRAME)) {
					trace("@@@@");
					activePanel = outPanel;
					if(panels[outPanel].verticalMover) {
						addEventListener(Event.ENTER_FRAME, onEasePanelY);
					} else {
						addEventListener(Event.ENTER_FRAME, onEasePanelX);
					}
					//onEaseOut = onEasePanelY(outPanel);
					//addEventListener(Event.ENTER_FRAME, onEaseOut);
				}
				//if the current panel is the one we clicked, close it and set the state to stable
				if(currentPanel == panelName)  {
					currentPanel = "";
				} else {
				//if not, get ready to close the panel
					currentPanel = panelName;
				}
			}
		}
		
		//Only called once it knows everything else was animated out
		//or didn't need to be animated out
		public function animateIn():void {
			//trace("Animate in: " + currentPanel);
			panels[currentPanel].visible = true;
			panels[currentPanel].moveY = panels[currentPanel].openY;
			panels[currentPanel].moveX = panels[currentPanel].openX;
			trace("AA!");
			if(!hasEventListener(Event.ENTER_FRAME)) {
				trace("@@@@!");
				activePanel = currentPanel;
				if(panels[activePanel].verticalMover) {
					addEventListener(Event.ENTER_FRAME, onEasePanelY);
				} else {
					addEventListener(Event.ENTER_FRAME, onEasePanelX);					
				}
				//onEaseIn = onEasePanelY(currentPanel);
				//addEventListener(Event.ENTER_FRAME, onEasePanelY);
			}
		}
		
		//This handles closing the Panel frame by frame, until is it done 
		//This is arbitrary Y movement, but could allow for any type of movement
		public function onEasePanelY(e:Event):void {
			trace(panels[activePanel].frameCounter + " -- " + (panels[activePanel].moveX - x) * panels[activePanel].easing);
			//My distance = (where I want to go) - where I am
			panels[activePanel].dy = ( panels[activePanel].moveY - panels[activePanel].y);
			//If where I want to go is less than 1, I will stay there
			//Otherwise move a proportional distance to my target "easing" my way there
			if(Math.abs(panels[activePanel].dy) < 1) {
				if(panels[activePanel].dy < 0) {
					removeEventListener(Event.ENTER_FRAME, onEasePanelY);
					panels[activePanel].visible = false;
					if(currentPanel != "") {
						animateIn();
					}
				} else {
					removeEventListener(Event.ENTER_FRAME, onEasePanelY);
				}
				//removeEventListener(Event.ENTER_FRAME, arguments.callee);
				panels[activePanel].frameCounter = 0;
			} else {
				var limit:Number;
				var compare:Boolean;
				var startingPoint:int = panels[activePanel].tabNumber * -1;
				var newPos:int;
				panels[activePanel].y += panels[activePanel].dy * panels[activePanel].easing;
				for(var i:int = panels[activePanel].tabNumber; i < tabs.length; i++) {
					if(panels[activePanel].dy < 0) {
						limit = tabs[i].minCloseY;
						compare = tabs[i].y > limit;
						newPos = panels[activePanel].y + panels[activePanel].myHeight + tabs[i].height*2*(startingPoint+i) * panels[activePanel].easing;
					} else {
						limit = tabs[i].maxOpenY;
						compare = tabs[i].y < limit;
						newPos = tabs[i].y + (panels[activePanel].dy + TAB_SIZE/16) * panels[activePanel].easing;
					}
					//trace("move tab " + i)
					if(compare) {
						tabs[i].y = newPos;//panels[activePanel].y + panels[activePanel].myHeight + tabs[i].height*2*(startingPoint+i) * panels[activePanel].easing;
					} else {
						tabs[i].y = limit;
					}
				}
			}
			panels[activePanel].frameCounter++;
		}
		
		//This handles closing the Panel frame by frame, until is it done 
		//This is arbitrary Y movement, but could allow for any type of movement
		public function onEasePanelX(e:Event):void {
			trace(panels[activePanel].frameCounter + " moveX: " + (panels[activePanel].moveX) + " x: " + (panels[activePanel].x));
			//My distance = (where I want to go) - where I am
			panels[activePanel].dx = ( panels[activePanel].moveX - panels[activePanel].x);
			//If where I want to go is less than 1, I will stay there
			//Otherwise move a proportional distance to my target "easing" my way there
			if(Math.abs(panels[activePanel].dx) < 1) {
				if(panels[activePanel].dx > 0) {
					removeEventListener(Event.ENTER_FRAME, onEasePanelX);
					panels[activePanel].visible = false;
					if(currentPanel != "") {
						animateIn();
					}
				} else {
					removeEventListener(Event.ENTER_FRAME, onEasePanelX);
				}
				//removeEventListener(Event.ENTER_FRAME, arguments.callee);
				panels[activePanel].frameCounter = 0;
			} else {
				panels[activePanel].x += panels[activePanel].dx * panels[activePanel].easing;
			}
			panels[activePanel].frameCounter++;
		}
		
		public function addToList(labelName:String, panelName:String, buttonText:String, onClick:Function):void {
			if(!panels[panelName].labels.hasOwnProperty(labelName)) {
				var lastTabNum:int = tabs.length-1;
				if( panels[panelName].visible == true) {
					if(!hasEventListener(Event.ENTER_FRAME)) {
						tabs[lastTabNum].openY = tabs[lastTabNum].y+TAB_SIZE * 5/4;	
						tabs[lastTabNum].moveY = tabs[lastTabNum].openY;
						addOne = squish( true, labelName, panelName, buttonText, onClick);
						addEventListener(Event.ENTER_FRAME, addOne);
					} else {
						// Create buffer in the form of a timer that trys to add the element over and over until success
						var tryThatAgain:Function = tryAgain(arguments.callee, labelName, panelName, buttonText, onClick);
						var myTimer:Timer = new Timer(100, 1); // .1 second
						myTimer.addEventListener(TimerEvent.TIMER, tryThatAgain);
						myTimer.start();
					}
				} else {
					panels[panelName].addSureLabel(labelName, buttonText, onClick, TAB_SIZE);
				}
			}
		}
		
		public function tryAgain(callee:Function, labelName:String, panelName:String, buttonText:String = "", onClick:Function =null):Function {
			return function(e:TimerEvent):void {
				if(onClick != null){
					callee(labelName, panelName, buttonText, onClick);
				} else {
					callee(labelName, panelName);
				}
				//addPlayertoPlayerList(labelName, panelName);
			}
		}
		
		public function deleteFromList(labelName:String, panelName:String):void {
			//trace("panels[panelName].labels.hasOwnProperty(labelName): " + panels[panelName].labels.hasOwnProperty(labelName));
			if(panels[panelName].labels.hasOwnProperty(labelName)) {
				var lastTabNum:int = tabs.length-1;
				if(!hasEventListener(Event.ENTER_FRAME)) {
					panels[panelName].removeSureLabel(labelName);
					tabs[lastTabNum].openY = tabs[lastTabNum].y-TAB_SIZE * 5/4;	
					tabs[lastTabNum].moveY = tabs[lastTabNum].openY;
					if( panels[panelName].visible == true) {
						deleteOne = squish( false, labelName, panelName);
						addEventListener(Event.ENTER_FRAME, deleteOne);	
					}
				} else {
					// AS3
					var tryThatAgain:Function = tryAgain(arguments.callee, labelName, panelName);
					var myTimer:Timer = new Timer(100, 1); // .1 second
					myTimer.addEventListener(TimerEvent.TIMER, tryThatAgain);
					myTimer.start();
				}
			}
		}
		
		public function squish(isAdding:Boolean, labelName:String, panelName:String, buttonText:String = "", onClick:Function = null):Function {
			return function(e:Event):void {
				//trace(( tabs[tabs.length-1].moveY - tabs[tabs.length-1].y));
				//My distance = (where I want to go) - where I am
				var lastTabNum:int = tabs.length-1;
				tabs[lastTabNum].dy = ( tabs[lastTabNum].moveY - tabs[lastTabNum].y);
				//If where I want to go is less than 1, I will stay there
				//Otherwise move a proportional distance to my target "easing" my way there
				if(Math.abs(tabs[lastTabNum].dy) < 1) {
					for(var i:int = panels[panelName].tabNumber; i < tabs.length; i++) {
						//trace("move tab " + i)
						//tabs[i].y = tabs[i].openY;
					}
					if(isAdding == true) {
						panels[panelName].addSureLabel(labelName, buttonText, onClick, TAB_SIZE);
						removeEventListener(Event.ENTER_FRAME, addOne);
					} else {
						removeEventListener(Event.ENTER_FRAME, deleteOne);							
					}
				} else {
					//panels[currentPanel].y += panels[currentPanel].dy * panels[currentPanel].easing;
					for(var i:int = lastTabNum; i >= panels[panelName].tabNumber; i--) {
						//trace("move tab " + i)
						trace(tabs[i].y < tabs[i].maxOpenY);
						if(tabs[i].y < tabs[i].maxOpenY) {
							tabs[i].y += tabs[lastTabNum].dy * tabs[lastTabNum].easing;
						} else {
							tabs[i].y = tabs[i].maxOpenY;
							tabs[i].moveY = tabs[i].y;
						}
					}
				}
			}
		}
	}
}