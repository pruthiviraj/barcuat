@isTest
public class GenarateDeliveryChallanTest {

	public static testMethod void test() {
	    
	    Packing_List__c pk = new Packing_List__c();
	    insert pk;
	    
	    Packing_List_Line_Item__c pkl = new Packing_List_Line_Item__c(Packing_List__c=pk.id);
	    insert pkl;
	    
	    ApexPages.currentPage().getParameters().put('id', pk.id);
	    
	    GenarateDeliveryChallan gdc = new GenarateDeliveryChallan();
	    gdc.generate();

	}

}