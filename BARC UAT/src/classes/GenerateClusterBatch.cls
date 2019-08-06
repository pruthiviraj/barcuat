global class GenerateClusterBatch implements Database.Batchable<sObject> {
    global String samplingNo{get;set;}
    global GenerateClusterBatch(String smNo){
        samplingNo = smNo;
    }
     
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('samplingNo ===='+samplingNo);
        String query = ' SELECT  Id,  Name,  StbID__c,District__c,  Smart_Card__c, VC_No__c, STB_Type__c,  Status__c,Operator_Name__c,LCO_Name__c,  Cluster__c,  State__c,  City__c,  Town_Village__c,  Pincode__c,  LCO_Code__c FROM Sampling__c WHERE Name=: samplingNo' ;                
        return Database.getQueryLocator(query);     
    }
     
    global void execute(Database.BatchableContext BC, List<Sampling__c> sampList){        
        System.debug('sampList ===='+sampList);
        Set<String> clusterSet = new Set<String>();
        for(Sampling__c samp : sampList){          
            clusterSet.add(samp.Name);   
        } 
        
        List<Cluster__c> exCluList = [SELECT Id,Name FROM Cluster__c WHERE Name in: clusterSet];
        Map<String,String> exClMap = new Map<String,String>();
        for(Cluster__c clu: exCluList){
            exClMap.put(clu.Name,clu.Id);
        }
        
        List<Address_Master__c> addressMaster = [ SELECT  Id,  Name FROM Address_Master__c];
        Map<String,String> adMap = new Map<String,String>();
        for(Address_Master__c am: addressMaster){
            adMap.put(am.Name,am.Id);
        }
        
        List<Local_Operator__c> localOperatorList = [SELECT Id, Name,LCO_Partner_Pincode__c FROM Local_Operator__c];
        Map < String, String > lopMap = new Map < String, String > ();
        Map<String,String> lcoMap = new Map<String,String>();
        for (Local_Operator__c o: localOperatorList) {
            String key = o.Name+o.LCO_Partner_Pincode__c;
            System.debug('keyM ===='+key);
            lopMap.put(key, o.Id);
            lcoMap.put(o.Name,o.Id);
        }
        
        List<Operator__c> opTechList = [SELECT Id,Name FROM Operator__c];
        Map<String,String> techMap = new Map<String,String>();
        for (Operator__c o: opTechList) {
            techMap.put(o.Name, o.Id);
        }
        
        List<Cluster_Item__c> NclusterItemList = new List<Cluster_Item__c>();
        for(Sampling__c samp : sampList){ 
            
            Cluster__c cl = new Cluster__c();
             System.debug('samp ===='+samp);
            if(exClMap.get(samp.Cluster__c) == null){
                cl.Name = samp.Cluster__c;
                cl.Town_Village__c = samp.Town_Village__c;
                cl.City__c = samp.City__c;
                String key = samp.LCO_Name__c+samp.Pincode__c;
                System.debug('key ===='+key);
                if(lopMap.get(key) != null){
                    cl.Local_Operator__c = lopMap.get(key);
                }else if(lcoMap.get(samp.LCO_Name__c) != null){
                    cl.Local_Operator__c = lcoMap.get(samp.LCO_Name__c);
                }
                
                if(techMap.get(samp.Operator_Name__c) != null){
                    cl.Operator__c = techMap.get(samp.Operator_Name__c);
                }
                
                cl.State__c = samp.State__c;
                cl.Pincode__c = samp.Pincode__c;
                cl.Sampling__c = samp.Id;
                cl.District__c = samp.District__c;
                if(adMap.get(samp.Pincode__c) != null){
                    cl.Address_Master__c = adMap.get(samp.Pincode__c);
                }
                insert cl;
                
                exClMap.put(cl.Name, cl.Id);
            }else{
                cl.Id = exClMap.get(samp.Cluster__c);
            }
            
            
            Cluster_Item__c cli = new Cluster_Item__c();
            cli.Smart_Card_ID__c = samp.Smart_Card__c;
            cli.STB_ID__c = samp.StbID__c;
            cli.STB_Type__c = samp.STB_Type__c;
            cli.VC_No__c = samp.VC_No__c;
            cli.Cluster__c = cl.Id;
            NclusterItemList.add(cli);
        }
        System.debug('NclusterItemList ======'+NclusterItemList);
        insert NclusterItemList;
        
        
    }
     
    global void finish(Database.BatchableContext BC) {
         
    }
}