trigger saveOperatorInCAF on Operator__c (after Insert) {
    
    for(Operator__c o: Trigger.new){
        system.debug('CAFID===>' +o.CAFID__c);
        
        if(!test.isRunningTest()){
            if(o.CAFID__c == '' ){
                callCAFOperatorAPI.apiCallout(o.Id);
            }
        }else{
            system.debug('CAFID===>' +o.CAFID__c);
        }
    }
    
}