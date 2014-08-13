import ceylon.file { File, createZipFileSystem }
import javax.xml.parsers { DocumentBuilderFactory }
import java.io { ByteArrayInputStream }
import ceylon.interop.java { javaString }

"Represents a JVLT file"
abstract shared class JVLT() {
	
	"The dictionary stored in this JVLT"
	formal shared Dictionary dictionary;
}

"Loads a JVLT file from a `.jvlt` ZIP archive, if possible."
shared JVLT? loadJVLT(File file) {
	value zip = createZipFileSystem(file);
	value dictPath = zip.parsePath("/dict.xml");
	if (is File dictFile = dictPath.resource) {		
		try (reader = dictFile.Reader()) {
			
			return loadJVLTFromDictionaryString(readAll(reader));
		}
	} else {
		return null;
	}
}

"Loads a JVLT file by the parsing the dictionary XML directly from a string"
shared JVLT loadJVLTFromDictionaryString(String dictXML) {
	value docBuilderFactory = DocumentBuilderFactory.newInstance();
	value builder = docBuilderFactory.newDocumentBuilder();
	value doc = builder.parse(ByteArrayInputStream(javaString(dictXML).bytes));
	
	object result extends JVLT() { 
		dictionary = loadDictionaryFromXML(doc);
	}
	return result;
}