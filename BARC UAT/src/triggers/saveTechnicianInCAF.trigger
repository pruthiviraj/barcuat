trigger saveTechnicianInCAF on Operator_Technician__c (after Insert) {
    
    for(Operator_Technician__c o: Trigger.new){
        
         if(!test.isRunningTest()){    
            if(o.CAFID__c == '' || o.CAFID__c == Null){
                system.debug(' in call API CAFID===>' +o.CAFID__c);
                callCAFTechnicianAPI.apiCallout(o.Id); 
            }else{
                system.debug('CAFID===>' +o.CAFID__c);
            }
         }
    }
    
}