@isTest
public class TaxInvoicePDFClsTest {

	public static testMethod void test() {
	    
	    Invoice__c inv = new Invoice__c();
	    insert inv;
	    
	    Invoice_Line_Item__c invl = new Invoice_Line_Item__c(Invoice__c=inv.id);
	    insert invl;
	    
	    ApexPages.currentPage().getParameters().put('id', inv.id);
	    
	    TaxInvoicePDFCls txi = new TaxInvoicePDFCls();

	}

}