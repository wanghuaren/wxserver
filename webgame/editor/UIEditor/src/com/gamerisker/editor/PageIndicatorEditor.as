package com.gamerisker.editor
{
	import com.gamerisker.manager.SkinManager;
	import com.gamerisker.utils.GUI;
	
	import feathers.controls.Button;
	import feathers.controls.PageIndicator;
	import feathers.core.FeathersControl;
	import feathers.events.FeathersEventType;
	
	import mx.collections.ArrayList;
	
	public class PageIndicatorEditor extends Editor
	{
		private var m_pageIndicatorEditor : PageIndicator;
		
		private var m_pageCount : int;
		private var m_skin : String;
		private var m_width : int;
		private var m_height : int;
		private var m_enabled : Boolean;
		
		public function PageIndicatorEditor()
		{
			m_type = "PageIndicatorEditor";
			
			m_pageIndicatorEditor = new PageIndicator;
			m_pageIndicatorEditor.addEventListener(FeathersEventType.CREATION_COMPLETE , onCreateComponent);
			addChild(m_pageIndicatorEditor)
		}
		
		override public function create():void
		{
			id = GUI.getInstanteIdNew();
			pageCount = 3;
			skin = "default_button1";
			width = 100;
			height = 50;
			enabled = true;
			alpha = 1;
		}

		override public function setStyleName(name:String, value:*):void{m_pageIndicatorEditor[name] = value;	}
		override public function getComponent() : FeathersControl{return m_pageIndicatorEditor;}
		
		public function get pageCount():int{return m_pageCount;}
		public function set pageCount(value:int):void
		{
			m_pageCount = value;
			m_pageIndicatorEditor.pageCount = value;
		}

		public function get skin():String{return m_skin;}
		public function set skin(value:String):void
		{
			m_skin = value;
//			m_button.skinInfo = SkinManager.GetButtonSkin(value);
		}

		override public function get width():Number{return m_width;}
		override public function set width(value:Number):void
		{
			m_width = value;
			m_pageIndicatorEditor.width = m_width;
		}

		override public function get height():Number{return m_height;}
		override public function set height(value:Number):void
		{
			m_height = value;
			m_pageIndicatorEditor.height = m_height;
		}

		public function get enabled():Boolean{return m_enabled;}
		public function set enabled(value:Boolean):void
		{
			m_enabled = value;
			m_pageIndicatorEditor.isEnabled = value;
		}

		override public function toCopy():Editor
		{
			var _button : ButtonEditor = new ButtonEditor();
			_button.xmlToComponent(new XML(toXMLString()));
			_button.id = GUI.getInstanteIdNew();
			return _button;
		}
		
		override public function toArrayList():ArrayList
		{
			var list : Array = new Array;
			list[0] = {"Name" : "id" , "Value" : id};
			list[1] = {"Name" : "pageCount" , "Value" : pageCount};
			list[2] = {"Name" : "skin" , "Value" : skin};
			list[3] = {"Name" : "x" , "Value" : x};
			list[4] = {"Name" : "y" , "Value" : y};
			list[5] = {"Name" : "width" , "Value" : width};
			list[6] = {"Name" : "height" , "Value" : height};
			list[7] = {"Name" : "enabled" , "Value" : enabled};
			list[8] = {"Name" : "alpha" , "Value" : alpha};
			
			return new ArrayList(list);
		}
		
		override public function toXMLString():String
		{
			var xml : String = '<PageIndicator id="'+id+'" pageCount="'+pageCount+'" skin="'+skin+'" x="'+x+'" y="'+y+'" width="'+width+'" height="'+height+'" enabled="'+enabled+'" alpha="'+alpha + '"';
			var leng : int = childList.length;
			
			if(leng > 0)
			{
				xml += ">";
			}
			else
			{
				return xml += "/>";
			}
			
			var editor : Editor;
			for(var i:int=0;i<leng;i++)
			{
				editor = childList[i];
				xml += editor.toXMLString();
			}

			return xml += '</PageIndicator>';
		}
		
		override public function xmlToComponent(value:XML):Editor
		{
			id = GUI.getInstanteId(value.@id.toString());
			pageCount = value.@pageCount.toString();
			skin = value.@skin.toString();
			width = int(value.@width);
			height = int(value.@height);
			enabled = (value.@enabled.toString() == "true" ? true : false);
			alpha = Number(value.@alpha);
			x = int(value.@x);
			y = int(value.@y);
			
			return this;
		}
	}
}