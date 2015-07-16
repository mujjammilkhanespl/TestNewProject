/**
 
 */
@isTest
private class TestCampaignMember {

    static testMethod void testInsertCamp() {
        
        Campaign parent = new Campaign();
        parent.Name = 'Parent';
        insert parent;
        
        
        Campaign child = new Campaign();
        child.Name = 'Parent';
        child.ParentId = parent.Id;
        insert child;
        
        Lead l = new Lead();
        l.LastName = 'Lead';
        l.Company = 'espl';
        insert l;
        
        Lead l1 = new Lead();
        l1.LastName = 'Lead';
        l1.Company = 'espl';
        insert l1;
        
       
        CampaignMemberStatus cms = new CampaignMemberStatus();
        cms.CampaignId = child.Id;
        cms.Label = 'RSVP Yes';
        cms.SortOrder = 3;
        insert cms;
        
        CampaignMemberStatus cms1 = new CampaignMemberStatus();
        cms1.CampaignId = child.Id;
        cms1.Label = 'RSVP No';
        cms1.SortOrder = 4;
        insert cms1;
        
        CampaignMember cmm = new CampaignMember();
        cmm.LeadId = l.Id;
        cmm.CampaignId = child.Id;
        cmm.Status = 'RSVP Yes';
        insert cmm;
        
        CampaignMember cmm1 = new CampaignMember();
        cmm1.LeadId = l1.Id;
        cmm1.CampaignId = child.Id;
        cmm1.Status = 'RSVP No';
        insert cmm1;
        
        Campaign cmmq = [select Id,Total_RSVP_No_Total__c,Total_RSVP_yes_Total__c from Campaign where id = :parent.id];
        system.assertEquals(cmmq.Total_RSVP_yes_Total__c, 1);
        system.assertEquals(cmmq.Total_RSVP_No_Total__c, 1);
        
    }
    
    
    static testMethod void testUpdateCamp() {
        
        Campaign parent = new Campaign();
        parent.Name = 'Parent';
        insert parent;
        
        
        Campaign child = new Campaign();
        child.Name = 'Parent';
        child.ParentId = parent.Id;
        insert child;
        
        CampaignMemberStatus cms = new CampaignMemberStatus();
        cms.CampaignId = child.Id;
        cms.Label = 'RSVP Yes';
        cms.SortOrder = 3;
        insert cms;
        
        CampaignMemberStatus cms1 = new CampaignMemberStatus();
        cms1.CampaignId = child.Id;
        cms1.Label = 'RSVP No';
        cms1.SortOrder = 4;
        insert cms1;
        
        Lead l = new Lead();
        l.LastName = 'Lead';
        l.Company = 'espl';
        insert l;
        
        Lead l1 = new Lead();
        l1.LastName = 'Lead';
        l1.Company = 'espl';
        insert l1;
        
        CampaignMember cmm = new CampaignMember();
        cmm.LeadId = l.Id;
        cmm.CampaignId = child.Id;
        cmm.Status = 'RSVP Yes';
        insert cmm;
        
        cmm.Status = 'RSVP No';
        update cmm;
        
        CampaignMember cmm1 = new CampaignMember();
        cmm1.LeadId = l1.Id;
        cmm1.CampaignId = child.Id;
        cmm1.Status = 'RSVP No';
        insert cmm1;
        
        Campaign cmmq = [select Id,Total_RSVP_No_Total__c,Total_RSVP_yes_Total__c from Campaign where id = :parent.id];       
        system.assertEquals(cmmq.Total_RSVP_No_Total__c, 2);
        
    }
    
    static testMethod void testDeleteCamp() {
        
        Campaign parent = new Campaign();
        parent.Name = 'Parent';
        insert parent;
        
        
        Campaign child = new Campaign();
        child.Name = 'Parent';
        child.ParentId = parent.Id;
        insert child;
        
        Lead l = new Lead();
        l.LastName = 'Lead';
        l.Company = 'espl';
        insert l;
        
        Lead l1 = new Lead();
        l1.LastName = 'Lead';
        l1.Company = 'espl';
        insert l1;
        
        CampaignMemberStatus cms = new CampaignMemberStatus();
        cms.CampaignId = child.Id;
        cms.Label = 'RSVP Yes';
        cms.SortOrder = 3;
        insert cms;
        
        CampaignMemberStatus cms1 = new CampaignMemberStatus();
        cms1.CampaignId = child.Id;
        cms1.Label = 'RSVP No';
        cms1.SortOrder = 4;
        insert cms1;
        
        CampaignMember cmm = new CampaignMember();
        cmm.LeadId = l.Id;
        cmm.CampaignId = child.Id;
        cmm.Status = 'RSVP Yes';
        insert cmm;
        
        cmm.Status = 'RSVP No';
        update cmm;
        
        delete cmm;
        CampaignMember cmm1 = new CampaignMember();
        cmm1.LeadId = l1.Id;
        cmm1.CampaignId = child.Id;
        cmm1.Status = 'RSVP No';
        insert cmm1;
        
        Campaign cmmq = [select Id,Total_RSVP_No_Total__c,Total_RSVP_yes_Total__c from Campaign where id = :parent.id];        
        system.assertEquals(cmmq.Total_RSVP_No_Total__c, 1);
    }
    
    
    
    static testMethod void testInsertCampBulk() {
        
        Campaign parent = new Campaign();
        parent.Name = 'Parent';
        insert parent;        
        
        Campaign child = new Campaign();
        child.Name = 'Parent';
        child.ParentId = parent.Id;
        insert child;
        
        Campaign parent1 = new Campaign();
        parent1.Name = 'Parent';
        insert parent1;
        
        
        Campaign child1 = new Campaign();
        child1.Name = 'Parent';
        child1.ParentId = parent1.Id;
        insert child1;
        
        Lead l = new Lead();
        l.LastName = 'Lead';
        l.Company = 'espl';
        insert l;
        
        Lead l2 = new Lead();
        l2.LastName = 'Lead';
        l2.Company = 'espl';
        insert l2;
        Lead l3 = new Lead();
        l3.LastName = 'Lead';
        l3.Company = 'espl';
        insert l3;
        
        Lead l1 = new Lead();
        l1.LastName = 'Lead';
        l1.Company = 'espl';
        insert l1;
        List<CampaignMember> lstcm = new List<CampaignMember>();
        
        CampaignMemberStatus cms = new CampaignMemberStatus();
        cms.CampaignId = child.Id;
        cms.Label = 'RSVP Yes';
        cms.SortOrder = 3;
        insert cms;
        
        CampaignMemberStatus cms1 = new CampaignMemberStatus();
        cms1.CampaignId = child.Id;
        cms1.Label = 'RSVP No';
        cms1.SortOrder = 4;
        insert cms1;
        
        CampaignMember cmm = new CampaignMember();
        cmm.LeadId = l.Id;
        cmm.CampaignId = child.Id;
        cmm.Status = 'RSVP Yes';
        lstcm.add(cmm);
        
        CampaignMember cmm1 = new CampaignMember();
        cmm1.LeadId = l1.Id;
        cmm1.CampaignId = child.Id;
        cmm1.Status = 'RSVP No';
        lstcm.add(cmm1);
        
        CampaignMember cmm2 = new CampaignMember();
        cmm2.LeadId = l2.Id;
        cmm2.CampaignId = child1.Id;
        cmm2.Status = 'RSVP Yes';
        lstcm.add(cmm2);
        
        CampaignMember cmm12 = new CampaignMember();
        cmm12.LeadId = l3.Id;
        cmm12.CampaignId = child1.Id;
        cmm12.Status = 'RSVP No';
        lstcm.add(cmm12);
        
        insert lstcm;
        Campaign cmmq = [select Id,Total_RSVP_No_Total__c,Total_RSVP_yes_Total__c from Campaign where id = :parent.id];
        system.assertEquals(cmmq.Total_RSVP_yes_Total__c, 1);
        system.assertEquals(cmmq.Total_RSVP_No_Total__c, 1);
        
        

    }
    
    
     static testMethod void testUpdateCampBulk() {
        
        Campaign parent = new Campaign();
        parent.Name = 'Parent';
        insert parent;        
        
        Campaign child = new Campaign();
        child.Name = 'Parent';
        child.ParentId = parent.Id;
        insert child;
        
        Campaign parent1 = new Campaign();
        parent1.Name = 'Parent';
        insert parent1;
        
        
        Campaign child1 = new Campaign();
        child1.Name = 'Parent';
        child1.ParentId = parent1.Id;
        insert child1;
        
        Lead l = new Lead();
        l.LastName = 'Lead';
        l.Company = 'espl';
        insert l;
        
        Lead l2 = new Lead();
        l2.LastName = 'Lead';
        l2.Company = 'espl';
        insert l2;
        Lead l3 = new Lead();
        l3.LastName = 'Lead';
        l3.Company = 'espl';
        insert l3;
        
        Lead l1 = new Lead();
        l1.LastName = 'Lead';
        l1.Company = 'espl';
        insert l1;
        List<CampaignMember> lstcm = new List<CampaignMember>();
        List<CampaignMember> lstcm1 = new List<CampaignMember>();
        
        CampaignMemberStatus cms = new CampaignMemberStatus();
        cms.CampaignId = child.Id;
        cms.Label = 'RSVP Yes';
        cms.SortOrder = 3;
        insert cms;
        
        CampaignMemberStatus cms1 = new CampaignMemberStatus();
        cms1.CampaignId = child.Id;
        cms1.Label = 'RSVP No';
        cms1.SortOrder = 4;
        insert cms1;
        
        CampaignMember cmm = new CampaignMember();
        cmm.LeadId = l.Id;
        cmm.CampaignId = child.Id;
        cmm.Status = 'RSVP Yes';
        lstcm.add(cmm);
        
        CampaignMember cmm1 = new CampaignMember();
        cmm1.LeadId = l1.Id;
        cmm1.CampaignId = child.Id;
        cmm1.Status = 'RSVP No';
        lstcm.add(cmm1);
        
        CampaignMember cmm2 = new CampaignMember();
        cmm2.LeadId = l2.Id;
        cmm2.CampaignId = child1.Id;
        cmm2.Status = 'RSVP Yes';
        lstcm.add(cmm2);
        
        CampaignMember cmm12 = new CampaignMember();
        cmm12.LeadId = l3.Id;
        cmm12.CampaignId = child1.Id;
        cmm12.Status = 'RSVP No';
        lstcm.add(cmm12);
        
        insert lstcm;
        cmm.Status = 'RSVP No';
        lstcm1.add(cmm);
        cmm1.Status = 'RSVP Yes';
        lstcm1.add(cmm1);
        
        update lstcm1;
        
        Campaign cmmq = [select Id,Total_RSVP_No_Total__c,Total_RSVP_yes_Total__c from Campaign where id = :parent.id];
        system.assertEquals(cmmq.Total_RSVP_yes_Total__c, 1);
        system.assertEquals(cmmq.Total_RSVP_No_Total__c, 1);
    }
    
    
    
     static testMethod void testDeleteCampBulk() {
        
        Campaign parent = new Campaign();
        parent.Name = 'Parent';
        insert parent;        
        
        Campaign child = new Campaign();
        child.Name = 'Parent';
        child.ParentId = parent.Id;
        insert child;
        
        Campaign parent1 = new Campaign();
        parent1.Name = 'Parent';
        insert parent1;
        
        
        Campaign child1 = new Campaign();
        child1.Name = 'Parent';
        child1.ParentId = parent1.Id;
        insert child1;
        
        Lead l = new Lead();
        l.LastName = 'Lead';
        l.Company = 'espl';
        insert l;
        
        Lead l2 = new Lead();
        l2.LastName = 'Lead';
        l2.Company = 'espl';
        insert l2;
        Lead l3 = new Lead();
        l3.LastName = 'Lead';
        l3.Company = 'espl';
        insert l3;
        
        Lead l1 = new Lead();
        l1.LastName = 'Lead';
        l1.Company = 'espl';
        insert l1;
        List<CampaignMember> lstcm = new List<CampaignMember>();
        List<CampaignMember> lstcm1 = new List<CampaignMember>();
        
        CampaignMemberStatus cms = new CampaignMemberStatus();
        cms.CampaignId = child.Id;
        cms.Label = 'RSVP Yes';
        cms.SortOrder = 3;
        insert cms;
        
        CampaignMemberStatus cms1 = new CampaignMemberStatus();
        cms1.CampaignId = child.Id;
        cms1.Label = 'RSVP No';
        cms1.SortOrder = 4;
        insert cms1;
        
        CampaignMember cmm = new CampaignMember();
        cmm.LeadId = l.Id;
        cmm.CampaignId = child.Id;
        cmm.Status = 'RSVP Yes';
        lstcm.add(cmm);
        
        CampaignMember cmm1 = new CampaignMember();
        cmm1.LeadId = l1.Id;
        cmm1.CampaignId = child.Id;
        cmm1.Status = 'RSVP No';
        lstcm.add(cmm1);
        
        CampaignMember cmm2 = new CampaignMember();
        cmm2.LeadId = l2.Id;
        cmm2.CampaignId = child1.Id;
        cmm2.Status = 'RSVP Yes';
        lstcm.add(cmm2);
        
        CampaignMember cmm12 = new CampaignMember();
        cmm12.LeadId = l3.Id;
        cmm12.CampaignId = child1.Id;
        cmm12.Status = 'RSVP No';
        lstcm.add(cmm12);
        
        insert lstcm;
        
        lstcm1.add(cmm);
        
        lstcm1.add(cmm1);
        
        delete lstcm1;
        Campaign cmmq = [select Id,Total_RSVP_No_Total__c,Total_RSVP_yes_Total__c from Campaign where id = :parent.id];
        system.assertEquals(cmmq.Total_RSVP_yes_Total__c, 0);
        system.assertEquals(cmmq.Total_RSVP_No_Total__c, 0);
    }
}