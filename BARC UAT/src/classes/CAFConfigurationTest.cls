@isTest
public class CAFConfigurationTest {

	public static testMethod void test() {
	    
	    
	    Test.startTest();
	    CAFConfiguration cafc= new CAFConfiguration();
	    String samplingNo ='101';
	    cafc.generateCluster();
	    cafc.generateClusterCase();
	    cafc.pushSurveyApp();
	    Test.stopTest();

	}

}