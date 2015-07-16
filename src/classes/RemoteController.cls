public with sharing class RemoteController {
	public String sfdcBaseURL{get;set;}
	public RemoteController(){
		String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
		system.debug('*** \n\n SFDC URL IS :- '+sfdcBaseURL);
	}
	
	public void add(){
		
		
		MetadataService.MetadataPort service = createService();     
        MetadataService.RemoteSiteSetting remote = new MetadataService.RemoteSiteSetting();
        remote.fullName = 'Base Instance URL';
        remote.url = 'http://www.salesforce.com';
        remote.isActive = true;
        List<MetadataService.SaveResult> results = service.createMetadata(new MetadataService.Metadata[] { remote });
	}
	
	public static MetadataService.MetadataPort createService() { 
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
	    service.SessionHeader = new MetadataService.SessionHeader_element();
	    service.SessionHeader.sessionId = UserInfo.getSessionId();
	    return service; 
	}
	
}