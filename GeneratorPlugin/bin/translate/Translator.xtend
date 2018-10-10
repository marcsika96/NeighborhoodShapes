package translate

import java.io.File
import java.util.HashMap
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.slizaa.neo4j.opencypher.openCypher.OpenCypherPackage
import org.slizaa.neo4j.opencypher.openCypher.SinglePartQuery
import org.slizaa.neo4j.opencypher.openCypher.OpenCypherFactory
import org.slizaa.neo4j.opencypher.OpenCypherStandaloneSetup
import org.slizaa.neo4j.opencypher.openCypher.Return

class Translator {
	def static void main(String[] args) {
		OpenCypherPackage.eINSTANCE.eClass
		Resource.Factory.Registry.INSTANCE.extensionToFactoryMap.put("xmi",new XMIResourceFactoryImpl)
		OpenCypherStandaloneSetup.doSetup
		
		val t = new Translator
		
		val models = t.loadModels("models")
		println('''Load completed.''')
		t.saveModels(models,"cypher")
		println('''Save completed.''')
	}
	
	def loadModels(String path) {
		val folder = new File(path)
		val files = folder.listFiles
		
		val res = new HashMap
		
		for(file : files.filter[name.endsWith("xmi")]) {
			val uri = URI.createFileURI(file.absolutePath)
			val rs = new ResourceSetImpl
			val resource = rs.getResource(uri,true);
			val SinglePartQuery query = resource.contents.head as SinglePartQuery
			res.put(file,query)
		}
		
		return res
	}
	
	def saveModels(HashMap<File, SinglePartQuery> file2Query, String path) {
		val folder = new File(path)
		
		folder.listFiles.toList.forEach[delete]
		
		for(entry : file2Query.entrySet) {
			val original = entry.key
			val model = entry.value
			
			val rsi = new ResourceSetImpl
			val uri = URI.createFileURI('''«folder.absolutePath»/«original.name.split("\\.").head».cypher''')
			val resource = rsi.createResource(uri)
			val factory = OpenCypherFactory.eINSTANCE
			
			val cypher = factory.createCypher
			cypher.statement = model
			cypher.queryOptions = factory.createAllOptions => [it.explain = false it.profile = false]
			model.eAllContents.filter(Return).forEach[it.^return = "RETURN"]
			resource.contents.add(cypher)
			
			try{
				resource.save(emptyMap)
			} catch(Exception e) {
				println('''
				Unable to save file "«original.absolutePath»"
				--------------------
				''')
				e.printStackTrace
			}
		}
	}
}