trigger CampaignMemberStatus on CampaignMember (after delete, after insert, after update) {
	
	CampaignMemberStatusController controller = new CampaignMemberStatusController();
	if(trigger.isAfter && trigger.isInsert){
		controller.afterinsert(trigger.new);
	}
	if(trigger.isAfter && trigger.isUpdate){
		controller.afterupdate(trigger.new,trigger.old);
	}
	if(trigger.isAfter && trigger.isDelete){
		controller.afterdelete(trigger.old);
	}
	
}