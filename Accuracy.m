%Project CtpS570

function [Accu,error]=Accuracy(Data,Table)

[Samples,~]=size(Data);
Yhat=zeros(Samples,1);

for j=1:Samples
    k=1;
    Unpure =1;
    while (Unpure ==1)
        %temp=Table(:,1);
        temp = find(Table(:,1)==k); %find row of next node from its index
        result = Table(temp,2)*Data(j,2) +Table(temp,3)*Data(j,3);
        if (Table(temp,7)==1)
            Yhat(j)=Table(temp,8);
            Unpure=0;
            break
        elseif result < Table(temp,4)
            k= Table(temp,5);
            temp = find(Table(:,1)==k); %find row of next node from its index
        else
            k= Table(temp,6); 
            temp = find(Table(:,1)==k); %find row of next node from its index
        end
    end
end


Y=Data(:,4);

error=sum(abs(Yhat-Y))/2;
Accu=100*(1-error/Samples);

end



