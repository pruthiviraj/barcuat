@isTest
public class BatchSurveyUpdateTest {
    
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
             else  if (req.getEndpoint().contains('getSurveyExistingData')) {
                
                String sta = 'OK';
                 
                List<Survey__c> surveyList = [SELECT Id FROM Survey__c];
                system.debug('surveyList ===='+surveyList);
                String js = '{"data":[{"surveyId":373,"sfSurveyId":"' + surveyList[0].Id +'","clusterId":"A1","smartcardId":"500001","headend":"Oisch","state":"Karnataka","district":"Bangalore","townVillage":"Karnataka","pinCode":"560001","recruitmentDate":"2019-05-20","installationDate":"2019-05-20","technician_no":"AIR-2001903003","callcenter_no":"AIR-CC-00002","householdStatus":"Agreed Scheduled","statusDesc":"Installed agree","q2":"None Of The Above","contact_date_time":[{"contact_date":"2019-05-20","contact_time":"00:12"},{"contact_date":"2019-05-20","contact_time":"12:31"}],"q3":[{"item":"Air Conditioner"},{"item":"Car / Jeep / Van"}],"q4a":"1","q4b":"","q4c":"false","q4d":"false","q4e":"true","tvSet":[{"dongleNo":"12365470","stbMake":"Cisco","coustomerNo":"8745213698522222","stbId":"5821478965235478","q4f":"Hall/Drawing Room","q5":"Color TV","q6":"CRT","q7":"14 inches or less","recordingFeature":"false","usbHubInstalled":"false"}],"q8a":"Kutchi","q8b":[{"Lang":"Assamese"},{"Lang":"Awadhi"},{"Lang":"Bengali"}],"q8c":"Kutchi","q9":"Rented","q10":"2","q11":"2","memberSet":[{"dob":"Feb-1975","age":"44","gender":"Male","accessToInternet":"Yes","q11a":"Cannot Read/Write","q11b":"Not Working","q11c":"Not Working"},{"dob":"Feb-1977","age":"42","gender":"Male","accessToInternet":"Yes","q11a":"Cannot Read/Write","q11b":"Not Working","q11c":"Not Working"}],"q12":"2","q13":"1","q14":"1"}],"flag":1,"Msg":"success"}';
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
	    
	    Survey__c sur = new Survey__c();
	    sur.Current_House_Ownership_status__c='Ownership';
	    insert sur;
	    
	    Survey_TV__c stv = new Survey_TV__c();
	    stv.Survey__c=sur.id;
	    insert stv;
	    
	    Survey_Member__c svm= new Survey_Member__c();
	    svm.Survey__c=sur.id;
	    svm.Age__c='24';
	    insert svm;
	    
        Test.startTest();
	    Test.setMock(HttpCalloutMock.class, new Mock());
	    BatchSurveyUpdate bsu = new BatchSurveyUpdate(0, 10);
	    
	    
	    Database.executeBatch(bsu);
	    
	    Test.stopTest();

	}
	
	
    
    
	
	@IsTest
    static void xyz() {
        Test.setMock(HttpCalloutMock.class, new Mock());
        
    }

}