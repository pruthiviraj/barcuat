@isTest
public class Testing_KittingTest {

	public static testMethod void test() {
	    
	    Product2 prod = new Product2(
          Name = 'GSM SIM',              // Product Name
          QuantityUnitOfMeasure = 'Each',  // Product UOM
          Product_Cost__c = 90.00,         // Product Cost
          IsActive = true                 // Active
        );
        insert prod;
	    
	    Id rt=[select id from RecordType where sObjectType='Inventory__c' and Name='Unit Inventory'].id;
	    
	    Inventory__c inv = new Inventory__c(
          RecordTypeId = rt,    // Record Type
          Product__c = prod.id  // Product
        );
        insert inv;
	    
	    List<Inventory_Product__c> invpList = new List<Inventory_Product__c>();
	    Inventory_Product__c invp = new Inventory_Product__c(
          Name = 'testpord',   // Inventory Product Sr No.
          Inventory__c = inv.id,  // Inventory
          Is_Added_To_Kitting__c = false,    // Is Added To Kitting
          Status__c = 'Ok',              // Status
          Remark__c = 'test'                // Remark
        );
        insert invp;
        invpList.add(invp);
        
        Inventory_Product__c invp1 = new Inventory_Product__c(
          Name = 'testpord1',   // Inventory Product Sr No.
          Inventory__c = inv.id,  // Inventory
          Is_Added_To_Kitting__c = false,    // Is Added To Kitting
          Status__c = 'Ok',              // Status
          Remark__c = 'test'                // Remark
        );
        insert invp1;
        invpList.add(invp1);
        
        
	    
	    ApexPages.currentPage().getParameters().put('id', inv.id);
	    Testing_Kitting tek = new Testing_Kitting();
	    Testing_Kitting.getInvProducts(prod.id);
	    String js=JSON.serialize(invpList);
	    //Testing_Kitting.parseInvJSON(js);
	    Testing_Kitting.createKitting(js,'Airtel Kitting');
	    

	}
	
	public static testMethod void test1() {
	    
	    Product2 prod = new Product2(
          Name = 'GSM SIM',              // Product Name
          QuantityUnitOfMeasure = 'Each',  // Product UOM
          Product_Cost__c = 90.00,         // Product Cost
          IsActive = true                 // Active
        );
        insert prod;
	    
	    Id rt=[select id from RecordType where sObjectType='Inventory__c' and Name='Unit Inventory'].id;
	    
	    Inventory__c inv = new Inventory__c(
          RecordTypeId = rt,    // Record Type
          Product__c = prod.id  // Product
        );
        insert inv;
	    
	    Inventory_Product__c invp = new Inventory_Product__c(
          Name = 'testpord',   // Inventory Product Sr No.
          Inventory__c = inv.id,  // Inventory
          Is_Added_To_Kitting__c = false,    // Is Added To Kitting
          Status__c = 'Faulty',              // Status
          Remark__c = 'test'                // Remark
        );
        insert invp;
	    
	    ApexPages.currentPage().getParameters().put('id', inv.id);
	    Testing_Kitting tek = new Testing_Kitting();
	    Testing_Kitting.getInvProducts(prod.id);
	    String js=JSON.serialize(invp);
	    //Testing_Kitting.parseInvJSON(js);
	    Testing_Kitting.saveInvProductsAsFaulty(js);
	    

	}

}