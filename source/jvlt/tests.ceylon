
import ceylon.test { ... }
import ceylon.collection { HashSet }

class DictionaryParserTests() {

	shared test void emptyDictionary() {
		value dic = loadJVLTFromDictionaryString("<dictionary/>");
		
		assert (dic.dictionary.words.empty);
		assert (dic.dictionary.language == "unknown");
	}
	
	shared test void languageAttributeRead() {
		value dic = loadJVLTFromDictionaryString("<dictionary language='testlang'/>");
		assert (dic.dictionary.language == "testlang");
	}
	
	void assertSenses(JVLT jvlt, String w, [String+] expectedSenses) {
		
		Word? word = jvlt.dictionary.words[w];
		if (exists word) {
			assert (word.senses.equals(HashSet(expectedSenses)));
			
		} else {
			fail("Word does not exists");
		}
	}
	
	void assertLesson(JVLT jvlt, String w, Integer lesson) {
		
		Word? word = jvlt.dictionary.words[w];
		if (exists word) {
			assert (word.lesson == lesson);
			
		} else {
			fail("Word does not exists");
		}
	}
	
	shared test void wordsWithSingleSenses() {
		value dic = loadJVLTFromDictionaryString(
			"<dictionary>
			 	<entry id='e1'>
			 		<orth>src1</orth>
			 		<sense id='e1-s1'>
			 			<trans>dst1</trans>
			 		</sense>
			 	</entry>
				 <entry id='e2'>
					 <orth>src2</orth>
					 <sense id='e2-s1'>
				 		<trans>dst2</trans>
				 	</sense>
				 </entry>
				 <entry id='e3'>
				 	<orth>src3</orth>
				 	<sense id='e3-s1'>
						 <trans>dst3</trans>
					 </sense>
				 </entry>
			 </dictionary>");
		
		assert (dic.dictionary.words.size == 3);
		assert (dic.dictionary.words["src1"] exists);		
		assert (dic.dictionary.words["src2"] exists);
		assert (dic.dictionary.words["src3"] exists);
		
		assertSenses(dic, "src1", ["dst1"]);
		assertSenses(dic, "src2", ["dst2"]);
		assertSenses(dic, "src3", ["dst3"]);
		
		assertLesson(dic, "src1", 0);
		assertLesson(dic, "src2", 0);
		assertLesson(dic, "src3", 0);
	}
	
	shared test void wordWithMultipleSenses() {
		value dic = loadJVLTFromDictionaryString(
			"<dictionary>
			 <entry id='e1'>
			 	<orth>src1</orth>
			 	<sense id='e1-s1'>
			 		<trans>dst1</trans>
			 	</sense>
			 	<sense id='e1-s2'>
			 		<trans>dst2</trans>
			 	</sense>			 
			 </entry>
			
			 </dictionary>");
		
		assertSenses(dic, "src1", ["dst1", "dst2"]);
	}
	
	shared test void lessonRead() {
		value dic = loadJVLTFromDictionaryString(
			"<dictionary>
			 	<entry id='e1'>
				 	<orth>src1</orth>
				 	<sense id='e1-s1'>
				 		<trans>dst1</trans>
				 	</sense>
				 	<lesson>10</lesson>			 
			 	</entry>			 
			 </dictionary>");		
		
		assertLesson(dic, "src1", 10);
	}
}
