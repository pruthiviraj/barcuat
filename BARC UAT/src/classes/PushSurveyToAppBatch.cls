global class PushSurveyToAppBatch implements Database.Batchable<sObject>, Database.AllowsCallouts,Database.Stateful {

global String samplingNo{get;set;}
    
    global PushSurveyToAppBatch(String smNo){
        samplingNo = smNo;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = ' SELECT  Id,  CaseNumber,  ContactId,  AccountId,Cluster__r.District__c,  ParentId,  Type,  Status,  Reason,  Origin,  Subject,  Priority,  Description,  Appointment_Start_Date__c, Appointment_End_Date__c,  Early_Start__c,  Late_Start__c,  Due_Date_Time__c,  Start_Date_Time__c,  End_Date_Time__c,  Casualty__c,  Interview_Start_Date__c,  URN_without_Visit__c,  Interview_End_Date__c,  Cluster__c, Cluster__r.Name,  Cluster__r.Pincode__c, Cluster__r.City__c , Cluster__r.State__c , Cluster__r.Town_Village__c , Operator__c,  Operator__r.CAFID__c, Operator__r.Name, Local_Operator__c , Local_Operator__r.LCO_Partner_Code__c,Local_Operator__r.Name,Sampling__c, (SELECT  Id,  Name,  Survey_Date__c,  Technician_Number__c,  Head_end__c,   Sub_District_Name__c,  Pincode__c,  Smart_Card_ID__c,  STB_ID_GOS_STB_ID__c,  Case__c,  State__c,  City__c,District__c,VC_No__c,  Town_Village__c FROM Survey__r) FROM Case where Sampling__r.Name=: samplingNo';
        return Database.getQueryLocator(query);  
    }
    
    global void execute(Database.BatchableContext BC, List<Case> caList){
        
        List<caseLister> NCaseList = new List<caseLister>();
        for(Case c:caList){
            for(Survey__c sv:c.Survey__r){
               caseLister cn = new caseLister();
               cn.clusterNo = c.Cluster__r.Name;
               cn.lcoId = c.Local_Operator__r.LCO_Partner_Code__c;
               cn.lcoName = c.Local_Operator__r.Name;
               cn.pincode = c.Cluster__r.Pincode__c;
               cn.state = c.Cluster__r.State__c;
               cn.district = c.Cluster__r.District__c;
               cn.city = c.Cluster__r.City__c;
               cn.oprId = c.Operator__r.CAFID__c;
               cn.oprName = c.Operator__r.Name;
               cn.stbNo = sv.STB_ID_GOS_STB_ID__c;
               cn.vcNo = sv.VC_No__c;
               cn.smartCardId = sv.Smart_Card_ID__c;
               cn.sfSurveyId = sv.Id;
               NCaseList.add(cn);
               
                
            }
            
        }
        
       //System.debug('NCaseList========>'+NCaseList);
       
       String clusJSON =JSON.serialize(NCaseList);
       
         
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        req.setMethod('POST');
        req.setTimeout(120000);
        req.setHeader('Content-type', 'application/json');
        // req.setEndpoint('http://66.70.152.185:4300/api/insertClusters'); //sandbox url
         String url = Label.Integration_URL + '/insertClusters';
        req.setEndpoint(url); //sandbox url
        
        
        req.setBody(clusJSON);
        
        try{
            HttpResponse res = h.send(req);
            System.debug('res=======>' +res.getBody());
            
        }catch(System.calloutException e){
            System.debug('Exception=======>' +e);
        }
        
        
    }
    
    global void finish(Database.BatchableContext BC) {
         
    }
    
    public class caseLister{
       public String sfSurveyId;
       public String clusterNo;
       public String lcoId;
       public String lcoName;
       public String pincode;
       public String state;
       public String district;
       public String city;
       public String oprId;
       public String oprName;
       public String stbNo;
       public String vcNo;
       public String smartCardId;

    }
}