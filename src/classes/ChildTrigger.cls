public with sharing class ChildTrigger {
	
	public void afterInsert(List<Child__c> lstchild){
		List<ID> lstMasterId = new List<Id>();
		List<Master__c> masterupdate = new List<Master__c>();
		List<String> names = new List<String>();
		
		for(Child__c ch :lstchild){
			lstMasterId.add(ch.Master_Record__c);			
		}
		List<Master__c> lstMaster = [select Id,Child_Record_Names__c from Master__c where Id IN :lstMasterId];
		
		for(Master__c mast : lstMaster){
			for(Child__c chld :lstchild){
				if(chld.Master_Record__c == mast.Id){
					if(Mast.Child_Record_Names__c =='' || Mast.Child_Record_Names__c == null){
						Mast.Child_Record_Names__c = chld.Name;
						masterupdate.add(mast);
					}
					else
					{
						Mast.Child_Record_Names__c += ', '+chld.Name; 
						masterupdate.add(Mast);
					}
				}
			}
		}
		if(masterupdate.size()>0)
			update masterupdate;
	}
	
	
	
	public void afterUpdate(List<Child__c> newlist){
		List<ID> lstMasterId = new List<Id>();
		List<Master__c> updatemaster = new List<Master__c>(); 
		system.debug('\n *** New :- '+newlist );	
		for(Child__c ch : newlist){
			lstMasterId.add(ch.Master_Record__c);
		}
		
		List<Master__c> lstMaster = [Select m.Id, 
											m.Child_Record_Names__c, 
											(Select Name, Master_Record__c From Child__r order by createddate) 
											From Master__c m 
											where Id IN :lstMasterId];
		String names = '';									
		system.debug('*** List '+lstMaster );
		for(Master__c mast : lstMaster){
			names = '';
			Child__c[] ch = mast.Child__r;
			system.debug('*** child record '+ch);
			for(integer i=0;i<ch.size();i++){
				if(i==0)
					names = ch[i].Name;
				else
					names += ', '+ch[i].Name;
			}
			mast.Child_Record_Names__c = names;
			updatemaster.add(mast);
		}
		if(updatemaster.size()>0)
			update updatemaster;
	}
	
	
	public void afterDelete(List<Child__c> oldlist){
		system.debug('******* new list for delete '+oldlist);
		List<ID> lstMasterId = new List<Id>();
		List<Master__c> updatemaster = new List<Master__c>(); 
			
		for(Child__c ch : oldlist){
			lstMasterId.add(ch.Master_Record__c);
		}
		
		List<Master__c> lstMaster = [Select m.Id, 
											m.Child_Record_Names__c, 
											(Select Name, Master_Record__c From Child__r order by createddate) 
											From Master__c m 
											where Id IN :lstMasterId];
		String names = '';									
		system.debug('*** List '+lstMaster );
		for(Master__c mast : lstMaster){
			Child__c[] ch = mast.Child__r;
			system.debug('*** child record '+ch);
			for(integer i=0;i<ch.size();i++){
				if(i==0)
					names = ch[i].Name;
				else
					names += ', '+ch[i].Name;
			}
			mast.Child_Record_Names__c = names;
			updatemaster.add(mast);
		}
		if(updatemaster.size()>0)
			update updatemaster;
	}
}