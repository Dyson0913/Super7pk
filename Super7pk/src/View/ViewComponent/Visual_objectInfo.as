package View.ViewComponent 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	import flash.text.TextFieldAutoSize;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * Visual_objectInfo present way
	 * @author ...
	 */
	public class Visual_objectInfo  extends VisualHandler
	{	
		public var recoderEvent:Boolean = false;
		
		public var spr:Sprite;
		private var g_temp:Graphics;
		
		//line
		public var g_line:Graphics;
		
		
		
		public function Visual_objectInfo() 
		{
			
		}
		
		public function init():void
		{			
			spr = new Sprite();
			add(spr);
			g_temp = spr.graphics;
		}
		
		//===========================================================================================
		
		
		public function select_object_mouse_down(e:Event,oldx:Number,oldy:Number):void
		{
			
			if ( _model.getValue("select_object") == null)
			{
				if ( recoderEvent) 
				{
					dispatcher(new ArrayObject([e.currentTarget], "select_object"));
					//utilFun.Log("dispatcher"));
				}
				return;
			}
			
		    utilFun.Log("mod" +_model.getValue("select_object"));
			var selectob:Array = _model.getValue("select_object");
			
			var selectitem:MultiObject = prepare("select", new MultiObject(), GetSingleItem("_view").parent.parent);	
			selectitem.container.x = 10;
			selectitem.container.y = 10;
			selectitem.Create_by_native(selectob.length, [Createitem("stt",0xFFFF00)], 0, 0, selectob.length, 0, 0, "time_");
			//selectob.addEventListener(MouseEvent.MOUSE_DOWN, onPickup, false, 0, true);
			
		}		
		
		/******************** 元件 ********************/
		
		private	function Createitem(text:String,color:uint,align:String = TextFieldAutoSize.LEFT):TextField
		{
			var tx:TextField = new TextField();
			tx.background = true;
			tx.backgroundColor  = color;
			tx.text = text;
			tx.width = tx.textWidth;
			tx.height = tx.height;
			tx.selectable = false;
			tx.autoSize = align;
			return tx;
		}
		
		
	}

}