public with sharing class WebController {
	public WebController(){
		
	}
	public void call(){
		Http h  = new Http();
		HttpRequest req = new HttpRequest();
    	req.setEndpoint('http://muk.rezlynx.net/rlxredirector/rlxsoapredir/RLXSoap.asmx');    	
    	req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        req.setHeader('SOAPAction', 'http://tempuri.org/RLXSOAP19/RLXSOAP19/pmsint_GetRooms');
        req.setBody('');
    	HttpResponse res = h.send(req);
    	system.debug(' Response  Body XML is :- '+' \n\n '+ res.getBody());
	}
}