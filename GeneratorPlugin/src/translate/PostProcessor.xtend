package translate

import org.slizaa.neo4j.opencypher.openCypher.Cypher
import org.slizaa.neo4j.opencypher.openCypher.MapLiteralEntry
import org.slizaa.neo4j.opencypher.openCypher.NodeLabel
import org.slizaa.neo4j.opencypher.openCypher.OpenCypherFactory
import org.slizaa.neo4j.opencypher.openCypher.Return
import org.slizaa.neo4j.opencypher.openCypher.SinglePartQuery
import org.slizaa.neo4j.opencypher.openCypher.StringLiteral
import org.slizaa.neo4j.opencypher.openCypher.VariableDeclaration
import org.slizaa.neo4j.opencypher.openCypher.RelationshipDetail
import org.slizaa.neo4j.opencypher.openCypher.RelationshipTypes

class PostProcessor {
	public def Cypher postProcessModel(SinglePartQuery model) {
		val factory = OpenCypherFactory.eINSTANCE
		val cypher = factory.createCypher
		cypher.statement = model
		cypher.queryOptions = factory.createAllOptions => [it.explain = false it.profile = false]
		// return fill "Return"
		model.eAllContents.filter(Return).forEach[it.^return = "RETURN"]
		// variable name filling
		val variables = model.eAllContents.filter(VariableDeclaration).toList
		val variableIndexes = 0..<variables.size
		for(i : variableIndexes) {
			variables.get(i).name = '''V«i+1»'''
		}
		// string name literals
		val stringliterals = model.eAllContents.filter(StringLiteral).toList
		val stringLiteralIndexes = 0..<stringliterals.size
		for(i : stringLiteralIndexes) {
			stringliterals.get(i).value ='''"String«i+1»"'''
		}
		//MapliteralEntry keys
		val mapkeys = model.eAllContents.filter(MapLiteralEntry).toList
		val mapKeyIndexes = 0..<mapkeys.size
		for(i : mapKeyIndexes){
			mapkeys.get(i).key = '''Key«i+1»'''
		}
		//NodeLabelNames keys
		val labels = model.eAllContents.filter(NodeLabel).toList
		val labelIndexes = 0..<labels.size
		for(i : labelIndexes){
			labels.get(i).labelName = '''Label«i+1»'''
		}

		//RelationshipDetail.relTypeNames
		val relDetails = model.eAllContents.filter(RelationshipDetail).toList
		val relDetailsIndexes = 0..<relDetails.size
		for(i : relDetailsIndexes){
			relDetails.get(i).relTypeNames += '''RelTypeName«i+1»'''
		}
		
		return cypher
	}
}