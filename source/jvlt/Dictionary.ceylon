import org.w3c.dom { Document, Element, Node }
import ceylon.collection { HashMap, HashSet }

"Represents a foreign word with one more more senses"
shared class Word(shared String word, shared Set<String> senses, shared Integer lesson) {	
}

"Represents a dictionary of words in a given language"
shared class Dictionary(shared String language, shared Map<String, Word> words) {	
}

"Creates a word entry for the dictionary"
String->Word loadEntry(Element elem) {
	
	value w = Word {
		word = selectNodeText(elem, "orth") else "???";
		lesson = selectNodeInteger(elem, "lesson") else 0;
		senses = HashSet(selectNodes(elem, "sense/trans").map((Node n) => n.textContent));
	};
	return w.word->w;
}

"Loads a dictionary from JVLT's `dict.xml` format."
Dictionary loadDictionaryFromXML(Document doc) { 

	doc.documentElement.normalize();

	return Dictionary { 
		language = getAttribute(doc.documentElement, "language") else "unknown";
		words = HashMap({ 
					for (node in selectNodes(doc, "dictionary/entry"))
				  	if (is Element elem = node)
		          	loadEntry(elem) }); 		
	};
}