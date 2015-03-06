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

	////////////////
	// TabInfo Class //
	////////////////	
	public class TabInfo {
		
		//vars
		public var tabName:String;
		public var scaleForm:Boolean;
		public var accordian:Boolean;
		public var peek:Boolean;
		
		public function TabInfo(tabName:String, peek:Boolean, accordian:Boolean, scaleForm:Boolean):void {
			this.tabName = tabName;
			this.accordian = accordian;
			this.peek = peek;
			this.scaleForm = scaleForm;
		}
	}
}