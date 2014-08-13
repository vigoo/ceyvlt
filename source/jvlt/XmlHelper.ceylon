import org.w3c.dom { Node, NodeList, Element }
import javax.xml.xpath { XPathFactory { newXPathFactory = newInstance },
						 XPathConstants { nodeSet = \iNODESET }}

String? getAttribute(Element elem, String attribute) {
	if (elem.hasAttribute(attribute)) {
		return elem.getAttribute(attribute);
	} else {
		return null;
	}
}

{Node*} selectNodes(Node root, String xpath) {
	
	value factory = newXPathFactory();
	value xpathCompiler = factory.newXPath();
	value expr = xpathCompiler.compile(xpath);
	value nodeList = expr.evaluate(root, nodeSet);	
	if (is NodeList nodeList) {		
		return NodeListIterator(nodeList);
	}
	else {
		return [];
	}
}

Node? selectNode(Node root, String xpath) {	
	return selectNodes(root, xpath).first;
}

String? selectNodeText(Node root, String xpath) {
	Node? result = selectNode(root, xpath);
	if (exists result) {
		return result.textContent;		
	} else {
		return null;
	}
}

Integer? selectNodeInteger(Node root, String xpath) {
	String? text = selectNodeText(root, xpath);
	if (exists text) {
		return parseInteger(text);
	} else {
		return null;
	}
}


class NodeListIterator(NodeList nodes) satisfies Iterable<Node> {
	
	shared actual default Iterator<Node> iterator() {
		object it satisfies Iterator<Node> {
			
			variable Integer i = 0;
			
			shared actual Node|Finished next() {
				if (i < nodes.length) {
					return nodes.item(i++);
				} else {
					return finished;
				}
			}
		}
		
		return it;
	}
}