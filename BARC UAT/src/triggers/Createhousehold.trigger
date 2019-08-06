trigger Createhousehold on Survey__c(after insert, after update) {

    Set < Id > sIds = new Set < Id > ();
    Map<Id,Id> sMap = new Map<Id,Id>();
    List < Survey__c > suLis = new List < Survey__c >();
    List < Household__c > hoList = new List < Household__c > ();
    List < HouseHold_Member__c > homList = new List < HouseHold_Member__c > ();
    List < HouseHold_TV_Detail__c > hotvList = new List < HouseHold_TV_Detail__c > ();
    for (Survey__c s: Trigger.new) {
        if (s.Household_StatusN__c == 'Installed agree' && s.Household__c == null) {
            sIds.add(s.Id);
        }
    }

    List < Survey__c > suList = [SELECT Id, Name, Language_Spoken_amongst_Family__c, Survey_Date__c, Technician_Number__c, Your_Native_Language__c, Most_Common_lang_amongst_family_member__c,
        Sub_District_Name__c, Current_House_Ownership_status__c, Total_Room_in_House_Except_Kitc_WC__c, Pincode__c, Smart_Card_ID__c, STB_ID_GOS_STB_ID__c, Case__c,
        State__c, City__c, Town_Village__c, Household_Status__c, House_Member_Works_in_of_the_Companies__c, Durables_in_working_condition__c, Working_TV_sets__c,
        Different_cable_or_DTH_connections__c, Is_household_part_of_TMP__c, Would_you_like_to_be_part_of_TMP__c, Television_Measurement_Panel_for_3_mnt__c,
        Installation_Date__c, Head_end__c, Total_members_living_currently__c, Highest_household_contributer__c, Decision_Maker_for_buying_groceries__c,
        Who_is_Respondant__c, District__c, VC_No__c, T6Q8__c, T8Q12_1__c, T2QB__c, T4MA__c, T6Q10__c, Household_StatusN__c,
        (SELECT Id, Name, Survey__c, Dongle_Number__c, STB_Make__c, Customer_VC_No__c, STB_ID__c, TV_sets_located_at_your_home__c,
            Type_of_TV__c, Television_Screen_at_your_home__c, TV_screen_size__c, Do_you_use_recording_feature__c, USB_HUB_Installed__c FROM Survey_TV__r),
        (SELECT Id, Name, Survey__c, Date_of_birth__c, Age__c, Gender__c, Access_to_internet__c, Education_Qualification__c, Work_status_of_member__c,
            Current_Occupation__c, DOB__c FROM Survey_Member__r), (SELECT Id, Name, Survey__c, Contact_Date__c, Contact_Time__c FROM Survey_Contact__r), Recruitment_Date__c, houseHold__c
        FROM Survey__c where id IN: sIds
    ];

    // List<Schema.PicklistEntry> durab = field_map.get(sur.Durables_in_working_condition__c).getDescribe().getPickListValues();

    for (Survey__c sur: suList) {

        Household__c ho = new Household__c();
        ho.Household_Status__c = sur.Household_StatusN__c;
        ho.House_Ownership__c = sur.Current_House_Ownership_status__c;
        ho.Installation_Date__c = sur.Installation_Date__c;
        ho.Recruitment_Date__c = sur.Recruitment_Date__c;
        ho.Mother_Tongue__c = sur.Your_Native_Language__c;
        ho.Working_TV_sets__c = sur.Working_TV_sets__c;
        ho.No_of_Members__c = sur.Total_members_living_currently__c;
        ho.Number_of_Rooms__c = sur.Total_Room_in_House_Except_Kitc_WC__c;
        ho.State__c = sur.State__c;
        ho.District__c = sur.District__c;
        ho.TownVillage__c = sur.Town_Village__c;
        ho.Pincode__c = sur.Pincode__c;
        ho.Installation_Date__c = sur.Installation_Date__c;
        ho.Recruitment_Date__c = sur.Recruitment_Date__c;

        if ((sur.Durables_in_working_condition__c).contains('Air Conditioner')) {
            ho.Air_Conditioner__c = true;
        }
        if ((sur.Durables_in_working_condition__c).contains('Car / Jeep / Van')) {
            ho.CarJeepVan__c = true;
        }
        if ((sur.Durables_in_working_condition__c).contains('Celling Fan')) {
            ho.Ceiling_Fan__c = true;
        }
        if ((sur.Durables_in_working_condition__c).contains('Color Tv')) {
            ho.Color_TV__c = true;
        }
        if ((sur.Durables_in_working_condition__c).contains('Personal Computer/ Laptop')) {
            ho.Personal_Computer_Laptop__c = true;
        }
        if ((sur.Durables_in_working_condition__c).contains('Refrigerator')) {
            ho.Refrigerator__c = true;
        }
        if ((sur.Durables_in_working_condition__c).contains('Two-Wheeler')) {
            ho.Two_Wheeler__c = true;
        }
        if ((sur.Durables_in_working_condition__c).contains('Washing Machine')) {
            ho.Washing_Machine__c = true;
        }
        if ((sur.Durables_in_working_condition__c).contains('Does the Chief wage earner (contributes the most to household expenditure) of the Household own any agricultural land?')) {
            ho.Agricultural_land__c = true;
        }

        // hoList.add(ho);
        insert ho;
        
        sMap.put(sur.id, ho.id);

        Integer i = 0;
        for (Survey_TV__c stv: sur.Survey_TV__r) {

            HouseHold_TV_Detail__c hotd = new HouseHold_TV_Detail__c();
            hotd.HouseHold__c = ho.id;
            hotd.Serial_Number__c = i+1;
            hotd.Size_of_Screen_in_Inches__c = stv.TV_screen_size__c;
            hotd.Type_of_TV_Screen__c = stv.Television_Screen_at_your_home__c;
            hotd.Type_of_Television__c = stv.Type_of_TV__c;
            hotd.STB_ID__c = stv.STB_ID__c;
            hotd.Customer_VC_No__c = stv.Customer_VC_No__c;
            hotd.STB_Make__c = stv.STB_Make__c;
            hotd.Dongle_Number__c = stv.Dongle_Number__c;
            hotd.TV_sets_located_at_your_home__c = stv.TV_sets_located_at_your_home__c;
            hotd.Do_you_use_recording_feature__c = stv.Do_you_use_recording_feature__c;
            hotd.USB_HUB_Installed__c = stv.USB_HUB_Installed__c;
            hotvList.add(hotd);
            i = i+1;
        }

        
        Integer j = 0;
        for (Survey_Member__c stv: sur.Survey_Member__r) {
            HouseHold_Member__c hom = new HouseHold_Member__c();
            hom.HouseHold__c = ho.id;
            hom.Serial_Number__c = j+1;
            hom.Gender__c = stv.Gender__c;
            hom.DOB__c = stv.DOB__c;
            hom.Occupation__c = stv.Current_Occupation__c;
            hom.Education__c = stv.Education_Qualification__c;
            hom.Age__c = Integer.valueOf(stv.Age__c);
            homList.add(hom);
            j = j+1;
        }
        // update sur;
    }
    
    for(Survey__c s:suList){
        
        Survey__c su = new Survey__c();
        su.houseHold__c=sMap.get(s.id);
        su.id=s.id;
        suLis.add(su);
    }
    update suLis;

    insert hotvList;
    insert homList;

}