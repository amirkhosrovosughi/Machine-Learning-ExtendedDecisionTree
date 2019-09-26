%Project CtpS570
clear all

Num_Samples=300;
noise=0.02; %between 0 to 1: 0 no noise

Table=zeros(1,11);
%Table to save the structre of three

%Table(:,1)=Index of table
%Table(:,2,,3,4)=a1,a2,b  in a1*x1+a2*x2=b
%Table(:,5,6)=childrens
%Table(:,7)=pure of not
%Table(:,8)=Label of pure class
%Table(:,9)=depth
%Table(:,10)=parent
%Table(:,11)=Checked prounng and it does not help

%% Read the Data File
Data=Sample_Generator(Num_Samples,noise);
Data_Validate=Sample_Generator(100,noise);
%Data=TestModel();

%UCI_Data = csvread('DataSet1.csv');
%Data=UCI_Data(1:200,:);
%Data_Validate=UCI_Data(201:334,:);
%% First iteration

% Find boundary with minimum Entropy
[Data_rotated,theta,pure,V1,V2]=Rotation3(Data,Data(:,1));

if pure==0
    [X1min, idx1, Index1, X2min, idx2, Index2,pure, bX1, bX2]=FindMinEntropy(Data_rotated,Data(:,1));
elseif pure==1
    Index1=Data(:,1);
    Index2=0;
    idx1=0;
    idx2=0;
    X1min=0;
    X2min=0;
    bX1=0; 
    bX2=0;
end
%Construct First row of Table (Initialization)
j=1;
Table(j,1)=1; %index
Table(j,9)=1; %depth

Clusters=(Data(:,1))';  %Each row shows the members of each cluster in decision tree
LenClusters=length(Clusters); %Length on each cluster

[Clusters,LenClusters,Table]=TableWrite(Clusters,LenClusters,Table,Data,j,pure,Index1,Index2,idx1,idx2,X1min,X2min, bX1, bX2,theta,V1,V2);

Allpure=1;
while (Allpure)
    j=j+1;
    temp=LenClusters(j);
    C=Clusters(j,1:temp);
    %Rotate the data
    [Data_rotated,theta,pure]=Rotation2(Data,C);
    
    if pure ==0
        [X1min, idx1, Index1, X2min, idx2, Index2,pure, bX1, bX2]=FindMinEntropy(Data_rotated,C);
    
    elseif pure==1
        Index1=C;
        Index2=0;
        idx1=0;
        idx2=0;
        X1min=0;
        X2min=0;
        bX1=0; 
        bX2=0;
    end
    
    %FindMinEntropy is written as above to find rotation based on X1min and X2min, using PCA, we do not need above information 
    
    [Clusters,LenClusters,Table]=TableWrite(Clusters,LenClusters,Table,Data,j,pure,Index1,Index2,idx1,idx2,X1min,X2min, bX1, bX2, theta,V1,V2);    
    
    [temp1,~]=size(Table);
    if (j==temp1)
        Allpure=0;
    end
end

%%%Learning is done here
%% Testing the Data
[Acc,error]=Accuracy(Data,Table);


[Acc,error]=Accuracy(Data_Validate,Table);
%% add proning to hear


stopPruning =1;
Tree1=Table;

while (stopPruning)
    Accu_old=Accuracy(Data_Validate,Tree1);
    Ind1 = find (Tree1(:,7)==1 & Tree1(:,11)==0 ); %find pure and not checked for pruning nodes
    
    if length(Ind1)==0
        stopPruning=0;
        break;
    end
    
    temp1= Tree1(Ind1,10); % Parent of above finded nodes
    temp2=[];
    for i=1:length(temp1)  % we want two find parents that are repeated two time in leafs
        temp3=find(temp1==temp1(i));
        if length(temp3)==2
            temp2=[temp2;temp1(i)];
        end 
    end
    temp2=unique(temp2);  %==> It is index
    %temp2=Tree1(temp2,1); %%%%%%%%%%%% ==> Wrong
    
    Tree2=Tree1; %==>> Tree 2 will be change here,
    if (length(temp2)==0)
        stopPruning=0;
        break;
    else
        % Prune the three
        
        %choose by random one of the ceils
        qq=ceil(rand(1)*length(temp2));
        temp3=temp2(qq); %%==> choose one parent to metge childrens
        
        temp4=find(Tree2(:,1)==temp3);  %==> find number of row from index (temp3 is index of parent)
        Tree2(temp4,7)=1;
        
        %%%%
        temp5=find(Tree2(:,10)==temp3);  %==> find num row of childs       
        temp6=Tree2(temp5,1); %==> find the index of childs
        
        temp10=LenClusters(temp6);
        
        if (temp10(1)>temp10(2)) % given to the parent the class label of the children that has more members
            Tree2(temp4,8)=Tree2(temp5(1),8); 
        else
            Tree2(temp4,8)=Tree2(temp5(2),8);
        end
        
        
        %temp4=find(Tree2(:,1)==temp3);  %==> find index branch
        %Tree2(temp4,6)=1;
        
        Tree2(temp5,:)=[];   %===> remove childs from table
    end
    Accu_new=Accuracy(Data_Validate,Tree2);
    
    if (Accu_new>=Accu_old)
        Tree1=Tree2;
        %8888
    else
        
        Tree1(temp5,11)=[1;1]; %==>> declare that branch is not modify with pruning, so don't look at it next round
    end
    
end

Acc=Accuracy(Data,Tree1)

Acc=Accuracy(Data_Validate,Tree1)

%% plotting

ind1 = Data(:,4) == 1;
ind2 = Data(:,4) == -1;

Data1 = Data(ind1,:);
Data2 = Data(ind2,:);

pointsize = 10;
scatter(Data1(:,2), Data1(:,3), pointsize, 'MarkerFaceColor',[0 .7 .7]);

hold on
scatter(Data2(:,2), Data2(:,3), pointsize, 'MarkerFaceColor',[1 .1 .1]);
grid on




hold off

%figure(1)
%plot(Data1(:,2),Data1(:,3))
%hold on

%plot(Data2(:,2),Data2(:,3))
%hold off