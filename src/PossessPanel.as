package {
	
	import flash.display.Sprite;	
	import flash.display.Shape;	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.Font;
	import flash.text.TextFormat;
		
	/////////////////
	// Description //
	/////////////////
	/**
	 * The PossessPanel is extended from the Panel class and is very specific in its
	 * implementation
	 *
	 * @category   root.menu.panel
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.1 (12/29/2014)
	 */

	////////////////////////
	// PossessPanel Class //
	////////////////////////	
	public class PossessPanel extends Panel {
		
		//Buttons to do actions
		var ghostButton:IconButton;
		var humanButton:IconButton;
		var labelButton:TextButton;
		
		//List fillable by unrealscript of possessable NPCs
		var possessList:Array = new Array();
			
		public function PossessPanel(panelName:String, menuWidth:int, panelWidth:int, height:int, TAB_SIZE:Number, leftSide:Boolean):void {
			super(panelName, menuWidth, panelWidth, height, TAB_SIZE, leftSide);
			ghostButton = new IconButton("Ghost", TAB_SIZE*2.25);
			ghostButton.y = TAB_SIZE;
			ghostButton.x = TAB_SIZE*.5;
			
			humanButton = new IconButton("Human", TAB_SIZE*2.25);
			humanButton.y = TAB_SIZE;
			humanButton.x = panelWidth - humanButton.width - TAB_SIZE*.5;
			
			labelButton = new TextButton("Show Labels", TAB_SIZE);
			labelButton.y = ghostButton.y+ghostButton.height+TAB_SIZE*.5;
			labelButton.x = panelWidth/2-labelButton.width/2;
			
			initialize();
		}
		
		private function initialize():void {
			addChild(ghostButton);
			addChild(humanButton);
			addChild(labelButton);
		}
	}
}