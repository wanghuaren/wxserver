package com.gamerisker.editor
{
	import com.gamerisker.themes.AeonDesktopTheme;
	import com.gamerisker.utils.GUI;
	
	import feathers.controls.ScrollText;
	import feathers.events.FeathersEventType;
	
	import flash.text.TextFormat;
	
	import mx.collections.ArrayList;
	import mx.utils.ObjectUtil;

	public class ScrollTextEditor extends Editor
	{
		private var m_scrollText : ScrollText;
		private var m_width : Number;
		private var m_height : Number;
		private var m_text : String;
		private var m_fontBold : Boolean;
		private var m_fontColor : uint;
		private var m_align : String;
		private var m_fontName : String;
		private var m_fontSize : int;
		private var globalTextFormat:TextFormat;
		public function ScrollTextEditor()
		{
			m_type = "ScrollText";
			
			m_scrollText = new ScrollText;
			m_scrollText.addEventListener(FeathersEventType.CREATION_COMPLETE , onCreateComponent);
			addChild(m_scrollText);
		}

		override public function create():void
		{
			initGlobalTextFormat();
			id = GUI.getInstanteIdNew();
			width = 100;
			height = 100;
			alpha = 1;
			text = "scrollText";
			fontBold = true;
			color = 0x000000;
			align = "left";
			fontName = "Verdana";
			fontSize = 12;
		}
		private function initGlobalTextFormat():void{
			if(globalTextFormat==null){
				globalTextFormat=new TextFormat();
				var m_properties_array:Array=ObjectUtil.getClassInfo(AeonDesktopTheme.m_headerTitleTextFormat).properties as Array;
				for each(var m_proper:String in m_properties_array){
					globalTextFormat[m_proper]=AeonDesktopTheme.m_defaultTextFormat[m_proper];
				}
			}
		}
		override public function get width():Number
		{
			return m_width;
		}

		override public function set width(value:Number):void
		{
			m_width = value;
		}

		override public function get height():Number
		{
			return m_height;
		}

		override public function set height(value:Number):void
		{
			m_height = value;
		}

		override public function set alpha(value:Number):void
		{
			m_scrollText.alpha = value;	
		}
		
		override public function get alpha():Number
		{
			return m_scrollText.alpha;
		}

		public function get text():String
		{
			return m_text;
		}

		public function set text(value:String):void
		{
			m_text = value;
			m_scrollText.text = value;
		}

		public function get fontBold():Boolean
		{
			return m_fontBold;
		}

		public function set fontBold(value:Boolean):void
		{
			m_fontBold = value;
			globalTextFormat.bold=value;
			
			var m_textFormat:TextFormat=new TextFormat();
			var m_properties_array:Array=ObjectUtil.getClassInfo(globalTextFormat).properties as Array;
			for each(var m_proper:String in m_properties_array){
				m_textFormat[m_proper]=globalTextFormat[m_proper];
			}
			m_scrollText.textFormat=m_textFormat;
		}

		public function get color():uint
		{
			return m_fontColor;
		}

		public function set color(value:uint):void
		{
			m_fontColor = value;
			globalTextFormat.color=value;
			
			var m_textFormat:TextFormat=new TextFormat();
			var m_properties_array:Array=ObjectUtil.getClassInfo(globalTextFormat).properties as Array;
			for each(var m_proper:String in m_properties_array){
				m_textFormat[m_proper]=globalTextFormat[m_proper];
			}
			m_scrollText.textFormat=m_textFormat;
		}

		public function get align():String
		{
			return m_align;
		}

		public function set align(value:String):void
		{
			m_align = value;
			globalTextFormat.align=value;
			
			var m_textFormat:TextFormat=new TextFormat();
			var m_properties_array:Array=ObjectUtil.getClassInfo(globalTextFormat).properties as Array;
			for each(var m_proper:String in m_properties_array){
				m_textFormat[m_proper]=globalTextFormat[m_proper];
			}
			m_scrollText.textFormat=m_textFormat;
		}

		public function get fontName():String
		{
			return m_fontName;
		}

		public function set fontName(value:String):void
		{
			m_fontName = value;
			globalTextFormat.font=value;
			
			var m_textFormat:TextFormat=new TextFormat();
			var m_properties_array:Array=ObjectUtil.getClassInfo(globalTextFormat).properties as Array;
			for each(var m_proper:String in m_properties_array){
				m_textFormat[m_proper]=globalTextFormat[m_proper];
			}
			m_scrollText.textFormat=m_textFormat;
		}

		public function get fontSize():int
		{
			return m_fontSize;
		}

		public function set fontSize(value:int):void
		{
			m_fontSize = value;
			globalTextFormat.size=value;
			
			var m_textFormat:TextFormat=new TextFormat();
			var m_properties_array:Array=ObjectUtil.getClassInfo(globalTextFormat).properties as Array;
			for each(var m_proper:String in m_properties_array){
				m_textFormat[m_proper]=globalTextFormat[m_proper];
			}
			m_scrollText.textFormat=m_textFormat;
		}
		
		override public function toCopy():Editor
		{
			var _text : ScrollTextEditor = new ScrollTextEditor();
			_text.xmlToComponent(new XML(toXMLString()));
			_text.id = GUI.getInstanteIdNew();
			return _text;
		}
		
		override public function toXMLString():String
		{
			var xml : String = '<ScrollText id="'
				+id+
				'" x="'
				+x+
				'" y="'
				+y+
				'" width="'
				+width+
				'" height="'
				+height+
				'" alpha="'
				+alpha+
				'" text="'
				+text+
				'" fontBold="'
				+fontBold + 
				
				'" color="'
				+color + 
				'" align="'
				+align + 
				'" fontName="'
				+fontName + 
				'" fontSize="'
				+fontSize + 				
				'"';
			
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
			
			return xml += '</ScrollText>';
		}
		
		override public function toArrayList():ArrayList
		{
			var list : Array = new Array
			list[0] = {"Name" : "id" , "Value" : id};
			list[1] = {"Name" : "text" , "Value" : text};
			list[2] = {"Name" : "fontBold" , "Value" : fontBold};
			list[3] = {"Name" : "color" , "Value" : "0x"+color.toString(16).toLocaleUpperCase()};
			list[4] = {"Name" : "align" , "Value" : align};
			list[5] = {"Name" : "fontSize" , "Value" : fontSize};
			list[6] = {"Name" : "alpha" , "Value" : alpha};
			list[7] = {"Name" : "x" , "Value" : x};
			list[8] = {"Name" : "y" , "Value" : y};
			list[9] = {"Name" : "width" , "Value" : width};
			list[10] = {"Name" : "height" , "Value" : height};
			return new ArrayList(list);
		}
		
		override public function xmlToComponent(value:XML):Editor
		{
			initGlobalTextFormat();
			id = GUI.getInstanteId(value.@id.toString());
			width = int(value.@width);
			height = int(value.@height);
			text = value.@text.toString();
			fontBold = (value.@fontBold.toString() == "true" ? true : false);
			color = int(value.@fontColor);
			align = value.@align.toString();
			fontSize = int(value.@fontSize);
			alpha = Number(value.@alpha);
			x = int(value.@x);
			y = int(value.@y);
			
			return this;
		}
	}
}