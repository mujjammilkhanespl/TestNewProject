public with sharing class TransactionTriggerHandler {
	
	public void afterinsert(List<Transaction__c> lstTran){
		
		Map<Id,Transaction__c> mapidtran = new Map<Id,Transaction__c>();
		for(Transaction__c tran : lstTran){
			mapidtran.put(tran.Sale_Header_Record__c,tran);
		}
		List<Case> lstcase = new List<Case>();
		for(SalesHeader__c sale : [select id,Pick_Status__c from SalesHeader__c where Id IN :mapidtran.keyset()]){
			if(mapidtran.containskey(sale.id)){
				Transaction__c tran = mapidtran.get(sale.id);
				if(tran.Methode_Name__c == 'Credit Card Address Verify' && tran.Status__c == 'Decline' && sale.Pick_Status__c == 'Open'){
					Case c = new Case();
					c.Status = 'New';
					c.Origin = 'Web';
					c.Description = 'Case created due to condition methode name = credit card and status decline';
					lstcase.add(c);
				}
			}
		}
		insert lstcase;
	}
	public void afterUpdate(List<Transaction__c> lstTran){
		Map<Id,Transaction__c> mapidtran = new Map<Id,Transaction__c>();
		for(Transaction__c tran : lstTran){
			mapidtran.put(tran.Sale_Header_Record__c,tran);
		}
		List<Case> lstcase = new List<Case>();
		for(SalesHeader__c sale : [select id,Pick_Status__c from SalesHeader__c where Id IN :mapidtran.keyset()]){
			if(mapidtran.containskey(sale.id)){
				Transaction__c tran = mapidtran.get(sale.id);
				if(tran.Methode_Name__c == 'Credit Card Address Verify' && tran.Status__c == 'Decline' && sale.Pick_Status__c == 'Open'){
					Case c = new Case();
					c.Status = 'New';
					c.Origin = 'Web';
					c.Description = 'Case created due to condition methode name = credit card and status decline';
					lstcase.add(c);
				}
			}
		}
		insert lstcase;
	}

}