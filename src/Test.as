package  
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author liu yi
	 */
	public class Test extends Sprite 
	{
		
		public function Test() 
		{
			 var list:Array = [ { a:0 }, { a:2 }, { a:4 } , { a:7 } ];
			
			
		 
			binarySort( { a:4.5 }, list, function(a:Object,b:Object):int {
					trace(a.a,b.a,a.a > b.a)
				if (a.a > b.a) return 1
				else return -1
				
			})
			 for (var i:int = 0; i < list.length;i++ ) {
				  trace(list[i].a);
		  }
			
			
			//trace(list,list.length);
			/*var list:Array = [0];
			binarySort(3, list);
			binarySort(2, list);
			binarySort(12, list);
			binarySort(6, list);
			
			trace(list);*/
			
			
			
		 
			
		}
		
		
		//if obj is a Object, can use sortBy function to compare which one is biigger.
		public function binarySort( obj:Object,list:Array,sortBy:Function=null):void {
			if (list.length == 0) {
				list[0] = obj;
				return;
			}
			
			var index:int = list.length;
			var end:int = index;
			var front:int = 0;
 
			while ((end-front) > 1) {
			 
				index = front + (end - front) * .5;
				if(sortBy!=null){
					if (sortBy(obj, list[index]) < 0) 
						end = index;
					else 
						front = index;
				}else{

					if (obj < list[index]) 
						end = index;
					else 
						front = index;
					}
			
			}
			list.splice(front + 1, 0, obj);
		}
		
	}

}