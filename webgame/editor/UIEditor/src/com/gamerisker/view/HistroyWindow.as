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
//		public var panel:Panel
		private var list:List;
		private static var _instance:HistroyWindow;
		public static function instance(value:List=null):HistroyWindow{
			if(_instance==null){
				_instance=new HistroyWindow(value);
			}
			if(value!=null){
				_instance.list=value;
			}
			return _instance;
		}
		public function HistroyWindow(value:List)
		{
			list=value;
		}
		private function Init(event : Event) : void
		{
//			statusBar.height = 3;
		}
		
		public function update() : void
		{
			if(list==null) return;
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