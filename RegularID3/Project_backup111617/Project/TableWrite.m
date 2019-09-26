%Project CtpS570

function [Clusters,LenClusters,Table]=TableWrite(Clusters,LenClusters,Table,Data,j,pure,Index1,Index2,idx1,idx2,X1min,X2min, bX1, bX2)

if pure==1
    Table(j,8)=Data(Index1(1),4);
    Table(j,7)=1;
else
    Table(j,7)=0;
    [temp1,dummy]=size(Table);
    Table(j,5)=temp1+1;  %Determine children rows 
    Table(j,6)=temp1+2;
    
    Table(temp1+1,1)=temp1+1;% add row for new Childrens
    Table(temp1+2,1)=temp1+2;
    
    Table(temp1+1,9)=Table(j,9)+1; %depth of node
    Table(temp1+2,9)=Table(j,9)+1;
    
    Table(temp1+1,10)=Table(j,1); %detemines parent of each node (for pruninig)
    Table(temp1+2,10)=Table(j,1);    
    

    
    %%% Here I need to assigned the List of entries of childeren as well
    
    if (X1min<X2min)  %a1 & a2 & b value
        Table(j,2)=1;
        Table(j,3)=0;
        Table(j,4)=bX1;
        
        LenClusters(temp1+1)=idx1;
        LenClusters(temp1+2)=length(Index1)-idx1;
        
        Clusters(temp1+1,1:LenClusters(temp1+1))=Index1(1:idx1);
        Clusters(temp1+2,1:LenClusters(temp1+2))=Index1(1+idx1:length(Index1));
        
    else
        Table(j,2)=0;
        Table(j,3)=1;
        Table(j,4)=bX2;
        
        LenClusters(temp1+1)=idx2;
        LenClusters(temp1+2)=length(Index2)-idx2;
        
        Clusters(temp1+1,1:LenClusters(temp1+1))=Index2(1:idx2);
        Clusters(temp1+2,1:LenClusters(temp1+2))=Index2(1+idx2:length(Index2));
        
    end
end

end


