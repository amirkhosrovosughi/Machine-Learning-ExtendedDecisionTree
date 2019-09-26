%Project CtpS570

function [Data]=Sample_Generator(n,noise)
    x1Max=5;
    x1Min=-5;
    x2Max=5;
    x2Min=-5;
    
    Data=[];
    
    for i=1:n
       temp1=rand(1);
       temp2=rand(1);
       x1=temp1*(x1Max-x1Min)+x1Min;
       x2=temp2*(x2Max-x2Min)+x2Min;
       y=underlying(x1,x2,noise);
       Data=[Data;[i,x1,x2,y]];
    end

end


function [y]=underlying(x1,x2,noise)
% if (x1) < 0
%     y=1;
% else
%     if x2>0
%         y=1;
%     else
%         y=-1;
%     end
% end

if x1>1
    y=1;
else
    y=-1;
end

if rand(1)>noise
   y=-y; 
end


end


