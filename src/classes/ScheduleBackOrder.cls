global with sharing class ScheduleBackOrder implements Schedulable  {
	Map<Id,SalesHeader__c> mapidSale ;
	public ScheduleBackOrder(Map<Id,SalesHeader__c> mapidSalepara){
		mapidSale = mapidSalepara;
	}
	global void execute(SchedulableContext sc){
		BatchBackOrder objBatch = new BatchBackOrder(mapidSale);
		Database.executeBatch(objBatch);
	}
}