package com.gamerisker.view
{
	import com.gamerisker.core.Define;
	import com.gamerisker.editor.Editor;
	import com.gamerisker.manager.ControlManager;
	import com.gamerisker.manager.TexturesManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import mx.controls.Alert;
	import mx.controls.Tree;
	
	import spark.components.CheckBox;
	import spark.components.Panel;
	import spark.components.TitleWindow;
	
	import starling.display.Sprite;

	public class TreeWindow
	{
		private var myTree:Tree;
		private static var _instance:TreeWindow;
		public static function instance(value:Tree=null):TreeWindow{
			if(_instance==null){
				_instance=new TreeWindow(value);
			}
			if(value!=null){
				_instance.myTree=value;
			}
			return _instance;
		}
		public function TreeWindow(value:Tree)
		{
			if(value!=null){
				myTree=value;
			}
		}
		
		private var _xml : String;
		
		public function get xml() : String{return _xml}
		
		private var xmlList : XMLList;
		
		private var list : Array = new Array;
		
		// Event handler for the Tree control change event.
		public function treeChanged(evt:Event):void 
		{
			var check : CheckBox;
			var editor : Editor;
			if(myTree.selectedItem)
			{
				var id : String = myTree.selectedItem.@id;
				var component : Editor = getComponent(id , Define.editorContainer);
				ControlManager.target = component;
				
				check = evt.target as CheckBox;
				editor = ControlManager.getCurrentComponent();
				if(check && editor)
				{
					switch(check["id"])
					{
						case "mouseCheck" :
							editor.touchable = !check.selected;
							break
						case "visiCheck" :
							editor.visible = !check.selected;
							break
					}
				}
			}
		}
		
		private function getComponent(id : String,container : starling.display.Sprite) : Editor
		{
			var component : Editor;
			var pon : Editor;
			var temp : Editor;
			
			var index : int=0;
			
			if(!container)return null;
			
			if(container.hasOwnProperty("id")&&container["id"]==id)
				return container as Editor;
			
			while(container.numChildren > index)
			{
				temp = container.getChildAt(index) as Editor;
				pon = getComponent(id,temp);
				index++;
				if(pon)return pon;
			}
			return null;
		}
		
		private function Init() : void
		{
//			statusBar.height = 3;
//			panel.titleDisplay.addEventListener(MouseEvent.MOUSE_DOWN,OnStartDrag);
		}
		
		private function OnStartDrag(event : MouseEvent) : void
		{
//			this.nativeWindow.startMove();
		}
		
		public function update() : void
		{
			if(myTree==null)return;
			var index:int = 0;
			var component : Editor;
			var xmlString : String = "";
			var numChildren : int = Define.editorContainer.numChildren;
			
			var s_xml : String = "";
			
			while(numChildren > index)
			{
				component = Define.editorContainer.getChildAt(index) as Editor;
				if(component)
				{
					s_xml += component.toXMLString();
				}
				index++;
			}
			
			SetTreeXml("<stage>"+ s_xml +"</stage>");
		}
		
		/**
		 * 设置选种
		 * @param id 
		 */
		public function selectItem(id : String) : void
		{
			var index : int = list.indexOf(id);
			
			for each(var item : Object in list)
			{
				if(item.@id.toString() == id)
					myTree.selectedItem = item;
			}
		}
		
		public function SetTreeXml(value : String) : void
		{
//			if(_xml!=value && isPopUp)
//			{
				list.length = 0;
				try
				{
					if(value == "<stage></stage>")
					{
						xmlList = new XMLList();
					}
					else
					{
						xmlList = new XMLList(value);
					}
				}
				catch(e : Error)
				{
					Alert.show("TreeWindow : " + value);
				}
				
				myTree.dataProvider = null;
				myTree.dataProvider = xmlList;
				
//				myTree.validateNow();
				myTree.invalidateList();
				
				setTimeout(expandItem,100);
//			}
			
			_xml = value;
		}
		
		private function expandItem() : void
		{
			for each(var item : Object in list)
			{
				myTree.expandItem(item,true);
			}
		}
		
		public function IconFunction(item:Object) : Class
		{
			var iconClass:Class;
			
			switch (XML(item).localName()) 
			{
				case "Button":
					iconClass = TexturesManager.ButtonIcon;
					break;
				case "ImageButton":
					iconClass = TexturesManager.ImageButtonIcon;
					break;
				case "CheckBox":
					iconClass = TexturesManager.CheckBoxIcon;
					break;
				case "ComboBox":
					iconClass = TexturesManager.ComboBoxIcon;
					break;
				case "Label":
					iconClass = TexturesManager.LabelIcon;
					break;
				case "List":
					iconClass = TexturesManager.ListIcon;
					break;
				case "RadioButton":
					iconClass = TexturesManager.RadioButtonIcon;
					break;
				case "Slider":
					iconClass = TexturesManager.SliderIcon;
					break;
				case "Tile":
					iconClass = TexturesManager.TileIcon;
					break;
				case "TileGroup":
					iconClass = TexturesManager.TileGroupIcon;
					break;
				case "TitleWindow":
					iconClass = TexturesManager.TitleWindowIcon;
					break;
				case "SkinImage":
					iconClass = TexturesManager.SkinImageIcon;
					break;
				case "SkinFrame":
					iconClass = TexturesManager.SkinFrameIcon;
					break;
				case "ImageNumber" :
					iconClass = TexturesManager.ImageNumberIcon;
					break
			}
			return iconClass;
		}
		
		public function LabelFunction(item : Object) : String
		{
			if(item.@id.toString() !="" && list.indexOf(item) == -1)
			{
				list.push(item);
			}
			
			return item.@id.toString();
		}
		
		public function OnStop(event : MouseEvent) : void
		{
			event.stopPropagation();
		}
	}
}