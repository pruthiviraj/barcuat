@isTest
public class AsyncApexFrameworkTest {

    public static testMethod void test() {

        Integer Cont = 30;
        Integer Max = 20;
        Integer Ofset = 0;

        Test.startTest();
        for (Integer i = 0; i < cont;) {

            ofset = i;
            batchForTest obj1 = new batchForTest('SELECT ID FROM CONTACT');
            AsyncApexFramework.submitBatch(obj1, 1, 99, true);
            i = i + max;
        }
        AsyncApexFramework.flush();
        
        String jobId = null;
        List<AsyncQueue__c> pendingAsyncList = new List<AsyncQueue__c>();
        for(Integer j= 0;j<10;){
            batchForTest obj1 = new batchForTest('SELECT ID FROM CONTACT');
            Database.batchable<sObject> b = (Database.batchable<sObject>)obj1; 
            String s = JSON.serialize(obj1);
            
            AsyncQueue__c  q = new AsyncQueue__c (); 
            q.Job_Type__c = 'Batch';
            q.Batch_Size__c  = 10;
            q.object__c = s;
            q.priority__c = 99 ; 
            q.IsRetry__c = false;
            q.Class_Name__c = String.valueOf(obj1).split(':')[0];
            q.Job_Id__c = jobId = Database.executeBatch(b, 10);
            q.Status__c = 'Queued'; 
            q.Retry_Count__c = 0;
            pendingAsyncList.add(q);
            
            AsyncQueue__c  q1 = new AsyncQueue__c (); 
            q1.Job_Type__c = 'Batch';
            q1.Batch_Size__c  = 10;
            q1.object__c = s;
            q1.priority__c = 99 ; 
            q1.IsRetry__c = true;
            q1.Class_Name__c = String.valueOf(obj1).split(':')[0];
            q1.Job_Id__c = jobId = Database.executeBatch(b, 10);
            q1.Status__c = 'Failed'; 
            q1.Retry_Count__c = 0;
            q1.Error_Collection_Status__c = 'Not Collected';
            pendingAsyncList.add(q1);
            
            
            AsyncQueue__c  q2 = new AsyncQueue__c (); 
            q2.Job_Type__c = 'Queueable';
            q2.Batch_Size__c  = 10;
            q2.object__c = s;
            q2.priority__c = 99 ; 
            q2.IsRetry__c = true;
            q2.Class_Name__c = String.valueOf(obj1).split(':')[0];
            q2.Job_Id__c = jobId = Database.executeBatch(b, 10);
            //q2.Job_Id__c = String.valueOf(j);
            q2.Status__c = 'Failed'; 
            q2.Retry_Count__c = 0;
            pendingAsyncList.add(q2);
            
            j = j+1;
        }
        
        system.debug('pendingAsyncList ======'+pendingAsyncList);
        insert pendingAsyncList;
        
        AsyncApexFrameworkScheduler sh1 = new AsyncApexFramework();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);


        Test.stopTest();

    }


}