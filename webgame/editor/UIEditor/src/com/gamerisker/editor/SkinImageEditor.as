package com.gamerisker.editor
{
	import com.gamerisker.manager.SkinManager;
	import com.gamerisker.utils.GUI;
	
	import feathers.controls.ImageLoader;
	import feathers.events.FeathersEventType;
	
	import mx.collections.ArrayList;

	public class SkinImageEditor extends Editor
	{
		private var m_skinImage : ImageLoader;
		private var m_skin : String;
		private var m_enabled : Boolean;
		
		public function SkinImageEditor()
		{
			m_type = "SkinImage";
			
			m_skinImage = new ImageLoader;
			m_skinImage.addEventListener(FeathersEventType.CREATION_COMPLETE , onCreateComponent);
			addChild(m_skinImage);
		}

		override public function create():void
		{
			id = GUI.getInstanteIdNew();
			source="";
			skin = "mail_lihe";
			alpha = 1;
			enabled = true;
		}
		
		public function get skin():String
		{
			return m_skin;
		}
		
		public function set skin(value:String):void
		{
			m_skin = value;
			//			m_skinImage.skinInfo = SkinManager.GetSkinImage(value);
		}
		
		override public function get source():Object
		{
			return m_source;
		}
		
		override public function set source(value:Object):void
		{
			m_source = value;
			m_skinImage.source = value;
		}

		public function get enabled():Boolean
		{
			return m_enabled;
		}

		public function set enabled(value:Boolean):void
		{
			m_enabled = value;
			m_skinImage.isEnabled = value;
		}

		override public function set rotation(value:Number):void{m_skinImage.rotation = value;};
		override public function get rotation():Number{return m_skinImage.rotation};
		
		override public function set alpha(value:Number):void{ m_skinImage.alpha = value;}
		override public function get alpha():Number{return m_skinImage.alpha};
		
		override public function set width(value:Number):void{};
		override public function get width():Number{return m_skinImage.width}
		
		override public function set height(value:Number):void{};
		override public function get height():Number{return m_skinImage.height;}
		
		override public function toCopy():Editor
		{
			var _skin : SkinImageEditor = new SkinImageEditor();
			_skin.xmlToComponent(new XML(toXMLString()));
			_skin.id = GUI.getInstanteIdNew();
			return _skin;
		}
		
		override public function toXMLString():String
		{
			var xml : String = '<SkinImage id="'
				+id+
				'" skin="'
				+skin+
				'" source="'
				+source+
				'" x="'
				+x+
				'" y="'
				+y+
				'" alpha="'
				+alpha+
				'" enabled="'
				+enabled+
				'" rotation="'
				+rotation+
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
			
			return xml += '</SkinImage>';
		}
		
		override public function toArrayList():ArrayList
		{
			var list : Array = new Array
			list[0] = {"Name" : "id" , "Value" : id};
			list[1] = {"Name" : "skin" , "Value" : skin};
			list[2] = {"Name" : "source" , "Value" : source};
			list[3] = {"Name" : "enabled" , "Value" : enabled};
			list[4] = {"Name" : "alpha" , "Value" : alpha};
			list[5] = {"Name" : "x" , "Value" : x};
			list[6] = {"Name" : "y" , "Value" : y};
			list[7] = {"Name" : "rotation" , "Value" : rotation};
			return new ArrayList(list);
		}
		
		override public function xmlToComponent(value:XML):Editor
		{
			id = GUI.getInstanteId(value.@id.toString());
			skin = value.@skin.toString();
			source = value.@source.toString();
			enabled = (value.@enabled.toString() == "true" ? true : false);
			alpha = Number(value.@alpha);
			x = int(value.@x);
			y = int(value.@y);
			rotation = Number(value.@rotation);
			
			return this;
		}
	}
}