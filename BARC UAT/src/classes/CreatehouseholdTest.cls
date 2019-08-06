@isTest
public class CreatehouseholdTest {

	public static testMethod void test() {
	    
	    Survey__c sur = new Survey__c();
	    sur.Current_House_Ownership_status__c='Ownership';
	    insert sur;
	    
	    Survey_TV__c stv = new Survey_TV__c();
	    stv.Survey__c=sur.id;
	    insert stv;
	    
	    Survey_Member__c svm= new Survey_Member__c();
	    svm.Survey__c=sur.id;
	    svm.Age__c='24';
	    insert svm;
	    
	    sur.Household_StatusN__c = 'Installed agree';
	    sur.Durables_in_working_condition__c='Air Conditioner';
	    update sur;
	    

	}

}