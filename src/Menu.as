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
	 * @version    1.1 (12/23/2014)
	 */

	//////////////////
	//* Menu Class *//
	//////////////////	
	public class Menu extends Sprite {
		
		//Properties
		var easing:Number = 0.25;
		var openX:int;
		var closeX:int;
		var moveX:int;
		var dx:int;
		var frameCounter:int = 0;
		public var myWidth:int; 
		public var myHeight:int; 
		
		//variables
		var currentPanel:String = "";
		var outPanel:String = "";
		
		//Objects
		var tabs:Array = new Array();
		var panels:Array = new Array();
		var panelMasks:Array = new Array();
		
		//Menu initializes objects and gives them values
		public function Menu(width:int, height:int, tabNames:Array, TAB_HEIGHT:int):void {
			this.myWidth = width;
			this.myHeight = height;
			
			var tabY:int = 0;
			for each(var tabName:String in tabNames){
				
				var panelMask:Sprite = new Sprite();
				panelMask.graphics.beginFill(0xffFF00); 
				panelMask.graphics.drawRect(0, 0, width, height); 
				panelMask.graphics.endFill(); 
				panelMask.x = width*(-1);
				panelMask.y = 0;
				panelMasks.push(panelMask);
				
				var tab = new Tab(tabName, width, TAB_HEIGHT);
				tab.x = 0;
				tab.y = tabY;
				tab.draw();
				tab.buttonMode=true;
				tab.mouseChildren=false;
				tab.addEventListener(MouseEvent.CLICK, tabClick(tabName));
				tabs.push(tab);
				tabY += TAB_HEIGHT;
				
				var panel = new Panel(tabName, width, height);
				panel.x = 0;
				panel.y = 0;
				panel.closeX = 0;
				panel.openX = width*(-1);
				panel.visible = false;
				panel.mask = panelMask;
				panels[tabName] = panel;
			}
			init();
			draw(width, height);
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
		
		//Draw creates the background of black and 50% opactiy
		public function draw(width, height):void {
			graphics.beginFill(0x000000, .5);
			graphics.drawRect(0, 0, width, height); 
			graphics.endFill();
			
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