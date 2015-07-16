public with sharing class LoginPageController {
    public String username {get;set;}
	public String password {get;set;}
	public String token {get;set;}
	public String environment {get;set;}
	public String message;
	public String serverUrl;
	public String sessionId;
	public String UserId ;
	public List<Selectoption> ObjectList {get;set;}
	public List<String> ObjectList1 {get;set;}
	public List<String> fieldnames {get;set;}
	public String obj {get;set;}
	public boolean show {get;set;}
	public boolean log {get;set;}
	public String Usernm {get;set;}
	public List<String> fieldnm {get;set;}
	public List<SelectOption> selectfield {set;get;}
	public List<Selectoption> fieldList {get;set;}
	public List<Selectoption> selectedfieldList {get;set;}
	public List<String> selnm {get;set;}
	public List<String> lstid {get;set;} 
	public List<String> lstnm {get;set;} 
	public List<Map<String,String>> lstRecords {get;set;}
	List<String> sel;
    public LoginPageController() {
    	ObjectList = new list<Selectoption>();
		ObjectList1 = new list<String>();
		fieldnames = new List<string>();
		fieldnm = new List<String>();
		fieldList = new List<Selectoption>();
		selectedfieldList = new List<Selectoption>();
		selectfield = new List<Selectoption>();
		lstRecords = new List<Map<String,String>>();
		sel = new List<String>();
		show = false;
		log = true;
    }
    public void login(){			
		if(validate())	{
			return ;
		}	
		String soapav = 'http://schemas.xmlsoap.org/soap/envelope/';
		Http h  = new Http();
		HttpRequest req = new HttpRequest();
    	req.setEndpoint(environment);
    	req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        req.setHeader('SOAPAction', '""');
        req.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="urn:partner.soap.sforce.com"><username>' + USERNAME + '</username><password>' + PASSWORD + '</password></login></Body></Envelope>');
    	HttpResponse res = h.send(req);
    	system.debug(' Response  Body XML is :- '+' \n\n '+ res.getBody());  	
		try{
			Dom.Document doc = res.getBodyDocument();
			Dom.XMLNode envelop = doc.getRootElement();
			//system.debug(' *** Root element is  :- '+envelop + '**** body '+envelop.getText());
			Dom.XMLNode body = envelop.getChildElement('Body', soapav);
			//system.debug(' Body is '+body+' \n **** body text '+body.getText());
			
			
			Dom.XMLNode[] loginResponse = body.getChildElements();
			//system.debug('*** login Response :- '+loginResponse[0]+' \n *** text is :- '+loginResponse[0].getText());
			
			Dom.XMLNode[] result = loginResponse[0].getChildElements();
			//system.debug('*** result  :- '+result[0]+' \n *** text is :- '+result[0].getText()+'**** \n size '+result.size());
			
			Dom.XMLNode[] childrens = result[0].getChildren();
			//system.debug('******* Childs '+childrens);
			serverUrl = childrens[3].getText().split('services/')[0];
			sessionId = childrens[4].getText();
			UserId = childrens[5].getText();
			Dom.XMLNode[] userinfoarr = childrens[6].getChildren();
			 
			Usernm = userinfoarr[14].getText();
			//system.debug('**** Server Url :- '+serverUrl);
			//system.debug('**** \n\n\n /// Session Id is :- '+sessionId);
		}catch(Exception e){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Invalid Credential for Login'));
		}
		callService();
	}
	
	public List<Selectoption> getOptions(){
		List<Selectoption> op = new List<Selectoption>();
		
		op.add(new Selectoption('https://login.salesforce.com/services/Soap/u/28.0','Developer/Production'));
		op.add(new Selectoption('https://test.salesforce.com/services/Soap/u/28.0','Sandbox'));
		return op;
	}
	public boolean validate(){
		Boolean error = false;
		if(username == ''){
			message = 'Invalid User Name';
			error = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,message));
		}
			
		if(password == ''){
			message = 'Invalid Password';
			error = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,message));
		}
			
		/*if(token == ''){
			message = 'Invalid Token';
			error = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,message));
		}*/
		
		return error;
	}
	public void callService(){
		if(serverUrl == null || sessionId == null){
			return;
		}
		String labelnm='';
		String APIName ='';
		
		//system.debug('**** \n\n\n\n\n In Call service');
		Http h  = new Http();
		HttpRequest req = new HttpRequest();
    	req.setEndpoint(serverUrl+'services/data/v29.0/sobjects/');
    	req.setMethod('GET');    	
       // req.setHeader('Content-Type', 'text/xml;charset=UTF-8');        
        req.setHeader('Authorization', 'Bearer '+sessionId);
        //system.debug(' ***** Request Header session id is :- '+req.getHeader('Authorization'));
    	HttpResponse res = h.send(req);
    	system.debug(' Response Body JSON  is :- '+' \n\n '+ res.getBody());
    	
    	JSONParser parser = JSON.createParser(res.getBody());
    	Integer i = 0;
    	
    	while (parser.nextToken() != null ) {  
    		    
    		if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
    			
    			while (parser.nextToken() != null && parser.getCurrentToken() != JSONToken.END_ARRAY) {    				
    				if(parser.getText()=='label'){
    					parser.nextToken();
    					labelnm = parser.getText();    				
    					//system.debug('\n\n **** Label is :- '+labelnm);
    					ObjectList1.add(labelnm);
					}  
					if(parser.getText()=='name'){
						parser.nextToken();
						APIName = parser.getText();							
						//system.debug('\n\n **** API NAme is :- '+APIName);
						ObjectList1.add(APIName);
					}  
				}
    	
			}
		}
	
		String lbl;
		String nm;
		ObjectList.add(new Selectoption('Select Object','-- Select Object --'));
		system.debug('*** \n\n\n\n\n\n\n\n\n\n\t String List is '+ObjectList1 + '\n\n Size is '+ObjectList1.size());
		for(i = 0; i<ObjectList1.size();i++){
			lbl = ObjectList1[i];
			i++;
			if(i!=ObjectList1.size())
				nm = ObjectList1[i];
			else
				nm = ' ';
			ObjectList.add(new Selectoption(lbl,lbl));
		}
		system.debug('*** \n\n\n\n\n\n\n\n\n\n\t Object List is '+ObjectList + '\n\n Size is '+ObjectList.size());
		if(ObjectList.size()>0){
			log = false;
			show = true;
		}
		//User u = [select Id,Name from User where id = :UserId];
		/*if(U!=null){
			Usernm = u.Name;
		}*/
		//getFields();
	}
	
	public void getFields(){
		if(obj == null || obj ==''){
			return;
		}
		String labelnm='';
		String Names ='';
		//ObjectList1 = new list<String>();
		Http h  = new Http();
		HttpRequest req = new HttpRequest();
		String endp = serverUrl+'services/data/v29.0/sobjects/'+obj+'/describe';
		system.debug(' *** \n\n\n\n\n Endpoint is :- '+endp);
    	req.setEndpoint(endp);
    	
    	req.setMethod('GET');                
        req.setHeader('Authorization', 'Bearer '+sessionId);        
    	HttpResponse res = h.send(req);
    	system.debug(' Response Body JSON for Object getting Field is :- '+' \n\n '+ res.getBody());
    	
    	//JSONParser parser = JSON.createParser(res.getBody());
    	Integer i = 0;
    	

    	Map<String,Object> JsonMap = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
    	Object objNM = JsonMap.get('fields');
    	system.debug('\n\n Object is :-'+objNM);
    	String FieldsJson = JSON.serialize(objNM);
    	system.debug('\n Field Json is :- '+FieldsJson);

    	/*List<Object> lstJsonFlds = (List<Object>)JSON.deserializeUntyped(FieldsJson);
    	system.debug('\n 1 st element :- '+String.valueOf(lstJsonFlds));*/
    	/*for(String s : lstJsonFlds){
    		system.debug('\n Key :- '+s);
    		system.debug('\n\n s :- '+s + '\n Contains :- '+String.valueOf(s).contains('label'));
    	}
    	fieldnames = new List<string>();*/
    	
    	JSONParser parser = JSON.createParser(FieldsJson);
    	List<string> FieldApiNames = new List<String>();
    	fieldList.add(new Selectoption('test','test'));
    	/*while (parser.nextToken() != null ) {      		    
    		if (parser.getCurrentToken() == JSONToken.START_ARRAY && parser.getCurrentToken() != JSONToken.END_ARRAY) {    			
    			while (parser.nextToken() != null ) {    				
    				if(parser.getText()=='label'){
    					parser.nextToken();
    					labelnm = parser.getText();    					
    					fieldnames.add(labelnm);
					}  
					if(parser.getText()=='name'){
						parser.nextToken();
						Names = parser.getText();							
						FieldApiNames.add(Names);						
					}  					                    
				}
    		}	
		}*/		
    	fieldList = new list<Selectoption>();
    	selectedfieldList = new List<Selectoption>();
    	system.debug(' ***** Field Names :- '+fieldnames); 

    	for(Integer i1 = 0; i1< FieldApiNames.size() - 1 ; i1++){
    		system.debug('\n Api Name :- '+FieldApiNames[i1] + '\t Label :- '+fieldnames[i1]);
    	}

    	for(Integer i1 = 0; i1< FieldApiNames.size()  ; i1++){
    		fieldList.add(new Selectoption(FieldApiNames[i1], FieldApiNames[i1]));
    	}  
    	system.debug(' ***** Field List :- '+fieldList);
    	  	
	}
	
	/*public void add(){
		system.debug('** \n\n Click on Add ... selected List is '+fieldnm);
		selnm = new List<String>();
		for(String nm:fieldnm){
			selectedfieldList.add(new Selectoption(nm,nm));
			selnm.add(nm);
		}
		for(Integer i =0;i<fieldnames.size();i++){
			for(Integer j = 0; j<selnm.size();j++){
				if(fieldnames[i] == selnm[j]){
					fieldnames.remove(i);
				}
			}
		}
		fieldList = new List<Selectoption>();
		for(String s :fieldnames){
    		fieldList.add(new Selectoption(s,s));
    	}  
	}*/
	
	/*public void remove(){
		system.debug(' ****** \n\n\n\n\n fieldlist left before  :- '+fieldList);
		system.debug(' *** Select field in right before are  :- '+selectedfieldList);
		for(Integer i = 0; i<selnm.size();i++){
			for(integer j = 0; j<selectfield.size();j++){
				if(selnm[i] == selectfield[j]){
					selnm.remove(i);
					system.debug('\n\n\n ****  Field names from remove if == condition '+fieldnames);
					fieldnames.add(selnm[i]);
				}
			}
		}
		selectedfieldList = new List<Selectoption>();
		for(String s :selnm){
    		selectedfieldList.add(new Selectoption(s,s));
    	}
    	fieldList = new List<Selectoption>();
    	fieldnames.sort();
		for(String s :fieldnames){
    		fieldList.add(new Selectoption(s,s));
    	} 
    	system.debug(' ****** \n\n\n\n\n fieldlist left after  :- '+fieldList);
		system.debug(' *** Select field in right before after  :- '+selectedfieldList);
	}*/
	
	public void ShowRecord(){
		system.debug(' *** \n\n in show record methode ');
		String query = '';
		query += createQuery();
		query +=' ';
		system.debug(' ****** \n\n\n\n\n\n  Query = :- '+query);
		
		selnm = new List<String>();
		for(Selectoption sop : selectedfieldList){
			selnm.add(sop.getValue().trim());
		}
		lstRecords = new List<Map<String,String>>();

		Http h  = new Http();
		HttpRequest req = new HttpRequest();
		String ur = EncodingUtil.urlEncode(query, 'UTF-8');
		String endp = serverUrl+'services/data/v32.0/query?q='+ur;
		system.debug(' *** \n\n\n\n\n Endpoint is :- '+endp);
    	req.setEndpoint(endp);    	
    	req.setMethod('GET');                
        req.setHeader('Authorization', 'Bearer '+sessionId);        
    	HttpResponse res = h.send(req);
    	system.debug(' Response Body JSON for Query is :- '+' \n\n '+ res.getBody());
		
		JSONParser parser = JSON.createParser(res.getBody());
		String id,name;

		Map<String,Object> JsonMap = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
    	Object objNM = JsonMap.get('records');

    	system.debug('\n\n Object is :-'+objNM);
    	String FieldsJson = JSON.serialize(objNM);
    	system.debug('\n Field Json is :- '+FieldsJson);

		List<Object> JsonMap1 = (List<Object>)JSON.deserializeUntyped(FieldsJson);
		system.debug('\n\n JsonMap1 :- '+JsonMap1);

		for(Object o : JsonMap1){
			system.debug('\n\n o :- '+o);
			String RecJson = JSON.serialize(o);
    		system.debug('\n RecJson Json is :- '+RecJson);
    		Map<String,Object> JsonMap2 = (Map<String,Object>) JSON.deserializeUntyped(RecJson);
    		Map<String,String> mapKeyVal = new Map<String,String>();
    		for(String str : JsonMap2.keySet()){
    			if(String.valueOf(JsonMap2.get(str)) != null)
    				mapKeyVal.put(str.trim(), String.valueOf(JsonMap2.get(str)));
    			else
    				mapKeyVal.put(str.trim(), ' ');
    		}
    		lstRecords.add(mapKeyVal);
		}



		lstid = new list<String>();
		lstnm = new list<String>();
		/*while (parser.nextToken() != null ) {      		    
    		if (parser.getCurrentToken() == JSONToken.START_ARRAY) {    			
	    			while (parser.nextToken() != null) {    				
	    				if(parser.getText()=='Id'){
	    					parser.nextToken();
	    					id = parser.getText();  				
	    					lstid.add(id);
						}  
						if(parser.getText()=='name'){
							parser.nextToken();
							name = parser.getText();	
							lstnm.add(name);						
						}  					                    
					}
    			}	
		}*/
		
		system.debug('****/// \n\n\n  List of id,name '+lstid);
		system.debug('\n\n lstRecords :- '+lstRecords + ' \n  size :- '+lstRecords.size());
		for(Map<String,Object> m : lstRecords){
			for(String s : m.keySet()){
				system.debug('\n\t\tKey'+s + '\t value :- '+m.get(s));
			}
		}
		
	}
	public String createQuery(){
		String query;
		query = 'select ';
		sel = new List<String>();
		for(Selectoption sop :selectedfieldList){
			sel.add(sop.getValue());
		}
		
		for(Integer i = 0; i<sel.size();i++){
			if(i!=sel.size() -1)
				query += sel[i]+', ';
			else
				query += sel[i]+' ';
		}
		query += 'from '+obj;
		return query;
	}
	
	public void QueryforIds(List<String> ids){
		
		for(String Id :ids){
			Http h  = new Http();
			HttpRequest req = new HttpRequest();
			String endp = serverUrl+'services/data/v29.0/sobjects/'+obj+'/'+Id;
			system.debug(' *** \n\n\n\n\n Endpoint is :- '+endp);
	    	req.setEndpoint(endp);    	
	    	req.setMethod('GET');                
	        req.setHeader('Authorization', 'Bearer '+sessionId);        
	    	HttpResponse res = h.send(req);
	    	system.debug(' Response Body JSON for ID is :- '+' \n\n '+ res.getBody());
	    	
	    	JSONParser parser = JSON.createParser(res.getBody());
	    	/*while (parser.nextToken() != null ) {   
	    			    			    				
	    				if(parser.getText()=='Id'){
	    					parser.nextToken();
	    					id = parser.getText();    				
	    					//system.debug('\n\n **** Label is :- '+labelnm);
	    					//ObjectList1.add(labelnm);
	    					lstid.add(id);
						}  
						if(parser.getText()=='name'){
							parser.nextToken();
							name = parser.getText();	
							lstnm.add(name);						
							//system.debug('\n\n **** Label NAme is :- '+Names);
							
							//ObjectList1.add(Names);
						}  					                    
				   				
			}   */
	    		    	
		}
	}
}