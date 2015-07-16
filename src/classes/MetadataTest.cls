public with sharing class MetadataTest {
	public static void createObject()
    {
		MetadataService.MetadataPort service = createService();     
        MetadataService.CustomObject customObject = new MetadataService.CustomObject();
        customObject.fullName = 'Test__c';
        customObject.label = 'Test';
        customObject.pluralLabel = 'Tests';
        customObject.nameField = new MetadataService.CustomField();
        customObject.nameField.type_x = 'Text';
        customObject.nameField.label = 'Test Record';
        customObject.deploymentStatus = 'Deployed';
        customObject.sharingModel = 'ReadWrite';
        List<MetadataService.SaveResult> results =      
            service.createMetadata(
                new MetadataService.Metadata[] { customObject });       
        //handleSaveResults(results[0]);
	}
	public static MetadataService.MetadataPort createService()
	    { 
	        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
	        service.SessionHeader = new MetadataService.SessionHeader_element();
	        service.SessionHeader.sessionId = UserInfo.getSessionId();
	        return service;     
	    }
	    
	    public static void listMetadata()
    	{
        MetadataService.MetadataPort service = createService();     
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();        
        MetadataService.ListMetadataQuery queryWorkflow = new MetadataService.ListMetadataQuery();
        queryWorkflow.type_x = 'HomePageLayout';
        queries.add(queryWorkflow);
        MetadataService.ListMetadataQuery queryWorkflow1 = new MetadataService.ListMetadataQuery();
        queryWorkflow1.type_x = 'HomePageComponent';
        queries.add(queryWorkflow1);     
        
        MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 25);
        for(MetadataService.FileProperties fileProperty : fileProperties)
            System.debug(fileProperty.fullName);
    	}
	    
	
	
	public static void createHomeComponent()
    {
		MetadataService.MetadataPort service = createService();
		
		// --------------------
		MetadataService.WebLink webLink = new MetadataService.WebLink();
		webLink.fullName = 'test Link';
		webLink.availability = 'online';
		webLink.displayType = 'link';
		webLink.encodingKey = 'UTF-8';
		//webLink.hasMenubar = false;
		//webLink.hasScrollbars = true;
		//webLink.hasToolbar = false;
		//webLink.height = 600;
		//webLink.isResizable = true;
		webLink.linkType = 'javascript';
		webLink.masterLabel = 'google link';
		webLink.openType = 'onClickJavaScript';
		//webLink.position = 'none';
		
		webLink.protected_x = false;
		//webLink.showsLocation = false;
		//webLink.showsStatus = false;
		webLink.url = 'alert(\'Click on Link\')';
		//webLink.width = 600;	
		handleSaveResults(
			service.createMetadata(
				new List<MetadataService.Metadata> { webLink })[0]);
		//------------------
		     
        MetadataService.HomePageComponent HComp = new  MetadataService.HomePageComponent();
        //HComp.width = 'wide';
        HComp.fullName = 'Test from Metadata Api for link with custom link';
        HComp.pageComponentType = 'links';
        HComp.links = new List<String> {'test Link'};
        //HComp.body = '<p>Hello Apto </p>';
        List<MetadataService.SaveResult> results =      
            service.createMetadata(
                new MetadataService.Metadata[] { HComp });       
        //handleSaveResults(results[0]);
	}
	
	
	public static void createCustomLink()
    {
		MetadataService.MetadataPort service = createService();     
        MetadataService.WebLink webLink = new MetadataService.WebLink();
		//webLink.fullName = 'test__c.googleButtonlinknew12';
		webLink.fullName = 'CustomPageItem.xyz';
		//webLink.p = ne 'CustomPageItem';
		webLink.availability = 'online';
		webLink.displayType = 'link';
		webLink.encodingKey = 'UTF-8';
		//webLink.hasMenubar = false;
		//webLink.hasScrollbars = true; 
		//webLink.hasToolbar = false;
		//webLink.height = 600;
		//webLink.isResizable = true;
		webLink.linkType = 'javascript';
		webLink.masterLabel = 'google link';
		webLink.openType = 'onClickJavaScript';
		//webLink.position = 'none';
		
		webLink.protected_x = false;
		//webLink.showsLocation = false;
		//webLink.showsStatus = false;
		webLink.url = 'alert(\'Click on Link\')';
		//webLink.width = 600;	
		handleSaveResults(
			service.createMetadata(
				new List<MetadataService.Metadata> { webLink })[0]);

		// Read the Layout		
		MetadataService.HomePageLayout layout = 
			(MetadataService.HomePageLayout) service.readMetadata('HomePageLayout', 
				new String[] { 'DE Default' }).getRecords()[0];
				
		// Add the Custom Button to the Layout
		
			layout.narrowComponents = new List<String> {'Test from Metadata Api for link'};
		//layout.customButtons.add('googleButtonlink');
		
		// Update the Layout
		handleSaveResults(
			service.updateMetadata(
				new MetadataService.Metadata[] { layout })[0]);
        
	}
	private static void handleSaveResults(MetadataService.SaveResult saveResult)
	{
		// Nothing to see?
		if(saveResult==null || saveResult.success)
			return;
		// Construct error message and throw an exception
		List<String> messages = new List<String>();
		messages.add(
			(saveResult.errors.size()==1 ? 'Error ' : 'Errors ') + 
				'occured processing component ' + saveResult.fullName + '.');
		for(MetadataService.Error error : saveResult.errors)
			messages.add(
				error.message + ' (' + error.statusCode + ').' + 
				( error.fields!=null && error.fields.size()>0 ? 
					' Fields ' + String.join(error.fields, ',') + '.' : '' ) );
		if(messages.size()>0)
			system.debug('*** \n\n\n Error thrown '+messages);
	}	
	
	
	// ----------------------------------------------------------------------------------
	// **********************************************************************************
	
	public static void UpdatePicklist(String oldnm , String newnm){
		system.debug('*****  \n\n API NAME FOR PICKLIST IS :- '+SObjectType.Lead.fields.Lead_Status__c.Name);
		system.debug('*****  \n\n API NAME FOR OBJECT IS :- '+SObjectType.Lead.Name);
		MetadataService.MetadataPort service = createService();  
		list<metadataservice.PicklistValue> pickval = new list<metadataservice.PicklistValue>();
		
	   Schema.DescribeFieldResult fieldResult =Lead.Lead_Status__c.getDescribe(); 
	   List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); 
	   for( Schema.PicklistEntry f : ple) { 
	        metadataservice.PicklistValue two = new metadataservice.PicklistValue();
		    if(f.getValue() == oldnm)
		    	two.fullName = newnm;
		    else
		    	two.fullName= f.getValue();
		    
		    if(f.isDefaultValue() == true)
		    	two.default_x=true;
		    else
		    	two.default_x=false;
		    system.debug('*** \n\n\n picklist value :- '+two);
		    pickval.add(two);
	   }       
		system.debug('*** \n\n\n List pickval :- '+pickval);   
	    MetadataService.CustomField customField = new MetadataService.CustomField();
	    customField.fullName = SObjectType.Lead.Name+'.'+SObjectType.Lead.fields.Lead_Status__c.Name;
	    customField.label = 'Lead Status';
	    customField.type_x = 'Picklist';
	    metadataservice.Picklist pt = new metadataservice.Picklist();
	    pt.sorted= false;
	    metadataservice.PicklistValue two1 = new metadataservice.PicklistValue();
	    two1.fullName= 'Closed new';
	    two1.default_x=false ;
	    metadataservice.PicklistValue three = new metadataservice.PicklistValue();
	    three.fullName= 'Open - Closed new';
	    three.default_x=false ;
	   // pickval.add(two1);
	   // pickval.add(three);
	    pt.picklistValues = pickval;
	    customField.picklist = pt ;
	    MetadataService.UpdateMetadata ut = new MetadataService.UpdateMetadata();
	    ut.currentName=SObjectType.Lead.Name+'.'+SObjectType.Lead.fields.Lead_Status__c.Name;
	    ut.metadata= customField;	
		List<MetadataService.SaveResult> results = 		
			service.updateMetadata(
				new MetadataService.Metadata[] { customField });
		handleSaveResults(results[0]);
	}
	
	// 12-9-2014 ------------------------------------------------------------------------------------
	public static void listHomePageComponent() {
        MetadataService.MetadataPort service = createService();     
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();        
        MetadataService.ListMetadataQuery queryWorkflow = new MetadataService.ListMetadataQuery();
        queryWorkflow.type_x = 'HomePageLayout';
        //queries.add(queryWorkflow);
        MetadataService.ListMetadataQuery queryWorkflow1 = new MetadataService.ListMetadataQuery();
        queryWorkflow1.type_x = 'HomePageComponent';
        queries.add(queryWorkflow1);     
        
        MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 25);
        for(MetadataService.FileProperties fileProperty : fileProperties)
            System.debug('**** Home Page Component is :- '+fileProperty.fullName);
    	}
    	
    	//---------------------
    	public static void createSidebarComponent(){
    	
    	//createing custom link
    	MetadataService.MetadataPort service = createService();     
        MetadataService.WebLink webLink = new MetadataService.WebLink();
        webLink.fullName = 'CustomPageItem.AptotudeCustomLink';
        webLink.availability = 'online';
        webLink.displayType = 'link';
        webLink.encodingKey = 'UTF-8';
        webLink.linkType = 'javascript';
        webLink.masterLabel = 'Apto link';
        webLink.openType = 'onClickJavaScript';
        webLink.protected_x = false;
        webLink.url = 'alert(\'Clicked on custom link from homepage sidebar\')';
        handleSaveResults(service.createMetadata(new List<MetadataService.Metadata> { webLink })[0]);
        
        //create component
        MetadataService.HomePageComponent HComp = new  MetadataService.HomePageComponent();
        HComp.fullName = 'Custom Component Using Metadata';
        HComp.pageComponentType = 'links';
        HComp.links = new List<String> {'AptotudeCustomLink'};
        List<MetadataService.SaveResult> results =  service.createMetadata(new MetadataService.Metadata[] { HComp });  
        
    	// Read the Layout      
        List<MetadataService.HomePageLayout> lstlayout = 
            (List<MetadataService.HomePageLayout>) service.readMetadata('HomePageLayout', new String[] { 'DE Default' }).getRecords();
           system.debug('*** \n\n Layout list is :- '+lstlayout); 
        // Add the Custom Link to the Layout
          List<String> narrowlst =  new List<String>();
        	for(String s :lstlayout[0].narrowComponents){
        		narrowlst.add(s);
        	}
        	narrowlst.add('Custom Component Using Metadata');
        
            lstlayout[0].narrowComponents = narrowlst;
        // Update the Layout
        handleSaveResults(service.updateMetadata(new MetadataService.Metadata[] { lstlayout[0] })[0]);
    }  
    
}