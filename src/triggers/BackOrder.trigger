trigger BackOrder on SalesHeader__c (after insert, after update) {
	BackOrderController objController = new BackOrderController();
	if(trigger.isAfter && trigger.isInsert){
		objController.afterinsert(trigger.new);
	}
	if(trigger.isAfter && trigger.isUpdate){
		objController.afterUpdate(trigger.new);
	}

}