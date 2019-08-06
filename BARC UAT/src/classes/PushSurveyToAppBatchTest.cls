@isTest
public class PushSurveyToAppBatchTest {
    
    private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            if (req.getEndpoint().endsWith('insertOperator')) {
                
                
                Boolean b = True;
                String reCode = '200';
                String fullJson = 'Here is my String JSON';
                String sta = 'OK';
                String Js = '{"data":[{"operator_id":21}],"flag":1,"Msg":"Operator Created Successfully"}';
                
                HttpResponse res = new HttpResponse();
                res.setBody(Js);
                res.setStatusCode(200);
                res.setStatus(sta);
                return res;
                
                
            } else  if (req.getEndpoint().endsWith('insertLCO')) {
                
                String sta = 'OK';
                String js = '{"data":[{"lco_id":65}],"flag":1,"Msg":"Operator Created Successfully"}';
                HTTPResponse res = new HTTPResponse();
                res.setBody(js);
                res.setHeader('Content-Type', 'application/json');
                res.setStatusCode(200);
                res.setStatus(sta);
                return res;
            }
             else  if (req.getEndpoint().endsWith('insertTech')) {
                
                String sta = 'OK';
                String js = '{"data":[{"lco_id":65}],"flag":1,"Msg":"Operator Created Successfully"}';
                HTTPResponse res = new HTTPResponse();
                res.setBody(js);
                res.setHeader('Content-Type', 'application/json');
                res.setStatusCode(200);
                res.setStatus(sta);
                return res;
            }
             else  if (req.getEndpoint().endsWith('insertClusters')) {
                
                String sta = 'OK';
                String js = '{"data":[{"lco_id":65}],"flag":1,"Msg":"Operator Created Successfully"}';
                HTTPResponse res = new HTTPResponse();
                res.setBody(js);
                res.setHeader('Content-Type', 'application/json');
                res.setStatusCode(200);
                res.setStatus(sta);
                return res;
            }
            
            return null;
        }
    }

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
        
        Case cs = new Case(Cluster__c=clus.id, Sampling__c=scm.id, Status='New', Origin='Email');
        insert cs;
        
        Survey__c sur = new Survey__c(
          Head_end__c = '111111',                                                  // Head end
        //   District_Name__c = 'Bangalore',                                          // District Name
          Smart_Card_ID__c = '109876543212',                                       // Smart Card ID
          STB_ID_GOS_STB_ID__c = '109876543212',                                   // STB ID/ GOS STB ID
          Case__c = cs.id,                                             // Case
          Household_Status__c = 'Agreed Scheduled',                                // Household Status
          House_Member_Works_in_of_the_Companies__c = 'None Of The Above',         // House Member Works in of the Companies
          Durables_in_working_condition__c = 'Air Conditioner; Car / Jeep / Van',  // Durables in working condition
          Working_TV_sets__c = '1',                                                // Working TV sets
          Is_household_part_of_TMP__c = false,                                     // Is household part of TMP
          Would_you_like_to_be_part_of_TMP__c = true,                              // Would you like to be part of TMP
          Television_Measurement_Panel_for_3_mnt__c = false                       // Television Measurement Panel for 3 mnt
        );
        insert sur;
        
        Test.startTest();
	    
	    PushSurveyToAppBatch psa = new PushSurveyToAppBatch('101');
	    
	    Test.setMock(HttpCalloutMock.class, new Mock());
	    Database.executeBatch(psa);
	    Test.stopTest();

	}
	
	static void xyz() {
        Test.setMock(HttpCalloutMock.class, new Mock());
        
    }


}