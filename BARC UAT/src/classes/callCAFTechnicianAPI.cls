public with sharing class callCAFTechnicianAPI {
    
    @Future(callout=true)
    public static void apiCallout(String opId){
        Operator_Technician__c techData = [   SELECT  Id,  Name,  Technician_Name__c,  Technician_Phone__c,Username__c,Password__c,Role__c,  Technician_Email__c, Technician_Pincode__c, Technician_City__c,Technician_District__c,  Technician_State__c,  Technician_Country__c,  Technician_Town_Name__c,  CAFID__c,  Technician_Billing_Address__c,  Operator__c,Operator__r.CAFID__c,  Local_Operator__c,Local_Operator__r.CAFID__c FROM Operator_Technician__c WHERE Id=:opId LIMIT 1];
        
        TechJSON te = new TechJSON();
        te.operator_id = techData.Operator__r.CAFID__c;
        te.lco_id = techData.Local_Operator__r.CAFID__c;
        te.tech_name = techData.Technician_Name__c;
        te.tech_phone_no = techData.Technician_Phone__c;
        te.tech_email = techData.Technician_Email__c;
        te.tech_country = techData.Technician_Country__c;
        te.tech_state = techData.Technician_State__c;
        te.tech_distric = techData.Technician_District__c;
        te.tech_city = techData.Technician_City__c;
        
        te.tech_pin_code = techData.Technician_Pincode__c;
        te.tech_code = techData.Name;
        te.user_name = techData.Username__c;
        te.user_password = techData.Password__c;
        te.roll_assignment = techData.Role__c;
        te.data_flag = 'N';
        
         Map<String,Object> dataMap = new Map<String,Object>();
        dataMap.put('tech_Form_data',te);
        String jsonData = JSON.serialize(dataMap);
        //String jsonData = JSON.serialize(te);
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        req.setMethod('POST');
        req.setTimeout(120000);
        req.setHeader('Content-type', 'application/json');
        
        String url = Label.Integration_URL + '/insertTech';
        req.setEndpoint(url);
        
        System.debug('jsonData ====='+jsonData);
        
       
        
        req.setBody(jsonData);
        
        try{
            HttpResponse res = h.send(req);
            System.debug('res=======>' +res.getBody());
            
            SuccessJSON resdata = new SuccessJSON();
            callCAFTechnicianAPI c = new callCAFTechnicianAPI();
            resdata = c.parse(res.getBody());
            
            if(resdata.flag == '1'){
                List<opData> oprRData = resdata.data;
                techData.CAFID__c = oprRData[0].operator_id;
                update techData;
                
            }
            
        }catch(System.calloutException e){
            System.debug('Exception=======>' +e);
        }

        
    }

    public class TechJSON {
        public String operator_id {
            get;
            set;
        }
        public String lco_id {
            get;
            set;
        }
        public String tech_name {
            get;
            set;
        }
        public String tech_phone_no {
            get;
            set;
        }
        public String tech_email {
            get;
            set;
        }
        public String tech_country {
            get;
            set;
        }
        public String tech_state {
            get;
            set;
        }
        public String tech_distric {
            get;
            set;
        }
        public String tech_city {
            get;
            set;
        }
        public String tech_pin_code {
            get;
            set;
        }
        public String tech_code {
            get;
            set;
        }
        public String user_name {
            get;
            set;
        }
        public String user_password {
            get;
            set;
        }
        public String roll_assignment {
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