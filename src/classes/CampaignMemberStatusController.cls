public with sharing class CampaignMemberStatusController {
	public void afterinsert(List<CampaignMember> lstcm){
	    set<Id> setCampId = new set<Id>(); 
	    
		Map<Id,Id> mapchild_Parent  = new Map<Id,Id>();
		Map<Id,Campaign> mapParentid_campaign = new Map<Id,Campaign>();    
	    for(CampaignMember ch:lstcm)
	    {
	       setCampId.add(ch.Campaignid);
	    }
	  	
		for(Campaign cm :[select id , parentid from Campaign where id IN :setCampId]){
			mapchild_Parent.put(cm.id,cm.parentid);
		}
		
		List<Id> parentids  = mapchild_Parent.values();
		for(Campaign cm : [select id, Total_RSVP_yes_Total__c, Total_RSVP_No_Total__c from Campaign where id IN :parentids]) {
			mapParentid_campaign.put(cm.id,cm);
		}
		
		map<Campaign, list<CampaignMember>> mapCamp_CampMember = new map<Campaign, list<CampaignMember>>();
		for(CampaignMember cm :lstcm){
			Id i = cm.CampaignId;
			Id parent = mapchild_Parent.get(i);
			Campaign c = mapParentid_campaign.get(parent);
			if(!mapCamp_CampMember.containsKey(c))
                   mapCamp_CampMember.put(c, new list<CampaignMember>{cm});
               else
                   mapCamp_CampMember.get(c).add(cm);
		}
		List<Campaign> lstupdatepending  = new List<Campaign>();
		for(Campaign objparent : mapCamp_CampMember.keyset()) {
		    for(CampaignMember cm: mapCamp_CampMember.get(objparent)) {
			     if(cm.Status.equalsIgnoreCase('RSVP Yes')) {
			     	if(objparent.Total_RSVP_yes_Total__c == null)
			     		objparent.Total_RSVP_yes_Total__c = 1;			     	
			     	else
			     		objparent.Total_RSVP_yes_Total__c ++;
			     }
			     if(cm.Status.equalsIgnoreCase('RSVP No')){
			     	if(objparent.Total_RSVP_No_Total__c == null)
			     		objparent.Total_RSVP_No_Total__c = 1;			     	
			     	else
			     		objparent.Total_RSVP_No_Total__c ++;
			     }				    		                    
		    }
		    lstupdatepending.add(objparent) ;
     	}		
		if(lstupdatepending.size()>0)
			update lstupdatepending;
        	
        		
	}
	
	// Methode for Updating trigger
	public void afterupdate(List<CampaignMember> lstcm, List<CampaignMember> oldcm){
	
		set<Id> setCampId = new set<Id>(); 
	    
		Map<Id,Id> mapchild_Parent  = new Map<Id,Id>();
		Map<Id,Campaign> mapParentid_campaign = new Map<Id,Campaign>();    
	    for(CampaignMember ch:lstcm)
	    {
	       setCampId.add(ch.Campaignid);
	    }
	  	
		for(Campaign cm :[select id , parentid from Campaign where id IN :setCampId]){
			mapchild_Parent.put(cm.id,cm.parentid);
		}
		
		
		List<Id> parentids  = mapchild_Parent.values();
		for(Campaign cm : [select id, Total_RSVP_yes_Total__c, Total_RSVP_No_Total__c from Campaign where id IN :parentids]) {
			mapParentid_campaign.put(cm.id,cm);
		}
		
		map<Campaign, list<CampaignMember>> mapCamp_CampMember = new map<Campaign, list<CampaignMember>>();
		map<Campaign, list<CampaignMember>> mapCamp_CampMemberOld = new map<Campaign, list<CampaignMember>>();
		for(CampaignMember cm :lstcm){
			Id i = cm.CampaignId;
			Id parent = mapchild_Parent.get(i);
			Campaign c = mapParentid_campaign.get(parent);
			if(!mapCamp_CampMember.containsKey(c))
                   mapCamp_CampMember.put(c, new list<CampaignMember>{cm});
               else
                   mapCamp_CampMember.get(c).add(cm);
		}
		for(CampaignMember cm :oldcm){
			Id i = cm.CampaignId;
			Id parent = mapchild_Parent.get(i);
			Campaign c = mapParentid_campaign.get(parent);
			if(!mapCamp_CampMemberOld.containsKey(c))
                   mapCamp_CampMemberOld.put(c, new list<CampaignMember>{cm});
               else
                   mapCamp_CampMemberOld.get(c).add(cm);
		}
		List<Campaign> lstupdatepending  = new List<Campaign>();
		for(Campaign objparent : mapCamp_CampMember.keyset()) {
		    for(CampaignMember cm: mapCamp_CampMember.get(objparent)) {
			     if(cm.Status.equalsIgnoreCase('RSVP Yes')) {
			     	if(objparent.Total_RSVP_yes_Total__c == null)
			     		objparent.Total_RSVP_yes_Total__c = 1;			     	
			     	else
			     		objparent.Total_RSVP_yes_Total__c ++;
			     }
			     if(cm.Status.equalsIgnoreCase('RSVP No')){
			     	if(objparent.Total_RSVP_No_Total__c == null)
			     		objparent.Total_RSVP_No_Total__c = 1;			     	
			     	else
			     		objparent.Total_RSVP_No_Total__c ++;
			     }				    		                    
		    }
		    lstupdatepending.add(objparent) ;
     	}	
     	if(lstupdatepending.size()>0)
			update lstupdatepending;
		lstupdatepending = new List<Campaign>();
     	for(Campaign objparent : mapCamp_CampMemberOld.keyset()) {
		    for(CampaignMember cm: mapCamp_CampMemberOld.get(objparent)) {
			     if(cm.Status.equalsIgnoreCase('RSVP Yes')) {
			     	if(objparent.Total_RSVP_yes_Total__c == 0)
			     		objparent.Total_RSVP_yes_Total__c = null;			     	
			     	else
			     		objparent.Total_RSVP_yes_Total__c --;
			     }
			     if(cm.Status.equalsIgnoreCase('RSVP No')){
			     	if(objparent.Total_RSVP_No_Total__c == 0)
			     		objparent.Total_RSVP_No_Total__c = null;			     	
			     	else
			     		objparent.Total_RSVP_No_Total__c --;
			     }				    		                    
		    }
		    lstupdatepending.add(objparent) ;
     	}
     			
		if(lstupdatepending.size()>0)
			update lstupdatepending;
			
	}
	public void afterdelete(List<CampaignMember> lstcm){
		set<Id> setCampId = new set<Id>(); 
	    
		Map<Id,Id> mapchild_Parent  = new Map<Id,Id>();
		Map<Id,Campaign> mapParentid_campaign = new Map<Id,Campaign>();    
	    for(CampaignMember ch:lstcm)
	    {
	       setCampId.add(ch.Campaignid);
	    }
	  	
		for(Campaign cm :[select id , parentid from Campaign where id IN :setCampId]){
			mapchild_Parent.put(cm.id,cm.parentid);
		}
		
		List<Id> parentids  = mapchild_Parent.values();
		for(Campaign cm : [select id, Total_RSVP_yes_Total__c, Total_RSVP_No_Total__c from Campaign where id IN :parentids]) {
			mapParentid_campaign.put(cm.id,cm);
		}
		
		map<Campaign, list<CampaignMember>> mapCamp_CampMember = new map<Campaign, list<CampaignMember>>();
		for(CampaignMember cm :lstcm){
			Id i = cm.CampaignId;
			Id parent = mapchild_Parent.get(i);
			Campaign c = mapParentid_campaign.get(parent);
			if(!mapCamp_CampMember.containsKey(c))
                   mapCamp_CampMember.put(c, new list<CampaignMember>{cm});
               else
                   mapCamp_CampMember.get(c).add(cm);
		}
		List<Campaign> lstupdatepending  = new List<Campaign>();
		for(Campaign objparent : mapCamp_CampMember.keyset()) {
		    for(CampaignMember cm: mapCamp_CampMember.get(objparent)) {
			     if(cm.Status.equalsIgnoreCase('RSVP Yes')) {
			     	if(objparent.Total_RSVP_yes_Total__c == 0)
			     		objparent.Total_RSVP_yes_Total__c = null;			     	
			     	else
			     		objparent.Total_RSVP_yes_Total__c --;
			     }
			     if(cm.Status.equalsIgnoreCase('RSVP No')){
			     	if(objparent.Total_RSVP_No_Total__c == 0)
			     		objparent.Total_RSVP_No_Total__c = null;			     	
			     	else
			     		objparent.Total_RSVP_No_Total__c --;
			     }				    		                    
		    }
		    lstupdatepending.add(objparent) ;
     	}		
		if(lstupdatepending.size()>0)
			update lstupdatepending;
        	
	}
}