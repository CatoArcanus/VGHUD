package {
	
	import flash.display.Sprite;	
	import flash.display.MovieClip;
	import flash.display.Shape;	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	///////////////////
	//* Description *//
	///////////////////
	/**
	 * The Menu is the main window that is loaded for the HuD
	 *
	 * @namespace  root.menu
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.0 (12/27/2014)
	 */

	//////////////////
	//* Menu Class *//
	//////////////////	
	public class Menu extends UIElement {
		
		//Properties
		public var none:int;
		
		//variables
		var currentPanel:String = "";
		var outPanel:String = "";
		
		//Objects
		var tabs:Array = new Array();
		var panels:Array = new Array();
		var panelMasks:Array = new Array();
		
		//Menu initializes objects and gives them values
		public function Menu(width:int, height:int, tabNames:Array, TAB_SIZE:Number):void {
			this.easing = .25;
			this.myWidth = width;
			this.myHeight = height;
			this.currentAlpha = .5;
			this.color = 0x000000;				
									
			var tabY:int = 0;
			var panelMask:Sprite = new Sprite();
			for each(var tabName:String in tabNames) {
							
				panelMask = new Sprite();
				panelMask.graphics.beginFill(0xffFF00); 
				panelMask.graphics.drawRect(0, 0, width, height); 
				panelMask.graphics.endFill(); 
				panelMask.x = width*(-1);
				panelMask.y = 0;
				panelMasks.push(panelMask);
				
				var panel = new Panel(tabName, width, height, TAB_SIZE);			
				panel.mask = panelMask;
				panels[tabName] = panel;
				
				var tab = new Tab(tabName, width, tabY, TAB_SIZE);				
				tab.addEventListener(MouseEvent.CLICK, tabClick(tabName));
				tabs.push(tab);
				tabY += TAB_SIZE;
				
			}
			var chatPanel:ChatPanel = new ChatPanel("Chat", width*2, height, TAB_SIZE);
			panelMask.graphics.beginFill(0xffFF00); 
			panelMask.graphics.drawRect(0, 0, width*2, height); 
			panelMask.graphics.endFill(); 
			panelMask.x = width*(-2);
			panelMask.y = 0;
			panelMasks.push(panelMask);
			chatPanel.mask = panelMask;
			panels["Chat"] = chatPanel;
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
			draw();
		}
		
		private function tabClick(panelName:String):Function {
			return function(e:MouseEvent):void {
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
		
		//This handles opening the Menu frame by frame, until is it done 
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