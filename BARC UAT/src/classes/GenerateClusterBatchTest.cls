@isTest
public class GenerateClusterBatchTest {

	public static testMethod void test() {
	    
	    Sampling__c scm = new Sampling__c(
	      Name = '101',                         // Sampling No
          Cluster__c = '55003978',                // Cluster
          STB_Type__c = 'GOSPELL',                // STB Type
          City__c = 'Ernakulam',                  // City
          StbID__c = '4D0038A30',                 // STBID
          State__c = 'RAJASTHAN',                 // State
          Status__c = 'Active',                   // Status
          Town_Village__c = '5 Psd B.O',          // Town Village
          Smart_Card__c = '127867565432',         // Smart Card
          Pincode__c = '110095'                  // Pincode
          );                    
        //   Local_Operator__c = 'a1L0p0000000gl8',  // Local Operator
        //   Operator__c = 'a0r0p0000000oZv');
	    insert scm;
	    
	    Test.startTest();
	    
	    GenerateClusterBatch gcb = new GenerateClusterBatch('101');
	    
	    Database.executeBatch(gcb);
	    
	    Test.stopTest();
	    

	}

}