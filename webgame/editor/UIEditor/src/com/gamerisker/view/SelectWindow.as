package com.gamerisker.view
{
	import com.gamerisker.manager.MouseManager;
	import com.gamerisker.manager.TexturesManager;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import spark.components.Panel;
	import spark.components.TitleWindow;

	public class SelectWindow
	{
		public var panel:Panel;
		private static var _instance:SelectWindow;
		public static function get instance():SelectWindow{
			if(_instance==null){
				_instance=new SelectWindow();
			}
			return _instance;
		}
		public function SelectWindow()
		{
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
		
		public function OnComponentClick(event : MouseEvent) : void
		{
			var bitmap : flash.display.Sprite = TexturesManager.getIcon(event.target.name);
			bitmap.mouseChildren = bitmap.mouseEnabled = false;
			bitmap.x = 100;
			bitmap.y = 100;
			MouseManager.AddBand(bitmap,event.target.name);
		}
		
		public function OnComponentRemove(event : MouseEvent) : void
		{
			if(MouseManager.GetBand())
			{
				MouseManager.RemoveBand();
			}
		}
	}
}