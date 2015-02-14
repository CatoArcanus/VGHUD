package com.vrl.controls {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	import com.vrl.UIElement; 

	/////////////////
	// Description //
	/////////////////
	/**
	 * The AvatarWindow is extended from the Window class and is very specific in its
	 * implementation
	 *
	 * @category   root.menu.panel
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.3 (01/13/2015)
	 */

	//////////////////////
	// AvatarWindow Class //
	//////////////////////
	public class AvatarWindow extends Window {
		
		//Objects
		var bg:Sprite;
		var avatarMC:Sprite;
		var avatarMask:Sprite;
		var scrollerMC:ScrollerMC;
		var TAB_SIZE:Number;
					
		public function AvatarWindow(windowName:String, TAB_SIZE:Number, leftSide:Boolean, stageRef:Stage):void {
			super(windowName, TAB_SIZE*16, TAB_SIZE*25, TAB_SIZE, leftSide, stageRef);
			
			this.TAB_SIZE = TAB_SIZE;
			
			//Format for text
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = TAB_SIZE*.30;
			myFormat.font = "Arial";
			
			//Chat Log BG
			bg = new Sprite();
			bg.graphics.beginFill(0x000000, 0.2); 
			bg.graphics.drawRect(0, 0, this.myWidth, this.myHeight); 
			bg.graphics.endFill();
			bg.x = 0;
			bg.y = 0;
			
			//AvatarMC Mask
			avatarMask = new Sprite();
			avatarMask.graphics.beginFill(0xFFFF00, 1.0); 
			avatarMask.graphics.drawRect(0, 0, this.myWidth, this.myHeight); 
			avatarMask.graphics.endFill();
			avatarMask.x = 0;
			avatarMask.y = 0;
									
			debugAvatarMC();
			avatarMC.mask = avatarMask;
			
			//Scroller
			scrollerMC = new ScrollerMC(avatarMC, TAB_SIZE, stageRef, bg.height);
			scrollerMC.x = bg.width;
			scrollerMC.y = bg.y;
			initialize();
		}
		
		//Add objects to stage
		private function initialize():void {
			addChild(bg);
			addChild(avatarMC);
			addChild(avatarMask);
			addChild(scrollerMC);
			this.draw();
		}
		
		private function debugAvatarMC() {
			avatarMC = new Sprite();
			for(var i:int = 0; i < 5; i++) {
				for(var j:int = 0; j < 9; j++) {
					trace(i +","+ j);
					var temp:Sprite = new Sprite();
					temp.graphics.beginFill(0xFF0000, 0.8); 
					temp.graphics.drawRect(0, 0, 140, 140); 
					temp.graphics.endFill();
					temp.x = i*150+(TAB_SIZE/8);
					temp.y = j*150+(TAB_SIZE/8);
					avatarMC.addChild(temp);
				}
			}
		}
	}
}