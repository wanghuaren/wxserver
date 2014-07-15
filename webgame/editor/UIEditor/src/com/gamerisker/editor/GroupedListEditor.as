package com.gamerisker.editor
{
	import com.gamerisker.manager.SkinManager;
	import com.gamerisker.utils.GUI;
	
	import feathers.controls.Button;
	import feathers.controls.GroupedList;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.IGroupedListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.data.HierarchicalCollection;
	import feathers.events.FeathersEventType;
	
	import mx.collections.ArrayList;

	public class GroupedListEditor extends Editor
	{
		private var m_groupedList:GroupedList;

		private var m_label:String;
		private var m_skin:String;
		private var m_width:int;
		private var m_height:int;
		private var m_enabled:Boolean;

		public function GroupedListEditor()
		{
			m_type="GroupedList";

			m_groupedList=new GroupedList;
			m_groupedList.addEventListener(FeathersEventType.CREATION_COMPLETE, onCreateComponent);
			addChild(m_groupedList)
		}

		override public function create():void
		{
			id=GUI.getInstanteIdNew();
			label="Group1:item11,item12,item13;Group2:item21,item22,item23;Group3:item31,item32,item33";
			skin="default_button1";
			width=100;
			height=50;
			enabled=true;
			alpha=1;
		}

		override public function setStyleName(name:String, value:*):void
		{
			m_groupedList[name]=value;
		}

		override public function getComponent():FeathersControl
		{
			return m_groupedList;
		}

		public function get label():String
		{
			return m_label;
		}

		public function set label(value:String):void
		{
			var m_arr1:Array=value.split(";");
			var m_arr2:Array;
			var m_arr3:Array;
			var m_result:Array;
			var result:Array=[];
			;
			for each (var m_s1:String in m_arr1)
			{
				m_arr2=m_s1.split(":");
				m_arr3=m_arr2[1].split(",");
				m_result=[];
				for each (var m_s2:String in m_arr3)
				{
					m_result.push({text: m_s2});
				}
				result.push({header: m_arr2[0], children: m_result});
			}

			m_label=value;
			m_groupedList.dataProvider=new HierarchicalCollection(result);
			
//			m_groupedList.itemRendererFactory=function():IGroupedListItemRenderer
//			{
//				var m_renderer:DefaultGroupedListItemRenderer=new DefaultGroupedListItemRenderer();
//				m_renderer.labelField="text";
//				return m_renderer;
//			}
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
			m_groupedList.width=m_width;
		}

		override public function get height():Number
		{
			return m_height;
		}

		override public function set height(value:Number):void
		{
			m_height=value;
			m_groupedList.height=m_height;
		}

		public function get enabled():Boolean
		{
			return m_enabled;
		}

		public function set enabled(value:Boolean):void
		{
			m_enabled=value;
			m_groupedList.isEnabled=value;
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

			return new ArrayList(list);
		}

		override public function toXMLString():String
		{
			var xml:String='<GroupedList id="' + id + '" label="' + label + '" skin="' + skin + '" x="' + x + '" y="' + y + '" width="' + width + '" height="' + height + '" enabled="' + enabled + '" alpha="' + alpha + '"';
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

			return xml+='</GroupedList>';
		}

		override public function xmlToComponent(value:XML):Editor
		{
			id=GUI.getInstanteId(value.@id.toString());
			label=value.@label.toString();
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