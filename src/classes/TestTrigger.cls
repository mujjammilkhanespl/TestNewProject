/**
 
 */
@isTest
private class TestTrigger {

    static testMethod void TestInsert() {
        
        Master__c m = new Master__c();
        M.Name = 'Test Master';
        insert m;
          
        Master__c m1 = new Master__c();
        m1.Name = 'Test Master';
        insert m1;
         
	    Child__c ch = new Child__c();
	    ch.Name = 'Ch 1';
	    ch.Master_Record__c = m.Id;
	    insert ch;
	    
	    for(Integer i = 0;i<50;i++){
	    	Child__c chld = new Child__c();
	    	chld.Name = 'Test child '+i;
	    	if(i/2==0)
	    		ch.Master_Record__c = m.Id;
	    	else
	    		ch.Master_Record__c = m1.Id;
	    	insert chld;
	    }
	    
	    //Master__c Mq = [select Id,Child_Record_Names__c from Master__c];	    
	   // system.assertEquals('Ch 1', Mq.Child_Record_Names__c, 'Names are not Matched');
    }
    
    static testMethod void Testupdate() {
        
        Master__c m = new Master__c();
        M.Name = 'Test Master';
        insert m;
            
	    Child__c ch = new Child__c();
	    ch.Name = 'Ch 1';
	    ch.Master_Record__c = m.Id;
	    insert ch;
	        
	        
	     Child__c ch2 = new Child__c();
	     ch2.Name = 'Ch 2';
	     ch2.Master_Record__c = m.Id;
	     insert ch2;
	     
	     ch.Name = 'ch 0';
	     update ch;
	       
	      Master__c Mq = [select Id,Child_Record_Names__c from Master__c];
	      system.debug('********* child record name '+Mq.Child_Record_Names__c);
	      system.assertEquals('Ch 2, ch 0', Mq.Child_Record_Names__c, 'Names are not Matched after update');
    }
    
    static testMethod void TestDelete() {
        
        Master__c m = new Master__c();
        M.Name = 'Test Master';
        insert m;
       
	     Child__c ch = new Child__c();
	     ch.Name = 'Ch 1';
	     ch.Master_Record__c = m.Id;
	     insert ch;
	        
	     Child__c ch1 = new Child__c();
	     ch1.Name = 'Ch 2';
	     ch1.Master_Record__c = m.Id;
	     insert ch1;
	        
	     Child__c ch2 = new Child__c();
	     ch2.Name = 'Ch 3';
	     ch2.Master_Record__c = m.Id;
	     insert ch2;
	        
	     delete ch1;
	     
	     Master__c Mq = [select Id,Child_Record_Names__c from Master__c];
	     system.debug('********* child record name '+Mq.Child_Record_Names__c);
	     system.assertEquals('Ch 3, Ch 1', Mq.Child_Record_Names__c, 'Names are not Matched after Delete');
	        
    }
}