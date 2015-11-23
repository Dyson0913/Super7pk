package util 
{
	import Model.Model;
	import caurina.transitions.properties.CurveModifiers;
	import Model.valueObject.*;
	
	/**
	 * handle about object Property
	 * @author hhg4092
	 */
	public class objectProperty 
	{
		[Inject]
		public var _model:Model;		
		
		public function objectProperty() 
		{
			
		}
		
		public function init():void
		{			
			
		}
		
		[MessageHandler(type="Model.valueObject.ArrayObject",selector="select_object")]
		public function select_object(arrob:ArrayObject):void
		{			
			utilFun.Log("rese"+arrob.Value);
			_model.getValue("select_object").push(arrob.Value);			
		}
		
	
	}

}