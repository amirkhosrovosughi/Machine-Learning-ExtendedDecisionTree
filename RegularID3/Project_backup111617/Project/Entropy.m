%Project CtpS570

function [Ent]=Entropy(Beforeall,Before1s,Afterall,After1s)

Totalall=Beforeall+Afterall;
Total1s=Before1s+After1s;

PrBefore=Beforeall/Totalall;
PrAfter=Afterall/Totalall;

AfterPr1=After1s/Afterall;
BeforePr1=Before1s/Beforeall;

Ent=PrBefore*(-xlogx(BeforePr1)-xlogx(1-BeforePr1)) +PrAfter*(-xlogx(AfterPr1)-xlogx(1-AfterPr1));
end


function [result]=xlogx(x)
if x ==0
    result=0;
else
    result=x*log(x);
end
end


