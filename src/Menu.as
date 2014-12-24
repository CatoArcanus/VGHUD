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
	 * @category   sprite
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
		
		//variables
		var currentPanel:String = "";
		
		//Objects
		var tabs:Array = new Array();
		var panels:Array = new Array();
		
		//Menu initializes objects and gives them values
		public function Menu(width:int, height:int, tabNames:Array, TAB_HEIGHT:int):void {
			var tabY:int = 0;
			for each(var tabName:String in tabNames){
				trace(tabName);
				var tab = new Tab(tabName, TAB_HEIGHT);
				tab.x = 0;
				tab.y = tabY;
				tab.draw();
				tab.buttonMode=true;
				tab.mouseChildren=false;
				tab.addEventListener(MouseEvent.MOUSE_DOWN, showPanel);
				tabs.push(tab);
				tabY += TAB_HEIGHT;
			}
			init();
			draw(width, height);
		}
		
		//Init Adds resources to stage and sets up initial event listeners
		private function init():void {
			for each(var tab:Tab in tabs){
				addChild(tab);
			}
		}
		
		//Draw creates the background of black and 50% opactiy
		public function draw(width, height):void {
			graphics.beginFill(0x000000, .5);
			graphics.drawRect(0, 0, width, height); 
			graphics.endFill(); 
		}
		
		//This handles opening the Menu frame by frame, until is it done 
		//This is arbitrary X movement, but could allow for any type of movement
		public function onEnterFrame(e:Event):void {
			//trace(frameCounter + " -- " + (openX - x) * easing);
			//My distance = (where I want to go) - where I am
			dx = ( moveX - x);
			//If where I want to go is less than 1, I will stay there
			//Otherwise move a proportional distance to my target "easing" my way there
			if(Math.abs(dx) < 1) {
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				frameCounter = 0;
			} else {
				x += dx * easing;
			}
			frameCounter++;
		}
		
		public function showPanel(e:MouseEvent = null):void {
			animateOut(currentPanel);
			animateIn(e.target.tabName);			
		}
		
		public function animateOut(panelName:String):void {
			trace("Animate out: " + currentPanel);			
		}
	
		public function animateIn(panelName:String):void {
			trace("Animate in: " + panelName);			
			currentPanel = panelName;			
		}
	}
}