trigger UpdateKitting on HouseHold_TV_Detail__c(after Insert,after update){
    Set<String> kittingNames = new Set<String>();
    Set<Id> htIDs = new Set<Id>();
    Map<String,HouseHold_TV_Detail__c> houseHoldTVMap =new Map<String,HouseHold_TV_Detail__c>(); 
    for(HouseHold_TV_Detail__c ht: Trigger.new){
        if(ht.Kitting__c == null){
            htIds.add(ht.Id);
        }
    }
    
    if(Trigger.isInsert || Trigger.isUpdate){
        List<HouseHold_TV_Detail__c> htList = [SELECT Id,Dongle_Number__c,Kitting__c FROM HouseHold_TV_Detail__c WHERE Id in: htIds];
        for(HouseHold_TV_Detail__c ht: htList){
            if(ht.Kitting__c == null){
                kittingNames.add(ht.Dongle_Number__c);
                houseHoldTVMap.put(ht.Dongle_Number__c,ht);
            }
        }
        
        List<Kitting__c> kittingList = [SELECT Id,Name FROM Kitting__c WHERE Name in: kittingNames];
        
        
        if(kittingList.size() != 0){
            List<HouseHold_TV_Detail__c> NHtList = new List<HouseHold_TV_Detail__c>();
            for(Kitting__c k: kittingList){
                if(houseHoldTVMap.get(k.Name) != Null){
                    HouseHold_TV_Detail__c ht = houseHoldTVMap.get(k.Name);
                    ht.Kitting__c = k.Id;
                    NHtList.add(ht);
                }
            }
            update NHtList;
        }
    }
    
    
}