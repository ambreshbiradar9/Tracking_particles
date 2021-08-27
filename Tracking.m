clc;
clear all;
% Reading images and removing the noise of the background
z=[];
str='result (';
for i=1:330
k=append(str,num2str(i),')');
I=imread([k,'.BMP']);
Ir=imrotate(I,12.7);
%Ic=imcrop(Ir,[355,410,375-355,650-410]);
%Ic=imcrop(Ir,[630,800,645-630,1000-200]);
%Ic=imcrop(Ir,[630,220,640-625,1100-220]);
%Ic=imcrop(Ir,[700,570,720-705,800-570]);
Ic=imcrop(Ir,[700,200,720-705,550-210]);
%imshow(Ic)
levela = graythresh(Ic);
bwa = im2bw(Ic,(levela));
bw = bwareaopen(bwa, 100);
h = bwlabel(bw);
%h = bwconcomp(bwa);
stats = regionprops(bw,'Basic');
count = length(stats);
 while count>2
        disp(i);
        disp(count);
        bw=~imfill(~bw);
        stats = regionprops(bw,'all');
        count = length(stats);
        bw = bwareaopen(bw,5);
        imshow(bw)
 end
C(i)=count;
r = regionprops(bw, 'Centroid','area');
f=ones(count,1);
 
centroid1 = cat(1, r.Centroid);
centroid = cat(2, centroid1, (i*f));
z = cat(1,z,centroid);

end


% % Tracking
    tr=track_mou(z,25); % tr has the ultimate coordinate data
% % 
% %% code appended by MUTHARASU L.C. on 6/18/2013
% 
% 
total_points      = max(tr(:,4));
number_of_images  = length(tr(:,4))/total_points;

x = zeros(number_of_images,total_points);
y = zeros(number_of_images,total_points);
for i =  1:1:number_of_images
        img_num = i;
    for j = 1:1:total_points        
        x(i,j)  = tr(img_num+number_of_images*(j-1),1); 
        y(i,j)  = tr(img_num+number_of_images*(j-1),2); 
    end
end

d             = zeros(total_points,total_points,number_of_images);
stretch_ratio = zeros(total_points,total_points,number_of_images);
strain        = zeros(total_points,total_points,number_of_images);
for i = 1:1:total_points
    for j = 1:1:total_points
        for img_num = 1:1:number_of_images
             d(i,j,img_num)      = ((x(img_num,i)-x(img_num,j))^2+...
                 (y(img_num,i)-y(img_num,j))^2)^(1/2);
             stretch_ratio(i,j,img_num) = d(i,j,img_num)/d(i,j,1);
             strain(i,j,img_num) = (d(i,j,img_num)-d(i,j,1))/d(i,j,1);
        end
    end
end

display(['type     strain_between_points_i_j(:,1) = strain(i,j,:)   for'...
    'knowing the strains  between points i and j at all instants of time'])

%----------- writing data in a xls file-----------------------------
image_NOs(:,1) = 1:1:number_of_images;
%strain_between_points_1_7(:,1) = strain(1,7,:)
%strain_between_points_2_6(:,1) = strain(2,6,:)
%strain_between_points_3_4(:,1) = strain(3,4,:)
%strain_between_points_4_5(:,1) = strain(4,5,:)
%strain_between_points_3_5(:,1) = strain(3,5,:)
% strain_between_points_2_3(:,1) = strain(2,3,:)
% strain_between_points_5_6(:,1) = strain(5,6,:)   
% 
strain_between_points_1_2 (:,1) = strain(1,2,:);
%strain_between_points_2_3(:,1) = strain(2,3,:);
%strain_between_points_1_3(:,1) = strain(1,3,:);
% strain_between_points_3_4(:,1) = strain(3,4,:);
% strain_between_points_4_5(:,1) = strain(4,5,:);
% strain_between_points_1_9 (:,1) = strain(1,9,:);
% strain_between_points_2_8(:,1) = strain(2,8,:);
% strain_between_points_3_7(:,1) = strain(3,7,:);
% strain_between_points_4_6(:,1) = strain(4,6,:);
% strain_between_points_5_9(:,1) = strain(5,9,:);
% strain_between_points_6_8(:,1) = strain(6,8,:);
% strain_between_points_5_4(:,1) = strain(5,4,:) ;
% strain_between_points_6_4(:,1) = strain(6,4,:);
% strain_between_points_3_2(:,1) = strain(3,2,:);
% strain_between_points_8_7(:,1) = strain(8,7,:);
% strain_between_points_6_2(:,1) = strain(6,2,:);
% strain_between_points_10_2(:,1) = strain(10,2,:);
col ={'Image No','strain_bt_pt_1_2'};%,'strain_bt_pt_2_3','strain_bt_pt_1_3'};
  m =[image_NOs, strain_between_points_1_2];%, strain_between_points_2_3,strain_between_points_1_3];
          % ,...
         %strain_between_points_3_4,strain_between_points_4_5, strain_between_points_3_5,];
     
size_m = size(m);
data   = cell(size_m(1)+1,size_m(2));

for i=1:size_m(2)
data{1,i} = col{1,i};
end

for i=1:size_m(1)
    for j=1:size_m(2)
      data{i+1,j}= m(i,j);
    end
end
%    remeber to delete or relocate the previous .xls file
%------------
     xlswrite('strain_dataV',data) 
%------------
%------------------------------------------------------------------------




