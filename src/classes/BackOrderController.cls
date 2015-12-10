public with sharing class BackOrderController {
	
	public void afterinsert(List<SalesHeader__c> lstSales){
		Map<Id,SalesHeader__c> mapidSales = new Map<Id,SalesHeader__c>();
		List<Job_Sales__c> lstjs = new List<Job_Sales__c>(); 
		for(SalesHeader__c sale :lstSales){
			if(sale.Status__c == 'Released' && sale.Pick_Status__c == 'Open'){
				mapidSales.put(sale.id,sale);
			}
		}
		system.debug('mapidSales :- '+mapidSales);
		

		for(SalesHeader__c s : [select CreatedDate,LastModifiedDate from SalesHeader__c where id IN :mapidSales.keyset()]){
			Date d = Date.valueOf(s.LastModifiedDate);
			Integer Month = d.month();
			Integer Year = d.year();
			Integer day = d.day();			
			Datetime dt  = s.CreatedDate.addminutes(5);
			Integer Min = dt.minute();
			Integer hr = dt.hour();
			Integer sec = dt.second();			 
			String cron = sec + ' '+ min +' '+ hr + ' '+day + ' '+ month + ' ? '+year;
			ScheduleBackOrder objsch = new ScheduleBackOrder(mapidSales);
			String jobID = system.schedule('Merge Job from Insert '+System.now(), cron, objsch);
			
			Job_Sales__c js = new Job_Sales__c();
			js.Batch_Job_Id__c = jobId;
			js.Sale_Record_Id__c = String.valueOf(s.id);
			lstjs.add(js);									
		}
		insert lstjs;
	}
	
	
	public void afterUpdate(List<SalesHeader__c> lstSales){
		
		
		Map<Id,SalesHeader__c> mapidSales = new Map<Id,SalesHeader__c>();
		Map<Id,SalesHeader__c> mapidSalesOther = new Map<Id,SalesHeader__c>();
		List<Job_Sales__c> lstjs = new List<Job_Sales__c>();
		for(SalesHeader__c sale :lstSales){
			if(sale.Status__c == 'Released' && sale.Pick_Status__c == 'Open'){
				mapidSales.put(sale.id,sale);
			}
			if((sale.Status__c == 'Released' && sale.Pick_Status__c == 'Closed')||(sale.Status__c == 'UnReleased' && sale.Pick_Status__c == 'Open')||(sale.Status__c == 'UnReleased' && sale.Pick_Status__c == 'Closed')) {
				mapidSalesOther.put(sale.id,sale);
			}
		}
		
		List<Job_Sales__c> lstj = [select id,Batch_Job_Id__c,Sale_Record_Id__c from Job_Sales__c where Sale_Record_Id__c IN :mapidSales.keyset()];
		
		Map<Id,Job_Sales__c> mapsalejobid = new Map<Id,Job_Sales__c>();
		for(Job_Sales__c job : lstj){
			mapsalejobid.put(job.Sale_Record_Id__c,job);
		}
		
		List<Job_Sales__c> lstjOther = [select id,Batch_Job_Id__c,Sale_Record_Id__c from Job_Sales__c where Sale_Record_Id__c IN :mapidSalesOther.keyset()];
		Map<Id,Job_Sales__c> mapsalejobidOther = new Map<Id,Job_Sales__c>();
		for(Job_Sales__c job : lstjOther){
			mapsalejobidOther.put(job.Sale_Record_Id__c,job);
		}
		Boolean shedule;
		List<Job_Sales__c> lstdeletejob = new List<Job_Sales__c>();
		
		
		for(SalesHeader__c s : [select CreatedDate,LastModifiedDate from SalesHeader__c where id IN :mapidSales.keyset()]){
			
			if(mapsalejobid.ContainsKey(s.id)){
				Job_Sales__c jd = mapsalejobid.get(s.id);
				String Id = jd.Batch_Job_Id__c;
				system.debug('\n\n ***** Job id  = '+Id);
				system.abortJob(id);
				shedule = true;	
				lstdeletejob.add(jd);			
			}			
			Date d = Date.valueOf(s.LastModifiedDate);
			Integer Month = d.month();
			Integer Year = d.year();
			Integer day = d.day();			
			Datetime dt  = s.CreatedDate.addminutes(5);
			Integer Min = dt.minute();
			Integer hr = dt.hour();
			Integer sec = dt.second();			 
			String cron = sec + ' '+ min +' '+ hr + ' '+day + ' '+ month + ' ? '+year;
			ScheduleBackOrder objsch = new ScheduleBackOrder(mapidSales);
			String jobID;
			
			jobID = system.schedule('Merge Job from Update '+System.now(), cron, objsch);
			Job_Sales__c js = new Job_Sales__c();
			js.Batch_Job_Id__c = jobId;
			js.Sale_Record_Id__c = String.valueOf(s.id);
			lstjs.add(js);			
		}		
		for(SalesHeader__c s : [select CreatedDate,LastModifiedDate from SalesHeader__c where id IN :mapidSalesOther.keyset()]){
			if(mapsalejobidOther.ContainsKey(s.id)){
				Job_Sales__c jd = mapsalejobidOther.get(s.id);
				String Id = jd.Batch_Job_Id__c;
				system.debug('\n\n ***** Job id in other = '+Id);
				system.abortJob(id);
					
				lstdeletejob.add(jd);			
			}
		}
		insert lstjs;
		delete lstdeletejob;	
	}
}
