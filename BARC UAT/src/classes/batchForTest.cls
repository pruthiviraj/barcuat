global class batchForTest implements Database.Batchable<sObject> {
    
    global final String Query;
    
    
    global batchForTest(String q){
        Query=q;
    
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        return Database.getQueryLocator(query);
    
    }

    global void execute(Database.BatchableContext BC,List<sObject> s){
        Integer i = 0;
        for(i = 0; i< 10000;){
            i = i + 1;
        }
        
        if(i == 9999){
            System.debug('print this when pending');
        }
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}