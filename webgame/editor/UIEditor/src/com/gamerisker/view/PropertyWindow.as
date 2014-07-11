package com.gamerisker.view
{
	import com.gamerisker.core.Define;
	import com.gamerisker.editor.Editor;
	import com.gamerisker.manager.ControlManager;
	
	import feathers.events.FeathersEventType;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.managers.PopUpManager;
	
	import spark.components.DataGrid;
	import spark.components.Panel;
	import spark.components.TitleWindow;

	public class PropertyWindow
	{
		private var m_target : Editor;
		private var m_rowIndex : int;
		
		private var m_panel : EditorWindow = new EditorWindow;
		public var myDataGrid:DataGrid;
		private static var _instance:PropertyWindow;
		public static function instance(value:DataGrid=null):PropertyWindow{
			if(_instance==null){
				_instance=new PropertyWindow(value);
			}
			return _instance;
		}
		public function PropertyWindow(value:DataGrid)
		{
			myDataGrid=value;
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
		
		public function setTarget(component : Editor) : void
		{
			m_target = component;
			
//			if(component)panel.title ="属性 : " + m_target.type;
			
			updatePropVeiw();
		}
		
		/**
		 * 设置当前皮肤
		 *   
		 */
		public function setSkin(type : String , skin : String) : Boolean
		{
			if(m_target.type == type)
			{
				m_target["skin"] = skin;
				
				m_target.addEventListener(FeathersEventType.CREATION_COMPLETE , updatePoint);
				
				updatePropVeiw();
				
				return true;
			}
			
			return false;
		}
		
		private function updatePoint(event : *) : void
		{
			ControlManager.updatePoint();
			m_target.removeEventListener(FeathersEventType.CREATION_COMPLETE,updatePoint);
		}
		
		/**
		 *	刷新表格中的组件属性 
		 * 
		 */		
		public function ResetProperty() : void
		{
//			if(isPopUp)
//			{
				setTarget(m_target);
				ControlManager.updatePoint();
//			}
		}
		
		/**
		 * 更新视图属性 
		 * 
		 */		
		public function updatePropVeiw() : void
		{
			if(myDataGrid==null) return;
			if(!m_target)
			{
				myDataGrid.dataProvider = new ArrayList;
				return;
			}
			myDataGrid.dataProvider = m_target.toArrayList();
			
			//				RookieEditor.getInstante().Tree.update();		//Tree 必须在Code之上
			RookieEditor.getInstante().Code.update();
		}
		
		public function OnDoubleClick(event : MouseEvent) : void
		{
			var selected : Object =myDataGrid.selectedItem;
			
			if(selected)
			{
				if(selected["Name"] == "skin")
				{
					RookieEditor.getInstante().Skin.open();
					RookieEditor.getInstante().Skin.activate();
					RookieEditor.getInstante().Skin.setSkin(m_target.type);
				}
				else
				{
					showWindow(selected,m_target);
				}
			}
		}
		
		
		
		public function hideWindow() : void{PopUpManager.removePopUp(m_panel)}
		public function showWindow(value : Object,target : Editor) : void
		{
//			m_panel.x = (this.width - m_panel.width) >> 1;
//			m_panel.y = (this.height - m_panel.height) >> 1;
			
			PopUpManager.addPopUp(m_panel,myDataGrid);
			
			m_panel.setTarget(value,target);
		}
	}
}