public with sharing class callCAFOperatorAPI {
    
    @Future(callout=true)
    public static void apiCallout(String opId){
        Operator__c oprData = [ SELECT  Id,  Name,  Phone__c,  Email__c,  City__c,  State__c,  Country__c,  Pin_Code__c,  CAFID__c FROM Operator__c WHERE Id=:opId LIMIT 1];
        
        OperatorJSON opj = new OperatorJSON();
        opj.operator_name = oprData.Name;
        opj.operator_phone_no = oprData.Phone__c;
        opj.operator_email = oprData.Email__c;
        opj.operaotr_country = oprData.Country__c;
        opj.operator_state = oprData.State__c;
        opj.operator_pin_code = oprData.Pin_Code__c;
        opj.data_flag = 'N';
        
        Map<String,Object> dataMap = new Map<String,Object>();
        dataMap.put('operatorForm_data',opj);
        String jsonData = JSON.serialize(dataMap);
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        req.setMethod('POST');
        req.setTimeout(120000);
        req.setHeader('Content-type', 'application/json');
        String url = Label.Integration_URL + '/insertOperator';
        req.setEndpoint(url);
        
        System.debug('jsonData ====='+jsonData);
        
        req.setBody(jsonData);
        
        try{
            HttpResponse res = h.send(req);
            System.debug('res=======>' +res.getBody());
            
            String jsdata = res.getBody();
            SuccessJSON resdata = new SuccessJSON();
            callCAFOperatorAPI c = new callCAFOperatorAPI();
            resdata = c.parse(jsdata);
            
            if(resdata.flag == '1'){
                List<opData> oprRData = resdata.data;
                oprData.CAFID__c = oprRData[0].operator_id;
                update oprData;
                
            }
            
            
        }catch(System.calloutException e){
            System.debug('Exception=======>' +e);
        }

        
    }

    public class OperatorJSON {
        public String operator_name {
            get;
            set;
        }
        public String operator_phone_no {
            get;
            set;
        }
        public String operator_email {
            get;
            set;
        }
        public String operaotr_country {
            get;
            set;
        }
        public String operator_state {
            get;
            set;
        }
        public String operator_pin_code {
            get;
            set;
        }
        public String data_flag {
            get;
            set;
        }
    }
    
    
    public class SuccessJSON {
        public List<opData> data{get;set;}
        public String flag{get;set;}
        public String Msg{get;set;}
    }
    
    public class opData{
        public String operator_id{get;set;}
    }
    
    public SuccessJSON parse(String json) {
        return (SuccessJSON) System.JSON.deserialize(json, SuccessJSON.class);
    }
}