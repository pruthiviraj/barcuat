@RestResource(urlMapping = '/sfdc_aims/*')
global class AIMS {

    @HttpGet
    global static void getDCDetails() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        String dc_No = req.params.get('dc_No');

        System.debug('dc_No ======' + dc_No);
        try {
            List < Delivery_Challan__c > dlData = [SELECT Id, Name, Total_Amount__c, Docket_No__c, (SELECT Id, Kitting__r.Name FROM Delivery_Challan_Line_Items__r), Delivery_Challan_Date__c, Delivery_Mode__c, Transporter_Name__c, Place_of_Supply__c, Number_of_Boxes__c, Shipment_Weight_Kg__c, Installer_Name__c, Declarations__c,
                Packing_List__r.Ship_To_Local_Operator__r.CAFID__c, Packing_List__r.Ship_To_Operator__r.CAFID__c, Packing_List__r.Bill_To_Operator__r.CAFID__c, Packing_List__r.Bill_To_Name__c, Packing_List__r.Bill_To_Phone__c, Packing_List__r.Bill_To_Email__c, Packing_List__r.Bill_To_State__c, Packing_List__r.Bill_To_City__c, Packing_List__r.Bill_To_Pincode__c,
                Packing_List__r.Ship_To_Name__c, Packing_List__r.Ship_To_Phone__c, Packing_List__r.Ship_To_Email__c, Packing_List__r.Ship_To_State__c, Packing_List__r.Ship_To_Country__c, Packing_List__r.Ship_To_City__c, Packing_List__r.Ship_To_Pincode__c FROM Delivery_Challan__c WHERE Name =: dc_No
            ];

            if (dlData.size() != 0) {
                res.responseBody = Blob.valueOf(JSON.serialize(dlData[0]));
                res.statusCode = 200;
            } else {
                res.responseBody = Blob.valueOf('No Delivery Challan found by this DC No');
                res.statusCode = 200;
            }
        } catch (Exception e) {

            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;

        }
    }

    @HttpPost
    global static resp savegrnDetails() {

        RestResponse res;
        try {
            resp rsp = new resp();
            String jsonString = RestContext.request.requestBody.toString();
            System.debug('jsonString' + jsonString);

            DelvJSON devData = new DelvJSON();
            devData = parse(jsonString);


            Delivery_Challan__c dch = new Delivery_Challan__c();
            dch.id = devData.deId;
            dch.GRN_No__c = devData.grnum;
            dch.GRN_Date__c = Date.valueOf(devData.grndate);

            update dch;
            
            
            rsp.status = true;
            rsp.msg = 'Successfully Updated Survey Data.';
            rsp.statusCode = '200';
            return rsp;

        } catch (Exception e) {
            resp rsp = new resp();
            rsp.status = false;
            rsp.msg = String.valueOf(e.getMessage());
            rsp.statusCode = '400';
            System.debug(e);
            return rsp;
        }


    }

    global class DelvJSON {

        public String deId;
        public String grnum;
        public String grndate;
    }

    global class resp {
        Boolean status;
        String msg;
        String statusCode;

    }

    global static DelvJSON parse(String json) {
        return (DelvJSON) System.JSON.deserialize(json, DelvJSON.class);
    }
    
}