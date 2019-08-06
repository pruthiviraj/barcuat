@isTest
public class SaveSurveyDataTest {
    
    public static testMethod void test() {
        
        Survey__c sur= new Survey__c();
        insert sur;
        
        String json='[{"surveyId":407,"sfSurveyId":"'+sur.id+'","clusterId":"A9","smartcardId":"500044","headend":"111111","state":"Karnataka","district":"Bangalore","townVillage":"Thane","pinCode":"560001","recruitmentDate":"2019-05-20","installationDate":"2019-05-28","technician_no":"","callcenter_no":"AIR-CC-00002","householdStatus":"Agreed Scheduled","statusDesc":"Installed agree","q2":"None Of The Above","contact_date_time":[{"contact_date":"2019-06-04","contact_time":"11:50"},{"contact_date":"2019-06-04","contact_time":"11:50"},{"contact_date":"2019-06-04","contact_time":"11:50"},{"contact_date":"2019-06-04","contact_time":"11:50"},{"contact_date":"2019-06-04","contact_time":"11:50"},{"contact_date":"2019-06-04","contact_time":"11:50"},{"contact_date":"2019-06-04","contact_time":"11:50"},{"contact_date":"2019-06-04","contact_time":"11:50"},{"contact_date":"2019-05-28","contact_time":"13:25"}],"q3":[{"item":"Color Tv"},{"item":"Celling Fan "}],"q4a":"1","q4b":"","q4c":"false","q4d":"false","q4e":"true","tvSet":[{"dongleNo":"12365470","stbMake":"HuaweiDS366","coustomerNo":"12547879655","stbId":"5666666666666666","q4f":"Bedroom","q5":"Black & White","q6":"LCD","q7":"14 inches or less","recordingFeature":"false","usbHubInstalled":"false"}],"q8b":[{"Lang":"Assamese"},{"Lang":"Awadhi"}],"memberSet":[{"dob":"Mar-1986","age":"33","gender":"Male","accessToInternet":"Yes","q11a":"Cannot Read/Write","q11b":"Not Working","q11c":"Not Working"}]}]';
        
        RestRequest request = new RestRequest();
        request.requestUri = System.Url.getSalesforceBaseURL().toExternalForm()+'/services/apexrest/sfdc/saveSurvey';
        request.httpMethod = 'POST';
		request.requestBody = Blob.valueof(json);
        RestContext.request = request;

		Test.startTest();
        //SaveSurveyData.parse(json); 
        SaveSurveyData.saveSurvey();
        Test.stopTest();
	}

}