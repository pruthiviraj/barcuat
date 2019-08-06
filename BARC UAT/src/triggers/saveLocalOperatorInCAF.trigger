trigger saveLocalOperatorInCAF on Local_Operator__c (after insert) {

        For(Local_Operator__c oAccount: Trigger.New) {
         if (!test.isRunningTest()) {
            if (oAccount.CAFID__c == '' || oAccount.CAFID__c == Null) {
                SaveLocalOperatorInCAFClass.apiCallout(oAccount.Id);
            }
         }
    }
        

}