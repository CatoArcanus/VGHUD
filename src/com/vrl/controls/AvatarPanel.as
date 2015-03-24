package com.vrl.controls {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	import com.vrl.UIElement;

	///////////////////////
	// AvatarPanel Class //
	///////////////////////
	public class AvatarPanel extends Panel {
		
		//Objects
		var bg:Sprite;
		
		/**
		* The Avatar panel is a panel like most panels. It is unique in that it needs a bg.
		* FIXME: Get Bg to dynamically change size based on the number of avatars, so that
		* when you scroll the psaces inbetween will register.
		*/
		public function AvatarPanel(panelName:String, width:int, height:int, TAB_SIZE:Number, leftSide:Boolean, verticalMover:Boolean, stageRef:Stage, scrollerHeight:Number):void {
			bg = new Sprite();
			addChild(bg);
			super(panelName, width, height, TAB_SIZE, leftSide, verticalMover, stageRef, scrollerHeight);
			
			//Format for text
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = TAB_SIZE*.30;
			myFormat.font = "Arial";
			
			//BG
			bg.graphics.beginFill(0x000000, 0.8); 
			bg.graphics.drawRect(0, 0, this.myWidth, this.myHeight); 
			bg.graphics.endFill();
			bg.x = 0;
			bg.y = 0;

			//debugAvatarMC();
			
			//Scroller
			initialize();
		}
		
		//Add objects to stage
		private function initialize():void {
			this.draw();
		}
		
		//Largely for testing
		//FIXME: Delete this function		
		private function debugAvatarMC() {
			//labelContainer = new Sprite();
			for(var i:int = 0; i < 5; i++) {
				for(var j:int = 0; j < 9; j++) {
					trace(i +","+ j);
					var temp:Sprite = new Sprite();
					temp.graphics.beginFill(0xFF0000, 0.8); 
					temp.graphics.drawRect(0, 0, 140, 140); 
					temp.graphics.endFill();
					temp.x = i*150+(TAB_SIZE/8);
					temp.y = j*150+(TAB_SIZE/8);
					labelContainer.addChild(temp);
				}
			}
		}
	}
}