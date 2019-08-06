@isTest
public class GenerateClusterCaseBatchTest {

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
	    insert scm;
	    
	    Cluster__c clus = new Cluster__c(
          Name = '55003973',                                // Cluster No
          Sampling__c = scm.id,                             // Sampling
          City__c = 'Aligarh',                              // City
          Pincode__c = '110012',                            // Pincode
          State__c = 'ANDHRA PRADESH',                      // State
          Town_Village__c = '(Gandhinagar) Sector 22 S.O'   // Town Village
        );
        insert clus;
        
        Cluster_Item__c cli = new Cluster_Item__c(cluster__c=clus.id);
        insert cli;
	     
	     Test.startTest();
	    
	    GenerateClusterCaseBatch gcc = new GenerateClusterCaseBatch('101');
	    
	    Database.executeBatch(gcc);
	    
	    Test.stopTest();

	}

}