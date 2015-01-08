package {
	
	import flash.display.Sprite;	
	import flash.display.MovieClip;
	import flash.display.Shape;	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;	
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
	
		//variables
		var currentPanel:String = "";
		var outPanel:String = "";
		
		//Objects
		var tabs:Array = new Array();
		var panels:Array = new Array();
		var panelMasks:Array = new Array();
		
		//Menu initializes objects and gives them values
		public function Menu(width:int, height:int, tabInfos:Array, TAB_SIZE:Number, leftSide:Boolean):void {
			//Set up paramaters that differ from the default
			this.easing = .25;
			this.myWidth = width;
			this.myHeight = height;
			this.currentAlpha = .5;
			
			//This variable is used with the menu is on the left or right. 
			//It isn't very elegant. Maybe we can do away with the Bool all together
			//TODO: Time permiting, try to make this more elegant 
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
				var tab = new Tab(tabInfo.tabName, width, TAB_SIZE, leftSide, tabInfo.accordian);
				tab.x = 0;
				tab.y = tabY;
				if(tabInfo.accordian) {
					tab.addEventListener(MouseEvent.CLICK, tabAccordian(tabInfo.tabName));
				} else {
					//tab.addEventListener(MouseEvent.CLICK, tabClick(tabInfo.tabName));
				}
				tabs.push(tab);
				//Accordians need panels
				if(tabInfo.accordian) {
					//set up a panel mask
					var panelMask:Sprite = new Sprite();
					panelMask.graphics.beginFill(0xffFF00, .5); 
					panelMask.graphics.drawRect(0, 0, width, height); 
					panelMask.graphics.endFill(); 
					panelMask.x = 0;
					panelMask.y = tab.y + tab.myHeight;
					//set up a panel
					var panel = new Panel(tabInfo.tabName, width, TAB_SIZE, TAB_SIZE, leftSide);
					panel.x = 0;
					panel.y = tab.y + tab.myHeight - panel.myHeight;
					panel.closeY = panel.y;
					panel.openY = panel.y + panel.myHeight;
					panel.tabNumber = tabNumber;
					panel.mask = panelMask;
					panelMasks[tabInfo.tabName] = panelMask;
					panels[tabInfo.tabName] = panel;
				}
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
				trace(key);
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
		/*
		//this is for normal toggleable tabs
		private function tabClick(panelName:String):Function {
			return function(e:MouseEvent):void {
				
			};
		}
		*/				
		public function animateOut(panelName:String):void {
			//If no current panel, just open the panel and make it the current
			if(currentPanel == "") {
				currentPanel = panelName;
				animateIn();
			} else {
				outPanel = currentPanel;
				panels[outPanel].moveY = panels[outPanel].closeY;
				addEventListener(Event.ENTER_FRAME, onEaseOut);
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
			trace("Animate in: " + currentPanel);
			panels[currentPanel].visible = true;
			panels[currentPanel].moveY = panels[currentPanel].openY;
			addEventListener(Event.ENTER_FRAME, onEaseIn);
		}
		
		//This handles closing the Panel frame by frame, until is it done 
		//This is arbitrary X movement, but could allow for any type of movement
		public function onEaseOut(e:Event):void {
			//trace(frameCounter + " -- " + (openX - x) * easing);
			//My distance = (where I want to go) - where I am
			panels[outPanel].dy = ( panels[outPanel].moveY - panels[outPanel].y);
			//If where I want to go is less than 1, I will stay there
			//Otherwise move a proportional distance to my target "easing" my way there
			if(Math.abs(panels[outPanel].dy) < 1) {
				removeEventListener(Event.ENTER_FRAME, onEaseOut);
				panels[outPanel].frameCounter = 0;
				panels[outPanel].visible = false;
				if(currentPanel != "")
				{
					animateIn();
				}
			} else {
				panels[outPanel].y += panels[outPanel].dy * panels[outPanel].easing;
				for(var i:int = panels[outPanel].tabNumber; i < tabs.length; i++) {
					trace("move tab " + i)
					tabs[i].y += panels[outPanel].dy * panels[outPanel].easing;
				}
			}
			panels[outPanel].frameCounter++;
		}
		
		//This handles opening the Panel frame by frame, until is it done 
		//This is arbitrary X movement, but could allow for any type of movement
		public function onEaseIn(e:Event):void {
			//trace(frameCounter + " -- " + (openX - x) * easing);
			//My distance = (where I want to go) - where I am
			panels[currentPanel].dy = ( panels[currentPanel].moveY - panels[currentPanel].y);
			//If where I want to go is less than 1, I will stay there
			//Otherwise move a proportional distance to my target "easing" my way there
			if(Math.abs(panels[currentPanel].dy) < 1) {
				removeEventListener(Event.ENTER_FRAME, onEaseIn);
				panels[currentPanel].frameCounter = 0;
			} else {
				panels[currentPanel].y += panels[currentPanel].dy * panels[currentPanel].easing;
				for(var i:int = panels[currentPanel].tabNumber; i < tabs.length; i++) {
					trace("move tab " + i)
					tabs[i].y += panels[currentPanel].dy * panels[currentPanel].easing;
				}
			}
			panels[currentPanel].frameCounter++;
		}
	}
}