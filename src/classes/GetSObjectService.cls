@RestResource (urlMapping='/VFPage/*')
global with sharing class GetSObjectService {
	@Httpget
	global static void doGet()
	{
		List<String> op = new List<String>();
		Map<String, Schema.SObjectType> objects = Schema.getGlobalDescribe();
  		Schema.DescribeSObjectResult objInfo = null;
  		for (Schema.SObjectType obj : objects.values()) {
     		objInfo = obj.getDescribe();     		
      		op.add(objInfo.getLabel()) ;
  		}	
  		RestContext.response.responseBody = Blob.valueOf(JSON.serialize(op));	
		//return op;
	}
}