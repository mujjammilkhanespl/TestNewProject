public with sharing class testPaginationController {
	
	public List<Quote> lstQ {get;set;}
	public Custom_Controller cc {get;set;}
	public testPaginationController(){
		lstQ = new List<Quote>();
		List<Quote> temp = [select id,Name from Quote];
		cc = new Custom_Controller(temp);
		cc.SetPageSize(10);
		lstQ = (List<Quote>) cc.getRecords();
		system.debug('\n\n from constructor Next :- '+cc.gethasNext());	
		system.debug('\n\n from constructor Previous :- '+cc.gethasPrevious());		
	}
	public void next(){
		cc.next();
		lstQ = new List<Quote>();
		lstQ = (List<Quote>) cc.getRecords();
		system.debug('\n\n Next :- '+cc.gethasNext());
	}
	public void previous(){
		cc.previous();		
		lstQ = new List<Quote>();
		lstQ = (List<Quote>) cc.getRecords();
		system.debug('\n\n Previous :- '+cc.gethasPrevious());
	}
	public void last(){
		cc.Last();
		lstQ = new List<Quote>();
		lstQ = (List<Quote>) cc.getRecords();
		system.debug('\n\n Last :- '+cc.gethasPrevious());
	}
	public void First(){
		cc.First();
		lstQ = new List<Quote>();
		lstQ = (List<Quote>) cc.getRecords();
		system.debug('\n\n First :- '+cc.gethasPrevious());
	}
}