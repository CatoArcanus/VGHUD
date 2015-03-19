package com.vrl {

	/////////////////
	// Description //
	/////////////////
	/**
	 * The TabInfo Class is a helper class that holds information about different
	 * types of tabs
	 *
	 * Note: This Class is not a Sprite. It just holds information.
	 *
	 * @category   root
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.0 (01/07/2014)
	 */

	///////////////////
	// TabInfo Class //
	///////////////////
	public class TabInfo {
		
		//vars
		public var name:String;
		public var title:String;
		public var scaleForm:Boolean;
		public var accordian:Boolean;
		public var peek:Boolean;
		public var leftSide:Boolean;
		
		public function TabInfo(name:String, title:String, peek:Boolean, accordian:Boolean, scaleForm:Boolean, leftSide:Boolean):void {
			this.name = name;
			this.title = title;
			this.accordian = accordian;
			this.peek = peek;
			this.scaleForm = scaleForm;
			this.leftSide = leftSide;
		}
	}
}