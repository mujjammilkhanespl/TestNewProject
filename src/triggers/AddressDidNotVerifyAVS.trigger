trigger AddressDidNotVerifyAVS on Transaction__c (after insert, after update) {
	TransactionTriggerHandler objHandler = new TransactionTriggerHandler();
	if(trigger.isAfter && trigger.isInsert){
		objHandler.afterinsert(trigger.new);
	}
	if(trigger.isAfter && trigger.isUpdate){
		objHandler.afterUpdate(trigger.new);		
	}

}