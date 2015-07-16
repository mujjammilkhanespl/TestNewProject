public with sharing class FileController {
	
	public Blob csvFile {get;set;}
	public String filename {get;set;}
	public FileController(){
		
	}
	
	public void check(){
		system.debug('\n\n CSV File Name :- '+filename);
		system.debug('\n\n CSV file Contains :- '+csvFile);
		system.debug('\n\n CSV file Contains in to String  :- '+csvFile.toString());
		system.debug('\n\n CSV fileSize  :- '+csvFile.size());
	}
}