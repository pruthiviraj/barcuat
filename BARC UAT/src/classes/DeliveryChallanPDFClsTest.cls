@isTest
public class DeliveryChallanPDFClsTest {

	public static testMethod void test() {
	    
	    Delivery_Challan__c dch = new Delivery_Challan__c();
	    insert dch;
	    
	    Delivery_Challan_Line_Item__c dcl = new Delivery_Challan_Line_Item__c(Delivery_Challan__c=dch.id);
	    insert dcl;
	    
	    
	    ApexPages.currentPage().getParameters().put('id', dch.id);
	    
	    DeliveryChallanPDFCls dcp = new DeliveryChallanPDFCls();

	}

}