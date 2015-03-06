package com.vrl.utils {
	
	import flash.display.Sprite;	
	import flash.display.MovieClip;
	import flash.display.Shape;	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import fl.containers.UILoader;
	
	import com.vrl.UIElement;
	
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
	public class Icon extends Sprite {
		
		public var image:Sprite;
		public var other_image:Sprite;
		public var myBitmapData:BitmapData;
		public var TAB_SIZE:int;
		
		public function Icon(name:String, TAB_SIZE:Number, scaleForm:Boolean = true, center:Boolean = false):void {
			this.name = name;
			this.TAB_SIZE = TAB_SIZE;
			var icon_size:int = TAB_SIZE/2;
			//other_image = loadImage(other_image, "../src/img/"+name+"_icon_black.png", 0, 0 , icon_size, icon_size, center);
			var urlString:String = "img://VGHUD.VGHudRight.Src.img." + name + "_icon_white";
			if(!scaleForm) {
				urlString = "../src/img/" + name + "_icon_white.png";
			}
			image = loadImage(image, urlString, 0, 0, icon_size, icon_size, center);
		}
		
		public function loadOtherImage(name:String, scaleForm:Boolean = true, center:Boolean = false) {
			var icon_size:int = TAB_SIZE/2;
			var urlString:String = "img://VGHUD.VGHudRight.Src.img." + name + "_icon_white";
			if(!scaleForm) {
				urlString = "../src/img/" + name + "_icon_white.png";
			}
			other_image = loadImage(image, urlString, 0, 0, icon_size, icon_size, center);
		}			
			
		protected function loadImage(new_mc:Sprite, urlString:String, x:int, y:int, height:int, width:int, center:Boolean ):Sprite {
			new_mc = new Sprite();
			var myLoader:Loader = new Loader(); 
			var url:URLRequest = new URLRequest(urlString);
			var functionOnImageLoaded:Function = onImageLoaded(new_mc, x, y, height, width, center);
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, functionOnImageLoaded);
			myLoader.load(url);
			addChild(new_mc);
			return new_mc;
		}
		
		protected function onImageLoaded(new_mc:Sprite, x:int, y:int, height:int, width:int, center:Boolean):Function {
			trace("imageLoaded");
			return function(e:Event):void {
				myBitmapData = e.target.content.bitmapData;
				var bitmap = new Bitmap(myBitmapData);
				// if you set width and height bitmap same with the stage use this 
				bitmap.height = height;
				bitmap.width = width;
				bitmap.x = x;
				bitmap.y = y;
				if(center) {
					bitmap.x = -width/2;
					bitmap.y = -height/2;
				}
				bitmap.smoothing = true;
				new_mc.addChild(bitmap);
			};
		}		
	}
}