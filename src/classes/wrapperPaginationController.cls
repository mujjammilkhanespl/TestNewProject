public with sharing class wrapperPaginationController {
    
	 
	public PaginationController sc {get;set;}
	public List<Object> lstBind {get;set;}
    
    public wrapperPaginationController() {
    	List<wrapper> lstwrap = new List<wrapper>();    	
    	List<Quote> lstq = [Select name,Status From Quote];
    	for(Quote q : lstq){
    		lstwrap.add(new wrapper(q));
    	}
    	sc = new PaginationController(lstwrap);
    	sc.SetPageSize(10);
    	lstBind = sc.getRecords();
    }
    public void next(){
		if(sc.getHasNext()){
			sc.next();
			lstBind = sc.getRecords();
		}
	}
	public void previous(){
		if(sc.getHasPrevious()){
			sc.previous();
			lstBind = sc.getRecords();
		}
	}
	public void firstR(){		
			sc.first();
			lstBind = sc.getRecords();
		
	}
	public void lastR(){		
			sc.last();
			lstBind = sc.getRecords();		
	}


	public class wrapper{
    	public Quote a {get;set;}
    	public wrapper(Quote a){
    		this.a = a;
    	}
    }
}