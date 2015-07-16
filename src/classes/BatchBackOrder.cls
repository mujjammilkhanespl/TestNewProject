global with sharing class BatchBackOrder implements Database.Batchable<sObject>, Database.Stateful {
	//Map<Id,SalesHeader__c> mapidSale = new Map<Id,SalesHeader__c>();
	Set<Id> setid = new Set<Id>();
	
	public BatchBackOrder(Map<Id,SalesHeader__c> mapidSale){
		setid = mapidSale.keyset();				
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC){
	  	
	  	String query = 'select Id, Back_Order__c, Status__c, Pick_Status__c,CreatedDate,LastModifiedDate from SalesHeader__c where id IN :setid and Back_Order__c = \'yes\'';
      	system.debug('\n\n **** Query is '+query);
      	return Database.getQueryLocator(query);
   }
   global void execute(Database.BatchableContext BC, List<SalesHeader__c> lstSale){
   		List<Case> lstcase = new List<Case>();
   		for(SalesHeader__c sale : lstSale){
   			Case c = new Case();
   			c.Status = 'New';
   			c.origin = 'Web';
   			c.Description = 'This is a case generated for Salesheader whose id is '+sale.Id + ' and generated from Batch apex';
   			lstcase.add(c);
   		}
   		insert lstcase;
   }
   global void finish(Database.BatchableContext BC){
   		
   }

}