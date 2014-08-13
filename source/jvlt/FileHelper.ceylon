import ceylon.file { File }

"Reads all lines from a file reader and returns the concatenated string"
String readAll(File.Reader reader) { 
	variable String result = "";
	
	while (exists line = reader.readLine()) {
		result += line; 
	}
	
	return result;
}