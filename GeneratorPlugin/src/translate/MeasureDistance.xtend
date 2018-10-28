package translate

import java.util.HashMap
import java.util.Map
import java.util.List
import java.math.BigInteger
import com.google.common.collect.Sets

class MeasureDistance {
	
	public static def <Shape,Model> measureCosineDistances(
		List<Model> models,
		Map<Model,Map<? extends Shape,Integer>> shapes,
		boolean print, 
		boolean store
	) {
		var alg=new AngularDistance<Shape>()
		getAllDistances(models,shapes,alg,print,store);
	}
	
	public static def <Shape,Model> measureSymmetricDistances(
		List<Model> models,
		Map<Model,Map<? extends Shape,Integer>> shapes,
		boolean print, 
		boolean store
	) {
		var alg=new SetDiffDistance<Shape>()
		getAllDistances(models,shapes,alg,print,store);
	}
	
	public static def <Shape,Model> getAvgDistance(
		List<Model> models,
		Map<Model,List<Map<? extends Shape,Integer>>> shapes,
		int range
	) {
		var sum=0 as long
		var cntr=0;
		for (m1:models) {
			for (m2:models) {
				cntr++;
				if (m1!=m2) {
					val s1=shapes.get(m1).get(range).keySet
					val s2=shapes.get(m2).get(range).keySet
					sum+=(Sets.symmetricDifference(s1,s2).size)
				}
			}
		}
		val avg=(sum as double)/(cntr as double)
		return avg;
	}
	
	public static def <Shape,Model> getAllDistances(
		List<Model> modelList,
		Map<Model,Map<? extends Shape,Integer>> shapes,
		OnlineDistanceMetric<Shape> metric,
		boolean print, 
		boolean store
	) {
		val result= new HashMap<Model,Map<Model,Double>>();
		
		if (store) {
			for (Model m : shapes.keySet) {
				result.put(m,new HashMap<Model,Double>());
			}
		}
		
		if (print) println("Model1;Model2;Distance")
		
		for (var id1=0;id1<shapes.size();id1++) {
			val model1=modelList.get(id1);
			val modelshape1=shapes.get(model1)
			var m1map=null as Map<Model,Double>
			if (store) m1map=result.get(model1)
			for (var id2=id1+1;id2<shapes.size();id2++) {
				val model2=modelList.get(id2);
				val modelshape2=shapes.get(model2)
				
				val distance=calculate(modelshape1,modelshape2, metric)
				if (print) println(model1+";"+model2+";"+distance)
				if (store) {
					m1map.put(model2,distance);
					result.get(model2).put(model1,distance)
				}
			}
		}
		
		return result;
	}
	
	public static def <K> double calculate(Map<? extends K,Integer> shape1, Map<? extends K,Integer> shape2,OnlineDistanceMetric<K> metric) {
		
		for (K key:shape1.keySet()) {
			val value1=shape1.get(key);
			if (shape2.containsKey(key)) {
				metric.newCoordinate(key,value1,shape2.get(key));
			} else {
				metric.newCoordinate(key,value1,0);
			}
		}
		
		for (K key:shape2.keySet()) {
			if (!shape1.containsKey(key)) {
				metric.newCoordinate(key,0,shape2.get(key));
			}
		}
		
		return metric.getDistance();
	}
	
	public interface OnlineDistanceMetric<Shape> {
		public def void  newCoordinate(Shape key,Integer value1,Integer value2);
		public def double getDistance();
	}
	
	public static class VectorDistance<Shape> implements OnlineDistanceMetric<Shape> {
		int sum=0;
		public override void newCoordinate(Shape key,Integer value1,Integer value2) {
			 val dist=value1-value2;
			 sum+=dist*dist;
		}
		public override double getDistance() {
			return Math.sqrt(sum);
		}
	}
	
	public static class AngularDistance<Shape> implements OnlineDistanceMetric<Shape> {
		int number=0;
		int prod=0;//dotproduct
		int sum1=0;//for length1
		int sum2=0;//for length2
		public override newCoordinate(Shape key,Integer value1,Integer value2) {
			number++;
			prod+=value1*value2;
			sum1+=value1*value1;
			sum2+=value2*value2;
		}
		public override getDistance() {
			val length1=Math.sqrt(sum1);
			val length2=Math.sqrt(sum2);
			val cosine=prod/(length1*length2);			
			return 1-cosine;
		}
	}
	
	public static class SetDiffDistance<Shape> implements OnlineDistanceMetric<Shape> {
		
		int cntr=0;
				
		override newCoordinate(Shape key, Integer value1, Integer value2) {
			if (value1==0 || value2==0) cntr++;
		}
		
		override getDistance() {
			return cntr;
		}
		
	}
	
	public static class VectorDiffDistance<Shape> implements OnlineDistanceMetric<Shape> {
		
		int cntr=0;
				
		override newCoordinate(Shape key, Integer value1, Integer value2) {
			cntr+=Math.abs(value1+value2);
		}
		
		override getDistance() {
			return cntr;
		}
		
	}
	 
}