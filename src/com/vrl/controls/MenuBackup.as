package com.vrl.controls {
	
	import flash.display.Sprite;	
	import flash.display.MovieClip;
	import flash.display.Shape;	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.vrl.UIElement;
		
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
	 * @version    1.2 (12/29/2014)
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
		public function Menu(width:int, height:int, tabNames:Array, TAB_SIZE:Number, leftSide:Boolean):void {
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
			var tabY:int = 0;
			for each(var tabName:String in tabNames) {
				//This creates a series of panels. We will move away from this model				
				panelMask = new Sprite();
				panelMask.graphics.beginFill(0xffFF00); 
				panelMask.graphics.drawRect(0, 0, width, height); 
				panelMask.graphics.endFill(); 
				panelMask.x = width*(pos);
				panelMask.y = 0;
				panelMasks.push(panelMask);
				
				//A mask for the panels
				var panel = new Panel(tabName, width, width, height, TAB_SIZE, leftSide);			
				panel.mask = panelMask;
				panels[tabName] = panel;
				
				//A series of tabs is generated based on the list of tab names
				var tab = new Tab(tabName, width, TAB_SIZE, leftSide);
				tab.x = 0;
				tab.y = tabY;
				tab.addEventListener(MouseEvent.CLICK, tabClick(tabName));
				tabs.push(tab);
				tabY += TAB_SIZE+1;
				this.graphics.lineStyle(1, 0xCCCCCC, .75);
				this.graphics.moveTo(0, tabY); 
				this.graphics.lineTo(tab.myWidth, tabY);
			}
			
			//Chat Panel //
			//First custom panel, it is just stubbed for now.
			var panelMask:Sprite = new Sprite();
			var chatPanelWidth:int = width*2;
			var chatPanel:ChatPanel = new ChatPanel("Chat", width, chatPanelWidth, height, TAB_SIZE, leftSide);
			panelMask.graphics.beginFill(0xffFF00); 
			panelMask.graphics.drawRect(0, 0, chatPanelWidth, height); 
			panelMask.graphics.endFill(); 
			if(leftSide){
				panelMask.x = this.myWidth;
			} else {
				panelMask.x = chatPanelWidth*(pos);
			}
			panelMask.y = 0;
			panelMasks.push(panelMask);
			chatPanel.mask = panelMask;
			panels["Chat"] = chatPanel;
			
			panelMask = new Sprite();
			var possessPanelWidth:int = TAB_SIZE*6;
			var possessPanel:PossessPanel = new PossessPanel("Possess", width, possessPanelWidth, height, TAB_SIZE, leftSide);
			panelMask.graphics.beginFill(0xffFF00); 
			panelMask.graphics.drawRect(0, 0, possessPanelWidth, height); 
			panelMask.graphics.endFill(); 
			if(leftSide){
				panelMask.x = this.myWidth;
			} else {
				panelMask.x = possessPanelWidth*(pos);
			}
			panelMask.y = 0;
			panelMasks.push(panelMask);
			possessPanel.mask = panelMask;
			panels["Possess"] = possessPanel;
			
			/*
			//var tabNames:Array = new Array("Chat", "Kick", "Avatars", "Possess", "Scenario");
			//Chat Panel
			panels["Chat"].myWidth = 600;
			panels["Chat"].draw();
			//Kick Panel
			panels["Kick"].draw();
			
			//Avatar Panel
			panels["Avatars"].draw();
			
			//Possession Panel
			panels["Possess"].draw();
			
			//Scenario Panel
			panels["Scenario"].draw();
			*/
			init();
		}
		
		private function tabClick(panelName:String):Function {
			return function(e:MouseEvent):void {
				for each(var tab:Tab in tabs) {
					trace("Looking at: " + tab.buttonName);
					if(tab.buttonName == currentPanel) {
						trace("Found tab named " + currentPanel + "setting it's minAlpha to 0.0");
						tab.minAlpha = 0.0;
						tab.unHighlight();
					}
					
					if(tab.buttonName == panelName) {
						trace("Found tab named " + panelName + "setting it's minAlpha to 0.3");
						tab.minAlpha = 0.5;
					}
				}
				trace( "function: " + panelName);
				animateOut(panelName);
			};
		}
		
		//Init Adds resources to stage and sets up initial event listeners
		private function init():void {
			for each(var panelMask:Sprite in panelMasks){
				addChild(panelMask);
			}
			for each(var tab:Tab in tabs){
				addChild(tab);
			}
			for (var key:String in panels){
				addChild(panels[key]);
			}
		}
				
		public function animateOut(panelName:String):void {
			trace("Animate out: " + currentPanel);
			if(currentPanel != "") {
				outPanel = currentPanel;
				panels[outPanel].moveX = panels[outPanel].closeX;
				addEventListener(Event.ENTER_FRAME, onEaseOut);
				currentPanel = panelName;
			} else {
				currentPanel = panelName;
				animateIn();
			}
		}
	
		public function animateIn():void {
			trace("Animate in: " + currentPanel);
			panels[currentPanel].visible = true;
			panels[currentPanel].moveX = panels[currentPanel].openX;
			addEventListener(Event.ENTER_FRAME, onEaseIn);
		}
		
		//This handles closing the Menu frame by frame, until is it done 
		//This is arbitrary X movement, but could allow for any type of movement
		public function onEaseOut(e:Event):void {
			//trace(frameCounter + " -- " + (openX - x) * easing);
			//My distance = (where I want to go) - where I am
			panels[outPanel].dx = ( panels[outPanel].moveX - panels[outPanel].x);
			//If where I want to go is less than 1, I will stay there
			//Otherwise move a proportional distance to my target "easing" my way there
			if(Math.abs(panels[outPanel].dx) < 1) {
				removeEventListener(Event.ENTER_FRAME, onEaseOut);
				panels[outPanel].frameCounter = 0;
				panels[outPanel].visible = false;
				animateIn();
			} else {
				panels[outPanel].x += panels[outPanel].dx * panels[outPanel].easing;
			}
			panels[outPanel].frameCounter++;
		}
		
		//This handles opening the Menu frame by frame, until is it done 
		//This is arbitrary X movement, but could allow for any type of movement
		public function onEaseIn(e:Event):void {
			//trace(frameCounter + " -- " + (openX - x) * easing);
			//My distance = (where I want to go) - where I am
			panels[currentPanel].dx = ( panels[currentPanel].moveX - panels[currentPanel].x);
			//If where I want to go is less than 1, I will stay there
			//Otherwise move a proportional distance to my target "easing" my way there
			if(Math.abs(panels[currentPanel].dx) < 1) {
				removeEventListener(Event.ENTER_FRAME, onEaseIn);
				panels[currentPanel].frameCounter = 0;
			} else {
				panels[currentPanel].x += panels[currentPanel].dx * panels[currentPanel].easing;
			}
			panels[currentPanel].frameCounter++;
		}
	}
}