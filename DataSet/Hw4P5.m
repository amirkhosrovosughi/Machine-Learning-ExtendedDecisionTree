%%% Homework #3 ID3 algorithm
%%% Amirkhosro Vosughi
%%% Matlab 2017 has been used to implement this assignment]
%%% The text filds must be in 'fortunecookiedata\' folder

clc
clear all


M = csvread('transfusion.txt',1,0);

[~,q]=size(M);
M2=M(:,q);
NumTrain=length(M2);

for i=1:NumTrain
    if M2(i)==0;
        M2(i)=-1;
    end
end

M(:,q)=M2;

M(:,2:3)=[];

%xlswrite('DataSet',M)
loop1=1;
loop2=1;
i1=0;
i2=0;

while (loop1)
    i1=i1+1;
    i2=i1;
    
    
    

    
    temp1=M(i1,1);
    temp2=M(i1,2);
    
    loop2=1;
    
    while (loop2)
        i2=i2+1;
       
        if (i1==178)
           qqqqq=100000; 
        end
        
        temp3=M(i2,1);
        temp4=M(i2,2);
        
        if (temp1==temp3 && temp2==temp4)
           M(i2,:)=[];
           i2=i2-1;
        end
         
        
        [q,~]=size(M);
        if (i2 >= q)
            loop2=0;
            break;
        end
        
    end
    
    [q,~]=size(M);
    if (i1>=q-1)
        loop1=0;
        break;
    end
end

[q,~]=size(M);
M3=1:q;
M=[M3',M];

csvwrite('DataSet1.csv',M)

N = csvread('DataSet1.csv');

