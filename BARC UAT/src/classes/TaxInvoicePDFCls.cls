public class TaxInvoicePDFCls {

public Id inId{get;set;}
public Invoice__c inv{get;set;}
public List<Invoice_Line_Item__c> invline {get;set;}
	
	public TaxInvoicePDFCls() {
	    
	    inId=ApexPages.currentPage().getParameters().get('id');
	    
	    inv=[SELECT  Id,  Name,  Invoice_Date_Time__c,  Transporter_Name__c,  Shipment_Weight__c,  Number_of_Boxes__c,  Docket_Number__c,  Packing_List__c,  
	        Delivery_Mode__c,  Declaration__c FROM Invoice__c where id=:inId];
	   
	    invline=[SELECT  Id,  Name,  Invoice__c,  CGST_Amount__c,  CGST__c,  GST_Rate__c,  IGST_Amount__c,  IGST__c,  Is_IGST__c,  Kitting_Amount__c,  Kitting__c,  Kitting__r.Name,  
	            SGST_Amount__c,  SGST__c,  Total_Amount__c FROM Invoice_Line_Item__c where Invoice__c=:inId];

	}

}