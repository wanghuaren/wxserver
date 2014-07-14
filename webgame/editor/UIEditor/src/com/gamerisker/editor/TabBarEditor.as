package com.gamerisker.editor
{
	import com.gamerisker.core.Define;
	import com.gamerisker.utils.GUI;
	import com.gamerisker.view.Main;

	import feathers.controls.TabBar;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;

	import mx.collections.ArrayList;

	import starling.display.Stage;

	public class TabBarEditor extends Editor
	{
		private var m_tabBar:TabBar;

		private var m_label:String;
		private var m_skin:String;
		private var m_width:int;
		private var m_height:int;
		private var m_enabled:Boolean;
		private var m_data:ListCollection;

		public function TabBarEditor()
		{
			m_type="TabBar";

			m_tabBar=new TabBar;
			m_tabBar.addEventListener(FeathersEventType.CREATION_COMPLETE, onCreateComponent);
			addChild(m_tabBar)
		}

		override public function create():void
		{
			id=GUI.getInstanteIdNew();
			label="tab1,tab2,tab3";
			skin="default_tabBar1";
			width=100;
			height=50;
			enabled=true;
			alpha=1;
		}

		override public function setStyleName(name:String, value:*):void
		{
			m_tabBar[name]=value;
		}

		override public function getComponent():FeathersControl
		{
			return m_tabBar;
		}

		public function get label():String
		{
			return m_label;
		}

		public function set label(value:String):void
		{
			m_label=value;
			m_data=new ListCollection;
			var m_arr:Array=value.split(",");
			for each (var m_s:String in m_arr)
			{
				m_data.addItem({label: m_s});
			}

			m_tabBar.dataProvider=m_data;
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
			m_tabBar.width=value;
			if (this.name != "T")
			{
				var s:Stage=Define.starlingStg
				if (s != null)
				{
					var i:int=s.numChildren
					while (i > 0)
					{
						i--;
						var o:*=s.getChildAt(i);
						if (o as Main)
						{
							if (o.getChildByName("T") != null)
								o.getChildByName("T").width=value;
							break;
						}
					}
				}
			}
			trace(m_tabBar.width)
		}

		override public function get height():Number
		{
			return m_height;
		}

		override public function set height(value:Number):void
		{
			m_height=value;
			m_tabBar.height=m_height;
			trace(m_tabBar.width)
		}

		public function get enabled():Boolean
		{
			return m_enabled;
		}

		public function set enabled(value:Boolean):void
		{
			m_enabled=value;
			m_tabBar.isEnabled=value;
		}

		override public function toCopy():Editor
		{
			var _btaBbar:TabBarEditor=new TabBarEditor();
			_btaBbar.xmlToComponent(new XML(toXMLString()));
			_btaBbar.id=GUI.getInstanteIdNew();
			return _btaBbar;
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
			var xml:String='<TabBar id="' + id + '" label="' + label + '" skin="' + skin + '" x="' + x + '" y="' + y + '" width="' + width + '" height="' + height + '" enabled="' + enabled + '" alpha="' + alpha + '"';
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

			return xml+='</TabBar>';
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