enum util'boolean {
	util'boolean'true, util'boolean'false
}
one sig util'language {
	util'root : one type'ReturnItems'class + (type'SingleQuery'class + (type'VariableRef'class + (type'ReturnBody'class + (type'Literal'class + (type'ReadingClause'class + (type'AllOptions'class + (type'MapLiteral'class + (type'ReturnItem'class + (type'Query'class + (type'Expression'class + (type'SinglePartQuery'class + (type'Cypher'class + (type'Return'class + (type'QueryOptions'class + (type'Match'class + (type'PropertyExpression'class + (type'MapLiteralEntry'class + (type'RegularQuery'class + (type'Statement'class + (type'AnonymousPatternPart'class + (type'NodeLabels'class + (type'NodePattern'class + (type'StringLiteral'class + (type'PatternElement'class + (type'VariableDeclaration'class + (type'Properties'class + (type'Clause'class + (type'Pattern'class + (type'PatternPart'class + (type'SinglePartQuery'class'DefinedPart + (type'SinglePartQuery'class'UndefinedPart + (type'SingleQuery'class'DefinedPart + (type'SingleQuery'class'UndefinedPart + (type'RegularQuery'class'DefinedPart + (type'RegularQuery'class'UndefinedPart + (type'Query'class'DefinedPart + (type'Query'class'UndefinedPart + (type'Statement'class'DefinedPart + type'Statement'class'UndefinedPart)))))))))))))))))))))))))))))))))))))),
	util'contains : (type'ReturnItems'class + (type'SingleQuery'class + (type'VariableRef'class + (type'ReturnBody'class + (type'Literal'class + (type'ReadingClause'class + (type'AllOptions'class + (type'MapLiteral'class + (type'ReturnItem'class + (type'Query'class + (type'Expression'class + (type'SinglePartQuery'class + (type'Cypher'class + (type'Return'class + (type'QueryOptions'class + (type'Match'class + (type'PropertyExpression'class + (type'MapLiteralEntry'class + (type'RegularQuery'class + (type'Statement'class + (type'AnonymousPatternPart'class + (type'NodeLabels'class + (type'NodePattern'class + (type'StringLiteral'class + (type'PatternElement'class + (type'VariableDeclaration'class + (type'Properties'class + (type'Clause'class + (type'Pattern'class + (type'PatternPart'class + (type'SinglePartQuery'class'DefinedPart + (type'SinglePartQuery'class'UndefinedPart + (type'SingleQuery'class'DefinedPart + (type'SingleQuery'class'UndefinedPart + (type'RegularQuery'class'DefinedPart + (type'RegularQuery'class'UndefinedPart + (type'Query'class'DefinedPart + (type'Query'class'UndefinedPart + (type'Statement'class'DefinedPart + type'Statement'class'UndefinedPart))))))))))))))))))))))))))))))))))))))) lone->set (type'ReturnItems'class + (type'SingleQuery'class + (type'VariableRef'class + (type'ReturnBody'class + (type'Literal'class + (type'ReadingClause'class + (type'AllOptions'class + (type'MapLiteral'class + (type'ReturnItem'class + (type'Query'class + (type'Expression'class + (type'SinglePartQuery'class + (type'Cypher'class + (type'Return'class + (type'QueryOptions'class + (type'Match'class + (type'PropertyExpression'class + (type'MapLiteralEntry'class + (type'RegularQuery'class + (type'Statement'class + (type'AnonymousPatternPart'class + (type'NodeLabels'class + (type'NodePattern'class + (type'StringLiteral'class + (type'PatternElement'class + (type'VariableDeclaration'class + (type'Properties'class + (type'Clause'class + (type'Pattern'class + (type'PatternPart'class + (type'SinglePartQuery'class'DefinedPart + (type'SinglePartQuery'class'UndefinedPart + (type'SingleQuery'class'DefinedPart + (type'SingleQuery'class'UndefinedPart + (type'RegularQuery'class'DefinedPart + (type'RegularQuery'class'UndefinedPart + (type'Query'class'DefinedPart + (type'Query'class'UndefinedPart + (type'Statement'class'DefinedPart + type'Statement'class'UndefinedPart)))))))))))))))))))))))))))))))))))))))
}
abstract sig util'Object {
}
sig type'Cypher'class in util'Object {
	statement'reference'Cypher : lone type'Statement'class
}
sig type'AllOptions'class in type'QueryOptions'class {
	explain'attribute'AllOptions : lone util'boolean,
	profile'attribute'AllOptions : lone util'boolean
}
sig type'SinglePartQuery'class in type'SingleQuery'class {
	readingClauses'reference'SinglePartQuery : set type'ReadingClause'class,
	return'reference'SinglePartQuery : lone type'Return'class
}
sig type'Match'class in type'ReadingClause'class {
	pattern'reference'Match : lone type'Pattern'class,
	optional'attribute'Match : lone util'boolean
}
sig type'Pattern'class in util'Object {
	patterns'reference'Pattern : some type'PatternPart'class
}
sig type'PatternPart'class in util'Object {
	var'reference'PatternPart : one type'VariableDeclaration'class,
	part'reference'PatternPart : lone type'AnonymousPatternPart'class
}
sig type'PatternElement'class in type'AnonymousPatternPart'class {
	nodepattern'reference'PatternElement : lone type'NodePattern'class
}
sig type'NodePattern'class in type'NodeLabels'class {
	properties'reference'NodePattern : lone type'Properties'class,
	variable'reference'NodePattern : lone type'VariableDeclaration'class
}
sig type'VariableDeclaration'class in util'Object {
	name'attribute'VariableDeclaration : one String
}
sig type'MapLiteral'class in type'Properties'class + type'Literal'class {
	entries'reference'MapLiteral : set type'MapLiteralEntry'class
}
sig type'MapLiteralEntry'class in util'Object {
	value'reference'MapLiteralEntry : lone type'Expression'class,
	key'attribute'MapLiteralEntry : lone String
}
sig type'StringLiteral'class in type'Literal'class {
	value'attribute'StringLiteral : lone String
}
sig type'Return'class in type'Clause'class {
	body'reference'Return : lone type'ReturnBody'class,
	return'attribute'Return : lone String,
	distinct'attribute'Return : lone util'boolean
}
sig type'ReturnBody'class in util'Object {
	returnItems'reference'ReturnBody : lone type'ReturnItems'class
}
sig type'ReturnItems'class in util'Object {
	items'reference'ReturnItems : set type'ReturnItem'class,
	all'attribute'ReturnItems : lone String
}
sig type'ReturnItem'class in util'Object {
	alias'reference'ReturnItem : lone type'VariableDeclaration'class,
	expression'reference'ReturnItem : lone type'Expression'class
}
sig type'VariableRef'class in type'Expression'class {
	variableRef'reference'VariableRef : lone type'VariableDeclaration'class
}
sig type'SingleQuery'class in type'RegularQuery'class {
}
sig type'RegularQuery'class in type'Query'class {
}
sig type'Query'class in type'Statement'class {
}
sig type'Statement'class in util'Object {
}
sig type'ReadingClause'class in type'Clause'class {
}
sig type'Clause'class in util'Object {
}
sig type'AnonymousPatternPart'class in type'PatternPart'class {
}
sig type'NodeLabels'class in util'Object {
}
sig type'Properties'class in util'Object {
}
sig type'Literal'class in type'Expression'class {
}
sig type'Expression'class in type'NodeLabels'class + type'PropertyExpression'class {
}
sig type'PropertyExpression'class in util'Object {
}
sig type'QueryOptions'class in util'Object {
}
sig type'SinglePartQuery'class'DefinedPart in type'SinglePartQuery'class + type'SingleQuery'class'DefinedPart {
}
sig type'SinglePartQuery'class'UndefinedPart in type'SinglePartQuery'class + type'SingleQuery'class'UndefinedPart {
}
sig type'SingleQuery'class'DefinedPart in type'SingleQuery'class + type'RegularQuery'class'DefinedPart {
}
sig type'SingleQuery'class'UndefinedPart in type'SingleQuery'class + type'RegularQuery'class'UndefinedPart {
}
sig type'RegularQuery'class'DefinedPart in type'RegularQuery'class + type'Query'class'DefinedPart {
}
sig type'RegularQuery'class'UndefinedPart in type'RegularQuery'class + type'Query'class'UndefinedPart {
}
sig type'Query'class'DefinedPart in type'Query'class + type'Statement'class'DefinedPart {
}
sig type'Query'class'UndefinedPart in type'Query'class + type'Statement'class'UndefinedPart {
}
sig type'Statement'class'DefinedPart in type'Statement'class {
}
sig type'Statement'class'UndefinedPart in type'Statement'class {
}
one sig element'o'1 in type'Statement'class'DefinedPart {
}
pred pattern'validation'hasReturn [parameter'q: type'SinglePartQuery'class, parameter'r: type'Return'class] {
	parameter'r in parameter'q.return'reference'SinglePartQuery && parameter'r in type'Return'class
}
pred pattern'validation'hasNoReturn [parameter'q: type'SinglePartQuery'class] {
	all variable'0: type'Return'class { parameter'q in type'SinglePartQuery'class && ! (pattern'validation'hasReturn [ parameter'q , variable'0 ]) }
}
pred pattern'validation'hasMatch [parameter'q: type'SinglePartQuery'class, parameter'm: type'Match'class] {
	parameter'm in type'Match'class && parameter'm in parameter'q.readingClauses'reference'SinglePartQuery
}
pred pattern'validation'hasNoMatch [parameter'q: type'SinglePartQuery'class] {
	all variable'0: type'Match'class { parameter'q in type'SinglePartQuery'class && ! (pattern'validation'hasMatch [ parameter'q , variable'0 ]) }
}
pred pattern'validation'hasPattern [parameter'm: type'Match'class, parameter'p: type'Pattern'class] {
	parameter'p in parameter'm.pattern'reference'Match && parameter'p in type'Pattern'class
}
pred pattern'validation'hasNoPattern [parameter'm: type'Match'class] {
	all variable'0: type'Pattern'class { parameter'm in type'Match'class && ! (pattern'validation'hasPattern [ parameter'm , variable'0 ]) }
}
pred pattern'validation'hasReturnItems [parameter'body: type'ReturnBody'class, parameter'items: type'ReturnItems'class] {
	parameter'items in parameter'body.returnItems'reference'ReturnBody && parameter'items in type'ReturnItems'class
}
pred pattern'validation'hasNoReturnItems [parameter'body: type'ReturnBody'class] {
	all variable'0: type'ReturnItems'class { parameter'body in type'ReturnBody'class && ! (pattern'validation'hasReturnItems [ parameter'body , variable'0 ]) }
}
pred pattern'validation'hasReturnItem [parameter'items: type'ReturnItems'class, parameter'item: type'ReturnItem'class] {
	parameter'item in parameter'items.items'reference'ReturnItems && parameter'item in type'ReturnItem'class
}
pred pattern'validation'hasNoReturnItem [parameter'items: type'ReturnItems'class] {
	all variable'0: type'ReturnItem'class { parameter'items in type'ReturnItems'class && ! (pattern'validation'hasReturnItem [ parameter'items , variable'0 ]) }
}
fact typedefinition'SinglePartQuery'class'DefinedPart {
	type'SinglePartQuery'class'DefinedPart = element'o'1
}
fact typedefinition'SingleQuery'class'DefinedPart {
	type'SingleQuery'class'DefinedPart = element'o'1
}
fact typedefinition'RegularQuery'class'DefinedPart {
	type'RegularQuery'class'DefinedPart = element'o'1
}
fact typedefinition'Query'class'DefinedPart {
	type'Query'class'DefinedPart = element'o'1
}
fact typedefinition'Statement'class'DefinedPart {
	type'Statement'class'DefinedPart = element'o'1
}
fact abstract'MapLiteral'class {
	type'MapLiteral'class = type'Properties'class & type'Literal'class
}
fact abstract'Expression'class {
	type'Expression'class = type'NodeLabels'class & type'PropertyExpression'class
}
fact abstract'SinglePartQuery'class'DefinedPart {
	type'SinglePartQuery'class'DefinedPart = type'SinglePartQuery'class & type'SingleQuery'class'DefinedPart
}
fact abstract'SinglePartQuery'class'UndefinedPart {
	type'SinglePartQuery'class'UndefinedPart = type'SinglePartQuery'class & type'SingleQuery'class'UndefinedPart
}
fact abstract'SingleQuery'class'DefinedPart {
	type'SingleQuery'class'DefinedPart = type'SingleQuery'class & type'RegularQuery'class'DefinedPart
}
fact abstract'SingleQuery'class'UndefinedPart {
	type'SingleQuery'class'UndefinedPart = type'SingleQuery'class & type'RegularQuery'class'UndefinedPart
}
fact abstract'RegularQuery'class'DefinedPart {
	type'RegularQuery'class'DefinedPart = type'RegularQuery'class & type'Query'class'DefinedPart
}
fact abstract'RegularQuery'class'UndefinedPart {
	type'RegularQuery'class'UndefinedPart = type'RegularQuery'class & type'Query'class'UndefinedPart
}
fact abstract'Query'class'DefinedPart {
	type'Query'class'DefinedPart = type'Query'class & type'Statement'class'DefinedPart
}
fact abstract'Query'class'UndefinedPart {
	type'Query'class'UndefinedPart = type'Query'class & type'Statement'class'UndefinedPart
}
fact abstract'SinglePartQuery'class {
	type'SinglePartQuery'class = type'SinglePartQuery'class'DefinedPart + type'SinglePartQuery'class'UndefinedPart
}
fact abstract'SingleQuery'class {
	type'SingleQuery'class = type'SinglePartQuery'class + (type'SingleQuery'class'DefinedPart + type'SingleQuery'class'UndefinedPart)
}
fact abstract'RegularQuery'class {
	type'RegularQuery'class = type'SingleQuery'class + (type'RegularQuery'class'DefinedPart + type'RegularQuery'class'UndefinedPart)
}
fact abstract'Query'class {
	type'Query'class = type'RegularQuery'class + (type'Query'class'DefinedPart + type'Query'class'UndefinedPart)
}
fact abstract'Statement'class {
	type'Statement'class = type'Query'class + (type'Statement'class'DefinedPart + type'Statement'class'UndefinedPart)
}
fact ObjectTypeDefinition {
	util'Object = type'Cypher'class + (type'Pattern'class + (type'PatternPart'class + (type'VariableDeclaration'class + (type'MapLiteralEntry'class + (type'ReturnBody'class + (type'ReturnItems'class + (type'ReturnItem'class + (type'Statement'class + (type'Clause'class + (type'NodeLabels'class + (type'Properties'class + (type'PropertyExpression'class + type'QueryOptions'class))))))))))))
}
fact common'types'Pattern'class'Cypher'class {
	type'Pattern'class & type'Cypher'class = none
}
fact common'types'PatternPart'class'Cypher'class {
	type'PatternPart'class & type'Cypher'class = none
}
fact common'types'PatternPart'class'Pattern'class {
	type'PatternPart'class & type'Pattern'class = none
}
fact common'types'VariableDeclaration'class'Cypher'class {
	type'VariableDeclaration'class & type'Cypher'class = none
}
fact common'types'VariableDeclaration'class'Pattern'class {
	type'VariableDeclaration'class & type'Pattern'class = none
}
fact common'types'VariableDeclaration'class'PatternPart'class {
	type'VariableDeclaration'class & type'PatternPart'class = none
}
fact common'types'MapLiteralEntry'class'Cypher'class {
	type'MapLiteralEntry'class & type'Cypher'class = none
}
fact common'types'MapLiteralEntry'class'Pattern'class {
	type'MapLiteralEntry'class & type'Pattern'class = none
}
fact common'types'MapLiteralEntry'class'PatternPart'class {
	type'MapLiteralEntry'class & type'PatternPart'class = none
}
fact common'types'MapLiteralEntry'class'VariableDeclaration'class {
	type'MapLiteralEntry'class & type'VariableDeclaration'class = none
}
fact common'types'ReturnBody'class'Cypher'class {
	type'ReturnBody'class & type'Cypher'class = none
}
fact common'types'ReturnBody'class'Pattern'class {
	type'ReturnBody'class & type'Pattern'class = none
}
fact common'types'ReturnBody'class'PatternPart'class {
	type'ReturnBody'class & type'PatternPart'class = none
}
fact common'types'ReturnBody'class'VariableDeclaration'class {
	type'ReturnBody'class & type'VariableDeclaration'class = none
}
fact common'types'ReturnBody'class'MapLiteralEntry'class {
	type'ReturnBody'class & type'MapLiteralEntry'class = none
}
fact common'types'ReturnItems'class'Cypher'class {
	type'ReturnItems'class & type'Cypher'class = none
}
fact common'types'ReturnItems'class'Pattern'class {
	type'ReturnItems'class & type'Pattern'class = none
}
fact common'types'ReturnItems'class'PatternPart'class {
	type'ReturnItems'class & type'PatternPart'class = none
}
fact common'types'ReturnItems'class'VariableDeclaration'class {
	type'ReturnItems'class & type'VariableDeclaration'class = none
}
fact common'types'ReturnItems'class'MapLiteralEntry'class {
	type'ReturnItems'class & type'MapLiteralEntry'class = none
}
fact common'types'ReturnItems'class'ReturnBody'class {
	type'ReturnItems'class & type'ReturnBody'class = none
}
fact common'types'ReturnItem'class'Cypher'class {
	type'ReturnItem'class & type'Cypher'class = none
}
fact common'types'ReturnItem'class'Pattern'class {
	type'ReturnItem'class & type'Pattern'class = none
}
fact common'types'ReturnItem'class'PatternPart'class {
	type'ReturnItem'class & type'PatternPart'class = none
}
fact common'types'ReturnItem'class'VariableDeclaration'class {
	type'ReturnItem'class & type'VariableDeclaration'class = none
}
fact common'types'ReturnItem'class'MapLiteralEntry'class {
	type'ReturnItem'class & type'MapLiteralEntry'class = none
}
fact common'types'ReturnItem'class'ReturnBody'class {
	type'ReturnItem'class & type'ReturnBody'class = none
}
fact common'types'ReturnItem'class'ReturnItems'class {
	type'ReturnItem'class & type'ReturnItems'class = none
}
fact common'types'Statement'class'Cypher'class {
	type'Statement'class & type'Cypher'class = none
}
fact common'types'Statement'class'Pattern'class {
	type'Statement'class & type'Pattern'class = none
}
fact common'types'Statement'class'PatternPart'class {
	type'Statement'class & type'PatternPart'class = none
}
fact common'types'Statement'class'VariableDeclaration'class {
	type'Statement'class & type'VariableDeclaration'class = none
}
fact common'types'Statement'class'MapLiteralEntry'class {
	type'Statement'class & type'MapLiteralEntry'class = none
}
fact common'types'Statement'class'ReturnBody'class {
	type'Statement'class & type'ReturnBody'class = none
}
fact common'types'Statement'class'ReturnItems'class {
	type'Statement'class & type'ReturnItems'class = none
}
fact common'types'Statement'class'ReturnItem'class {
	type'Statement'class & type'ReturnItem'class = none
}
fact common'types'Clause'class'Cypher'class {
	type'Clause'class & type'Cypher'class = none
}
fact common'types'Clause'class'Pattern'class {
	type'Clause'class & type'Pattern'class = none
}
fact common'types'Clause'class'PatternPart'class {
	type'Clause'class & type'PatternPart'class = none
}
fact common'types'Clause'class'VariableDeclaration'class {
	type'Clause'class & type'VariableDeclaration'class = none
}
fact common'types'Clause'class'MapLiteralEntry'class {
	type'Clause'class & type'MapLiteralEntry'class = none
}
fact common'types'Clause'class'ReturnBody'class {
	type'Clause'class & type'ReturnBody'class = none
}
fact common'types'Clause'class'ReturnItems'class {
	type'Clause'class & type'ReturnItems'class = none
}
fact common'types'Clause'class'ReturnItem'class {
	type'Clause'class & type'ReturnItem'class = none
}
fact common'types'Clause'class'Statement'class {
	type'Clause'class & type'Statement'class = none
}
fact common'types'NodeLabels'class'Cypher'class {
	type'NodeLabels'class & type'Cypher'class = none
}
fact common'types'NodeLabels'class'Pattern'class {
	type'NodeLabels'class & type'Pattern'class = none
}
fact common'types'NodeLabels'class'PatternPart'class {
	type'NodeLabels'class & type'PatternPart'class = none
}
fact common'types'NodeLabels'class'VariableDeclaration'class {
	type'NodeLabels'class & type'VariableDeclaration'class = none
}
fact common'types'NodeLabels'class'MapLiteralEntry'class {
	type'NodeLabels'class & type'MapLiteralEntry'class = none
}
fact common'types'NodeLabels'class'ReturnBody'class {
	type'NodeLabels'class & type'ReturnBody'class = none
}
fact common'types'NodeLabels'class'ReturnItems'class {
	type'NodeLabels'class & type'ReturnItems'class = none
}
fact common'types'NodeLabels'class'ReturnItem'class {
	type'NodeLabels'class & type'ReturnItem'class = none
}
fact common'types'NodeLabels'class'Statement'class {
	type'NodeLabels'class & type'Statement'class = none
}
fact common'types'NodeLabels'class'Clause'class {
	type'NodeLabels'class & type'Clause'class = none
}
fact common'types'Properties'class'Cypher'class {
	type'Properties'class & type'Cypher'class = none
}
fact common'types'Properties'class'Pattern'class {
	type'Properties'class & type'Pattern'class = none
}
fact common'types'Properties'class'PatternPart'class {
	type'Properties'class & type'PatternPart'class = none
}
fact common'types'Properties'class'VariableDeclaration'class {
	type'Properties'class & type'VariableDeclaration'class = none
}
fact common'types'Properties'class'MapLiteralEntry'class {
	type'Properties'class & type'MapLiteralEntry'class = none
}
fact common'types'Properties'class'ReturnBody'class {
	type'Properties'class & type'ReturnBody'class = none
}
fact common'types'Properties'class'ReturnItems'class {
	type'Properties'class & type'ReturnItems'class = none
}
fact common'types'Properties'class'ReturnItem'class {
	type'Properties'class & type'ReturnItem'class = none
}
fact common'types'Properties'class'Statement'class {
	type'Properties'class & type'Statement'class = none
}
fact common'types'Properties'class'Clause'class {
	type'Properties'class & type'Clause'class = none
}
fact common'types'Properties'class'NodeLabels'class {
	type'Properties'class & type'NodeLabels'class = type'MapLiteral'class
}
fact common'types'PropertyExpression'class'Cypher'class {
	type'PropertyExpression'class & type'Cypher'class = none
}
fact common'types'PropertyExpression'class'Pattern'class {
	type'PropertyExpression'class & type'Pattern'class = none
}
fact common'types'PropertyExpression'class'PatternPart'class {
	type'PropertyExpression'class & type'PatternPart'class = none
}
fact common'types'PropertyExpression'class'VariableDeclaration'class {
	type'PropertyExpression'class & type'VariableDeclaration'class = none
}
fact common'types'PropertyExpression'class'MapLiteralEntry'class {
	type'PropertyExpression'class & type'MapLiteralEntry'class = none
}
fact common'types'PropertyExpression'class'ReturnBody'class {
	type'PropertyExpression'class & type'ReturnBody'class = none
}
fact common'types'PropertyExpression'class'ReturnItems'class {
	type'PropertyExpression'class & type'ReturnItems'class = none
}
fact common'types'PropertyExpression'class'ReturnItem'class {
	type'PropertyExpression'class & type'ReturnItem'class = none
}
fact common'types'PropertyExpression'class'Statement'class {
	type'PropertyExpression'class & type'Statement'class = none
}
fact common'types'PropertyExpression'class'Clause'class {
	type'PropertyExpression'class & type'Clause'class = none
}
fact common'types'PropertyExpression'class'NodeLabels'class {
	type'PropertyExpression'class & type'NodeLabels'class = type'Expression'class
}
fact common'types'PropertyExpression'class'Properties'class {
	type'PropertyExpression'class & type'Properties'class = type'MapLiteral'class
}
fact common'types'QueryOptions'class'Cypher'class {
	type'QueryOptions'class & type'Cypher'class = none
}
fact common'types'QueryOptions'class'Pattern'class {
	type'QueryOptions'class & type'Pattern'class = none
}
fact common'types'QueryOptions'class'PatternPart'class {
	type'QueryOptions'class & type'PatternPart'class = none
}
fact common'types'QueryOptions'class'VariableDeclaration'class {
	type'QueryOptions'class & type'VariableDeclaration'class = none
}
fact common'types'QueryOptions'class'MapLiteralEntry'class {
	type'QueryOptions'class & type'MapLiteralEntry'class = none
}
fact common'types'QueryOptions'class'ReturnBody'class {
	type'QueryOptions'class & type'ReturnBody'class = none
}
fact common'types'QueryOptions'class'ReturnItems'class {
	type'QueryOptions'class & type'ReturnItems'class = none
}
fact common'types'QueryOptions'class'ReturnItem'class {
	type'QueryOptions'class & type'ReturnItem'class = none
}
fact common'types'QueryOptions'class'Statement'class {
	type'QueryOptions'class & type'Statement'class = none
}
fact common'types'QueryOptions'class'Clause'class {
	type'QueryOptions'class & type'Clause'class = none
}
fact common'types'QueryOptions'class'NodeLabels'class {
	type'QueryOptions'class & type'NodeLabels'class = none
}
fact common'types'QueryOptions'class'Properties'class {
	type'QueryOptions'class & type'Properties'class = none
}
fact common'types'QueryOptions'class'PropertyExpression'class {
	type'QueryOptions'class & type'PropertyExpression'class = none
}
fact common'types'SinglePartQuery'class'UndefinedPart'SinglePartQuery'class'DefinedPart {
	type'SinglePartQuery'class'UndefinedPart & type'SinglePartQuery'class'DefinedPart = none
}
fact common'types'SingleQuery'class'DefinedPart'SinglePartQuery'class {
	type'SingleQuery'class'DefinedPart & type'SinglePartQuery'class = type'SinglePartQuery'class'DefinedPart
}
fact common'types'SingleQuery'class'UndefinedPart'SinglePartQuery'class {
	type'SingleQuery'class'UndefinedPart & type'SinglePartQuery'class = type'SinglePartQuery'class'UndefinedPart
}
fact common'types'SingleQuery'class'UndefinedPart'SingleQuery'class'DefinedPart {
	type'SingleQuery'class'UndefinedPart & type'SingleQuery'class'DefinedPart = none
}
fact common'types'RegularQuery'class'DefinedPart'SingleQuery'class {
	type'RegularQuery'class'DefinedPart & type'SingleQuery'class = type'SingleQuery'class'DefinedPart
}
fact common'types'RegularQuery'class'UndefinedPart'SingleQuery'class {
	type'RegularQuery'class'UndefinedPart & type'SingleQuery'class = type'SingleQuery'class'UndefinedPart
}
fact common'types'RegularQuery'class'UndefinedPart'RegularQuery'class'DefinedPart {
	type'RegularQuery'class'UndefinedPart & type'RegularQuery'class'DefinedPart = none
}
fact common'types'Query'class'DefinedPart'RegularQuery'class {
	type'Query'class'DefinedPart & type'RegularQuery'class = type'RegularQuery'class'DefinedPart
}
fact common'types'Query'class'UndefinedPart'RegularQuery'class {
	type'Query'class'UndefinedPart & type'RegularQuery'class = type'RegularQuery'class'UndefinedPart
}
fact common'types'Query'class'UndefinedPart'Query'class'DefinedPart {
	type'Query'class'UndefinedPart & type'Query'class'DefinedPart = none
}
fact common'types'Statement'class'DefinedPart'Query'class {
	type'Statement'class'DefinedPart & type'Query'class = type'Query'class'DefinedPart
}
fact common'types'Statement'class'UndefinedPart'Query'class {
	type'Statement'class'UndefinedPart & type'Query'class = type'Query'class'UndefinedPart
}
fact common'types'Statement'class'UndefinedPart'Statement'class'DefinedPart {
	type'Statement'class'UndefinedPart & type'Statement'class'DefinedPart = none
}
fact common'types'ReadingClause'class'Return'class {
	type'ReadingClause'class & type'Return'class = none
}
fact common'types'Expression'class'NodePattern'class {
	type'Expression'class & type'NodePattern'class = none
}
fact common'types'StringLiteral'class'MapLiteral'class {
	type'StringLiteral'class & type'MapLiteral'class = none
}
fact common'types'Literal'class'VariableRef'class {
	type'Literal'class & type'VariableRef'class = none
}
fact util'containmentDefinition {
	util'language.util'contains = statement'reference'Cypher + (readingClauses'reference'SinglePartQuery + (return'reference'SinglePartQuery + (pattern'reference'Match + (patterns'reference'Pattern + (var'reference'PatternPart + (part'reference'PatternPart + (nodepattern'reference'PatternElement + (properties'reference'NodePattern + (variable'reference'NodePattern + (entries'reference'MapLiteral + (value'reference'MapLiteralEntry + (body'reference'Return + (returnItems'reference'ReturnBody + (items'reference'ReturnItems + (alias'reference'ReturnItem + expression'reference'ReturnItem)))))))))))))))
}
fact util'noParentForRoot {
	no parent: type'ReturnItems'class + (type'SingleQuery'class + (type'VariableRef'class + (type'ReturnBody'class + (type'Literal'class + (type'ReadingClause'class + (type'AllOptions'class + (type'MapLiteral'class + (type'ReturnItem'class + (type'Query'class + (type'Expression'class + (type'SinglePartQuery'class + (type'Cypher'class + (type'Return'class + (type'QueryOptions'class + (type'Match'class + (type'PropertyExpression'class + (type'MapLiteralEntry'class + (type'RegularQuery'class + (type'Statement'class + (type'AnonymousPatternPart'class + (type'NodeLabels'class + (type'NodePattern'class + (type'StringLiteral'class + (type'PatternElement'class + (type'VariableDeclaration'class + (type'Properties'class + (type'Clause'class + (type'Pattern'class + (type'PatternPart'class + (type'SinglePartQuery'class'DefinedPart + (type'SinglePartQuery'class'UndefinedPart + (type'SingleQuery'class'DefinedPart + (type'SingleQuery'class'UndefinedPart + (type'RegularQuery'class'DefinedPart + (type'RegularQuery'class'UndefinedPart + (type'Query'class'DefinedPart + (type'Query'class'UndefinedPart + (type'Statement'class'DefinedPart + type'Statement'class'UndefinedPart)))))))))))))))))))))))))))))))))))))) { parent->(util'language.util'root) in util'language.util'contains }
}
fact util'atLeastOneParent {
	all child: type'ReturnItems'class + (type'SingleQuery'class + (type'VariableRef'class + (type'ReturnBody'class + (type'Literal'class + (type'ReadingClause'class + (type'AllOptions'class + (type'MapLiteral'class + (type'ReturnItem'class + (type'Query'class + (type'Expression'class + (type'SinglePartQuery'class + (type'Cypher'class + (type'Return'class + (type'QueryOptions'class + (type'Match'class + (type'PropertyExpression'class + (type'MapLiteralEntry'class + (type'RegularQuery'class + (type'Statement'class + (type'AnonymousPatternPart'class + (type'NodeLabels'class + (type'NodePattern'class + (type'StringLiteral'class + (type'PatternElement'class + (type'VariableDeclaration'class + (type'Properties'class + (type'Clause'class + (type'Pattern'class + (type'PatternPart'class + (type'SinglePartQuery'class'DefinedPart + (type'SinglePartQuery'class'UndefinedPart + (type'SingleQuery'class'DefinedPart + (type'SingleQuery'class'UndefinedPart + (type'RegularQuery'class'DefinedPart + (type'RegularQuery'class'UndefinedPart + (type'Query'class'DefinedPart + (type'Query'class'UndefinedPart + (type'Statement'class'DefinedPart + type'Statement'class'UndefinedPart)))))))))))))))))))))))))))))))))))))) { child = util'language.util'root || (some parent: type'ReturnItems'class + (type'SingleQuery'class + (type'VariableRef'class + (type'ReturnBody'class + (type'Literal'class + (type'ReadingClause'class + (type'AllOptions'class + (type'MapLiteral'class + (type'ReturnItem'class + (type'Query'class + (type'Expression'class + (type'SinglePartQuery'class + (type'Cypher'class + (type'Return'class + (type'QueryOptions'class + (type'Match'class + (type'PropertyExpression'class + (type'MapLiteralEntry'class + (type'RegularQuery'class + (type'Statement'class + (type'AnonymousPatternPart'class + (type'NodeLabels'class + (type'NodePattern'class + (type'StringLiteral'class + (type'PatternElement'class + (type'VariableDeclaration'class + (type'Properties'class + (type'Clause'class + (type'Pattern'class + (type'PatternPart'class + (type'SinglePartQuery'class'DefinedPart + (type'SinglePartQuery'class'UndefinedPart + (type'SingleQuery'class'DefinedPart + (type'SingleQuery'class'UndefinedPart + (type'RegularQuery'class'DefinedPart + (type'RegularQuery'class'UndefinedPart + (type'Query'class'DefinedPart + (type'Query'class'UndefinedPart + (type'Statement'class'DefinedPart + type'Statement'class'UndefinedPart)))))))))))))))))))))))))))))))))))))) { parent->child in util'language.util'contains }) }
}
fact util'noCircularContainment {
	no circle: type'ReturnItems'class + (type'SingleQuery'class + (type'VariableRef'class + (type'ReturnBody'class + (type'Literal'class + (type'ReadingClause'class + (type'AllOptions'class + (type'MapLiteral'class + (type'ReturnItem'class + (type'Query'class + (type'Expression'class + (type'SinglePartQuery'class + (type'Cypher'class + (type'Return'class + (type'QueryOptions'class + (type'Match'class + (type'PropertyExpression'class + (type'MapLiteralEntry'class + (type'RegularQuery'class + (type'Statement'class + (type'AnonymousPatternPart'class + (type'NodeLabels'class + (type'NodePattern'class + (type'StringLiteral'class + (type'PatternElement'class + (type'VariableDeclaration'class + (type'Properties'class + (type'Clause'class + (type'Pattern'class + (type'PatternPart'class + (type'SinglePartQuery'class'DefinedPart + (type'SinglePartQuery'class'UndefinedPart + (type'SingleQuery'class'DefinedPart + (type'SingleQuery'class'UndefinedPart + (type'RegularQuery'class'DefinedPart + (type'RegularQuery'class'UndefinedPart + (type'Query'class'DefinedPart + (type'Query'class'UndefinedPart + (type'Statement'class'DefinedPart + type'Statement'class'UndefinedPart)))))))))))))))))))))))))))))))))))))) { circle->circle in ^ (util'language.util'contains) }
}
fact errorpattern'validation'hasNoReturn {
	all p0: type'SinglePartQuery'class { ! (pattern'validation'hasNoReturn [ p0 ]) }
}
fact errorpattern'validation'hasNoMatch {
	all p0: type'SinglePartQuery'class { ! (pattern'validation'hasNoMatch [ p0 ]) }
}
fact errorpattern'validation'hasNoPattern {
	all p0: type'Match'class { ! (pattern'validation'hasNoPattern [ p0 ]) }
}
fact errorpattern'validation'hasNoReturnItems {
	all p0: type'ReturnBody'class { ! (pattern'validation'hasNoReturnItems [ p0 ]) }
}
fact errorpattern'validation'hasNoReturnItem {
	all p0: type'ReturnItems'class { ! (pattern'validation'hasNoReturnItem [ p0 ]) }
}
fact EnsureAllStrings {
	"A" = "A"
}
run { } for 16 util'Object , 3 Int , exactly 0 String