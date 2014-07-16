package com.gamerisker.editor
{
	import com.gamerisker.manager.SkinManager;
	import com.gamerisker.utils.GUI;

	import feathers.controls.Button;
	import feathers.controls.ScrollContainer;
	import feathers.core.FeathersControl;
	import feathers.events.FeathersEventType;

	import mx.collections.ArrayList;

	public class ScrollContainerEditor extends Editor
	{
		private var m_scrollContainer:ScrollContainer;

		private var m_skin:String;
		private var m_width:int;
		private var m_height:int;
		private var m_enabled:Boolean;

		public function ScrollContainerEditor()
		{
			m_type="ScrollContainer";

			m_scrollContainer=new ScrollContainer;
			m_scrollContainer.addEventListener(FeathersEventType.CREATION_COMPLETE, onCreateComponent);
			addChild(m_scrollContainer)
		}

		override public function create():void
		{
			id=GUI.getInstanteIdNew();
			skin="default_button1";
			width=100;
			height=50;
			enabled=true;
			alpha=1;
		}

		override public function setStyleName(name:String, value:*):void
		{
			m_scrollContainer[name]=value;
		}

		override public function getComponent():FeathersControl
		{
			return m_scrollContainer;
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
			m_scrollContainer.width=m_width;
		}

		override public function get height():Number
		{
			return m_height;
		}

		override public function set height(value:Number):void
		{
			m_height=value;
			m_scrollContainer.height=m_height;
		}

		public function get enabled():Boolean
		{
			return m_enabled;
		}

		public function set enabled(value:Boolean):void
		{
			m_enabled=value;
			m_scrollContainer.isEnabled=value;
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
			list[1]={"Name": "skin", "Value": skin};
			list[2]={"Name": "x", "Value": x};
			list[3]={"Name": "y", "Value": y};
			list[4]={"Name": "width", "Value": width};
			list[5]={"Name": "height", "Value": height};
			list[6]={"Name": "enabled", "Value": enabled};
			list[7]={"Name": "alpha", "Value": alpha};

			return new ArrayList(list);
		}

		override public function toXMLString():String
		{
			var xml:String='<ScrollContainer id="' + id + '" skin="' + skin + '" x="' + x + '" y="' + y + '" width="' + width + '" height="' + height + '" enabled="' + enabled + '" alpha="' + alpha + '"';
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

			return xml+='</ScrollContainer>';
		}

		override public function addEditor(editor:Editor):Editor
		{
			m_scrollContainer.addChild(editor);
			childList.push(editor);
			RookieEditor.getInstante().Tree.update();
			return editor;
		}

		override public function removeEditor(editor:Editor):Editor
		{
			m_scrollContainer.removeChild(editor);

			childList.splice(childList.indexOf(editor), 1);

			return editor;
		}

		override public function xmlToComponent(value:XML):Editor
		{
			id=GUI.getInstanteId(value.@id.toString());
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