public with sharing class SaveLocalOperatorInCAFClass {
    @Future(callout=true)
    public static void apiCallout(String recId){
        
        Local_Operator__c recdata = [SELECT Id, Name, Operator__r.CAFID__c, Operator__r.Name, LCO_Partner_Phone__c, LCO_Partner_Email__c, LCO_Partner_Country__c, LCO_Partner_State__c, LCO_Partner_District__c, LCO_Partner_Pincode__c, LCO_Partner_Code__c FROM Local_Operator__c WHERE Id=:recId];
        LocalOperatorJSON opj = new LocalOperatorJSON();
        opj.operator_id = recdata.Operator__r.CAFID__c;
        opj.lco_name = recdata.Name;
        opj.lco_code = recdata.LCO_Partner_Code__c;
        opj.lco_operator_name = recdata.Operator__r.Name;
        opj.lco_phone_no = recdata.LCO_Partner_Phone__c;
        opj.lco_email = recdata.LCO_Partner_Email__c;
        opj.lco_country = recdata.LCO_Partner_Country__c;
        opj.lco_state = recdata.LCO_Partner_State__c;
        opj.lco_distric = recdata.LCO_Partner_District__c;
        opj.lco_pin_code = recdata.LCO_Partner_Pincode__c;
        opj.data_flag = 'N';
        
        Map<String,Object> dataMap = new Map<String,Object>();
        dataMap.put('lco_Form_data',opj);
        String jsonData = JSON.serialize(dataMap);
        //String jsonData = JSON.serialize(opj);
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        
        req.setMethod('POST');
        req.setTimeout(120000);
        req.setHeader('Content-type', 'application/json');
        String url = Label.Integration_URL + '/insertLCO';
        req.setEndpoint(url);
        
        System.debug('jsonData ====='+jsonData);
        
        req.setBody(jsonData);
        
        try{
            HttpResponse res = h.send(req);
            System.debug('res=======>' +res.getBody());
            
            String jsdata = res.getBody();
            SuccessJSON resdata = new SuccessJSON();
            SaveLocalOperatorInCAFClass c = new SaveLocalOperatorInCAFClass();
            resdata = c.parse(jsdata);
            
            if(resdata.flag == '1'){
                List<opData> oprRData = resdata.data;
                recdata.CAFID__c = oprRData[0].lco_id;
                update recdata;
                
            }
            
        }catch(System.calloutException e){
            System.debug('Exception=======>' +e);
        }
        
        
    }
    
    public class LocalOperatorJSON {
        public String operator_id {
            get;
            set;
        }
        public String lco_name {
            get;
            set;
        }
        public String lco_code {
            get;
            set;
        }
        public String lco_operator_name {
            get;
            set;
        }
        public String lco_phone_no {
            get;
            set;
        }
        public String lco_email {
            get;
            set;
        }
        public String lco_country {
            get;
            set;
        }
        public String lco_state {
            get;
            set;
        }
        public String lco_distric {
            get;
            set;
        }
        public String lco_pin_code {
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
        public String lco_id{get;set;}
    }
    
    public SuccessJSON parse(String json) {
        return (SuccessJSON) System.JSON.deserialize(json, SuccessJSON.class);
    }
    
    
    
}