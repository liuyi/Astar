package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author liuyi
	 */
	public class Map extends Sprite 
	{
		public var col:int = 10;
		public var row:int = 10;
		public var data:Vector.<MapNode>;
		public var backGroundColor:Number = 0xcccccc;
		public var borderColor:Number = 0x000000;
		public var targetColor:Number = 0xff0000;
		public var startColor:Number = 0x00000ff;
		public var pathColor:Number = 0x00ff00;
		
		public var blockColor:Number = 0x333333;
		
		
		public var mpWidth:Number=600;
		public var mpHeight:Number=600;
		
		private var terrain:Sprite;
		private var _cellHeight:Number;
		private var _cellWidth:Number;
		private var _dataLen:int;
		//from up ->right->down->left->right and top->right and down->left and down ->left and top;
		//private var _neightbors:Array = [[0, -1], [1, 0], [0, 1], [ -1, 0], [1, -1], [1, 1], [ -1, 1], [ -1, -1]];//for x, and y
		private var _neightbors:Array = [[0, -1], [1, 0], [0, 1], [ -1, 0], [1, -1], [1, 1], [ -1, 1], [ -1, -1]];//for id, [0] is col, [1] is row		
		
		private var SortIndex:int 
		private	var end:int 
		private	var front:int 
		
		private var txt:TextField = new TextField()
		
		public var _terrainData:Array;
		
		private var islands:int
		private var islandColors:Array=[0x00ff00,0xccee33,0xfeed99,0x9832ee,0xad98ef,0x99aab3,0x89ddee]
		
		
		
		public function Map() 
		{
			
		}
		
		
		public function convertData(list:Array,$col:int=10,$row:int=10):void {
			_terrainData = list;
			col = $col;
			row = $row;
			updateMap();
		}
		
		
		
		
		public function updateMap():void {
			data = new Vector.<MapNode>();
			if (_terrainData != null) {
				_dataLen = _terrainData.length;
				row = int(_dataLen/col);
			}else{
				_dataLen = col * row;
			
			}
			var blockPercent:Number = 0.3;
			for (var i:int = 0; i < _dataLen; i++ ) {
				var c:int = i % col;
				var r:int = int(i / row) ;
				data[i] = new MapNode();
				data[i].x=  i % col;
				data[i].y = int(i / row) ;
				data[i].id = i;
				
				if (_terrainData != null) {
					data[i].block =( _terrainData[i]>0) ?true:false;
				}else{
				
				if (Math.random() < blockPercent) 
					data[i].block = true;
			     else 
					data[i].block = false
					
				}
				data[i].neighbors = getNeighbors(i);
				
			}
			//trace("map:"+data);
			
			getIslands();
			
			updateTerrain();
			txt.width = terrain.width;
			txt.height = terrain.height;
			txt.x = terrain.width + terrain.x + 10;
			txt.y = terrain.y;
			
			addChild(txt);
			
		}
		
		public function updateTerrain():void {
				if (terrain == null) {
					terrain = new Sprite();
					addChild(terrain);
				}
				
				terrain.graphics.clear();
				terrain.graphics.beginFill(backGroundColor);
				terrain.graphics.lineStyle(1, borderColor, 1);
				terrain.graphics.moveTo(0, 0);
				terrain.graphics.drawRect(0, 0, mpWidth, mpHeight);
				
				_cellWidth = uint(mpWidth / col);
				_cellHeight = uint(mpHeight / row);
				for (var i:int = 0; i < col;i++ ) {
					terrain.graphics.moveTo(i * _cellWidth, 0);
					terrain.graphics.lineTo(i*_cellWidth,mpHeight);
				}
				
				
				for ( i = 0; i < row;i++ ) {
					terrain.graphics.moveTo(0,i * _cellHeight);
					terrain.graphics.lineTo(mpWidth,i*_cellHeight);
				}
				
				
				
				
				
				
				//create block
				for (i = 0; i < _dataLen; i++ ) {
					var c:int = i % col;
					var r:int = int(i / row) ;
					terrain.graphics.moveTo(c * _cellWidth, r * _cellHeight);
					if (data[i].block > 0) {
						//find rectangle position
				
						terrain.graphics.beginFill(blockColor);
						 
						
						
					}else  if (data[i].island >= 0) {
					
						terrain.graphics.beginFill(islandColors[data[i].island ]);
					}
					
					terrain.graphics.drawRect(c * _cellWidth, r * _cellHeight, _cellWidth, _cellHeight);
				  
				}
				
				
				terrain.graphics.endFill();
			
		}
		
		
		public function get cellWidth():Number {
			return _cellWidth;			
		}
		
		public function get cellHeight():Number {
			return _cellHeight;
		}
		
		public function init( $col:uint,$row:uint):void {
			col = $col; 
			row = $row;
			updateMap();
			
			
		}
		
		
		public function getIslands():void {
			var len:int = data.length;
			islands = 0;
			var cid:int;
			var cpoint:MapNode;
			var nList:Array;
			var k:int
			var nLen:int
			var nPoint:MapNode;
			var unSignList:Array = [];//store id
			var signList:Array = [];//store id
			var nIslandId:int=-1;//this current point's neighbor's island id.
			var access:Boolean
			var accessList:Array;//store all the can access neibour to this list. 
			for (var i:int = 0; i < len;i++ ) {
				unSignList[i] = i;
				trace("befor init:"+data[i].island)
			}
			var step:int = 2000;
			while (step>0 && unSignList.length > 0) {
				step--
				cid = unSignList[0];
				cpoint = data[cid];
				
				//remove block from list
				if (cpoint.block ) { 
					
					unSignList.shift();
					continue; 
				}  
				
				if (cpoint.island >= 0) {
					if (signList.indexOf(cid) < 0) {
						signList.unshift(unSignList.shift());
					}
					trace("cpoint id==>:"+cid)
					continue;
				}
				accessList = [];
				//have not check
				 //trace("step111:>>?" + step,cpoint.id,cpoint.island);
				 
				// trace("cid:>>" + cid+"  islands:"+islands);
				
				//check its neighbors, if all of them both not have island, then there is a new island.
				
				var hasNeibours:Boolean=true
				while(!hasNeibours){
					nList = cpoint.neighbors;
					nLen = nList.length;
					for (k = 0; k < nLen; k++ ) {
						nPoint = data[nList[k]];
						access = true;
						if (nPoint.block) {
							access=false
						}else if (cpoint.neighborG[k] > 10) {
								
								//if the neighbor point is diagonal,check can access to it.
								if (nPoint.id > cid) {
									if (data[nPoint.id - col].block && data[cid + col].block) 
										access=false
								
								}else {
									if (data[nPoint.id + col].block && data[cid - col].block) 
										access=false
								}
					 
						}
						
						if (access) {
							nIslandId = nPoint.island;
							trace("nIslandId:"+nIslandId)
							accessList.push(nPoint);
						}
					}//end for
				
				}
				
				//if all of its neigbours don't have sign in a island, then continue to find their neibours.
				if (nIslandId < 0) {
					islands++
					trace("get new island:"+islands,"id:"+cid+"accessList:"+accessList.length)
					cpoint.island = islands;
					
					for (k = 0; k < accessList.length;k++ ) {
						nPoint = accessList[k];
						nPoint.island = cpoint.island;
					}
					
				}else {
					cpoint.island = nIslandId;
					trace("===>cid:"+cid,"nIslandId:"+nIslandId)
				}
			 
				
				trace("cpoint id:"+cid)
				
				signList.unshift(unSignList.shift())
				
			}//end for
			trace("unSignList length:" + unSignList.length, signList.length);
			for (i = 0; i < signList.length;i++ ) {
				trace(data[signList[i]].island);
			}
		}
		
		public function find(from:Point, to:Point):Array {
			var time:Number = getTimer();
			var fromId:int=getIdByPosition(from.x,from.y);
			var toId:int = getIdByPosition(to.x, to.y);
			//trace("from id:" + fromId + "   |   to id: " + toId);
			if (data[toId].block) { trace("can not reach there"); return null }
			var openList:Array=[]
			var closeList:Array=[]

		    //getNeighbors(toId);
			var foundPath:Array;
			//avoid crash if  can not find path or map is too large.
			var step:int = 1000;
			
			var index:int = fromId;
			openList.push(fromId);
			data[fromId].g = 0;
			
			//the neighbors of index point
			var nbList:Array;//neighbors of current point.
			var cid:int;//current point's id
			var cpoint:MapNode//current point
			var cg:int//current point's g.
			var cf:int//curent point's f;
			var ch:int//current point's h;
			var found:Boolean = false;
			var nPoint:MapNode//index point
			var toPoint:MapNode = data[toId];
			
			var i:int = 0;
			var nbLen:int
			while (step > 0 && !found) {
				step-=1;
				index = openList[0];
				nPoint = data[index];
				nbList = nPoint.neighbors;
				nbLen = nbList.length;
				closeList.push(openList.shift());
				
				for (i = 0; i < nbLen; i++ ) {
					cid = nbList[i];
					cpoint = data[cid];
					//when find the target.
			
					//if the point has be added into close list, not add it to open list.
					if (cpoint.block) {
						closeList.push(cid);
						if (cid == toId) step = 0
						
						continue;
					} else if (nPoint.neighborG[i] > 10) {
						//if the neighbor point is diagonal,check can access to it.
						if (cid > index) {
							if (data[cid - col].block && data[index + col].block) 
								continue;
						
						}else {
							if (data[cid + col].block && data[index - col].block) 
								continue;
						}
					 
					}
					
				 	if (closeList.indexOf(cid) >= 0 ) {
					//	if (cid == toId) step = 0
						continue;
					} 
					
					
					if (cid == toId) {
						trace("found target!");
						found = true;
						cpoint.parent = index;
						step = 0;
						break;
					}
					
					//trace("is in close?" + closeList.indexOf(cid) );
					
					cg = nPoint.g +nPoint.neighborG[i];
					
					//if the point has arleady in open list
					if (openList.indexOf(cid) >= 0){
						
						if (cg < cpoint.g) {
							cpoint.g = cg;
							cpoint.parent = index;
							cpoint.f = cpoint.g + cpoint.h;
						}
					}else {
						
						//set values of current point.
						cpoint.g = nPoint.g +nPoint.neighborG[i];
						 
					//	cpoint.h = int(Math.sqrt((cpoint.x-toPoint.x) * (cpoint.x-toPoint.x)  + (cpoint.y-toPoint.y) *(cpoint.y-toPoint.y) ))*10;
						cpoint.h = int((cpoint.x-toPoint.x) * (cpoint.x-toPoint.x)  + (cpoint.y-toPoint.y) *(cpoint.y-toPoint.y));
						cpoint.f = cpoint.g + cpoint.h;
						cpoint.parent = index;
						binarySort(cid,openList,sortByItem);
						 
							
					}
					
				}//end for
			 
			}
		 
			//get path:
			if(found){
				foundPath = [toId];
				data[fromId].parent = -1;
				cpoint = data[toId];
				while (cpoint.parent>=0) {
					
					foundPath.push(cpoint.parent);
					cpoint = data[cpoint.parent];
				}
				
				foundPath.reverse();
				
				
				
				//trace("time:"+(getTimer()-time)+"  step:"+step+"  foundPath: "+foundPath+" openList:"+openList+ "close List:"+closeList)
				trace("time:" + (getTimer() - time) + "  step:" + step );
				txt.text = "time:" + (getTimer() - time) + "  step:" + step ;
				
				for (i = 0; i < foundPath.length;i++ ) {
						var bid:int = foundPath[i];
						//find rectangle position
						var c:int = bid % col;
						var r:int = int(bid / row) ;
						terrain.graphics.moveTo(c * _cellWidth, r * _cellHeight);
						terrain.graphics.beginFill(0xff33ee);
						terrain.graphics.drawRect(c * _cellWidth, r * _cellHeight, _cellWidth, _cellHeight);
						
					 
				}
				
				for (i = 0; i < openList.length;i++ ) {
						 bid = openList[i];
						//find rectangle position
						 c = bid % col;
						 r = int(bid / row) ;
						terrain.graphics.moveTo(c * _cellWidth, r * _cellHeight);
						terrain.graphics.beginFill(0xaa33ff);
						terrain.graphics.drawRect(c * _cellWidth, r * _cellHeight, _cellWidth, _cellHeight);
						
					 
				}
				
				
			}else {
					trace("can not found path, time:" + (getTimer() - time) + "  step:" + step );
					txt.text =("can not found path, time:" + (getTimer() - time) + "  step:" + step );
			}
			
			return foundPath;
			
		}
		
		protected function sortByItem(a:int, b:int):int {
			if (data[a].f> data[b].f) return 1
			else return -1;
		}
		
		
		//if obj is a Object, can use sortBy function to compare which one is biigger.
		public function binarySort( obj:Object,list:Array,sortBy:Function=null):void {
			if (list.length == 0) {
				list[0] = obj;
				return;
			}
			
			SortIndex = list.length;
			end = SortIndex;
			front = 0;
			/*var SortIndex:int = list.length;
			var end:int = SortIndex;
			var front:int = 0;*/
 
			while ((end-front) > 1) {
			 
				SortIndex = front + (end - front) * .5;
				if(sortBy!=null){
					if (sortBy(obj, list[SortIndex]) < 0) 
						end = SortIndex;
					else 
						front = SortIndex;
				}else{

					if (obj < list[SortIndex]) 
						end = SortIndex;
					else 
						front = SortIndex;
					}
			
			}
			list.splice(front + 1, 0, obj);
		}
		
		//	private var _neightbors:Array = [[0, -1], [1, 0], [0, 1], [ -1, 0], [1, -1], [1, 1], [ -1, 1], [ -1, -1]];
		//function getNeighbors(px:int,py:int):void {
		protected function getNeighbors(id:int):Array {
			var len:int = _neightbors.length;
			var neighbor:Array = [];
			var pid:int;
			var px:int;
			var idx:int;
			data[id].neighborG = [];
			for (var i:int = 0; i < len;i++ ) {
				//neighbor[i] = [_neightbors[i][0] + px,_neightbors[i][1]+py];
				pid = id + _neightbors[i][0]  + _neightbors[i][1] * col ;
				//check if the pid is id's neighbor.
				px = pid % col;
				idx = data[id].x;
				
				//if the tile can not access, or is not in terrrain or is not a neighbor, do not add it to list.
				if (pid >= 0 && pid < _dataLen && (px == idx || px == idx + 1 || px == idx - 1 ) ) {
					
					neighbor.push(pid);
					
					//set the cost from this point to his neighbor, so as to we do not need caculate when find path.
					if (i < 4) data[id].neighborG.push(10);
					else  data[id].neighborG.push(14);
				}
	
			}
			
			
			return neighbor;
		}
		
		
		
		protected function getIdByPosition(px:Number,py:Number) :int{
			var c:int =Math.ceil(px / _cellWidth)-1;
			var r:int = Math.ceil(py / _cellHeight) - 1;
			if (c < 0) c = 0;
			if (r < 0) r = 0;
			var id :int= r * col + c;
			return id;
		}
		
		public function addPlayer(p:Sprite):void {
			var added:Boolean = false;
			while (!added) {
				var pid:int = int(Math.random() * data.length);
				//trace("pid:" + pid);
				if (data[pid].block==0) {
					added = true;
					var c:int = pid % col;
					var r:int = int(pid / row) ;
					p.x = c * _cellWidth+1;
					p.y = r * _cellHeight+1;
					addChild(p);
					//trace("id:"+pid,"r:"+r,"c"+c,p.x,p.y)
				}
			}
		}//end function
		
		
	}
	
	
	
	


}


	 class MapNode extends Object{
		public var id:int;
		public var x:int;
		public var y:int;
		public var block:Boolean;
		public var neighbors:Array;
		public var parent:int = -1;;
		public var f:int;
		public var g:int;
		public var h:int;
		public var neighborG:Array;//A list of g which from this point to his neighbor, if is diagonal, neighborG[n] is 14, if is straight neighborG[n]  is 10;
		public var island:int=-1;
		
		
	}

