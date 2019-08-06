public class GenarateInvoice {
    public String packingListId{get;set;}
    public GenarateInvoice(){
        System.debug('load this');
        packingListId = ApexPages.currentPage().getParameters().get('id');
    }
    
    public PageReference generate(){
        System.debug('call this method on load ======='+packingListId);
        Packing_List__c pdata = [ SELECT  Id,  Name, ( SELECT  Id,  Name,  Packing_List__c,  Kitting__c FROM Packing_List_Line_Items__r), Bill_To_Name__c,  Bill_To_Address__c,  Bill_To_Phone__c,  Ship_To_Name__c,  Ship_To_Address__c,  Ship_To_Phone__c,  Ship_To_Email__c,  Bill_To_Operator__c,  Ship_To_Operator__c,  Ship_To_Local_Operator__c,  Bill_To_Email__c,  Bill_To_State__c,  Ship_To_State__c,  Bill_To_Country__c,  Ship_To_Country__c,  Bill_To_City__c,  Ship_To_City__c,  Bill_To_Pincode__c,  Ship_To_Pincode__c,  Transporter_Name__c,  Delivery_Mode__c,  Purpose__c,  Declaration__c FROM Packing_List__c WHERE Id=:packingListId];
        Set<Id> kittingIds = new Set<Id>();
        for(Packing_List_Line_Item__c pl: pdata.Packing_List_Line_Items__r){
            kittingIds.add(pl.Kitting__c);
        }
        List<Kitting__c> kittingData = [ SELECT  Id,  Name,( SELECT  Id,  Name,  Kitting__c,  Product__c,  Supplier__c,  Inventory_Product__c,Inventory_Product__r.Product_Cost__c FROM Kitting_Products__r) FROM Kitting__c WHERE Id in: kittingIds];
        Map<String,List<Kitting_Product__c>> kittingPMap = new Map<String,List<Kitting_Product__c>>();
        
        for(Kitting__c k: kittingData){
            kittingPMap.put(k.Id,k.Kitting_Products__r);
        }
        
        
        List<Invoice__c> inlist = [SELECT Id FROM Invoice__c WHERE Packing_List__c=: packingListId];
        
        if(inlist.size() == 0){
            Invoice__c d = new Invoice__c();
            d.Packing_List__c = pdata.Id;
            d.Invoice_Date_Time__c = DateTime.now();
            d.Transporter_Name__c = pdata.Transporter_Name__c;
            d.Delivery_Mode__c = pdata.Delivery_Mode__c;
            d.Declaration__c = pdata.Declaration__c;
            
            insert d;
            
            
            List<Invoice_Line_Item__c> NDlineItems = new List<Invoice_Line_Item__c>();
            for(Packing_List_Line_Item__c pl: pdata.Packing_List_Line_Items__r){
                Invoice_Line_Item__c dl = new Invoice_Line_Item__c();
                dl.Invoice__c = d.Id;
                dl.Kitting__c = pl.Kitting__c;
                
                Double amount = 0;
                if(kittingPMap.get(pl.Kitting__c) != null){
                    List<Kitting_Product__c> kittingpList = kittingPMap.get(pl.Kitting__c) ;
                    for(Kitting_Product__c kl: kittingpList){
                        amount = amount + kl.Inventory_Product__r.Product_Cost__c;
                    }
                    dl.Kitting_Amount__c = amount;
                }
                
                NDlineItems.add(dl);
                
            }
            
            insert NDlineItems;
        } 
        
        
        PageReference pageRef = new PageReference('/' + packingListId);
        pageRef.setRedirect(true);
        return pageRef;
    }
}