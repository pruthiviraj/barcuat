@RestResource(urlMapping = '/sfdc_rre/*')
global class SaveReturnReciept {

    @HttpPost
    global static resp saveReturnReceiptData() {

        RestResponse res;
        try {
            resp rsp = new resp();
            String jsonString = RestContext.request.requestBody.toString();
            System.debug('jsonString' + jsonString);

            List<recJSON> reclist = new List<recJSON>();
            reclist=parse(jsonString);
            
            Set<String> kName = new Set<String>();   
            Set<String> InvPSet = new Set<String>();   
            List<Kitting__c> kiList = new List<Kitting__c>();
            
            List<Return_Receipt_Details__c> rdList = new List<Return_Receipt_Details__c>();
            
            for(recJSON rj:recList){
                
                Return_Receipt__c ret = new Return_Receipt__c();
                ret.Purchase_Return_No__c=rj.PURCHASE_RETURN_NO;
                ret.GRN_No__c=rj.GRN_NUMBER;
                ret.GRN_Date__c=rj.GRN_DATE;
                ret.Challan_No__c=rj.CHALLAN_NUMBER;
                ret.Challan_Date__c=rj.CHALLAN_DATE;
                ret.Warehouse_Site__c=rj.WAREHOUSE_SITE;
                ret.L_R_No__c=rj.LR_NUMBER;
                ret.Reason__c=rj.REASONE;
                ret.Build_To_Name__c=rj.BUOLD_TO_NAME;
                ret.Build_To_Email__c=rj.BUOLD_TO_EMAIL;
                ret.Build_To_Phone__c=rj.BUOLD_TO_PHONE;
                ret.Build_To_Address__c=rj.BUOLD_TO_ADDRS;
                ret.Ship_To_Name__c=rj.SHIP_TO_NAME;
                ret.Ship_To_Email__c=rj.SHIP_TO_EMAIL;
                ret.Ship_To_Phone__c=rj.SHIP_TO_PHONE;
                ret.Ship_To_Address__c=rj.SHIP_TO_ADDRS;
                
                insert ret;
                
                System.debug(ret);
                kName = new Set<String>();   
                for(Details de:rj.details){
                    Return_Receipt_Details__c rde = new Return_Receipt_Details__c();
                    rde.Return_Receipt__c=ret.id;
                    rde.Sr_No__c=de.S_NO;
                    rde.Purchase_Return_No__c=de.PURCHASE_RETURN_NO;
                    rde.GRN_No__c=de.GRN_NUMBER;
                    rde.Item_Code__c=de.ITEM_CODE;
                    rde.Item_UOM__c=de.ITEM_UOM;
                    rde.Remarks__c=de.REMARKS;
                    
                    kName.add(rde.Item_Code__c);
                    
                    rdList.add(rde);
                }
            }
            
            insert rdlist;
            
            kiList = new List<Kitting__c>();
            for(Kitting__c ki:[select Id,Name, (SELECT id,Name, Kitting__c, Kitting__r.Status__c, Kitting__r.Name, Inventory_Product__c from Kitting_Products__r) FROM Kitting__c WHERE Name in: kName ]){
                
                // Kitting__c ki = new Kitting__c();
                // ki.id=kp.Kitting__c;
                ki.Status__c='Faulty';
                kiList.add(ki);
                for(Kitting_Product__c kp: ki.Kitting_Products__r){
                    InvPSet.add(kp.Inventory_Product__c);
                }
            }
            
            update kiList;
            List<Inventory_Product__c> invpList = new List<Inventory_Product__c>();
            for(Inventory_Product__c ip:[select id from Inventory_Product__c where id IN:InvPSet]){
                
                Inventory_Product__c prod = new Inventory_Product__c();
                prod.id=ip.id;
                prod.Status__c='Faulty';
                invpList.add(prod);
            }
            
            update invpList;
            
            System.debug(rdlist);
            
            rsp.status = true;
            rsp.msg = 'Successfully Updated Return Reciept Data.';
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
    
    global class resp {
        Boolean status;
        String msg;
        String statusCode;

    }
    
    global class recJSON {

    	public String RR_ID;
    	public String PURCHASE_RETURN_NO;
    	public String GRN_NUMBER;
    	public String GRN_DATE;
    	public String CHALLAN_NUMBER;
    	public String CHALLAN_DATE;
    	public String WAREHOUSE_SITE;
    	public String LR_NUMBER;
    	public String REASONE;
    	public String BUOLD_TO_NAME;
    	public String BUOLD_TO_EMAIL;
    	public String BUOLD_TO_PHONE;
    	public String BUOLD_TO_ADDRS;
    	public String SHIP_TO_NAME;
    	public String SHIP_TO_EMAIL;
    	public String SHIP_TO_PHONE;
    	public String SHIP_TO_ADDRS;
    	public List<Details> details;
  
    }  
    
    public class Details {
		public String S_NO;
		public String PURCHASE_RETURN_NO;
		public String GRN_NUMBER;
		public String ITEM_CODE;
		public String ITEM_UOM;
		public String REMARKS;
	}
    	
	global static List<recJSON> parse(String json) {
		return (List<recJSON>) System.JSON.deserialize(json, List<recJSON>.class);
	}

}