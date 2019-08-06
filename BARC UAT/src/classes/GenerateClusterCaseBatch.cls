global class GenerateClusterCaseBatch implements Database.Batchable < sObject > {
    global String samplingNo {
        get;
        set;
    }
    global GenerateClusterCaseBatch(String smNo) {
        samplingNo = smNo;
        System.debug('In Constructor I am getting sampling number-->'+samplingNo);
    }
    
    
    
    

    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('samplingNo before query-->' + samplingNo);
        
       	String query = 'SELECT  Id, Name, Operator__c, District__c,Technician_No__c,  City__c,  State__c,  Pincode__c,  Town_Village__c,  LCO_Code__c, Local_Operator__c, Sampling__c,( SELECT  Id,  Name,  Cluster__c,  Smart_Card_ID__c,  STB_ID__c,  STB_Type__c,VC_No__c FROM Cluster_Items__r) FROM Cluster__c WHERE Sampling__r.Name =:samplingNo';
      
        
        System.debug('query-->'+query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List < Cluster__c > clusterList) {
        System.debug('clusterList in Execute method--->' + clusterList);

        Set < String > clusterId = new Set < String > ();
        Set < String > clusterItemId = new Set < String > ();

        for (Cluster__c c: clusterList) {
            for (Cluster_Item__c ci: c.Cluster_Items__r) {
                clusterId.add(c.id);
                System.debug('clusterId===' + clusterId);

                clusterItemId.add(ci.Id);
                System.debug('clusterItemId===' + clusterItemId);

            }
        }

        List < Case > caseList = new List < Case > ();

        for (Cluster__c c: clusterList) {

            Case ca = new Case();
            ca.Cluster__c = c.Id;
            ca.Operator__c = c.Operator__c;
            ca.Local_Operator__c = c.Local_Operator__c;
            ca.Sampling__c = c.Sampling__c;
            caseList.add(ca);
        }

        Insert caseList;



        List < Case > cas = [Select Id, Cluster__c, Operator__c FROM Case WHERE Cluster__c IN: clusterId];

        Map < String, String > CaseClusterMap = new Map < String, String > ();
        Set < String > CaseId = new Set < String > ();

        for (Case c: cas) {

            CaseClusterMap.put(c.Cluster__c, c.id);
            System.debug('CaseClusterMap====' + CaseClusterMap);

            CaseId.add(c.id);
            System.debug('CaseId===' + CaseId);
        }

        List < Survey__c > SurveyList = new List < Survey__c > ();
        for (Cluster__c c: clusterList) {
            for(Cluster_Item__c ci: c.Cluster_Items__r) {
            if (CaseClusterMap.get(c.Id) != null) {
                Survey__c s = new Survey__c();
                s.Case__c = CaseClusterMap.get(c.Id);
                s.Smart_Card_ID__c = ci.Smart_Card_ID__c;
                s.STB_ID_GOS_STB_ID__c= ci.Smart_Card_ID__c;
               // s.District__c = c.District__c;
                s.VC_No__c = ci.VC_No__c;
                SurveyList.add(s);

            }
          }
        }
        
        Insert SurveyList;
        System.debug('SurveyList===='+SurveyList);
        


    }

    global void finish(Database.BatchableContext BC) {

    }
}