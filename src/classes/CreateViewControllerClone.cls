public with sharing class CreateViewControllerClone {   

	public String viewname {get;set;}
	//public List<Selectoption> available {get;set;}
	public List<String> availselected {get;set;}
	public List<String> optselected {get;set;}
	public List<Selectoption> SelectedList {get;set;}
	public Boolean isEdit {get;set;}
	public String msg {get;set;}
	public List<Selectoption> LeftFieldList {get;set;}
	public String objectname {get;set;}
	public String oldObjectName;
	public Map<String,String> mapeditfieldname ;
	String[] lst;
	lstfield__c listviewforEdit;
	public Integer Count = 0;
	public List<wrapper> lstwrapper {get;set;}
	public List<Selectoption> lstfeld {get;set;}
	public List<Selectoption> lstoperatorUnknown {get;set;}
	public List<Selectoption> lstoperatorNumber {get;set;}
	public List<Selectoption> lstoperatorString {get;set;}
	public boolean shownumber {get;set;}
	public String changemade {get;set;}
	private Map<String,String> mapNameToType;
	public String recordId {get;set;}
	public List<Selectoption> lstoperatorlookup {get;set;} 
	
	class wrapper{
		public Integer rowNumber {get;set;}
		public String fieldName {get;set;}
		public String operator {get;set;}
		public String value {get;set;}
		public String datatype {get;set;}
		public String recordId {get;set;}
		public wrapper(Integer rowNumber, String fieldName, String operator, String value){
			this.rowNumber = rowNumber;
			this.operator = operator;
			this.fieldName = fieldName;
			this.value = value;
			datatype = 'unknown';
			recordId = '';
		}
	}
	
	public CreateViewControllerClone(ApexPages.StandardController controller) {
		//available = new List<Selectoption>();
		availselected = new List<String>();
		SelectedList = new List<Selectoption>();
		optselected = new List<String>();
		lstwrapper = new List<wrapper>();
		lstfeld = new List<Selectoption>();
		lstoperatorUnknown = new List<Selectoption>();
		lstoperatorNumber = new List<Selectoption>();
		lstoperatorString = new List<Selectoption>();
		lstoperatorlookup = new List<Selectoption>();
		mapeditfieldname = new Map<String,String>();
		boolean ed = Boolean.valueOf(Apexpages.currentPage().getParameters().get('isEdit'));
		if(ed == true){
			String viewnamefromedit = Apexpages.currentPage().getParameters().get('viewname');
			oldObjectName = Apexpages.currentPage().getParameters().get('oldObjectName');
			if(viewnamefromedit != null || viewnamefromedit != ''){
				viewname = viewnamefromedit;
				listviewforEdit = [select id,Name, Fields__c,Object__c from lstfield__c where name = :viewname limit 1];
				objectname = listviewforEdit.Object__c;
				lst = listviewforEdit.Fields__c.split(',');
				if(lst.size()>0){
					for(String s : lst){
						SelectedList.add(new Selectoption(s,s));
						mapeditfieldname.put(s,s);
					}
				}
				
			}
			else {
				viewname = null;
			}			
			isEdit = ed;
			msg = 'Update Existing View';
		}
		else {
			isEdit = false;
			msg = 'Create New View';
		}
		
		lstwrapper.add(new wrapper(++Count,'','',''));
		lstwrapper.add(new wrapper(++Count,'','',''));
		lstwrapper.add(new wrapper(++Count,'','',''));
		lstwrapper.add(new wrapper(++Count,'','',''));
		lstwrapper.add(new wrapper(++Count,'','',''));
		
		getFieldList();
		filloperator();
    }    
    
	public void getFieldList(){
		system.debug('\n\n\n objectname '+objectname);
		LeftFieldList = new List<Selectoption>();
		lstfeld = new List<Selectoption>();
		mapNameToType = new Map<String,String>();
		lstfeld.add(new Selectoption('- None -','- None -'));
		if(objectname != null && objectname != '-- Select Object --'){
			if(isEdit == false){
				SobjectType Sobj = Schema.getGlobalDescribe().get(objectname);
				Map<String,Schema.Sobjectfield> objfields = Sobj.getDescribe().fields.getMap();
				Schema.Describefieldresult Descfield ;
				for(Schema.Sobjectfield feld : objfields.values() ){
					Descfield = feld.getDescribe();	
					if(!Descfield.isDeprecatedAndHidden())						
						LeftFieldList.add(new Selectoption(Descfield.getName(),Descfield.getName()));							
						Schema.Displaytype disp = Descfield.getType();							
						system.debug('\n\n\n\n\n ********* disp.Name() :- '+disp.name());															
						lstfeld.add(new Selectoption(Descfield.getName(),Descfield.getName()));
						
						system.debug('\n\n Related Object is :- '+Descfield.getReferenceTo());
						mapNameToType.put(Descfield.getName(),disp.name());
				}	
			}
			if(isEdit == true){
				SobjectType Sobj = Schema.getGlobalDescribe().get(objectname);
				Map<String,Schema.Sobjectfield> objfields = Sobj.getDescribe().fields.getMap();
				Schema.Describefieldresult Descfield ;
				for(Schema.Sobjectfield feld : objfields.values() ){
					Descfield = feld.getDescribe();
					if(!Descfield.isDeprecatedAndHidden()){
						if(!mapeditfieldname.containskey(Descfield.getName()))											
							LeftFieldList.add(new Selectoption(Descfield.getName(),Descfield.getName()));
					}
				}	
			}
		}
		system.debug('\n\n objectname :- '+objectname + '\n\n old object name :- '+oldObjectName);
		
		if(objectname != oldObjectName){
			SelectedList = new List<Selectoption>();
		}
		lstfeld.sort();	
		LeftFieldList.sort();			
	}
	
	public List<Selectoption> getobjectList(){
		List<Selectoption> op = new List<Selectoption>();
    	op.add(new SelectOption('-- Select Object --', '-- Select Object --'));        
    
    	Map<String, Schema.SObjectType> objects = Schema.getGlobalDescribe();
      	Schema.DescribeSObjectResult objInfo = null;
      	for (Schema.SObjectType obj : objects.values()) {
       		objInfo = obj.getDescribe();
       		if(objInfo.isQueryable())
          		op.add(new Selectoption(objInfo.getName(),objInfo.getName())) ;
      	}    
      	op.sort();
    	return op;
	}
	
	public Pagereference Save(){
		if(isEdit == false){
			if(SelectedList.size() == 0){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select at least one field'));
				return null;
			}
			if(objectname.equals('-- Select Object --') || objectname == null){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select valid Object'));
				return null;
			}	
			if(viewname == null || viewname == ''){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Name Field Can not be Empty'));
				return null;
			}
			if(validateName()){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'View Name Already Exist, Please select another Name'));
				return null;
			}
			else {	
				
				String fieldnm = '';
				Integer lastelement = SelectedList.size() - 1;
				for(Integer i = 0; i<SelectedList.size();i++){
					if(i == lastelement)
						fieldnm += SelectedList[i].getValue();
					else
						fieldnm += SelectedList[i].getValue() + ',';
				}
				String filter_Condition = getFilter();
				system.debug('\n\n filter_Condition is :- '+filter_Condition);
				
				lstfield__c ListView = new lstfield__c();
				ListView.Name = viewname;
				ListView.Fields__c = fieldnm;
				ListView.Object__c = objectname;
				ListView.Filter_Condition__c = filter_Condition;
				insert ListView;
			}
		}
		else {
				if(SelectedList.size() == 0){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select at least one field'));
				return null;
				}	
				if(viewname == null || viewname == ''){
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Name Field Can not be Empty'));
					return null;
				}
				if(objectname.equals('-- Select Object --') || objectname == null){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select valid Object'));
				return null;
				}
				String fieldnm = '';
				Integer lastelement = SelectedList.size() - 1;
				for(Integer i = 0; i<SelectedList.size();i++){
					if(i == lastelement)
						fieldnm += SelectedList[i].getValue();
					else
						fieldnm += SelectedList[i].getValue() + ',';
				}
				lstfield__c ListView = listviewforEdit;
				ListView.Name = viewname;
				ListView.Fields__c = fieldnm;
				ListView.Object__c = objectname;
				update ListView;
		}
		Pagereference p = new Pagereference('/apex/ViewDisplay');
		p.setRedirect(true);
		return p;
	}
	
	public boolean validateName(){
		List<lstfield__c> ListView = [select Id,Name from lstfield__c where Name = :viewname];
		if(ListView.size() != 0){
			system.debug('*** \n\n\n Already exist name is '+ListView);
			return true;
		}
		return false;
	}
	
	public Pagereference Cancel(){
		Pagereference p = new Pagereference('/apex/ViewDisplay');
		p.setRedirect(true);
		return p;
	}
	
	public void addrow(){
		lstwrapper.add(new wrapper(++Count,'','',''));
		if(Count > 5){
			showNumber = true;
		}
		system.debug('\n\n\n wrapper list is :- '+lstwrapper);
	}
	public void deleterow(){
		if(Count > 5){
			lstwrapper.remove(Count-1);
			Count --;			
		}
		if(Count <= 5 ){
			showNumber = false;
		}
		system.debug('\n\n\n wrapper list is :- '+lstwrapper);
	}
	public void changeoperator(){		
		integer i = Integer.valueOf(changemade);
		if(lstwrapper.get(i-1).fieldName != '- None -')	{			
			lstwrapper.get(i-1).operator = '=';
			String dtype = mapNameToType.get(lstwrapper.get(i-1).fieldName);
			if(dtype != null){
				if(dtype.equalsIgnoreCase('STRING')  || dtype.equalsIgnoreCase('DOUBLE') || dtype.equalsIgnoreCase('INTEGER') || dtype.equalsIgnoreCase('BOOLEAN')
										 || dtype.equalsIgnoreCase('CURRENCY') || dtype.equalsIgnoreCase('PHONE')
										  || dtype.equalsIgnoreCase('EMAIL') || dtype.equalsIgnoreCase('REFERENCE') || dtype.equalsIgnoreCase('PICKLIST')){
					lstwrapper.get(i-1).datatype = dtype;
				}
			}
		}	
		else {
			lstwrapper.get(i-1).operator = '- None -';
			lstwrapper.get(i-1).datatype = 'unknown';
		}
	}
	public void filloperator(){
    	
    	lstoperatorUnknown = new List<Selectoption>();    	
    	lstoperatorUnknown.add(new Selectoption('- None -','- None -'));  	    	
    	//lstoperatorUnknown.add(new Selectoption('=','equals'));
    	//lstoperatorUnknown.add(new Selectoption('<>','not equal to'));
    	
    	
	    	//lstoperator.add(new Selectoption('=','equals'));
    		//lstoperator.add(new Selectoption('<>','not equal to'));
    		lstoperatorNumber = new List<Selectoption>();
    		lstoperatorNumber.add(new Selectoption('- None -','- None -'));
    		lstoperatorNumber.add(new Selectoption('=','equals'));
    		lstoperatorNumber.add(new Selectoption('<>','not equal to'));
	    	lstoperatorNumber.add(new Selectoption(' < ','less than'));
	    	lstoperatorNumber.add(new Selectoption(' <= ','less than or equal to'));   
	    	lstoperatorNumber.add(new Selectoption(' > ','greater than'));
	    	lstoperatorNumber.add(new Selectoption(' >= ','greater than or equal to')); 
    	
    		lstoperatorString = new List<Selectoption>();
    		lstoperatorString.add(new Selectoption('- None -','- None -'));
    		lstoperatorString.add(new Selectoption('=','equals'));
    		lstoperatorString.add(new Selectoption('<>','not equal to'));
    		lstoperatorString.add(new Selectoption('start','starts with'));    
    		lstoperatorString.add(new Selectoption('end','ends with'));	
    		lstoperatorString.add(new Selectoption('contains','contains'));	
    		
    		lstoperatorlookup = new List<Selectoption>();
    		lstoperatorlookup.add(new Selectoption('- None -','- None -'));
    		lstoperatorlookup.add(new Selectoption('=','equals'));
    		lstoperatorlookup.add(new Selectoption('<>','not equal to'));
    		
    		
    }
	public String getFilter(){		
		String filter = ' where ';		
		for(Integer i = 0;i<lstwrapper.size();i++){
			wrapper w = lstwrapper[i];			
			if(w.fieldName != '- None -' && w.operator != '- None -'){
				String datatype = mapNameToType.get(w.fieldName);
				String val = w.value;
				String[] vals;
				if(val == ''){
					val = null;
				}
				if(dataType.equalsIgnoreCase('STRING')  || datatype.equalsIgnoreCase('EMAIL') ){
					if(val != null){
						
						String op = w.operator;
						if(op == 'start'){
							filter += w.fieldName +' '+ 'Like' + ' \'' + val+'%\' ';
						}	
						else if(op == 'end'){
							filter += w.fieldName +' '+ 'Like' + ' \'%' + val+'\' ';
						}
						else if(op == 'contains'){
							filter += w.fieldName +' '+ 'Like' + ' \'%' + val+'%\' ';
						}
						else {
							String newval = '\''+val + '\'';
							filter += w.fieldName +' '+ w.operator + ' ' + newval+' ';    // for equal and not equal 
						}					
						
					}
				}
				else if(datatype.equalsIgnoreCase('REFERENCE')){
					String id = w.recordId;
					if(id=='')
						id = null;
					
					String newval = '\''+id + '\'';
					filter += w.fieldName +' '+ w.operator + ' ' + newval+' ';    // for equal and not equal
				}
				else if(datatype.equalsIgnoreCase('PICKLIST') ){
					if(val.contains(',')){
						vals = val.split(',');
						filter += ' ( ';
						for(String s : vals){
							String newval = '\''+s + '\'';
							filter += w.fieldName +' '+ w.operator + ' ' + newval+'  or ';
						}
						filter = filter.substring(0, filter.length()-3);
						filter += ' ) ';
						system.debug('\n\n\n\n ****** Picklist Filter is :- '+filter);						
					}					
					else {
						String newval = '\''+val + '\'';
						filter += w.fieldName +' '+ w.operator + ' ' + newval+' ';
					}
				}
				else {	
													// for double data type and boolean 
					filter += w.fieldName +' '+ w.operator + ' ' + val+' ';
				}
				if(i+1 <= lstwrapper.size()-1 ){
					if(lstwrapper[i+1].fieldName != '- None -' && lstwrapper[i+1].operator != '- None -'){
						system.debug('\n\n\n Appending and to :- '+filter);
						filter += ' and ';
						system.debug('\n After Appending and filter is :- '+filter);
					}
				}
			}	
			else {
				if(i+1 <= lstwrapper.size()-1 && filter.length() > 7){
					if(lstwrapper[i+1].fieldName != '- None -' && lstwrapper[i+1].operator != '- None -'){
						system.debug('\n\n\n Appending and to :- '+filter);
						filter += ' and ';
						system.debug('\n After Appending and filter is :- '+filter);
					}
				}
			}		
		}
		
		if(filter.length() <= 7){
			filter = '';
		}
		system.debug(' \n\n\n Filter condition is :- '+filter);
		return filter;
	}
}