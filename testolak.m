
Data=TestModel();
Data=Data(4,:);
%Data=Data(:,14);

[Samples,~]=size(Data);
Yhat=zeros(Samples,1);

for j=1:Samples
    k=1;
    Unpure =1;
    while (Unpure ==1)
        result = Table(k,2)*Data(j,2) +Table(k,3)*Data(j,3);
        if (Table(k,7)==1)
            Yhat(j)=Table(k,8);
            Unpure=0;
            break
        elseif result < Table(k,4)
            k= Table(k,5);
        else
            k= Table(k,6);
                    
        end
    end
end

Y=Data(:,4);
[Y,Yhat]

