%Project CtpS570

function [Data_rotated,theta,pure,V1,V2]=Rotation3(Data,Index)

Data1=Data(Index,:);

VX1=var(Data1(:,2));
VX2=var(Data1(:,3));

V1=sqrt(VX1);
V2=sqrt(VX2);

%%%%
X1=Data1(:,2);
X2=Data1(:,3);


% normalization
X1 = reshape(zscore(X1(:)),size(X1,1),size(X1,2));
X2 = reshape(zscore(X2(:)),size(X2,1),size(X2,2));

%
Data1(:,2)=X1;
Data1(:,3)=X2;


%%%%
Signs=Data1(:,4);
positives=find(Signs==1);
negatives=find(Signs==-1);

if (length(positives)==0) || (length(negatives)==0)
    pure =1;
    Data_rotated=Data;
    theta=0;
else
    pure=0;

pos=Data1(positives,:);
neg=Data1(negatives,:);

%

%use pca
PosPCA = pca(pos(:,2:3));
NegPCA = pca(neg(:,2:3));

%handle expextation (has only one)
if length(PosPCA)==0 && length(NegPCA)>0
    Ave=NegPCA(:,1);
elseif length(PosPCA)>0 && length(NegPCA)==0
    Ave=PosPCA(:,1);
elseif length(PosPCA)==0 && length(NegPCA)==0
    [angle,~] = cart2pol(neg(2)-pos(2),neg(3)-pos(3));
    angle=angle+pi/2;
    [temp1,temp2]=pol2cart(angle,1);
    Ave=[temp1;temp2];
elseif length(PosPCA)>0 && length(NegPCA)>0
    Ave=PosPCA(:,1)+NegPCA(:,1);    
end
    

[theta,~] = cart2pol(Ave(1),Ave(2));


%Normalize theta to be between 0 =< theta =< pi/2
if (theta > pi/2) && (theta <= pi)
    theta=theta-pi/2;
elseif (theta >= -pi/2) && (theta < 0)
    theta=theta+pi/2;
elseif (theta >= -pi) && (theta <= -pi/2)
    theta=theta+pi;
end

%for comparing with simple case
%theta=0;

[q,~]=size(Data);
Data_rotated=Data;

Data_rotated(positives,:)=pos;
Data_rotated(negatives,:)=neg;


for i=1:q
    temp=Data_rotated(i,2:3);
    temp1=[cos(theta),sin(theta);-sin(theta),cos(theta)]*temp';
   Data_rotated(i,2:3)= temp1';
end


end

end


