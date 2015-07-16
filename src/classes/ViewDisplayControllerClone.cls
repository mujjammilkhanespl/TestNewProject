public with sharing class ViewDisplayControllerClone {
	
	public String name {get;set;}
	public String objectname {get;set;}
	public List<Selectoption> setval {get;set;}
	public Boolean show {get;set;}
	public String[] fldnames {get;set;}
	public Apexpages.Standardsetcontroller sc {get;set;}
	public List<Sobject> lstQuote {get;set;}
	//public boolean show {get;set;}
	public List<Selectoption> view {get;set;}
	public  ViewDisplayControllerClone(ApexPages.StandardController controller ){
		setval = new List<Selectoption>();
		lstfield__c viewOne = [select Name,Object__c from lstfield__c order by createddate desc limit 1];
		if(viewOne != null){
			name = viewOne.Name;
			objectname = viewOne.Object__c;
		}	
		lstQuote = new List<Sobject>();	
		show = false;
		view = new List<Selectoption>();
		//name = 'All';
		//objectname = 'Quote';
		getView();
		getRecord();
				
	}
	
	public void getView(){
		
		List<lstfield__c> views = [select Name from lstfield__c where Object__c = :objectname];	
		view = new List<Selectoption>();
				
		for(lstfield__c v :views){
			view.add(new Selectoption(v.Name,v.Name));			
		}		
	} 
	
	public Pagereference newview(){
		Pagereference p = new Pagereference('/apex/Create_View');
		p.getParameters().put('isEdit','false');
		p.getParameters().put('viewname','null');
		p.setRedirect(true);
		return p;
	}	
	public List<Selectoption> getobjectList(){
		List<Selectoption> op = new List<Selectoption>();
    	      
    
    	Map<String, Schema.SObjectType> objects = Schema.getGlobalDescribe();
      	Schema.DescribeSObjectResult objInfo = null;
      	for (Schema.SObjectType obj : objects.values()) {
       		objInfo = obj.getDescribe();
       		if(objInfo.isQueryable() )
          		op.add(new Selectoption(objInfo.getName(),objInfo.getName())) ;
      	}    
    	op.sort();
    	return op;
	}
	public void getRecord(){			
		system.debug(' *** \n\n Name is :-'+name);
		if(name != null && name != '--Select View --'){
			system.debug('\n\n\n\n\n New Object Selected is '+objectname);
			
			lstfield__c fld = [select Fields__c,Object__c,Filter_Condition__c   from lstfield__c where Name = :name limit 1];
						
			fldnames = fld.Fields__c.split(',');			
			String feld = fld.Fields__c;
			
			system.debug('*** \n\n\n field list is '+feld);
			String filter = fld.Filter_Condition__c;
			if(filter == '' || filter == null){
				filter = '';
			}
			String query = 'select '+feld+' from '+ objectname +' '+ filter +' Order by CreatedDate desc';
			
			system.debug('** \n\n Query is :- '+query);
			
			List<Sobject> l = Database.query(query);
			
			system.debug('*** \n\n\n  Query result is '+l);
			
			sc = new Apexpages.Standardsetcontroller(l);
			sc.setPageSize(10);							
			lstQuote =  sc.getRecords();
			show = true;
		}	
		else {
			show = false;
			system.debug('\n\n\n\n\n\n\n show--------------------------'+show);
		}		
	}
	public Pagereference del(){
		if(name.equalsIgnoreCase('All')){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'You can not delete this view'));
		}
		else {		
			lstfield__c ls = [select id from lstfield__c where Name = :name];
			delete ls;		
		}
			
		Pagereference p = new Pagereference('/apex/ViewDisplay');
		p.setRedirect(true);
		return p;
				
	}
	public Pagereference newp(){
		Pagereference p = new Pagereference('/0Q0/e');
		p.setRedirect(true);
		return p;
	}
	public Pagereference editview(){			
		Pagereference p = new Pagereference('/apex/Create_View');
		p.setRedirect(true);
		p.getParameters().put('isEdit','true');
		p.getParameters().put('viewname',name);
		p.getParameters().put('oldObjectName',objectname);
		return p;
	}
	public void next(){
		if(sc.getHasNext()){
			sc.next();
			lstQuote = sc.getRecords();
		}
	}
	public void previous(){
		if(sc.getHasPrevious()){
			sc.previous();
			lstQuote = sc.getRecords();
		}
	}
	public void firstR(){		
			sc.first();
			lstQuote = sc.getRecords();
		
	}
	public void lastR(){		
			sc.last();
			lstQuote = sc.getRecords();		
	}
	
	public void showrec(){
		setval = new List<Selectoption>();
		/*if(name != null ){
			lstfield__c viewOne = [select Name,Object__c from lstfield__c where Name = :name order by createddate desc limit 1];
			if(viewOne != null){
				name = viewOne.Name;
				//objectname = viewOne.Object__c;
			}	
			lstQuote = new List<Sobject>();	
		}	*/	
		system.debug('\n\n\n\n\n New Object Selected is  from action'+objectname);
		getView();
		if(view.size()>0){
			name = view[0].getValue();
			getRecord();
		}
		else {
			view.add(new Selectoption('None','None'));
			show = false;
		}
						
	}
}