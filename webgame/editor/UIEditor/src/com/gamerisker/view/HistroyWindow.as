package com.gamerisker.view
{
	import com.gamerisker.command.ICommand;
	import com.gamerisker.manager.OperateManager;
	
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	
	import spark.components.List;
	import spark.components.Panel;

	public class HistroyWindow
	{
		public var panel:Panel
		private var list:List;
		private static var _instance:HistroyWindow;
		public static function instance(value:Panel=null):HistroyWindow{
			if(_instance==null){
				_instance=new HistroyWindow(value);
			}
			return _instance;
		}
		public function HistroyWindow(value:Panel)
		{
			panel=value;
			list=value.getElementAt(0) as List;
		}
		private function Init(event : Event) : void
		{
//			statusBar.height = 3;
		}
		
		public function update() : void
		{
			list.dataProvider = new ArrayList(RookieEditor.getInstante().Operate.getList());
		}
		
		public function selectedIndex(value : int) : void
		{
			if(value > -1)
				list.selectedIndex = value;	
		}
		
		public function OnChangeEvent(event : Event) : void
		{
			var command : ICommand = (event.target as List).selectedItem;
			if(command)
				command.execute();
		}
	}
}