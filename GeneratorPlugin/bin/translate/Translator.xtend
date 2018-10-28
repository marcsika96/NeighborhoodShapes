package translate

import java.io.File
import java.util.HashMap
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.slizaa.neo4j.opencypher.OpenCypherStandaloneSetup
import org.slizaa.neo4j.opencypher.openCypher.OpenCypherPackage
import org.slizaa.neo4j.opencypher.openCypher.SinglePartQuery

class Translator {
	def static void main(String[] args) {
		OpenCypherPackage.eINSTANCE.eClass
		Resource.Factory.Registry.INSTANCE.extensionToFactoryMap.put("xmi",new XMIResourceFactoryImpl)
		OpenCypherStandaloneSetup.doSetup
		
		val t = new Translator
//		for(scenario : #["A","A","Ap","App"]) {
//			for(var i = 1; i<=10; i++) {
//				val models = t.loadModels("measurement"+scenario+"/models/run"+i)
//				t.saveModels(models,'''measurement«scenario»/cypher/run«i»''')
//			}
//		}

		for(scenario : (1..10).map[it*5]+#[100,150,200]) {
			for(var i = 1; i<=10; i++) {
				val models = t.loadModels("measurementB/models"+scenario+"/run"+i)
				t.saveModels(models,"measurementB/cyphers"+scenario+"/run"+i)
			}
			
		}
	}
	
	def loadModels(String path) {
		val folder = new File(path)
		val files = folder.listFiles
		
		val res = new HashMap
		
		for(file : files.filter[name.endsWith("xmi")]) {
			val uri = URI.createFileURI(file.absolutePath)
			val rs = new ResourceSetImpl
			val resource = rs.getResource(uri,true);
			resource.allContents.toList
			val SinglePartQuery query = resource.contents.head as SinglePartQuery
			res.put(file,query)
		}
		
		return res
	}
	
	def saveModels(HashMap<File, SinglePartQuery> file2Query, String path) {
		val folder = new File(path)
		folder.mkdirs
		
		folder.listFiles.toList.forEach[delete]
		
		for(entry : file2Query.entrySet) {
			val original = entry.key
			val model = entry.value
			
			val rsi = new ResourceSetImpl
			val uri = URI.createFileURI('''«folder.absolutePath»/«original.name.split("\\.").head».cypher''')
			val resource = rsi.createResource(uri)
			
			val startTime = System.nanoTime
			
			val cypher = (new PostProcessor).postProcessModel(model)
			
			resource.contents.add(cypher)
			val postProcessingFinished = System.nanoTime
			try{
				resource.save(emptyMap)
				val saveFinished = System.nanoTime
				println('''Successfully saved file "«original.absolutePath»;«postProcessingFinished-startTime»;«saveFinished-postProcessingFinished»''')
				
			} catch(Exception e) {
				println('''
				Unable to save file "«original.absolutePath»"
				--------------------
				''')
				e.printStackTrace(System.out)
			}
		}
	}
}