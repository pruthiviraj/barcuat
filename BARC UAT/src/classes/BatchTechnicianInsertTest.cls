@isTest
public class BatchTechnicianInsertTest {
    
    private class Mock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            String js='{"status":true,"message":"Technician Data","data":[{"technician_id":714,"operator_id":1,"technician_code":"AIR-MUM-VID-008","technician_name":"Afzal Shaikh","technician_phone":"","technician_email":"","technician_city":"Mumbai","technician_state":"Maharashtra","technician_country":"India","technician_pin_code":"400124"}]}';
            
            HTTPResponse res = new HTTPResponse();
            res.setBody(js);
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setStatus('ok');
            return res;
            
        }
    }
    
	public static testMethod void test() {
	    
	    test.startTest();
	    Test.setMock(HttpCalloutMock.class, new Mock());
	    
        BatchTechnicianInsert bti = new BatchTechnicianInsert(0, 10);
        Database.executeBatch(bti);
        test.stopTest();
	}
	
	@IsTest
    static void moc() {
        Test.setMock(HttpCalloutMock.class, new Mock());
        
    }

}