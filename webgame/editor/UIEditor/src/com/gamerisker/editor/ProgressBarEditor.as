package com.gamerisker.editor
{
	import com.gamerisker.manager.SkinManager;
	import com.gamerisker.utils.GUI;

	import feathers.controls.Button;
	import feathers.controls.ProgressBar;
	import feathers.core.FeathersControl;
	import feathers.events.FeathersEventType;

	import mx.collections.ArrayList;

	public class ProgressBarEditor extends Editor
	{
		private var m_progressBar:ProgressBar;

		private var m_style:Boolean;
		private var m_min:Number;
		private var m_max:Number;
		private var m_val:Number;
		private var m_skin:String;
		private var m_width:int;
		private var m_height:int;
		private var m_enabled:Boolean;

		public function ProgressBarEditor()
		{
			m_type="ProgressBar";

			m_progressBar=new ProgressBar;
			m_progressBar.addEventListener(FeathersEventType.CREATION_COMPLETE, onCreateComponent);
			addChild(m_progressBar)
		}

		override public function create():void
		{
			id=GUI.getInstanteIdNew();
			skin="default_button1";
			style=true;
			min=0;
			max=100;
			val=20;
			width=100;
			height=50;
			enabled=true;
			alpha=1;
		}

		override public function setStyleName(name:String, value:*):void
		{
			m_progressBar[name]=value;
		}

		override public function getComponent():FeathersControl
		{
			return m_progressBar;
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

		public function get style():Boolean
		{
			return m_style;
		}

		public function set style(value:Boolean):void
		{
			m_style=value;
			if (value)
			{
				m_progressBar.direction=ProgressBar.DIRECTION_HORIZONTAL;
			}
			else
			{
				m_progressBar.direction=ProgressBar.DIRECTION_VERTICAL;
			}
		}

		public function set min(value:Number):void
		{
			m_min=value;
			m_progressBar.minimum=value;
		}

		public function get min():Number
		{
			return m_min;
		}

		public function set max(value:Number):void
		{
			m_max=value;
			m_progressBar.maximum=value;
		}

		public function get max():Number
		{
			return m_max;
		}

		public function set val(value:Number):void
		{
			m_val=value;
			m_progressBar.value=value;
		}

		public function get val():Number
		{
			return m_val;
		}

		override public function get width():Number
		{
			return m_width;
		}

		override public function set width(value:Number):void
		{
			m_width=value;
			m_progressBar.width=m_width;
		}

		override public function get height():Number
		{
			return m_height;
		}

		override public function set height(value:Number):void
		{
			m_height=value;
			m_progressBar.height=m_height;
		}

		public function get enabled():Boolean
		{
			return m_enabled;
		}

		public function set enabled(value:Boolean):void
		{
			m_enabled=value;
			m_progressBar.isEnabled=value;
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
			list[1]={"Name": "val", "Value": val};
			list[2]={"Name": "skin", "Value": skin};
			list[3]={"Name": "x", "Value": x};
			list[4]={"Name": "y", "Value": y};
			list[5]={"Name": "width", "Value": width};
			list[6]={"Name": "height", "Value": height};
			list[7]={"Name": "enabled", "Value": enabled};
			list[8]={"Name": "alpha", "Value": alpha};
			list[9]={"Name": "style", "Value": style};
			list[10]={"Name": "min", "Value": min};
			list[11]={"Name": "max", "Value": max};

			return new ArrayList(list);
		}

		override public function toXMLString():String
		{
			var xml:String='<ProgressBar id="' + id + '" val="' + val + '" style="' + style + '" min="' + min + '" max="' + max + '" skin="' + skin + '" x="' + x + '" y="' + y + '" width="' + width + '" height="' + height + '" enabled="' + enabled + '" alpha="' + alpha + '"';
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

			return xml+='</ProgressBar>';
		}

		override public function xmlToComponent(value:XML):Editor
		{
			id=GUI.getInstanteId(value.@id.toString());
			val=value.@val.toString();
			min=value.@min.toString();
			max=value.@max.toString();
			style=(value.@label.toString() == "true" ? true : false);
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