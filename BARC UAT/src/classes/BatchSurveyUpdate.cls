public class BatchSurveyUpdate implements Database.Batchable < SurveyJSON > , Database.AllowsCallouts, Database.Stateful {

    public Integer offset = 0;
    public Integer Max = 0;
    public String error_msg = '';
    public String error_msgTv = '';
    public String error_msgMem = '';
    public String error_msgCon = '';
    public Integer num_record = 0;


    public BatchSurveyUpdate(Integer offset_cnt, Integer Max_cnt) {
        offset = offset_cnt;
        max = Max_cnt;
    }

    public Iterable < SurveyJSON > start(Database.BatchableContext BC) {

        System.debug('max===>' + max);
        System.debug('offset===>' + offset);
        HttpResponse resPonse = getCall(offset, max);

        System.debug('PRint Survey JSON =====' + resPonse.getBody());

        SurveyResponseJSON techR = parseSurveyResJSON(resPonse.getBody());

        System.debug('TechResponseJSON ======' + techR);


        List < SurveyJSON > surveyList = techR.data;
        num_record = surveyList.Size();

        return surveyList;
    }


    public void execute(Database.BatchableContext BC, List < SurveyJSON > surveyData) {
        List < Operator_Technician__c > techList = [SELECT Id, Name FROM Operator_Technician__c];
        Map < String, String > techMap = new Map < String, String > ();
        for (Operator_Technician__c ot: techList) {
            techMap.put(ot.Name, ot.Id);
        }
        if (surveyData.size() != 0) {
            List < Survey__c > surList = new List < Survey__c > ();
            List < Survey_TV__c > surTVList = new List < Survey_TV__c > ();
            List < Survey_Member__c > surMemList = new List < Survey_Member__c > ();
            List < Survey_Contact__c > surContactList = new List < Survey_Contact__c > ();

            for (SurveyJSON sj: surveyData) {

                System.debug('sj =====' + sj);
                Survey__c sn = new Survey__c();
                sn.id = sj.sfSurveyId;
                if (sj.sfSurveyId != null && sj.sfSurveyId != '') {

                    sn.Head_end__c = sj.headend;
                    // sn.District_Name__c = sj.district;
                    sn.Household_Status__c = sj.householdStatus;
                    sn.Household_StatusN__c = sj.statusDesc;
                    sn.House_Member_Works_in_of_the_Companies__c = sj.q2;
                    sn.Working_TV_sets__c = sj.q4a;
                    sn.Different_cable_or_DTH_connections__c = sj.q4b;
                    sn.Is_household_part_of_TMP__c = Boolean.valueOf(sj.q4c);
                    sn.Television_Measurement_Panel_for_3_mnt__c = Boolean.valueOf(sj.q4d);
                    sn.Would_you_like_to_be_part_of_TMP__c = Boolean.valueOf(sj.q4e);




                    if (sj.callcenter_no != null && techMap.get(sj.callcenter_no) != null) {
                        sn.Callcenter_Technician__c = techMap.get(sj.callcenter_no);
                    }

                    if (sj.technician_no != null && techMap.get(sj.technician_no) != null) {
                        sn.Technician_Number__c = techMap.get(sj.technician_no);
                    }

                    if (sj.statusDesc == 'Installed agree') {
                        System.debug('after install sj =====' + sj);
                        String q3String = '';
                        Boolean Start = true;
                        for (Q3List str: sj.q3) {
                            if (Start) {
                                q3String = str.item;
                                Start = false;
                            } else {
                                q3String = q3String + ';' + str.item;
                            }
                        }

                        sn.Durables_in_working_condition__c = q3String;

                        sn.Your_Native_Language__c = sj.q8a;
                        String q8bString = '';
                        Boolean Start8 = true;
                        for (Q8bList str: sj.q8b) {
                            if (Start8) {
                                q8bString = str.Lang;
                                Start8 = false;
                            } else {
                                q8bString = q8bString + ';' + str.Lang;
                            }
                        }
                        sn.Language_Spoken_amongst_Family__c = q8bString;

                        sn.Most_Common_lang_amongst_family_member__c = sj.q8c;
                        sn.Current_House_Ownership_status__c = sj.q9;
                        sn.Total_Room_in_House_Except_Kitc_WC__c = sj.q10;
                        sn.Total_members_living_currently__c = sj.q11;
                        sn.Highest_household_contributer__c = sj.q12;
                        sn.Decision_Maker_for_buying_groceries__c = sj.q13;
                        sn.Who_is_Respondant__c = sj.q14;


                        List < Survey_Contact__c > esurContactList = [select id from Survey_Contact__c where Survey__c =: sn.id];
                        delete esurContactList;



                        for (ContactSet co: sj.contact_date_time) {
                            Survey_Contact__c sc = new Survey_Contact__c();
                            sc.Contact_Date__c = Date.valueOf(co.contact_date);
                            sc.Contact_Time__c = co.contact_time;
                            sc.Survey__c = sn.Id;
                            surContactList.add(sc);
                        }

                        List < Survey_TV__c > esurTVList = [select id from Survey_TV__c where Survey__c =: sn.id];
                        delete esurTVList;



                        for (TvSet t: sj.tvset) {
                            Survey_TV__c stv = new Survey_TV__c();
                            stv.Survey__c = sn.id;
                            stv.Dongle_Number__c = t.dongleNo;
                            stv.STB_Make__c = t.stbMake;
                            stv.Customer_VC_No__c = t.coustomerNo;
                            stv.STB_ID__c = t.stbId;
                            stv.TV_sets_located_at_your_home__c = t.q4f;
                            stv.Type_of_TV__c = t.q5;
                            stv.Television_Screen_at_your_home__c = t.q6;
                            stv.TV_screen_size__c = t.q7;
                            stv.Do_you_use_recording_feature__c = Boolean.valueOf(t.recordingFeature);
                            stv.USB_HUB_Installed__c = Boolean.valueOf(t.usbHubInstalled);
                            surTVList.add(stv);
                        }

                        List < Survey_Member__c > esurMemList = [select id from Survey_Member__c where Survey__c =: sn.id];
                        delete esurMemList;



                        for (MemberSet mbs: sj.memberSet) {
                            Survey_Member__c svm = new Survey_Member__c();
                            svm.DOB__c = mbs.dob;
                            svm.Age__c = mbs.age;
                            svm.Gender__c = mbs.gender;
                            svm.Access_to_internet__c = mbs.accessToInternet;
                            svm.Survey__c = sn.Id;

                            svm.Education_Qualification__c = mbs.q11a;
                            svm.Work_status_of_member__c = mbs.q11b;
                            svm.Current_Occupation__c = mbs.q11c;

                            surMemList.add(svm);
                        }

                        sn.Recruitment_Date__c = Date.valueOf(sj.recruitmentDate);
                        sn.Installation_Date__c = Date.valueOf(sj.installationDate);

                    }

                    surList.add(sn);
                    // update sn;


                }

            }

            System.debug('surMemList ========' + surMemList);
            System.debug('surTVList ========' + surTVList);
            // System.debug('surMemList ========'+surMemList);

            Schema.DescribeFieldResult dfc = Schema.sObjectType.Survey_Contact__c.fields.Survey__c;
            Schema.sObjectField sc = dfc.getSObjectField();
            Database.SaveResult[] scList = Database.insert(surContactList, false);

            // Iterate through each returned result

            for (Integer i = 0; i < scList.size(); i++) {
                if (!scList[i].isSuccess()) {
                    for (Database.Error err: scList[i].getErrors()) {
                        error_msgCon = error_msgCon + 'ID :' + surContactList[i].Survey__c + 'The following error has occurred.' + err.getStatusCode() + ': ' + err.getMessage() + 'Fields that affected this error: ' + err.getFields();
                    }

                }
            }


            Schema.DescribeFieldResult dfm = Schema.sObjectType.Survey_Member__c.fields.Survey__c;
            Schema.sObjectField sm = dfm.getSObjectField();
            Database.SaveResult[] smList = Database.insert(surMemList, false);
            
            for (Integer i = 0; i < smList.size(); i++) {
                if (!smList[i].isSuccess()) {
                    for (Database.Error err: smList[i].getErrors()) {
                        error_msgMem = error_msgMem + 'ID :' + surMemList[i].Survey__c + 'The following error has occurred.' + err.getStatusCode() + ': ' + err.getMessage() + 'Fields that affected this error: ' + err.getFields();
                    }

                }
            }

            Schema.DescribeFieldResult dft = Schema.sObjectType.Survey_TV__c.fields.Survey__c;
            Schema.sObjectField st = dft.getSObjectField();
            Database.SaveResult[] stList = Database.insert(surTVList, false);
            
            
            for (Integer i = 0; i < stList.size(); i++) {
                if (!stList[i].isSuccess()) {
                    for (Database.Error err: stList[i].getErrors()) {
                        error_msgTv = error_msgTv + 'ID :' + surMemList[i].Survey__c + 'The following error has occurred.' + err.getStatusCode() + ': ' + err.getMessage() + 'Fields that affected this error: ' + err.getFields();
                    }

                }
            }
            
            //insert surContactList;
            //insert surMemList;
            // insert surTVList;

            Schema.DescribeFieldResult dfs = Schema.sObjectType.Survey__c.fields.Smart_Card_ID__c;
            Schema.sObjectField su = dfs.getSObjectField();
            Database.SaveResult[] suList = Database.update(surList, false);
            
            
            for (Integer i = 0; i < suList.size(); i++) {
                if (!suList[i].isSuccess()) {
                    for (Database.Error err: suList[i].getErrors()) {
                        error_msg = error_msg + 'ID :' + surList[i].Id + 'The following error has occurred.' + err.getStatusCode() + ': ' + err.getMessage() + 'Fields that affected this error: ' + err.getFields();
                    }

                }
            }

            // update surList;
        }
    }

    public void finish(Database.BatchableContext BC) {

        System.debug('offset=' + offset);
        System.debug('Max=' + max);

        Api_Job_Log__c apj = new Api_Job_Log__c();

        apj.Start_Offset__c = string.valueof(offset);
        apj.End_OffSet__c = string.valueof(offset + max);

        apj.End_Time__c = System.now();
        apj.Status__c = 'Processing Completed';
        apj.Job_Id__c = BC.getJobId();
        apj.Num_of_Records__c = num_record;
        apj.Error_Details_Survey__c = error_msg;
        apj.Error_Detail_Member__c = error_msgMem;
        apj.Error_Detail_TV__c = error_msgTv;
        apj.Error_Detail_Contact__c = error_msgCon;
        // apj.Api_Record_Count__c = gmac_record;
        // if (!errors.isEmpty()) {
        //     for (Exception ex: errors) {
        //         System.debug('Processing Completed' + ex);
        //         apj.Error_Details__c = gcl.Error_Details__c + '****' + ex;
        //     }
        // }
        insert apj;

        System.debug('Processing Completed');

    }

    public static HttpResponse getCall(Integer startOffSet, Integer max) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse response;
        req.setMethod('GET');
        req.setTimeout(120000);
        req.setHeader('Content-type', 'application/json');

        // String url = 'http://66.70.152.185:4300/api/getSurveyExistingData?offset=' + startOffSet + '&max=' + max;
        String url = Label.Integration_URL + '/getSurveyExistingData?offset=' + startOffSet + '&max=' + max;
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


    public class SurveyResponseJSON {
        public Boolean status {
            get;
            set;
        }
        public String message {
            get;
            set;
        }
        public List < SurveyJSON > data {
            get;
            set;
        }
    }

    public class SurveyJSON {
        public String sfSurveyId {
            get;
            set;
        }
        public Integer surveyId;
        public String clusterId;
        public String smartcardId;
        public String headend;
        public String state;
        public String district;
        public String townVillage;
        public String pinCode;
        public String recruitmentDate;
        public String installationDate;
        public String householdStatus;
        public String statusDesc;
        public String q2;
        public List < Q3List > q3;
        public String q4a;
        public String q4b; //??Not present in json
        public String q4c;
        public String q4d;
        public String q4e;
        public List < TvSet > tvSet;
        public String q8a; //??Not present in json
        public List < Q8bList > q8b;
        public String q8c;
        public String q9;
        public String q10;
        public String q11;
        public List < MemberSet > memberSet;
        public String q12;
        public String q13;
        public String q14;
        public String callcenter_no;
        public String technician_no;
        public List < ContactSet > contact_date_time;


    }


    public class ContactSet {
        public String contact_date;
        public String contact_time;
    }

    public class TvSet {
        public String dongleNo;
        public String stbMake;
        public String coustomerNo;
        public String stbId;
        public String q4f;
        public String q5;
        public String q6;
        public String q7;
        public String recordingFeature;
        public String usbHubInstalled;
    }

    public class Q8bList {
        public String Lang;
    }

    public class MemberSet {
        public String dob;
        public String age;
        public String gender;
        public String accessToInternet;
        public String q11a;
        public String q11b; //??Not present in json
        public String q11c;
        public String nom;
    }

    public SurveyResponseJSON parseSurveyResJSON(String json) {
        return (SurveyResponseJSON) System.JSON.deserialize(json, SurveyResponseJSON.class);
    }

    // public static List < SurveyJSON > parse(String json) {
    //     return (List < SurveyJSON > ) System.JSON.deserialize(json, List < SurveyJSON > .class);
    // }

    public class Q3List {
        public String item;
    }


}