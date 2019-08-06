global class CAFSyncController {
    public List < Operator__c > operatorList {
        get;
        set;
    }
    public List < Local_Operator__c > localOperatorList {
        get;
        set;
    }
    public CAFSyncController() {


    }


    /*Operators API Integration*/
    public void syncOperators() {
        operatorList = [SELECT Id, Name, Phone__c, Email__c, City__c, State__c, Country__c, Pin_Code__c, CAFID__c FROM Operator__c];
        Map < String, String > opMap = new Map < String, String > ();
        for (Operator__c o: operatorList) {
            opMap.put(o.CAFID__c, o.Id);
        }


        Http h = new Http();
        HttpRequest req = new HttpRequest();

        req.setMethod('GET');
        req.setTimeout(120000);
        req.setHeader('Content-type', 'application/json');
        // req.setEndpoint('http://66.70.152.185:4300/api/getAlloperator'); //sandbox url
        String url = Label.Integration_URL + '/getAlloperator'; //sandbox url
        req.setEndpoint(url); //sandbox url

        HttpResponse res = h.send(req);


        String json = res.getBody();
        System.debug('operator get json =======' + json);

        ResponseOpJSON responseData = parse(json);
        System.debug('operator get responseData =======' + responseData);


        List < Operator__c > NoperatorList = new List < Operator__c > ();

        if (responseData.status == true) {
            for (OperatorData opd: responseData.data) {
                System.debug('opd ======' + opd);
                Operator__c o = new Operator__c();
                o.Name = opd.operator_name;
                o.Email__c = opd.operator_email;
                o.Phone__c = opd.operator_phone;
                o.City__c = opd.operator_city;
                o.Country__c = opd.operator_country;
                o.State__c = opd.operator_state;
                o.Pin_Code__c = opd.operator_pin_code;
                o.CAFID__c = opd.operator_id;

                if (opMap.get(o.CAFID__c) != null) {
                    o.Id = opMap.get(o.CAFID__c);
                }

                NoperatorList.add(o);
            }
            upsert NoperatorList;
        }


    }

    public class ResponseOpJSON {
        public Boolean status;
        public String message;
        public List < OperatorData > data;
    }

    public class OperatorData {
        public String operator_id;
        public String operator_name;
        public String operator_phone;
        public String operator_email;
        public String operator_city;
        public String operator_state;
        public String operator_country;
        public String operator_pin_code;
    }

    public ResponseOpJSON parse(String json) {
        return (ResponseOpJSON) System.JSON.deserialize(json, ResponseOpJSON.class);
    }


    /*Local Operators / Partner API Integration*/
    public void syncLocalOperators() {
        operatorList = [SELECT Id, Name, Phone__c, Email__c, City__c, State__c, Country__c, Pin_Code__c, CAFID__c FROM Operator__c];
        Map < String, String > opMap = new Map < String, String > ();
        for (Operator__c o: operatorList) {
            opMap.put(o.CAFID__c, o.Id);
        }



        localOperatorList = [SELECT Id, Name, LCO_Partner_Code__c, Operator__c, LCO_Partner_Email__c, LCO_Partner_Phone__c, LCO_Partner_Country__c, LCO_Partner_State__c, LCO_Partner_District__c, LCO_Partner_Pincode__c, CAFID__c FROM Local_Operator__c];
        Map < String, String > lopMap = new Map < String, String > ();
        for (Local_Operator__c o: localOperatorList) {
            lopMap.put(o.CAFID__c, o.Id);
        }


        Http h = new Http();
        HttpRequest req = new HttpRequest();

        req.setMethod('GET');
        req.setTimeout(120000);
        req.setHeader('Content-type', 'application/json');
        // req.setEndpoint('http://66.70.152.185:4300/api/getAllLocalOperator'); //sandbox url
        String url = Label.Integration_URL + '/getAllLocalOperator'; //sandbox url
        req.setEndpoint(url); //sandbox url

        HttpResponse res = h.send(req);


        String json = res.getBody();
        System.debug('local operator get json =======' + json);

        ResponseLopJSON responseData = parseLop(json);
        System.debug('local operator get responseData =======' + responseData);


        List < Local_Operator__c > NLoperatorList = new List < Local_Operator__c > ();

        if (responseData.status == true) {
            for (LocalOperatorData opd: responseData.data) {
                Local_Operator__c lop = new Local_Operator__c();
                lop.Name = opd.LCO_name;
                
                if (opMap.get(opd.operator_id) != null) {
                    lop.Operator__c = opMap.get(opd.operator_id);
                }
                lop.LCO_Partner_Code__c = opd.LCO_code;
                lop.LCO_Partner_Phone__c = opd.LCO_phone;
                lop.LCO_Partner_Email__c = opd.LCO_email;
                lop.LCO_Partner_City__c = opd.LCO_city;
                lop.LCO_Partner_District__c = opd.LCO_District;
                lop.LCO_Partner_State__c = opd.LCO_state;
                lop.LCO_Partner_Country__c = opd.LCO_country;
                lop.LCO_Partner_Pincode__c = opd.LCO_pin_code;
                lop.CAFID__c = opd.LCO_id;

                if (lopMap.get(lop.CAFID__c) != null) {
                    lop.Id = lopMap.get(lop.CAFID__c);
                }

                NLoperatorList.add(lop);

            }
            upsert NLoperatorList;
        }


    }

    /*All Technicians Sync / Technicians API Integration*/
    public void syncAllTechnicians() {

        Http h = new Http();
        HttpRequest req = new HttpRequest();

        req.setMethod('GET');
        req.setTimeout(120000);
        req.setHeader('Content-type', 'application/json');
        // req.setEndpoint('http://66.70.152.185:4300/api/getTechnicianCount'); //sandbox url
        String url = Label.Integration_URL + '/getTechnicianCount'; //sandbox url
        req.setEndpoint(url); //sandbox url

        HttpResponse res = h.send(req);


        String json = res.getBody();
        System.debug('local operator get json =======' + json);

        ResponseTechJSON responsTech = parseTecAcc(json);
        System.debug('local operator get responsTech =======' + responsTech);

        Integer Cont = 0;
        Integer Max = 100;
        Integer Ofset = 0;
        
        if(!test.isRunningTest()){
            if (responsTech.status == true) {
                cont = responsTech.count;
                for (Integer i = 0; i < cont;) {
                    ofset = i;
    
                    BatchTechnicianInsert techBatch = new BatchTechnicianInsert(i, max);
                    Id batchId = Database.executebatch(techBatch, 200);
                    System.debug('i' + i);
    
                    i = i + max;
                }
    
            }
        }

    }


    public class ResponseTechJSON {
        public Boolean status;
        public String message;
        public Integer count;
    }


    public class ResponseLopJSON {
        public Boolean status;
        public String message;
        public List < LocalOperatorData > data;
    }

    public class OpTechnicianData {
        public String id;
        public String Name;
        public String TechnicianName;
        public String Phone;
        public String Email;
        public String City;
        public String State;
        public String Country;
        public String PinCode;
        public String TownVillageName;

    }

    public class LocalOperatorData {
        public String LCO_id;
        public String operator_id;
        public String LCO_code;
        public String LCO_name;
        public String LCO_phone;
        public String LCO_email;
        public String LCO_city;
        public String LCO_state;
        public String LCO_country;
        public String LCO_pin_code;
        public String LCO_District;
    }

    public ResponseLopJSON parseLop(String json) {
        return (ResponseLopJSON) System.JSON.deserialize(json, ResponseLopJSON.class);
    }

    public ResponseTechJSON parseTecAcc(String json) {
        return (ResponseTechJSON) System.JSON.deserialize(json, ResponseTechJSON.class);
    }
    
    
    
    /*All Existing Survey Data API Integration*/
    public void syncAllExistingSurveys() {

        Http h = new Http();
        HttpRequest req = new HttpRequest();

        req.setMethod('GET');
        req.setTimeout(120000);
        req.setHeader('Content-type', 'application/json');
        // req.setEndpoint('http://66.70.152.185:4300/api/getExistingSurveyCount'); //sandbox url
        String url = Label.Integration_URL + '/getExistingSurveyCount';
        req.setEndpoint(url); //sandbox url

        HttpResponse res = h.send(req);


        String json = res.getBody();
        System.debug('existing survey get json =======' + json);

        ResponseTechJSON responsTech = parseTecAcc(json);
        System.debug('existing survey =======' + responsTech);

        Integer Cont = 0;
        Integer Max = 20;
        Integer Ofset = 0;

        if (responsTech.status == true) {
            cont = responsTech.count;
            for (Integer i = 0; i < cont;) {
                ofset = i;

                BatchSurveyUpdate techBatch = new BatchSurveyUpdate(i, max);
	            AsyncApexFramework.submitBatch(techBatch,1,99,true);
                
                System.debug('i' + i);


                i = i + max;
            }
            AsyncApexFramework.flush();


        }

    }
}