package 
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author liuyi
	 */
	public class Main extends Sprite 
	{
		private var map:Map;
		private var player:Sprite;
		private var targetPoint:Sprite;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.align = StageAlign.TOP_LEFT
			stage.scaleMode=StageScaleMode.NO_SCALE
			var padding:Number = 20
			
			
			 var mapData:Array = [
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
			0, 0, 0, 0, 0, 0, 0, 1, 0, 0,
			0, 0, 1, 1, 1, 1, 1, 1, 0, 0,
			0, 0, 1, 0, 0, 0, 0, 1, 0, 0,
			0, 0, 1, 0, 0, 0, 0, 1, 0, 0,
			0, 0, 1, 1, 1, 1, 1, 1, 1, 1,
			0, 0, 0, 0, 0, 0, 0, 1, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 1, 0, 0
			] 
			
			/*var mapData:Array = [
			0, 1, 0, 0, 0, 0,
			1, 1, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0,
			0, 0, 1, 1, 1, 1,
			0, 0, 1, 0, 0, 0
			]*/
			
			mapData=[0,1,1,1,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,1,0,0,0,1,0,0,1,0,0,0,0,0,0,1,0,0,1,0,1,0,0,1,0,0,1,1,0,1,0,0,0,1,0,1,1,0,0,0,1,0,1,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,1,1,0,1,1,1,1,0,1,0,0,0]
			
			map = new Map();
			map.mpWidth=450
			map.mpHeight=450
			map.init(50, 50);
			//map.convertData(mapData,6,6);
		//	map.convertData(mapData,10,10);
			map.x = 20;
			map.y = 20;
			map.doubleClickEnabled = true;
			
			addChild(map);
			
			var updateMapBtn:Sprite = getButton(80,40,"Update map");
			updateMapBtn.x = map.x;
			updateMapBtn.y = map.y + map.height + padding;
			updateMapBtn.addEventListener(MouseEvent.CLICK,onMapUpdate)
			addChild(updateMapBtn);
			
			player = new Sprite();
			player.graphics.beginFill(map.startColor,0.9);
			//player.graphics.drawRect(0, 0, map.cellWidth, map.cellHeight);
			player.graphics.drawCircle(map.cellWidth*.5,map.cellWidth*.5,map.cellWidth*0.5);
			player.graphics.endFill();

			 
			
			
			targetPoint = new Sprite();
			targetPoint.graphics.beginFill(map.targetColor, 0.9);
			//targetPoint.graphics.drawRect(0, 0, map.cellWidth, map.cellHeight);
			targetPoint.graphics.drawCircle(map.cellWidth*.5,map.cellWidth*.5,map.cellWidth*0.5);
			targetPoint.graphics.endFill();
			
			
			
			
			
			map.addEventListener(MouseEvent.CLICK,onMapClicked)
			
			
		}
		
		private function onMapClicked(e:MouseEvent):void 
		{
			//target point
			map.updateTerrain();
			if(player!=null){
				var p:Point = new Point(map.mouseX, map.mouseY);
				var path:Array=map.find(new Point(player.x, player.y), p);
				
			}
		}
		
		private function getButton(w:Number, h:Number, label:String):Sprite {
			var _mc:Sprite = new Sprite();
			_mc.graphics.lineStyle(1, 0x9999cc);
			_mc.graphics.beginFill(0xeeeeee);
			_mc.graphics.drawRoundRect(0, 0, w, h, 5, 5);
			_mc.graphics.endFill();
			_mc.buttonMode = true;
			_mc.mouseChildren = false;
			
			var txt:TextField = new TextField();
			var tf:TextFormat = new TextFormat();
			tf.size = 12;
			tf.color = 0x000000;
			tf.align = "center";
			
			txt.defaultTextFormat = tf;
			txt.selectable = false;
			txt.width = w;
			txt.height = h;
			txt.text = label;
			txt.height = txt.textHeight + 5;
			txt.y = int((h - txt.height) * 0.5);
			
			
			
			_mc.addChild(txt);
			return _mc;
		}
		
		private function onMapUpdate(e:MouseEvent):void 
		{
			//if(e.currentTarget!=map)
			map.updateMap(true);
			map.addPlayer(player);
			map.addPlayer(targetPoint);
		}
		
	}
	
}