public with sharing class InvoiceController {
	public Amount__c amount ;
	public String amnt {get;set;}
	public String methode {get;set;}
	public String input {get;set;}
	public Integer output {get;set;}
	private Id id;
    public InvoiceController(ApexPages.StandardController controller) {
		id = controller.getId();
		amount = [select amount__c from amount__c where id = :id];
		amnt = String.valueOf(amount.Amount__c);
		
    }
	public List<Selectoption> getlist(){
		List<Selectoption> op = new List<Selectoption>();
		op.add(new Selectoption('mul','Multiplication'));
		op.add(new Selectoption('per','Percentage'));
		return op;
	}
	public Pagereference generate(){
		
		Invoice__c inv  = new Invoice__c();
		inv.Amount__c = id;
		system.debug('\n\n\n\n ***** output in generate methode **'+output);
		inv.Invoice_Amount__c = output;
		insert inv;
		Pagereference p = new Pagereference('/'+id);
		p.setRedirect(true);		
		return p;
		
	}
}