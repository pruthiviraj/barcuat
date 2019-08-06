@IsTest
private class CallCAFTechnicianAPITest {
    
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
            
            return null;
        }
    }
    
    
    static testMethod void abc() {
        
        Operator__c op = new Operator__c();
        op.CAFID__c = 'test0123';
        op.City__c = 'Vashi';
        op.Country__c = 'India';
        op.Email__c = 'ravi@testgmail.com';
        
        insert op;
        
        Local_Operator__c lc = new Local_Operator__c();
        lc.Operator__c = op.Id;
        lc.LCO_Partner_City__c = 'Vashi';
        lc.LCO_Partner_Code__c = 'abctst';
        lc.LCO_Partner_Country__c = 'India';
        
        insert lc;
        
        Operator_Technician__c optc = new Operator_Technician__c();
        optc.CAFID__c = '123fdf';
        optc.Technician_City__c = 'vashi';
        
        insert optc;
        
        
        Test.startTest();
        System.debug('-----Second test Case----------');
        
        callCAFTechnicianAPI contro = new callCAFTechnicianAPI();
        callCAFTechnicianAPI.apiCallout(optc.Id);
        Test.setMock(HttpCalloutMock.class, new Mock());
        
        
        Test.stopTest();
        
    }
    
    @IsTest
    static void xyz() {
        Test.setMock(HttpCalloutMock.class, new Mock());
        
    }
}