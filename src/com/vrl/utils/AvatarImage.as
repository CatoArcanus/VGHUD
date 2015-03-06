package com.vrl.utils {
	
	import flash.display.Sprite;	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.containers.UILoader;
	import flash.external.ExternalInterface;
	import flash.filters.GlowFilter;
	
	import com.vrl.UIElement;
	import com.vrl.buttons.AbstractButton;
	
	/////////////////
	// Description //
	/////////////////
	/**
	 * The Icon is one of many objects in a menu
	 *
	 * @category   root.menu.z
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.0 (12/23/2014)
	 */

	////////////////
	// Icon Class //
	////////////////	
	public class AvatarImage extends Icon {
				
		public var arrayVal:int;
		public var sprite:AbstractButton;
				
		public function AvatarImage(name:String, TAB_SIZE:Number, arrayVal:int, scaleForm:Boolean = true, center:Boolean = false):void {
			super(name, TAB_SIZE);
			this.arrayVal = arrayVal;
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(MouseEvent.MOUSE_OVER, handleIsOver);
		}
		
		private function onClick(e:Event):void {
			ExternalInterface.call("asReceiveClickedProfileImage", arrayVal);
		}
		
		private function handleIsOver( event:MouseEvent ):void {
			//FIXME: Can't put this in init for some reason
			//var sprite:Sprite = Sprite(event.currentTarget);
			sprite = new AbstractButton("", "", this.width, TAB_SIZE);
			sprite.color = 0xFFFFFF;
			sprite.easing = .3;
			sprite.maxAlpha = .5;
			sprite.minAlpha = 0.0;
			sprite.currentAlpha = sprite.minAlpha;
			sprite.fade = sprite.currentAlpha;
			sprite.myHeight = this.height;
			sprite.draw();
			this.addChild(sprite);
			//sprite.highlight();
			this.removeEventListener(MouseEvent.MOUSE_OVER, handleIsOver);		
			//this.addEventListener(MouseEvent.MOUSE_OUT, handleIsOut);		
		}

		private function handleIsOut( event:MouseEvent ):void {
			//var sprite:Sprite = Sprite(event.currentTarget);
			this.filters = [];
			this.removeEventListener(MouseEvent.MOUSE_OUT, handleIsOut);		
			this.addEventListener(MouseEvent.MOUSE_OUT, handleIsOver);		
		}
		
		public function loadAvatarImage(name:String, scaleForm:Boolean = true, center:Boolean = false) {
			var icon_size:int = TAB_SIZE*3;
			var urlString:String = "img://" + name;
			image = loadImage(image, urlString, 0, 0, icon_size, icon_size, center);
		}		
	}
}