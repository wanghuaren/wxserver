package com.gamerisker.editor
{
	import com.gamerisker.manager.SkinManager;
	import com.gamerisker.utils.GUI;

	import feathers.controls.Button;
	import feathers.controls.PickerList;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;

	import mx.collections.ArrayList;

	public class PickerListEditor extends Editor
	{
		private var m_pickerList:PickerList;

		private var m_label:String;
		private var m_data:String;
		private var m_skin:String;
		private var m_width:int;
		private var m_height:int;
		private var m_enabled:Boolean;

		public function PickerListEditor()
		{
			m_type="PickerList";

			m_pickerList=new PickerList;
			m_pickerList.addEventListener(FeathersEventType.CREATION_COMPLETE, onCreateComponent);
			addChild(m_pickerList)
		}

		override public function create():void
		{
			id=GUI.getInstanteIdNew();
			label="PickerList";
			data="item1,item2,item3"
			skin="default_button1";
			width=100;
			height=50;
			enabled=true;
			alpha=1;
		}

		override public function setStyleName(name:String, value:*):void
		{
			m_pickerList[name]=value;
		}

		override public function getComponent():FeathersControl
		{
			return m_pickerList;
		}

		public function get label():String
		{
			return m_label;
		}

		public function set label(value:String):void
		{
			m_label=value;
			m_pickerList.prompt=value;
		}

		public function get data():String
		{
			return m_data;
		}

		public function set data(value:String):void
		{
			var m_arr:Array=value.split(",");
			var result:Array=[];
			for each (var m_s:String in m_arr)
			{

				result.push({text: m_s});
			}

			m_data=value;
			m_pickerList.dataProvider=new ListCollection(result);
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
			m_pickerList.width=m_width;
		}

		override public function get height():Number
		{
			return m_height;
		}

		override public function set height(value:Number):void
		{
			m_height=value;
			m_pickerList.height=m_height;
		}

		public function get enabled():Boolean
		{
			return m_enabled;
		}

		public function set enabled(value:Boolean):void
		{
			m_enabled=value;
			m_pickerList.isEnabled=value;
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
			list[1]={"Name": "label", "Value": label};
			list[2]={"Name": "skin", "Value": skin};
			list[3]={"Name": "x", "Value": x};
			list[4]={"Name": "y", "Value": y};
			list[5]={"Name": "width", "Value": width};
			list[6]={"Name": "height", "Value": height};
			list[7]={"Name": "enabled", "Value": enabled};
			list[8]={"Name": "alpha", "Value": alpha};
			list[9]={"Name": "data", "Value": data};

			return new ArrayList(list);
		}

		override public function toXMLString():String
		{
			var xml:String='<PickerList id="' + id + '" label="' + label +'" data="' + data + '" skin="' + skin + '" x="' + x + '" y="' + y + '" width="' + width + '" height="' + height + '" enabled="' + enabled + '" alpha="' + alpha + '"';
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

			return xml+='</PickerList>';
		}

		override public function xmlToComponent(value:XML):Editor
		{
			id=GUI.getInstanteId(value.@id.toString());
			label=value.@label.toString();
			data=value.@data.toString();
			skin=value.@skin.toString();
			width=int(value.@width);
			height=int(value.@height);
			enabled=(value.@enabled.toString() == "true" ? true : false);
			alpha=Number(value.@alpha);
			x=int(value.@x);
			y=int(value.@y);

			return this;
		}
	}
}