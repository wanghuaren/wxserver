package com.gamerisker.view
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import spark.components.TitleWindow;
	import com.gamerisker.core.Define;
	
	import spark.components.Group;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	public class EditorScene
	{
		public var panel:TitleWindow
		private static var _instance:EditorScene;
		public static function instance(value:TitleWindow=null):EditorScene{
			if(_instance==null){
				_instance=new EditorScene(value);
			}
			return _instance;
		}
		public function EditorScene(value:TitleWindow)
		{
			panel=value;
			Init();
		}
		
		private var mStarling : Starling;
		//			private var m_title : String;
		
		//			override public function get title():String
		//			{
		//				if(m_title==null || m_title == "")m_title = "editor.xml";
		//			
		//				return m_title
		//			}
		//			override public function set title(value:String):void
		//			{
		//				panel.title = "编辑区 ---> " + value; 
		//				m_title = value;
		//			}
		
		public function setStatsVisble(value : Boolean) : void
		{
			if(value) 
			{
				Starling.current.showStats = true;
				Starling.current.showStatsAt(HAlign.LEFT,VAlign.BOTTOM);
			}
			else 
			{
				Starling.current.showStats = false;
			}
		}
		
		public function setTitleBar(value : Boolean) : void
		{
			var child : DisplayObject = panel.skin["_TitleWindowSkin_Group1"].getChildAt(2)
			child.visible = value;
		}
		
		private function Init() : void
		{
			var child : DisplayObject = panel.skin["_TitleWindowSkin_Group1"].getChildAt(1)
			child.visible = false;
			
			Start();
		}
		
		private function OnStartDrag(event : MouseEvent) : void
		{
			var group : Group = event.target as Group;
			
			if(panel.moveArea == group)
			{
				event.stopImmediatePropagation();
//				this.nativeWindow.startMove();
			}
			
		}
		
		private function Start(event : flash.events.Event = null) : void
		{			
			Define.stg = panel.stage;
			Define.stageWidth = panel.stage.fullScreenWidth;
			Define.stageHeight = panel.stage.fullScreenHeight;
			
			mStarling = new Starling(Main , panel.stage , null,null,"auto", "baseline");
			mStarling.simulateMultitouch = false;
			mStarling.enableErrorChecking = true;
			mStarling.stage.color = 0xcccccc;
			
			mStarling.addEventListener(starling.events.Event.ROOT_CREATED, function(event:starling.events.Event):void
			{
				mStarling.start();
			});
		}
		
		private function OnResize(event : flash.events.Event = null) : void
		{
			if(Define.stg && panel.stage && mStarling)
			{
				mStarling.viewPort = new Rectangle(0,0,panel.stage.stageWidth,panel.stage.stageHeight)
				mStarling.stage.stageWidth = panel.stage.stageWidth;
				mStarling.stage.stageHeight = panel.stage.stageHeight;
				
				Define.Scene_Edit.setStageSize(panel.stage.stageWidth,panel.stage.stageHeight);
			}
		}
	}
}