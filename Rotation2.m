%Project CtpS570

function [Data_rotated,theta,pure,V1,V2]=Rotation2(Data,Index)

Data1=Data(Index,:);

VX1=var(Data1(:,2));
VX2=var(Data1(:,3));

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




%recenter the feature to make mean equal zero (get ready for PCA)


% pos_x1_mean=sum(pos(:,2))/length(positives);
% pos_x2_mean=sum(pos(:,3))/length(positives);
% 
% neg_x1_mean=sum(neg(:,2))/length(negatives);
% neg_x2_mean=sum(neg(:,3))/length(negatives);
% 
% pos(:,2)=pos(:,2)-pos_x1_mean*eye(length(positives),1);
% pos(:,3)=pos(:,3)-pos_x2_mean*eye(length(positives),1);
% 
% neg(:,2)=neg(:,2)-neg_x1_mean*eye(length(negatives),1);
% neg(:,3)=neg(:,3)-neg_x2_mean*eye(length(negatives),1);
posx1=pos(:,2);
posx2=pos(:,3);

negx1=neg(:,2);
negx2=neg(:,3);

% normalization
posx1 = reshape(zscore(posx1(:)),size(posx1,1),size(posx1,2));
posx2 = reshape(zscore(posx2(:)),size(posx2,1),size(posx2,2));
negx1 = reshape(zscore(negx1(:)),size(negx1,1),size(negx1,2));
negx2 = reshape(zscore(negx2(:)),size(negx2,1),size(negx2,2));
%
pos(:,2)=posx1;
pos(:,3)=posx2;

neg(:,2)=negx1;
neg(:,3)=negx2;

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

Data_rotated1=Data_rotated(Index,:);
Vx1=var(Data_rotated1(:,2));
Vx2=var(Data_rotated1(:,3));

V1=sqrt(VX1/Vx1);
V2=sqrt(VX2/Vx2);

for i=1:q
    temp=Data_rotated(i,2:3);
    temp1=[cos(theta),sin(theta);-sin(theta),cos(theta)]*temp';
   Data_rotated(i,2:3)= temp1';
end


end

end


