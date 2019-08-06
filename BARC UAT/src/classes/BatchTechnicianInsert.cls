global class BatchTechnicianInsert implements Database.Batchable < TechJSON > , Database.AllowsCallouts, Database.Stateful {

    global Integer offset = 0;
    global Integer Max = 0;
    public List < TechJSON > techResponseData = new List < TechJSON > ();

    public BatchTechnicianInsert(Integer offset_cnt, Integer Max_cnt) {
        offset = offset_cnt;
        max = Max_cnt;
       
    }

    public Iterable < TechJSON > start(Database.BatchableContext BC) {

        System.debug('max===>' + max);
        System.debug('offset===>' + offset);
        HttpResponse resPonse = getCall(offset, max);
        TechResponseJSON techR = parseTecResJSON(resPonse.getBody());

        System.debug('resPonse.getBody() ======' + resPonse.getBody());
        System.debug('TechResponseJSON ======' + techR);

        List < TechJSON > techParseList = techR.data;

        return techParseList;
    }

    public void execute(Database.BatchableContext BC, List < TechJSON > techList) {
        if (techList.size() != 0) {
            List<Operator__c> operatorList = [SELECT Id,CAFID__c FROM Operator__c];
            Map < String, String > opMap = new Map < String, String > ();
            for (Operator__c o: operatorList) {
                opMap.put(o.CAFID__c, o.Id);
            }



            List<Local_Operator__c> localOperatorList = [SELECT Id, CAFID__c FROM Local_Operator__c];
            Map < String, String > lopMap = new Map < String, String > ();
            for (Local_Operator__c o: localOperatorList) {
                lopMap.put(o.CAFID__c, o.Id);
            }
            
            List<Operator_Technician__c> opTechList = [SELECT Id,CAFID__c FROM Operator_Technician__c];
            Map<String,String> techMap = new Map<String,String>();
            for (Operator_Technician__c o: opTechList) {
                techMap.put(o.CAFID__c, o.Id);
            }
            
            List<Operator_Technician__c> NTechList = new List<Operator_Technician__c>();
            for(TechJSON t: techList){
                Operator_Technician__c nt = new Operator_Technician__c();
                nt.Name = t.technician_code;
                nt.Technician_Name__c = t.technician_name;
                nt.Technician_Billing_Address__c = t.technician_billing_address;
                nt.Technician_Phone__c = t.technician_phone;
                nt.Technician_Email__c = t.technician_email;
                nt.Technician_City__c = t.technician_city;
                nt.Technician_State__c = t.technician_state;
                nt.Technician_Country__c = t.technician_country;
                nt.Technician_Pincode__c = t.technician_pin_code;
                nt.Technician_Town_Name__c = t.technician_town_name;
                nt.Technician_District__c = t.technician_District;
                nt.Username__c = t.User_Name;
                nt.Password__c = t.Password;
                nt.Role__c = t.Roll;
                nt.CAFID__c = t.technician_id;
                if(opMap.get(t.operator_id) != null){
                    nt.Operator__c = opMap.get(t.operator_id);
                }
                
                if(lopMap.get(t.LCO_id) != null){
                    nt.Local_Operator__c = lopMap.get(t.LCO_id);
                }
                
                if(techMap.get(t.technician_id) != null){
                    nt.Id = techMap.get(t.technician_id);
                }
                
                NTechList.add(nt);
            }
            
            System.debug('NTechList ===='+NTechList);
            upsert NTechList;
        }
    }

    public void finish(Database.BatchableContext BC) {

    }

    public static HttpResponse getCall(Integer startOffSet, Integer max) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse response;
        req.setMethod('GET');
        req.setTimeout(120000);
        req.setHeader('Content-type', 'application/json');

        String url = Label.Integration_URL + '/getAllTechnician?offset=' + startOffSet + '&max=' + max;
        req.setEndpoint(url); //sandbox url

        try {
            response = http.send(req);

            if (response.getStatusCode() == 200) {
                return response;
            } else {

                System.debug('Error http :');
            }
        } catch (System.CalloutException e) {
            System.debug('gamac error: ' + e);
            System.debug(response.toString());
        }
        return response;
    }

    public class TechResponseJSON {
        public Boolean status {
            get;
            set;
        }
        public String message {
            get;
            set;
        }
        public List < TechJSON > data {
            get;
            set;
        }
    }

    public class TechJSON {
        public String technician_id {
            get;
            set;
        }
        public String operator_id {
            get;
            set;
        }
        public String technician_code {
            get;
            set;
        }
        public String technician_name {
            get;
            set;
        }
        public String technician_billing_address {
            get;
            set;
        }
        public String technician_phone {
            get;
            set;
        }
        public String technician_email {
            get;
            set;
        }
        public String technician_city {
            get;
            set;
        }
        public String technician_state {
            get;
            set;
        }
        public String technician_country {
            get;
            set;
        }
        public String technician_pin_code {
            get;
            set;
        }
        public String technician_town_name {
            get;
            set;
        }
        public String technician_District{get;set;}
        public String User_Name{get;set;}
        public String Password{get;set;}
        public String Roll{get;set;}
        public String LCO_id {
            get;
            set;
        }
    }

    public TechResponseJSON parseTecResJSON(String json) {
        return (TechResponseJSON) System.JSON.deserialize(json, TechResponseJSON.class);
    }


}