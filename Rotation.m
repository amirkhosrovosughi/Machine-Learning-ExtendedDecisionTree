%Project CtpS570

function [Data_rotated,theta,pure]=Rotation(Data,Index)

Data1=Data(Index,:);
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
pos1=pos;
neg1=neg;

pos_x1_mean=sum(pos(:,2))/length(positives);
pos_x2_mean=sum(pos(:,3))/length(positives);

neg_x1_mean=sum(neg(:,2))/length(negatives);
neg_x2_mean=sum(neg(:,3))/length(negatives);

pos(:,2)=pos(:,2)-pos_x1_mean*eye(length(positives),1);
pos(:,3)=pos(:,3)-pos_x2_mean*eye(length(positives),1);

neg(:,2)=neg(:,2)-neg_x1_mean*eye(length(negatives),1);
neg(:,3)=neg(:,3)-neg_x2_mean*eye(length(negatives),1);

%use pca
PosPCA = pca(pos(:,2:3));
NegPCA = pca(neg(:,2:3));

%handle expextation (has only one)
if length(PosPCA)==0 && length(NegPCA)>0
    Ave=NegPCA(:,1);
elseif length(PosPCA)>0 && length(NegPCA)==0
    Ave=PosPCA(:,1);
elseif length(PosPCA)==0 && length(NegPCA)==0
    [angle,~] = cart2pol(neg1(2)-pos1(2),neg1(3)-pos1(3));
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
for i=1:q
    temp=Data_rotated(i,2:3);
    temp1=[cos(theta),sin(theta);-sin(theta),cos(theta)]*temp';
   Data_rotated(i,2:3)= temp1';
end


end

end


