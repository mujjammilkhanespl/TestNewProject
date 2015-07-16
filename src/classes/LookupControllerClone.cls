public with sharing class LookupControllerClone {
	//objectname=Invoice__c&fieldname=Amount__c&datatype=REFERENCE
	//&namefield=j_id0:formId:j_id34:filterid:j_id46:0:targetName&idfield=j_id0:formId:j_id34:filterid:j_id46:0:targetId
	public List<Sobject> lstObject {get;set;}
	public List<String> fldnames {get;set;}
	public List<wrapperpicklist> lstwrap {get;set;}
	String objectName ;
	String fieldname;
	public String datatype {get;set;}
	public String vals {get;set;}
	public String booleanval {get;set;}
	public List<Selectoption> booleanvals {get;set;}
	class wrapperpicklist {
		public boolean isChecked {get;set;}
		public String name {get;set;}
		
		public wrapperpicklist(String nm){
			name = nm;
			isChecked = false;
		}
	}
	
	
	public LookupControllerClone(){
		lstObject = new List<Sobject>();
		fldnames = new List<String>();
		fldnames.add('Name');
		fldnames.add('id');
		objectName = Apexpages.currentPage().getParameters().get('objectname');
		fieldname = Apexpages.currentPage().getParameters().get('fieldname');
		datatype = Apexpages.currentPage().getParameters().get('datatype');
		lstwrap = new List<wrapperpicklist>();
		//vals = 'default';
		if(datatype.equalsIgnoreCase('REFERENCE')){
			lookupobj();
		}
		if(datatype.equalsIgnoreCase('PICKLIST')){
			picklistval();
		}
		if(datatype.equalsIgnoreCase('BOOLEAN')){
			booleanvals = new List<Selectoption>();
			//booleanDisplay();
			booleanvals.add(new Selectoption('True','True'));
			booleanvals.add(new Selectoption('False','False'));
		}
	}	
	public void lookupobj(){
		
		Schema.Describefieldresult Descfield = 	DescribeField();	
		List<Schema.Sobjecttype> lstobjName = Descfield.getReferenceTo();
		system.debug('\n\n\n Related to :- '+lstobjName);
		if(lstobjName.size()>0){
			String query = 'Select Id, Name From '+lstobjName[0];
			lstObject = Database.query(query);
		}
	}
	public void picklistval(){
		Schema.Describefieldresult Descfield = 	DescribeField();
		List<Schema.Picklistentry> lstpicklistvalue = Descfield.getPicklistValues();
		if(lstpicklistvalue.size() >0){
			for(Schema.Picklistentry pick : lstpicklistvalue){			
				lstwrap.add(new wrapperpicklist(pick.getValue()));
			}
			system.debug('\n\n\n\n Picklist wrapper is :- '+lstwrap);
		}
	}
	public Schema.Describefieldresult DescribeField(){
		SobjectType Sobj = Schema.getGlobalDescribe().get(objectName);
		Map<String,Schema.Sobjectfield> objfields = Sobj.getDescribe().fields.getMap();
		Schema.Describefieldresult Descfield ;
		Schema.Sobjectfield feld = objfields.get(fieldname);
		Descfield = feld.getDescribe();	
		return Descfield;
	}
	public void processSelected(){
		vals = '';
		for(integer i= 0; i< lstwrap.size();i++){
			if(lstwrap[i].isChecked == true){
				
				
				vals += lstwrap[i].name+','; 
			}			
		}
		if(vals.length()>2)
		vals = vals.substring(0, vals.length()-1);
		system.debug('\n\n\n Vals = '+vals);
	}
	public void booleanDisplay(){
		booleanvals = new List<Selectoption>();
		booleanvals.add(new Selectoption('True','True'));
		booleanvals.add(new Selectoption('False','False'));
	}
	public void BooleanSelected(){
		if(booleanval == null){
			booleanval = '';
		}
		system.debug('\n\n\n\n\n ********** Boolean value selected is :- '+booleanval);
	}
}