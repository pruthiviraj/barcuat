global class Testing_Kitting {
    public Id invId {
        get;
        set;
    }
    public Inventory__c invt {
        get;
        set;
    }
    public String invLList {
        get;
        set;
    }
    public String productList {
        get;
        set;
    }
    
    public String kittingTypeList{get;set;}
    
    public Testing_Kitting() {
        invId = ApexPages.currentPage().getParameters().get('id');
        invt = [select id, Name, Product__c, Product__r.Name from Inventory__c where id =: invId];

        List < Inventory_Product__c > invLData = new List < Inventory_Product__c > ();
        invLData = [SELECT Id, Name, Supplier__c, Status__c, Warehouse__c, Inventory__c, Inventory__r.Name, Remark__c FROM Inventory_Product__c where Inventory__c =: invId and Is_Added_To_Kitting__c = false and(Status__c =: ''
            or Status__c =: Null)];
        invLList = JSON.serialize(invLData);

        List < Inventory__c > productData = [select id, Name, Product__c, Product__r.Name from Inventory__c where Product__c !=: invt.Product__c];
        productList = JSON.serialize(productData);
        
        Schema.DescribeFieldResult F = Kitting__c.Kitting_Type__c.getDescribe();
        Schema.sObjectField T = F.getSObjectField();
        List<PicklistEntry> entries = T.getDescribe().getPicklistValues();
        kittingTypeList = JSON.serialize(entries);
    }
    
    @RemoteAction
    global static List<Inventory_Product__c> getInvProducts(String pId) {
        List<Inventory_Product__c> invpList  = [SELECT Id, Name, Supplier__c, Status__c, Warehouse__c, Inventory__c, Inventory__r.Name, Remark__c FROM Inventory_Product__c where Inventory__r.Product__c =: pId and Is_Added_To_Kitting__c = false and(Status__c =: ''
            or Status__c =: Null)];
        return invpList;
    }
    
    
    @RemoteAction
    global static Boolean saveInvProductsAsFaulty(String invJSON) {
        System.debug('invJSON ====='+invJSON);
        Inventory_Product__c invp = new Inventory_Product__c();
        invp = parseInvJSON(invJSON);
        System.debug('invp ====='+invp);
        try{
            update invp;
            return true;
        }catch (System.CalloutException e) {
           System.debug(e.getMessage());
            //System.debug(response.toString());
            return false;
        }
    }
    
    global static Inventory_Product__c parseInvJSON(String json) {
        return (Inventory_Product__c) System.JSON.deserialize(json, Inventory_Product__c.class);
    }
    
    @RemoteAction
    global static String createKitting(String invJSON,String kittingType) {
        List<Inventory_Product__c> invpList = new List<Inventory_Product__c>();
        
        
        try{
            Kitting__c k = new Kitting__c();
            k.Kitting_Type__c = kittingType;
            insert k;

            List < Kitting_Product__c > kittingProList = new List < Kitting_Product__c > ();
            invpList = parseInvListJSON(invJSON);
            
            for (Inventory_Product__c i: invpList) {
                Kitting_Product__c kp = new Kitting_Product__c();
                kp.Inventory_Product__c = i.Id;
                kp.Kitting__c = k.Id;

                kittingProList.add(kp);

                i.Is_Added_To_Kitting__c = true;
                i.Status__c = 'Ok';
            }

            insert kittingProList;
            
            update invpList;
            
            Kitting__c kittingData= [SELECT Id,Name FROM Kitting__c WHERE Id=: k.Id];
            
            String srNo = kittingData.Name;
            return srNo;
            
        }catch (Exception e) {
            System.debug(e.getMessage());
            
            String ex = 'Error';
            //System.debug(response.toString());
            return ex;
        }
    }
    
    
    global static List<Inventory_Product__c> parseInvListJSON(String json) {
        return (List<Inventory_Product__c>) System.JSON.deserialize(json, List<Inventory_Product__c>.class);
    }
    
    
    

}