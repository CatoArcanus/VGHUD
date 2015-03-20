package com.vrl {

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
		
		/*
		* This is just a quick "struct" to hold some info related to tabs
		*/
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