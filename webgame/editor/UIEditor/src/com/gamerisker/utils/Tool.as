package com.gamerisker.utils
{
	import com.gamerisker.editor.Editor;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.utils.MatrixUtil;

	public class Tool
	{
		public function Tool()
		{
		}

		/**
		 *	浅复制一个目标对象
		 * @param _arg1		目标对象
		 * @return 			复制对象
		 *
		 */
		public static function UpdateObjectProperty(_arg1:Object):Object
		{
			var _local3:String;
			var _arg2:Object;
			if (_arg1 == null)
			{
				return _arg1;
			}

			_arg2=new Object;
			for (_local3 in _arg1)
			{
				_arg2[_local3]=_arg1[_local3];
			}

			return _arg2;
		}

		public static function CleanObjectProperty(_arg1:Object):void
		{
			var _local2:String;
			if (_arg1 == null)
			{
				return;
			}
			for (_local2 in _arg1)
			{
				delete _arg1[_local2];
			}
		}

		public static function DrawBitmapRectangle(bitd:flash.display.DisplayObject, rangle:Rectangle):Bitmap
		{
			var mat:Matrix=new Matrix();
			mat.translate(-rangle.x, -rangle.y);
			var bitmap:BitmapData=new BitmapData(rangle.width, rangle.height);
			bitmap.draw(bitd, mat, null, null, new Rectangle(0, 0, rangle.width, rangle.height));

			return new Bitmap(bitmap);
		}

		public static function findObjectsUnderPoint(display:starling.display.DisplayObject, localPoint:Point, forTouch:Boolean, to:Vector.<Editor>):void
		{
			if (forTouch && (!display.visible || !display.touchable))
			{
				return;
			}
			if (display is DisplayObjectContainer)
			{
				if (display is Sprite)
				{
					var sprite:Sprite=display as Sprite;
					if (sprite.clipRect && !sprite.clipRect.containsPoint(localPoint))
					{
						return;
					}
				}
				const container:DisplayObjectContainer=DisplayObjectContainer(display);
				const localX:Number=localPoint.x;
				const localY:Number=localPoint.y;
				const numChildren:int=container.numChildren;
				for (var i:int=numChildren - 1; i >= 0; --i)
				{
					const child:starling.display.DisplayObject=container.getChildAt(i);
					if (child as Editor)
					{
						var m_rect:Rectangle=new Rectangle(child.x, child.y, child.width + 10, child.height + 10);
						if (m_rect.containsPoint(container.globalToLocal(localPoint)))
						{
							to.push(child);
						}
					}
					findObjectsUnderPoint(child, localPoint, forTouch, to);
				}
			}
		}
	}
}