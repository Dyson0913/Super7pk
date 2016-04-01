package View.ViewComponent 
{
	import flash.display.MovieClip;		
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	import View.GameView.gameState;
	
	/**
	 * settle present way
	 * @author Dyson0913
	 */
	public class Visual_Settle  extends VisualHandler
	{
		
		public function Visual_Settle() 
		{
			
		}
		
		public function init():void
		{
			var zoneCon:MultiObject = create("zone", [ResName.emptymc]);		
			zoneCon.Create_(3);
			
			state_parse([gameState.END_ROUND]);
		}	
		
		override public function disappear():void
		{			
			setFrame("zone", 1);
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="settle_step")]
		public function settle2(v:Intobject):void
		{
			//patytable提示框
			dispatcher(new Intobject(_model.getValue("winstr"), "winstr_hint"));
			
			dispatcher(new ModelEvent("show_settle_table"));			
		}
		
	}
	
	

}