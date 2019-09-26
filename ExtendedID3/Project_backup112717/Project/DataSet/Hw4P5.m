%%% Homework #3 ID3 algorithm
%%% Amirkhosro Vosughi
%%% Matlab 2017 has been used to implement this assignment]
%%% The text filds must be in 'fortunecookiedata\' folder

clc
clear all


M = csvread('transfusion.txt',1,1);


M2=M(:,4);
NumTrain=length(M2);

for i=1:NumTrain
    if M2(i)==0;
        M2(i)=-1;
    end
end

M(:,4)=M2;

M(:,2)=[];

%xlswrite('DataSet',M)

M3=1:NumTrain;
M=[M3',M];

csvwrite('DataSet.csv',M)

N = csvread('DataSet.csv');

