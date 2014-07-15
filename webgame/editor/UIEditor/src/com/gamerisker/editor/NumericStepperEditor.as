package com.gamerisker.editor
{
	import com.gamerisker.manager.SkinManager;
	import com.gamerisker.utils.GUI;

	import feathers.controls.Button;
	import feathers.controls.NumericStepper;
	import feathers.core.FeathersControl;
	import feathers.events.FeathersEventType;

	import mx.collections.ArrayList;

	public class NumericStepperEditor extends Editor
	{
		private var m_numericStepper:NumericStepper;

		private var m_value:Number;
		private var m_min:Number;
		private var m_max:Number;
		private var m_step:Number;
		private var m_skin:String;
		private var m_width:int;
		private var m_height:int;
		private var m_enabled:Boolean;

		public function NumericStepperEditor()
		{
			m_type="Button";

			m_numericStepper=new NumericStepper;
			m_numericStepper.addEventListener(FeathersEventType.CREATION_COMPLETE, onCreateComponent);
			addChild(m_numericStepper)
		}

		override public function create():void
		{
			id=GUI.getInstanteIdNew();
			value=50;
			skin="default_button1";
			width=100;
			height=50;
			enabled=true;
			alpha=1;
			min=0;
			max=100;
			step=1;
		}

		override public function setStyleName(name:String, value:*):void
		{
			m_numericStepper[name]=value;
		}

		override public function getComponent():FeathersControl
		{
			return m_numericStepper;
		}

		public function get value():Number
		{
			return m_value;
		}

		public function set value(value:Number):void
		{
			m_value=value;
			m_numericStepper.value=value;
		}

		public function get min():Number
		{
			return m_min;
		}

		public function set min(value:Number):void
		{
			m_min=value;
			m_numericStepper.minimum=value;
		}

		public function get max():Number
		{
			return m_max;
		}

		public function set max(value:Number):void
		{
			m_max=value;
			m_numericStepper.maximum=value;
		}

		public function get step():Number
		{
			return m_step;
		}

		public function set step(value:Number):void
		{
			m_step=value;
			m_numericStepper.step=value;
		}

		public function get skin():String
		{
			return m_skin;
		}

		public function set skin(value:String):void
		{
			m_skin=value;
//			m_button.skinInfo = SkinManager.GetButtonSkin(value);
		}

		override public function get width():Number
		{
			return m_width;
		}

		override public function set width(value:Number):void
		{
			m_width=value;
			m_numericStepper.width=m_width;
		}

		override public function get height():Number
		{
			return m_height;
		}

		override public function set height(value:Number):void
		{
			m_height=value;
			m_numericStepper.height=m_height;
		}

		public function get enabled():Boolean
		{
			return m_enabled;
		}

		public function set enabled(value:Boolean):void
		{
			m_enabled=value;
			m_numericStepper.isEnabled=value;
		}

		override public function toCopy():Editor
		{
			var _button:ButtonEditor=new ButtonEditor();
			_button.xmlToComponent(new XML(toXMLString()));
			_button.id=GUI.getInstanteIdNew();
			return _button;
		}

		override public function toArrayList():ArrayList
		{
			var list:Array=new Array;
			list[0]={"Name": "id", "Value": id};
			list[1]={"Name": "value", "Value": value};
			list[2]={"Name": "skin", "Value": skin};
			list[3]={"Name": "x", "Value": x};
			list[4]={"Name": "y", "Value": y};
			list[5]={"Name": "width", "Value": width};
			list[6]={"Name": "height", "Value": height};
			list[7]={"Name": "enabled", "Value": enabled};
			list[8]={"Name": "alpha", "Value": alpha};
			list[9]={"Name": "min", "Value": min};
			list[10]={"Name": "max", "Value": max};
			list[11]={"Name": "step", "Value": step};

			return new ArrayList(list);
		}

		override public function toXMLString():String
		{
			var xml:String='<NumericStepper id="' + id + '" value="' + value + '" skin="' + skin + '" x="' + x + '" y="' + y + '" width="' + width + '" height="' + height + '" enabled="' + enabled + '" alpha="' + alpha + '" min="' + min + '" max="' + max + '" step="' + step + '"';
			var leng:int=childList.length;

			if (leng > 0)
			{
				xml+=">";
			}
			else
			{
				return xml+="/>";
			}

			var editor:Editor;
			for (var i:int=0; i < leng; i++)
			{
				editor=childList[i];
				xml+=editor.toXMLString();
			}

			return xml+='</NumericStepper>';
		}

		override public function xmlToComponent(value:XML):Editor
		{
			id=GUI.getInstanteId(value.@id.toString());
			value=value.@value.toString();
			skin=value.@skin.toString();
			width=int(value.@width);
			height=int(value.@height);
			enabled=(value.@enabled.toString() == "true" ? true : false);
			alpha=Number(value.@alpha);
			x=int(value.@x);
			y=int(value.@y);
			min=Number(value.@min);
			max=int(value.@max);
			step=int(value.@step);

			return this;
		}
	}
}