trigger GiveNameToMaster on Child__c (after delete, after insert, after update) {
	ChildTrigger objhandler = new ChildTrigger();
	if(trigger.isAfter && trigger.isInsert){		
		objhandler.afterInsert(trigger.new);
	}
	if(trigger.isAfter && trigger.isUpdate){
		objhandler.afterUpdate(trigger.new);
	}
	if(trigger.isAfter && trigger.isDelete){
		objhandler.afterDelete(trigger.old);
	}
}