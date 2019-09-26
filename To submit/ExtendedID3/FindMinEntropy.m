%Project CtpS570
function [X1min, idx1, Index1, X2min, idx2, Index2, pure, bX1, bX2]=FindMinEntropy(Data,Index)%,Index)
Data1=Data(Index,:);

[Totalall,~]=size(Data1);
Total1s=histc(Data1(:,4),1);

%%% Go through the x1 axis
Index1=Data1(:,1);
[temp,idx] = sort(Data1(:,2));
Index1=Index1(idx,:);

tempX1 = unique(temp);
FreqX1 = [tempX1,histc(temp,tempX1)];  %==>> To handle repeated points


Beforeall=0;
Before1s=0;
Ind=0;
EntX1=[];
for n=1:length(tempX1)-1
    (tempX1(n)+tempX1(n+1))/2;
    IndOld=Ind;
    Ind=Ind+FreqX1(n,2);  %count number of frequency to deal with cases that has multiple value
    
    newData=Data(Index1(IndOld+1:Ind),:);
    
    Stepall=length(newData(:,1));
    Step1s=histc(newData(:,4),1);
    
    Beforeall=Beforeall+Stepall;
    Before1s=Before1s+Step1s;
    
    Afterall=Totalall-Beforeall;
    After1s=Total1s-Before1s;
    
    EntX1(n)=Entropy(Beforeall,Before1s,Afterall,After1s);
end

[X1min, idx1] = min(EntX1);  %weong
bX1=(tempX1(idx1)+tempX1(idx1+1))/2;

idx1=sum(FreqX1(1:idx1,2));

%What I need to return from here %==>> X1min, idx1, Index

%%% Go through the x2 axis


Index2=Data1(:,1);
[temp,idx] = sort(Data1(:,3));
Index2=Index2(idx,:);


tempX2 = unique(temp);
FreqX2 = [tempX2,histc(temp,tempX2)];  %==>> To handle repeated points


Beforeall=0;
Before1s=0;
Ind=0;

EntX2=[];
for n=1:length(tempX2)-1
    (tempX2(n)+tempX2(n+1))/2;
    IndOld=Ind;
    Ind=Ind+FreqX2(n,2);
    
    newData=Data(Index2(IndOld+1:Ind),:);
    
    Stepall=length(newData(:,1));
    Step1s=histc(newData(:,4),1);
    
    Beforeall=Beforeall+Stepall;
    Before1s=Before1s+Step1s;
    
    Afterall=Totalall-Beforeall;
    After1s=Total1s-Before1s;
    
    EntX2(n)=Entropy(Beforeall,Before1s,Afterall,After1s);
end

[X2min, idx2] = min(EntX2);

bX2=(tempX2(idx2)+tempX2(idx2+1))/2;

idx2=sum(FreqX2(1:idx2,2));

%pure=max([X1min,X2min]);
%if length(pure)==0
%    pure=0;
%end

pure=0;
if (Totalall==Total1s || Total1s==0)
    pure=1;
end

%%% add to handle pure nodes
if length(X1min)==0
    X1min=1000;
end

if length(X2min)==0
    X2min=1000;
end


end

