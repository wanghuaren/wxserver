package com.gamerisker.manager
{
	import com.gamerisker.core.Define;
	import com.gamerisker.editor.ButtonEditor;
	import com.gamerisker.editor.CheckBoxEditor;
	import com.gamerisker.editor.Editor;
	import com.gamerisker.editor.GroupedListEditor;
	import com.gamerisker.editor.LabelEditor;
	import com.gamerisker.editor.ListEditor;
	import com.gamerisker.editor.NumericStepperEditor;
	import com.gamerisker.editor.PageIndicatorEditor;
	import com.gamerisker.editor.PickerListEditor;
	import com.gamerisker.editor.ProgressBarEditor;
	import com.gamerisker.editor.RadioButtonEditor;
	import com.gamerisker.editor.ScrollContainerEditor;
	import com.gamerisker.editor.ScrollTextEditor;
	import com.gamerisker.editor.SkinImageEditor;
	import com.gamerisker.editor.SliderEditor;
	import com.gamerisker.editor.TabBarEditor;
	import com.gamerisker.editor.TextInputEditor;
	import com.gamerisker.editor.TitleWindowEditor;
	
	import feathers.controls.TabBar;
	
	import mx.controls.Alert;
	
	import starling.events.TouchPhase;

	public class ComponentManager
	{

		/**
		 *	根据XML生成组件
		 * @param xml
		 * @return
		 *
		 */
		public static function setComponentByXML(xml:XML):Editor
		{
			var name:String=xml.localName();
			var editor:Editor=getComponentByClass(name);
			editor.xmlToComponent(xml);

			var child:Editor;
			for each (var item:XML in xml.elements())
			{
				child=setComponentByXML(item);

				if (child)
				{
					editor.addEditor(child);
				}
			}

			MouseManager.AddTouch(TouchPhase.BEGAN, editor, Define.Scene_Edit.OnTouchDownClick);
			MouseManager.AddTouch(TouchPhase.HOVER, editor, Define.Scene_Edit.OnTouchMoveComponent);
			return editor
		}

		/**
		 *	根据组件名获取组件
		 * @param className
		 * @return
		 *
		 */
		public static function getComponentByClass(className:String):Editor
		{
			if (className == null)
				return null;

			switch (className)
			{
				case "Button":
					return new ButtonEditor;
				case "TitleWindow":
					return new TitleWindowEditor;
				case "CheckBox":
					return new CheckBoxEditor;
				case "RadioButton":
					return new RadioButtonEditor;
				case "Label":
					return new LabelEditor;
				case "Slider":
					return new SliderEditor;
				case "SkinImage":
					return new SkinImageEditor;
				case "List":
					return new ListEditor;
				case "TabBar":
					return new TabBarEditor;
				case "TextInput":
					return new TextInputEditor;
				case "ScrollText":
					return new ScrollTextEditor;
				case "GroupedList":
					return new GroupedListEditor;
				case "NumericStepper":
					return new NumericStepperEditor;
				case "PageIndicator":
					return new PageIndicatorEditor;
				case "PickerList":
					return new PickerListEditor;
				case "ProgressBar":
					return new ProgressBarEditor;
				case "ScrollContainer":
					return new ScrollContainerEditor;
			}
			Alert.show("ComponentManager : 没有找到组件", "错误", 4, RookieEditor.getInstante().Editor.panel);
			return null;
		}
	}
}