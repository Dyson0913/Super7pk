package View.ViewComponent 
{
	import asunit.errors.AbstractError;
	import caurina.transitions.properties.DisplayShortcuts;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * Paytable present way
	 * @author Dyson0913
	 */
	public class Visual_ProbData  extends VisualHandler
	{
		public static const prob_square:String = "prob";		
		public function Visual_ProbData() 
		{
			
		}
		
		public function init():void
		{			
			var pro:MultiObject = create("prob",  [prob_square]);	
			pro.container.x = 384;
			pro.container.y =  176;
			pro.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			pro.Post_CustomizedData = [6, 50, 50];
			pro.Create_(6);
			
			put_to_lsit(pro);	
		}
	
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{			
			Get("prob").container.visible = false;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function opencard_parse():void
		{
			Get("prob").container.visible = true;
			
			var zero:Array = utilFun.Random_N(0, 6);
			zero.push(-1);
			_model.putValue("percent_prob",zero);		
			prob_update();
			
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="caculate_prob")]
		public function prob_percentupdate():void
		{			
			dispatcher(new StringObject("sound_prob","sound" ) );
			prob_update();
			
		}
		
		public function prob_update():void
		{
			var percentlist:Array = _model.getValue("percent_prob");	
			var ln:int = percentlist.length - 1;				
			var hiest:int = percentlist[percentlist.length-1];			
			for ( var i:int = 0; i < ln; i ++ )
			{				
				var per:int = percentlist[i];
				var gowithd:int =  125 * (per /100);
				Tweener.addTween(GetSingleItem("prob", i)["_mask"], { width:gowithd, time:1, onUpdate:this.percent, onUpdateParams:[GetSingleItem("prob", i), per, 5,hiest == i] } );
			}
		}
		
		public function percent(mc:MovieClip,per:int,start:int ,hist:Boolean ):void
		{
			
			if ( !hist) 
			{
				mc["_Text"].text = "";				
				mc["_probBar"].gotoAndStop(1);
				return;
			}			
			if ( mc["_Text"].text == "") mc["_Text"].text = "1";
			
			mc["_probBar"].gotoAndStop(2);
			
			var p:int = (parseInt( mc["_Text"].text) +start );
			if (p >= per) p = per;
			
			mc["_Text"].text = p.toString() + "%";
			mc["_Text"].textColor = 0xFFDD00;
			
			//position follow
			//var po:Number = mc["_mask"].x + mc["_mask"].width;
			//mc["_Text"].x = po;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function settle_parse():void
		{			
			Get("prob").container.visible = false;		
		}
		
	}

}