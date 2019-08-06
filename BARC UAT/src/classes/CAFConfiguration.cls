public class CAFConfiguration {
    public String samplingNo{get;set;}
    public CAFConfiguration(){
        samplingNo  = '';
    }
    
    
    public PageReference generateCluster(){
        System.debug('samplingNo ======'+samplingNo);
        GenerateClusterBatch gcb = new GenerateClusterBatch(samplingNo);
        Database.executeBatch(gcb,50);
        return null;
        
    }
    
    public PageReference generateClusterCase(){
        System.debug('samplingNogenerateClusterCase ======'+samplingNo);
        GenerateClusterCaseBatch gccb = new GenerateClusterCaseBatch(samplingNo);
        Database.executeBatch(gccb,50);
        return null;
    }
    
    public PageReference pushSurveyApp(){
        System.debug('samplingNogenerateClusterCase ======'+samplingNo);
        PushSurveyToAppBatch pst = new PushSurveyToAppBatch(samplingNo);
        Database.executeBatch(pst,5);
        return null;
    }
    
    
}