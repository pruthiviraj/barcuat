trigger CheckDupliProdOnInv on Inventory__c (before insert) {

   
    for(Inventory__c invt:Trigger.new){
        
        List<Inventory__c> inv=[select id, Product__c from Inventory__c where Product__c=:invt.Product__c];
        if(inv.size() != 0 ){
            invt.addError('Inventory Already Exists for this Product.');
        }
    }
}