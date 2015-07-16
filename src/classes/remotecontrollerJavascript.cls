public with sharing class remotecontrollerJavascript {
	public String host {get;set;}
	public remotecontrollerJavascript(){
		host = Apexpages.currentPage().getHeaders().get('Host');
		
	}
	
}