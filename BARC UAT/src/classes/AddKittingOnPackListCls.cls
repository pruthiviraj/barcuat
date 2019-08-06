public class AddKittingOnPackListCls {
    
public Id pkid{get; set;}
public Id selectId{get; set;}
public Integer delId{get; set;}
public List<Kitting__c> klist{get; set;}
public List<Packing_List_Line_Item__c> pkline{get; set;}

    public AddKittingOnPackListCls(){
        pkid=ApexPages.currentPage().getParameters().get('id');
        
        klist=[select id, Name from Kitting__c];
        pkline= new List<Packing_List_Line_Item__c>();
        
    }
    
    public void add(){
        
        for(Kitting__c k:[select id, Name from Kitting__c where id=:selectId]){
            
            Packing_List_Line_Item__c p = new Packing_List_Line_Item__c();
            p.Packing_List__c=pkid;
            p.Kitting__c=k.id;
            pkline.add(p);
        }
        
    }
    
    public void rem(){
        
        pkline.remove(delId);   
    }
    
    public PageReference Save(){
        
        insert pkline;
        
        PageReference pg = new PageReference('/'+pkid);
        pg.setRedirect(true);
        return pg;
    }
    
    public PageReference cancel(){
        
        PageReference pg = new PageReference('/'+pkid);
        pg.setRedirect(true);
        return pg;    
        
    }

}