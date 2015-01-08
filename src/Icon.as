package {
	
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
	
	/////////////////
	// Description //
	/////////////////
	/**
	 * The Icon is one of many objects in a menu
	 *
	 * @category   root.menu.
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.0 (12/23/2014)
	 */

	////////////////
	// Icon Class //
	////////////////	
	public class Icon extends Sprite {
		
		public var image_black:Sprite;
		public var image_white:Sprite;
		public var myBitmapData:BitmapData;
		
		public function Icon(name:String, TAB_SIZE:Number, center:Boolean = false):void {
			this.name = name;
			var icon_size:int = TAB_SIZE/2;
			image_black = loadImage(image_black, "../src/img/"+name+"_icon_black.png", 0, 0 , icon_size, icon_size, center);
			image_white = loadImage(image_white, "../src/img/"+name+"_icon_white.png", 0, 0 , icon_size, icon_size, center);
		}
		
		private function init():void {
			//addChild(image_white);	
		}
		
		private function loadImage(new_mc:Sprite, urlString:String, x:int, y:int, height:int, width:int, center:Boolean ):Sprite {
			new_mc = new Sprite();
			var myLoader:Loader = new Loader(); 
			var url :URLRequest = new URLRequest(urlString);
			var functionOnImageLoaded:Function = onImageLoaded(new_mc, x, y, height, width, center);
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, functionOnImageLoaded);
			myLoader.load(url);
			addChild(new_mc);
			//init();
			return new_mc;
		}
		
		private function onImageLoaded(new_mc:Sprite, x:int, y:int, height:int, width:int, center:Boolean):Function {
			return function(e:Event):void {
				myBitmapData = e.target.content.bitmapData;
				var bitmap = new Bitmap(myBitmapData);
				/* if you set width and height bitmap same with the stage use this */
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
				draw();
			};
		}
		
		public function draw():void {
			/*
			graphics.lineStyle(1, 0x990000, .75);
			graphics.moveTo(0, 0); 
			graphics.lineTo(0, height); 
			graphics.lineTo(width, height); 
			graphics.lineTo(width, 0); 
			graphics.lineTo(0, 0); 
			*/
		}
	}
}