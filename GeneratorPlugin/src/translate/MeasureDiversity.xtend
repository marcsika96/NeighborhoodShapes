package translate

import hu.bme.mit.inf.dslreasoner.ecore2logic.Ecore2Logic
import hu.bme.mit.inf.dslreasoner.ecore2logic.Ecore2LogicConfiguration
import hu.bme.mit.inf.dslreasoner.ecore2logic.EcoreMetamodelDescriptor
import hu.bme.mit.inf.dslreasoner.ecore2logic.ecore2logicannotations.Ecore2logicannotationsPackage
import hu.bme.mit.inf.dslreasoner.logic.model.logiclanguage.DefinedElement
import hu.bme.mit.inf.dslreasoner.logic.model.logiclanguage.LogiclanguagePackage
import hu.bme.mit.inf.dslreasoner.logic.model.logicproblem.LogicproblemPackage
import hu.bme.mit.inf.dslreasoner.viatra2logic.viatra2logicannotations.Viatra2LogicAnnotationsPackage
import hu.bme.mit.inf.dslreasoner.viatrasolver.partialinterpretation2logic.InstanceModel2PartialInterpretation
import hu.bme.mit.inf.dslreasoner.viatrasolver.partialinterpretationlanguage.neighbourhood.AbstractNodeDescriptor
import hu.bme.mit.inf.dslreasoner.viatrasolver.partialinterpretationlanguage.neighbourhood.PartialInterpretation2ImmutableTypeLattice
import hu.bme.mit.inf.dslreasoner.viatrasolver.partialinterpretationlanguage.partialinterpretation.PartialInterpretation
import hu.bme.mit.inf.dslreasoner.viatrasolver.partialinterpretationlanguage.partialinterpretation.PartialinterpretationPackage
import hu.bme.mit.inf.dslreasoner.workspace.FileSystemWorkspace
import java.io.File
import java.io.PrintWriter
import java.util.ArrayList
import java.util.Collections
import java.util.Comparator
import java.util.HashMap
import java.util.HashSet
import java.util.LinkedList
import java.util.List
import java.util.Map
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EEnum
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.slizaa.neo4j.opencypher.OpenCypherStandaloneSetup
import org.slizaa.neo4j.opencypher.openCypher.OpenCypherPackage
import java.io.FileOutputStream

class MeasureDiversity {
	static val partialInterpretation2Logic = new InstanceModel2PartialInterpretation
	static val neiguboirhoodComputer = new PartialInterpretation2ImmutableTypeLattice
	static val Ecore2Logic ecore2Logic = new Ecore2Logic
	
	static private def init() {
		LogiclanguagePackage.eINSTANCE.class
		LogicproblemPackage.eINSTANCE.class
		PartialinterpretationPackage.eINSTANCE.class
		Ecore2logicannotationsPackage.eINSTANCE.class
		Viatra2LogicAnnotationsPackage.eINSTANCE.class
		Resource.Factory.Registry.INSTANCE.extensionToFactoryMap.put("*",new XMIResourceFactoryImpl)
	}
	enum MeasurementType{GENORDER,COSDISTANCEORDER,SYMDISTANCEORDER,SHAPEORDER,RANDOMORDER,INTERNALDIVERSITY,RANGEDISTANCE,ALLORDERS}
	
	 static class BenchmarkConfig {
	 	MeasurementType measurement;
	 	//InputType input;
	 	int range;
	 	int size
	 	PrintWriter writer
	 }
	
	def static void main(String[] args) {
		init()
		val path = '''.'''
		val scenarios = #[
			'''measurementA/cypher/''',
			'''measurementAp/cypher/''',
			'''measurementApp/cypher/'''
//			'''measurementA/cypher'''
		]///+((1..10).map[it*5]+#[100,150,200]).map["measurementB/cyphers"+it]
		
		for(scenario : scenarios) {
			val writer = new PrintWriter(new FileOutputStream(path+"/"+"/diversity.csv",true));
			val config=new BenchmarkConfig();
			config.writer=writer
			config.range = 3
			config.size = 3
			measureDiversity(scenario,path+"/"+scenario,config)
			writer.close();
			println(scenario+" finished")
		}	
	}
	
	def static void measureDiversity(String scenario, String path, BenchmarkConfig config) {
		val file = new File(path)
		if(file.isDirectory) {
			val subfiles = file.list
			val xmiSubfiles = subfiles.filter[it.endsWith(".xmi") || it.endsWith(".cypher")]
			if(!xmiSubfiles.empty) {
				measureDiversity(scenario, file,xmiSubfiles.map[new File(path+"/"+it)].toList,path,config)
			} else {
				for(subfile : subfiles) {
					measureDiversity(scenario, path+"/"+subfile,config)
				}
			}
		} else if(file.isFile) {
			// Do nothing
		}
	}
	
	def static void measureDiversity(String scenario, File parent, List<File> files, String path, BenchmarkConfig config) {
		val depth=config.range
		
		//collect and order models
		val workspace = new FileSystemWorkspace(path, "")
		
		OpenCypherPackage.eINSTANCE.eClass
		Resource.Factory.Registry.INSTANCE.extensionToFactoryMap.put("xmi",new XMIResourceFactoryImpl)
		OpenCypherStandaloneSetup.doSetup
		
		files.sort(new FileComparator)
		
		//calculate shapes
		val modelShapeLists=new HashMap<File,List<Map<? extends AbstractNodeDescriptor, Integer>>>();
		val modelShapes=new HashMap<File,Map<? extends AbstractNodeDescriptor, Integer>>();
		for (file : files) {
			
			val model = workspace.readModel(EObject, file.name)
			
			val pckg = model.eClass.EPackage
			val metamodel = new EcoreMetamodelDescriptor(
				pckg.EClassifiers.filter(EClass).toList,
				Collections::emptySet,
				false,
				pckg.EClassifiers.filter(EEnum).toList,
				pckg.EClassifiers.filter(EEnum).map[ELiterals].flatten.toList,
				pckg.EClassifiers.filter(EClass).map[EReferences].flatten.filter[it.EType.name != "EObject"].toList,
				pckg.EClassifiers.filter(EClass).map[EAttributes].flatten.toList
			)
			val metamodelTransformationOutput = ecore2Logic.transformMetamodel(metamodel,new Ecore2LogicConfiguration)

			
			val partialModelOutput = partialInterpretation2Logic.transform(metamodelTransformationOutput, model.eResource,
				false)
			
			val list = shapeList(partialModelOutput, depth)
			if (config.measurement==MeasurementType.RANGEDISTANCE ) {
				modelShapeLists.put(file,list)
			} else {
				modelShapes.put(file,list.get(depth-1))
			}
			//println('''«file.name» shape done.''')
		}
		//println('''shapes done.''')
		val writer=config.writer
		println("Printing cumulative shape coverage based on order of generation (original order of files)")
		printShapeNumbers(writer,files,modelShapes);
	 }
		
		/*
		//If required, calculate distances
		var distances=null as Map<File,Map<File,Double>>;
		if (DistanceType.NONE!==config.distanceType) {
			//If required, store distances
			if(OrderType.DISTANCE===config.orderType) {
				distances=MeasureDistance.measureDistances(files,modelShapes,config.distanceType,config.printDistances,true)
			} else {
				//storing values will not be necessary
				MeasureDistance.measureDistances(files,modelShapes,config.distanceType,config.printDistances,false)
			}
		}
		
		//TODO: this part not yet finished
		if (OrderType.NONE!=config.orderType) {
			if (OrderType.DISTANCE==config.orderType) {
				val order=OrderModels.orderByDistance(distances,config.printOrder);
				if (config.calculateShapeCoverage) printShapeNumbers(order,modelShapes);
			} else if (OrderType.SHAPES==config.orderType) {
				if (config.calculateShapeCoverage || config.printOrder) {
					OrderModels.orderByShapeCoverage(modelShapes,true,false)
				} else {
					OrderModels.orderByShapeCoverage(modelShapes,false,false)
				}
			}
		}*/
		
		//ideal order
		//val order=OrderModels.orderByShapeCoverage(files,modelShapes,2)
		
		//shape by order
		//printShapeNumbers(files,modelShapes);
		
		//randomOrder
		//printShapeNumbersOnRandomOrders(files,modelShapes,30)
		
		//println('''order done.''')
		/*print("\\");
		for (file:files) {
			print(";"+file.getName())
		}
		println();
		
		for (file:files) {
			val dfromf=distances.get(file)
			print(file.name)
			for (file2:files) {
				if (file==file2) {
					print(";0")
				} else {
					print(";"+dfromf.get(file2))
				}
			}
			println();
		}*/
	
	
	def static printShapeNumbersOnRandomOrders(List<File> files, HashMap<File, Map<? extends AbstractNodeDescriptor, Integer>> shapes, int number) {
		val sequences=new ArrayList<List<File>>();
		println("Printing generated random orders (models apper in original order)")
		for (var i=0;i<number;i++) {
			val seq=new ArrayList<File>(files);
			Collections.shuffle(seq);
			sequences.add(seq);
			println("Model;NewIndex")
			for (model:files) {
				println(model+";"+seq.indexOf(model));
			}
		}
		
		println("Printing generated random orders (models apper in original order)")
		println("SeqNo;Index;Model;NewShapes;AllShapes")
		
		var seqindx=0;
		for (seq:sequences) {
			val currshapes=new HashSet<AbstractNodeDescriptor>()
			var indx=0
			for (model:seq){
				val beforesize=currshapes.size
				currshapes.addAll(shapes.get(model).keySet)
				val aftersize=currshapes.size
				val diff=aftersize-beforesize
				println(seqindx+";"+indx+";"+model+";"+diff+";"+currshapes.size)	
				indx++;
			}
			seqindx++;
		}
	}
	
	 def static void printShapeNumbers(PrintWriter writer, List<File> order, Map<File,Map<? extends AbstractNodeDescriptor, Integer>> shapes) {
	 	println("Model;Index;Size;InternalDiversity;NewShapes;AllCurrentShapes")
	 	writer.write("Model;Index;Size;InternalDiversity;NewShapes;AllCurrentShapes\n")
		val currshapes=new HashSet<AbstractNodeDescriptor>()
		
		for (file:order) {
			val beforesize=currshapes.size
			currshapes.addAll(shapes.get(file).keySet)
			val aftersize=currshapes.size
			val diff=aftersize-beforesize
			val index = file.name.split("\\.").head.split("\\_").last
			val sizeString = file.toPath.toString.split("\\\\").filter[it.startsWith("cyphers")].head
			
			val size = "x"//sizeString.substring("cyphers".length, sizeString.length);
			
			println(file+";" + index + ";" + size +";" +shapes.get(file).size+";"+diff+";"+currshapes.size)
			writer.write(file+";"+index +";" +size +";" +shapes.get(file).size+";"+diff+";"+currshapes.size+"\n")
		}
	 }
	
	
//	def static void measureDiversity(String scenario, File parent, List<File> files, String path, int depth) {
//		val workspace = new FileSystemWorkspace(path,"")
//		val file2Neighbourhood = new HashMap
//		for(file : files) {
//			val MetamodelLoader loader = new YakinduLoader(workspace) => [it.useSynchronization = false it.useComplexStates = true]
//			val metamodelTransformationOutput = ecore2Logic.transformMetamodel(loader.loadMetamodel,new Ecore2LogicConfiguration)
//			
//			val model = workspace.readModel(EObject,file.name)
//			val partialModel = partialInterpretation2Logic.transform(metamodelTransformationOutput,model.eResource,false)
//			val list = representationList(partialModel,depth)
//			
//			file2Neighbourhood.put(file,list)
//		}
//		for(file1Index : 0..<files.size) {
//			val file1 = files.get(file1Index)
//			if(Integer.parseInt(file1.name.runIndex)<=20) {
//				for(file2Index : 0..<file1Index) {
//					val file2 = files.get(file2Index)
//					val file1Representation = file2Neighbourhood.get(file1)
//					val file2Representation = file2Neighbourhood.get(file2)
//					print('''«scenario»;«file1.name.runIndex»;«file1.name.modelIndex»;«file2.name.modelIndex»''')
//					if(file1Representation.size == file1Representation.size) {
//						for(i : 0..<file1Representation.size) {
//							val s1 = file1Representation.get(i)
//							val s2 = file2Representation.get(i)
//							
//							val commonSet = new HashSet(s1)
//							commonSet.addAll(s2)
//							
//							val diff = (commonSet.size-s1.size) +  (commonSet.size-s2.size)
//							print(";"+diff)
//						}
//					} else {
//						throw new AssertionError('''length of representations is !=''')
//					}
//					println()
//				}
//			}
//		}
//	}
	
	protected def static runIndex(String name) {
		val res = name.split("\\.").head.split('_').get(0)
		if(res.startsWith("result")) {
			return res.substring(6)
		} else {
			return res
		}
	}
	protected def static modelIndex(String name) {
		name.split("\\.").head.split('_').get(1)
	}
	
	protected def static  representationList(PartialInterpretation partialModel, int depth) {
		val list = new LinkedList
		for(i : 0..<depth) {
			val neighbourhood = neiguboirhoodComputer.createRepresentation(partialModel,i,0,0)
			//val m = neighbourhood.modelRepresentation
			//println(m)
			list.add(neighbourhood.modelRepresentation.keySet.map[it.hashCode].toSet)
		}
		return list
	}
	protected def static List<Map<? extends AbstractNodeDescriptor, Integer>>  shapeList(PartialInterpretation partialModel, int depth) {
		
		val list = new LinkedList
		for(i : 0..<depth) {
			
			val neighbourhood = neiguboirhoodComputer.createRepresentation(partialModel,i,Integer.MAX_VALUE,Integer.MAX_VALUE)
			//val m = neighbourhood.modelRepresentation
			//println(m)
			val openWorldElements = partialModel.openWorldElements
			val representationsOfOpenElements = openWorldElements.map[neighbourhood.nodeRepresentations.get(it)].toSet 
			val allElementRepresentation = new HashMap(neighbourhood.modelRepresentation)
			representationsOfOpenElements.forEach[allElementRepresentation.remove(it)]
			
			val Map<Long, Integer> hashedRepresentation = new HashMap()
			for(entry : allElementRepresentation.entrySet) {
				hashedRepresentation.put(entry.key.dataHash,entry.value)
			}
			list.add(allElementRepresentation)
		}
		return list
	}
	

}

class PatternWithMatches {
	String name;
	List<List<DefinedElement>> matches
}

class FileComparator implements Comparator<File> {
	
	override compare(File arg0, File arg1) {
		val r1 = Integer.parseInt(MeasureDiversity::runIndex(arg0.name))
		val r2 = Integer.parseInt(MeasureDiversity::runIndex(arg1.name))
		val runRes = Integer.compare(r1, r2)
		if(runRes === 0) {
			val a = Integer.parseInt(MeasureDiversity::modelIndex(arg0.name))
			val b = Integer.parseInt(MeasureDiversity::modelIndex(arg1.name))
			Integer.compare(a,b)
		} else {
			return runRes
		}
	}
	
}