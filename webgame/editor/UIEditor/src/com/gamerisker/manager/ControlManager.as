package com.gamerisker.manager
{

	import com.gamerisker.command.Command;
	import com.gamerisker.core.Define;
	import com.gamerisker.editor.Editor;
	import com.gamerisker.editor.TitleWindowEditor;
	import com.gamerisker.utils.Tool;

	import feathers.core.FeathersControl;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.ReturnKeyLabel;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class ControlManager
	{
		private static var m_editor:Editor;

		private static var m_editorBox:Sprite;

		private static var leftTopBox:starling.display.Image;

		private static var leftBottomBox:starling.display.Image;

		private static var rightBottomBox:starling.display.Image;

		private static var rightTopBox:starling.display.Image;

		private static var centerBox:starling.display.Image;

		private static var leftCenterBox:starling.display.Image;

		private static var rightCenterBox:starling.display.Image;

		private static var topCenterBox:starling.display.Image;

		private static var bottomCenterBox:starling.display.Image;

		private static var highBackground:starling.display.Image;

		private static var highCurrentComponent:Editor;

		private static var copyComponent:FeathersControl;

		public function ControlManager()
		{

		}

		public static function Init():void
		{
			var box:flash.display.Shape=new flash.display.Shape;
			box.graphics.beginFill(0xff0000, 1);
			box.graphics.drawRect(0, 0, 5, 5);
			box.graphics.endFill();
			var bitmap:flash.display.Bitmap=new flash.display.Bitmap;
			var bitmapdata:flash.display.BitmapData=new flash.display.BitmapData(20, 20, true, 0);
			bitmapdata.draw(box, new Matrix(1, 0, 0, 1, 7, 7));
			bitmap.bitmapData=bitmapdata;
			leftTopBox=starling.display.Image.fromBitmap(bitmap);
			leftBottomBox=starling.display.Image.fromBitmap(bitmap);
			rightBottomBox=starling.display.Image.fromBitmap(bitmap);
			rightTopBox=starling.display.Image.fromBitmap(bitmap);
			centerBox=starling.display.Image.fromBitmap(bitmap);
			leftCenterBox=starling.display.Image.fromBitmap(bitmap);
			rightCenterBox=starling.display.Image.fromBitmap(bitmap);
			topCenterBox=starling.display.Image.fromBitmap(bitmap);
			bottomCenterBox=starling.display.Image.fromBitmap(bitmap);
		}

		/**
		 *	添加控制图标事件
		 *
		 */
		private static function AddEvent():void
		{
			RemoveEvent();

			centerBox.addEventListener(TouchEvent.TOUCH, OnCenterTouchEvent);

			leftTopBox.addEventListener(TouchEvent.TOUCH, OnleftTopTouchEvent);
			leftBottomBox.addEventListener(TouchEvent.TOUCH, OnleftBottomTouchEvent);
			rightBottomBox.addEventListener(TouchEvent.TOUCH, OnrightBottomTouchEvent);
			rightTopBox.addEventListener(TouchEvent.TOUCH, OnrightTopTouchEvent);
			leftCenterBox.addEventListener(TouchEvent.TOUCH, OnleftCenterTouchEvent);
			rightCenterBox.addEventListener(TouchEvent.TOUCH, OnrightCenterTouchEvent);
			topCenterBox.addEventListener(TouchEvent.TOUCH, OntopCenterTouchEvent);
			bottomCenterBox.addEventListener(TouchEvent.TOUCH, OnbottomCenterTouchEvent);
		}

		/**
		 *	移除控制图标事件
		 *
		 */
		private static function RemoveEvent():void
		{
			centerBox.removeEventListener(TouchEvent.TOUCH, OnCenterTouchEvent);

			leftTopBox.removeEventListener(TouchEvent.TOUCH, OnleftTopTouchEvent);
			leftBottomBox.removeEventListener(TouchEvent.TOUCH, OnleftBottomTouchEvent);
			rightBottomBox.removeEventListener(TouchEvent.TOUCH, OnrightBottomTouchEvent);
			rightTopBox.removeEventListener(TouchEvent.TOUCH, OnrightTopTouchEvent);
			leftCenterBox.removeEventListener(TouchEvent.TOUCH, OnleftCenterTouchEvent);
			rightCenterBox.removeEventListener(TouchEvent.TOUCH, OnrightCenterTouchEvent);
			topCenterBox.removeEventListener(TouchEvent.TOUCH, OntopCenterTouchEvent);
			bottomCenterBox.removeEventListener(TouchEvent.TOUCH, OnbottomCenterTouchEvent);
		}

		/**
		 *	添加组件控制
		 * @param component
		 *
		 */
		public static function set target(editor:Editor):void
		{
			if (editor == null)
			{
				RemoveEvent();
				if (m_editor)
					m_editor.removeControl();
				m_editor=null;
				RookieEditor.getInstante().Property.setTarget(null);
				return;
			}

			m_editor=editor;

			m_editor.addControl(centerBox, leftTopBox, leftBottomBox, rightBottomBox, rightTopBox, leftCenterBox, rightCenterBox, topCenterBox, bottomCenterBox);


			ResetComponent();

			RookieEditor.getInstante().Property.setTarget(editor);
			RookieEditor.getInstante().Select.panel.title="选择组件:" + editor.type;
//			PropertyManager.SetComponentValue(m_component);
//			
			RookieEditor.getInstante().Tree.selectItem(editor.id);

		}

		public static function move(flag:int):void
		{
			var component:Editor=ControlManager.getCurrentComponent() as Editor

			if (component)
			{

				switch (flag)
				{

					case Define.MOVE_UP:
						component.y--;
						break;
					case Define.MOVE_DOWN:
						component.y++;
						break;
					case Define.MOVE_LEFE:
						component.x--;
						break;
					case Define.MOVE_RIGHT:
						component.x++;
						break;
				}

				RookieEditor.getInstante().Property.ResetProperty(); //刷新组件属性
			}
		}

		/**
		 *	设置复制对象效果
		 *  Ctrl + C	被复制的组件透明度减低
		 *
		 */
		public static function SetCopyComponent(component:FeathersControl):void
		{
			copyComponent=component;
		}

		/**
		 *	设置恢复复制对象效果
		 *  恢复透明度
		 */
		public static function ResetCopyComponent():void
		{
			copyComponent=null;
		}

		/**
		 *	剪切对象
		 * @param component
		 *
		 */
		public static function SetCutComponet(component:FeathersControl):void
		{
			copyComponent=component;
		}


		/**
		 *	获取当前正在复制的对象
		 * @return
		 *
		 */
		public static function CopyComponent():FeathersControl
		{
			return copyComponent;
		}

		/**
		 *	获取当前控制的组件
		 * @return
		 *
		 */
		public static function getCurrentComponent():Editor
		{
			return m_editor;
		}

		/**
		 *	移除组件控制
		 * @param component
		 *
		 */
		public static function RemoveControl():void
		{
			m_editor.removeControl();

			RemoveEvent();
		}


		/**
		 *	获取当前高亮对象
		 * @return
		 *
		 */
		public static function GetCurrentHight():Editor
		{
			return highCurrentComponent;
		}

		/**
		 * 	给组件添加高亮
		 * @param component
		 *
		 */
		public static function AddHighLight(component:Editor):void
		{
			highBackground=getHightBack();
			highBackground.width=component.width;
			highBackground.height=component.height;

			highCurrentComponent=component;
			component.addChild(highBackground);
		}

		/**
		 *	移除高亮
		 * @param component
		 *
		 */
		public static function RemoveHighLight():void
		{
			if (highCurrentComponent != null)
			{
				highCurrentComponent.removeChild(highBackground);
				highCurrentComponent=null;
			}
		}

		public static function SetComponentProperty(value:Object):void
		{
//			if(m_editor==null)
//			{
//				return;
//			}
//			if(value["Name"] == "skin")
//			{
//				m_editor["skinInfo"] = SkinManager.GetSkin(getQualifiedClassName(m_component).split("::")[1].toString() , value["Value"]);
//			}
//			else
//			{
//				m_editor[value["Name"]] = value["Value"];
//			}
		}

		/**
		 *	获取高亮背景
		 * @return
		 *
		 */
		private static function getHightBack():Image
		{
			if (highBackground == null)
			{
				var box:flash.display.Shape=new flash.display.Shape;
				box.graphics.beginFill(0xff0000);
				box.graphics.drawRect(0, 0, 100, 100);
				box.graphics.endFill();
				var bitmap:flash.display.Bitmap=new flash.display.Bitmap;
				var bitmapdata:flash.display.BitmapData=new flash.display.BitmapData(100, 100);
				bitmapdata.draw(box);
				bitmap.bitmapData=bitmapdata;
				highBackground=starling.display.Image.fromBitmap(bitmap);
				highBackground.touchable=false;
				highBackground.alpha=0.3
			}

			return highBackground;
		}


		private static function OnleftTopTouchEvent(event:TouchEvent):void
		{
			var offsetPoint:Point=GetOffsetXY(event);
			if (offsetPoint != null)
			{
				m_editor.x+=offsetPoint.x;
				m_editor.y+=offsetPoint.y;

				m_editor.width+=(-offsetPoint.x);
				m_editor.height+=(-offsetPoint.y);

				ResetComponent();
				RookieEditor.getInstante().Property.ResetProperty(); //刷新组件属性
			}
		}


		private static function OnbottomCenterTouchEvent(event:TouchEvent):void
		{
			var offsetPoint:Point=GetOffsetXY(event);
			if (offsetPoint != null)
			{
				m_editor.height+=offsetPoint.y;
				ResetComponent();
				RookieEditor.getInstante().Property.ResetProperty(); //刷新组件属性
			}
		}

		private static function OntopCenterTouchEvent(event:TouchEvent):void
		{
			var offsetPoint:Point=GetOffsetXY(event);
			if (offsetPoint != null)
			{
				m_editor.height-=offsetPoint.y;
				m_editor.y+=offsetPoint.y;
				ResetComponent();
				RookieEditor.getInstante().Property.ResetProperty(); //刷新组件属性
			}
		}


		private static function OnrightCenterTouchEvent(event:TouchEvent):void
		{
			var offsetPoint:Point=GetOffsetXY(event);
			if (offsetPoint != null)
			{
				m_editor.width+=offsetPoint.x;
				ResetComponent();
				RookieEditor.getInstante().Property.ResetProperty(); //刷新组件属性
			}
		}


		private static function OnleftCenterTouchEvent(event:TouchEvent):void
		{
			var offsetPoint:Point=GetOffsetXY(event);
			if (offsetPoint != null)
			{
				m_editor.width-=offsetPoint.x;
				m_editor.x+=offsetPoint.x;
				ResetComponent();
				RookieEditor.getInstante().Property.ResetProperty(); //刷新组件属性
			}
		}

		private static function OnrightTopTouchEvent(event:TouchEvent):void
		{
			var offsetPoint:Point=GetOffsetXY(event);
			if (offsetPoint != null)
			{
				m_editor.width+=offsetPoint.x;
				m_editor.height-=offsetPoint.y;

				m_editor.y+=offsetPoint.y;
				ResetComponent();

				RookieEditor.getInstante().Property.ResetProperty(); //刷新组件属性
			}
		}

		private static function OnrightBottomTouchEvent(event:TouchEvent):void
		{
			var offsetPoint:Point=GetOffsetXY(event);
			if (offsetPoint != null)
			{
				m_editor.width+=offsetPoint.x;
				m_editor.height+=offsetPoint.y;

				ResetComponent();
				RookieEditor.getInstante().Property.ResetProperty(); //刷新组件属性
			}
		}

		private static function OnleftBottomTouchEvent(event:TouchEvent):void
		{
			var offsetPoint:Point=GetOffsetXY(event);
			if (offsetPoint != null)
			{
				m_editor.x+=offsetPoint.x;
				m_editor.width-=offsetPoint.x;
				m_editor.height+=offsetPoint.y;
				ResetComponent();
				RookieEditor.getInstante().Property.ResetProperty(); //刷新组件属性
			}
		}

		/**
		 *	单击中间的控制块，移动组件对象
		 * @param event
		 *
		 */
		private static function OnCenterTouchEvent(event:TouchEvent):void
		{
			touch=event.getTouch(Define.starlingStg);
			if (!touch)
				return;
			var point:Point;

			if (touch.phase == TouchPhase.MOVED)
			{
				m_editor.x-=touch.previousGlobalX - touch.globalX;
				m_editor.y-=touch.previousGlobalY - touch.globalY;

				RookieEditor.getInstante().Property.ResetProperty(); //刷新组件属性
			}
			else if (touch.phase == TouchPhase.ENDED)
			{
				RookieEditor.getInstante().Operate.addCommand(new Command(Command.MoveName));

				var hitComponents:Vector.<Editor>=new Vector.<Editor>();
				Tool.findObjectsUnderPoint(Define.editorContainer, mousePoint, true, hitComponents);
				componAddCompon(hitComponents);
			}
		}
		private static var touch:Touch;

		private static function get mousePoint():Point
		{
			return touch.getLocation(Define.starlingStg);
		}

		private static function componAddCompon(value:Vector.<Editor>):void
		{
			if (m_editor.type == "TitleWindow")
			{
				return;
			}
			trace(value + "," + m_editor)
			if (value.length > 0)
			{
				var m_childPoint:Point;
				var m_content1:Editor;
				var m_content2:Editor;
				for (var i:int=0; i < value.length; i++)
				{
					if (i > 2)
						break;
					if (value[i] != m_editor)
					{
						if (value[i].type == "TitleWindow" || value[i].type == "ScrollContainer")
						{
							if (m_content1 == null)
							{
								m_content1=value[i];
							}
							else
							{
								m_content2=value[i];
							}
						}
					}
				}
				if (m_content1 != null && m_content1.contains(m_editor))
				{
					removeAddEditor(m_content1, m_content2);
				}
				else if (m_content2 != null && m_content2.contains(m_editor))
				{
					removeAddEditor(m_content2, m_content1);
				}
				else
				{
					if (m_content1 != null)
					{
						addEditor(m_content1);
					}
					else if (m_content2 != null)
					{
						addEditor(m_content2);
					}
					else
					{
						removeAddEditor(getParent(m_editor));

					}
				}
			}
		}

		/**
		 * 取得当前元件的Editor类型的父级
		 * */
		private static function getParent(value:DisplayObject):Editor
		{
			var m_parent:DisplayObject=value.parent;
			while (m_parent != null)
			{
				if (m_parent as Editor)
				{
					return m_parent as Editor;
					break;
				}
				else
				{
					m_parent=m_parent.parent;
				}
			}
			return null;
		}

		private static function getComponetPoint(value:Editor):Point
		{
			return value.globalToLocal(mousePoint);
		}

		private static function removeAddEditor(value1:Editor, value2:Editor=null):void
		{
			if (value1 == null)
				return;
			var m_childPoint:Point=getComponetPoint(value1);
			if (m_childPoint.x < 0 || m_childPoint.y < 0 || value1.width < m_childPoint.x || value1.height < m_childPoint.y)
			{
				value1.removeEditor(m_editor);
				Define.editorContainer.addChild(m_editor);
				m_editor.x=touch.globalX - (m_editor.width >> 1);
				m_editor.y=touch.globalY - (m_editor.height >> 1);
				if (value2 != null)
				{
					addEditor(value2);
				}
			}
		}

		private static function addEditor(value:Editor):void
		{
			if (value.type != m_editor.type)
			{
				if (getParent(m_editor) != null)
					getParent(m_editor).removeEditor(m_editor);
				var m_childPoint:Point=getComponetPoint(value);
				value.addEditor(m_editor);
				m_editor.x=m_childPoint.x - (m_editor.width >> 1);
				m_editor.y=m_childPoint.y - (m_editor.height >> 1);
			}
		}

		public static function ResetComponent():void
		{
			updatePoint();

			AddEvent();
		}

		/**
		 * 更新控制点坐标
		 *
		 */
		public static function updatePoint():void
		{
			if (!m_editor)
				return;

			changedPoint(leftTopBox, -leftTopBox.width / 2, -leftTopBox.height / 2);
			changedPoint(leftBottomBox, -leftBottomBox.width / 2, m_editor.height - leftBottomBox.height / 2);
			changedPoint(rightBottomBox, m_editor.width - rightBottomBox.width / 2, m_editor.height - rightBottomBox.height / 2);
			changedPoint(rightTopBox, m_editor.width - rightTopBox.width / 2, -rightTopBox.height / 2);
			changedPoint(centerBox, (m_editor.width - centerBox.width) / 2, (m_editor.height - centerBox.height) / 2);
			changedPoint(leftCenterBox, -leftCenterBox.width / 2, (m_editor.height - leftCenterBox.height) / 2);
			changedPoint(rightCenterBox, m_editor.width - rightCenterBox.width / 2, (m_editor.height - rightCenterBox.height) / 2);
			changedPoint(topCenterBox, (m_editor.width - topCenterBox.width) / 2, -topCenterBox.height / 2);
			changedPoint(bottomCenterBox, (m_editor.width - bottomCenterBox.width) / 2, m_editor.height - bottomCenterBox.height / 2);
			function changedPoint(box:Image, px:Number, py:Number):void
			{
				box.x=px;
				box.y=py;
			}
		}

		/**
		 *	获取控制的偏移量
		 * @param touch
		 * @return
		 *
		 */
		private static function GetOffsetXY(event:TouchEvent):Point
		{
			var touch:Touch=event.getTouch(Define.starlingStg);
			if (touch == null)
				return null;
			if (touch.phase == TouchPhase.MOVED)
			{
				return new Point(touch.globalX - touch.previousGlobalX, touch.globalY - touch.previousGlobalY);
			}

			return null;
		}
	}
}