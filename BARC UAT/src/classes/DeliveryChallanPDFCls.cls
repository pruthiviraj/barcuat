public class DeliveryChallanPDFCls {
    
public Id deId{get;set;}
public Delivery_Challan__c dch{get;set;}
public List<Delivery_Challan_Line_Item__c> dchline {get;set;}

    public DeliveryChallanPDFCls(){
        
        deId=ApexPages.currentPage().getParameters().get('id');
        
        dch=[ SELECT  Id,  Name,  Delivery_Challan_Date__c,  Delivery_Mode__c,  Transporter_Name__c,  Place_of_Supply__c,  Number_of_Boxes__c,  Shipment_Weight_Kg__c,  Installer_Name__c,  
             Declarations__c,  Packing_List__c,  Docket_No__c,  Total_Amount__c,  GRN_No__c, GRN_Date__c FROM Delivery_Challan__c where id=:deId]; 
             
        dchline=[SELECT  Id,  Name,  Delivery_Challan__c,  Kitting__c,  Kitting_Amount__c,  Is_IGST__c,  Kitting__r.Name, 
                CGST__c,  SGST__c,  IGST__c,  CGST_Amount__c,  SGST_Amount__c,  IGST_Amount__c,  Total_Amount__c,  GST_Rate__c,  Copy_Total_Value__c FROM Delivery_Challan_Line_Item__c where
                Delivery_Challan__c=:deId];
    }

}