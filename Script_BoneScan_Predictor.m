clc; clear; close all;

%% STEP 1

[path, user_cance] = imgetfile();
if user_cance
    msgbox(sprintf('Error'), 'Error', 'Error');
    return
end

% memanggil gambar dari file dengan format dicom

BS_Image = dicomread (path);
BS_Im1 = BS_Image(:,:,1);
BS_Im2 = BS_Image(:,:,2);
BS_fuse = imfuse(BS_Im1, BS_Im2, 'montage');

%% STEP 2 
% meningkatkan intensitas gambar

BS_adapthisteq = adapthisteq (BS_fuse);
BS_upcont = imadjust(BS_fuse);

%figure, imshow (BS_adapthisteq);
%% STEP 3 
% membuat citra negatif pada gambar

BS_com = imcomplement(BS_adapthisteq); 

%figure, imshow (BS_com);
%% STEP 4
% melakukan pengaturan threshold pada gambar

BS_bw = im2bw(BS_upcont);

figure, imshow (BS_bw);
%% STEP 5
% menata elemen struktur objek yang dihasilkan oleh langkah 4

SE = strel('disk', 2);
BS_Read = imopen(BS_bw,SE);

%% STEP 6
% Membuat ROI untuk menandai objek

markSpot_image = regionprops(BS_Read,'centroid');
[labeled,numSpot] = bwlabel(BS_Read,4);
spot = regionprops(labeled,'Area','BoundingBox');
object = [spot.Area];

Spot_number = find(object > 50 & object < 3000);
spotDefects = spot(Spot_number);

figure, imshow(BS_adapthisteq);
hold on;

for Point = 1 : length(Spot_number)
    ROI = rectangle('Position', spotDefects(Point).BoundingBox);
    set(ROI, 'EdgeColor', [.55 0 0]);
    hold on;
end

%% STEP 7
% membuat penomoran untuk mengetahui banyaknya objek

for Count = 1:length(object)
    area = spot(Count).Area;
    centroid = spot(Count).BoundingBox;
 
    
    text(centroid(1),centroid(2),num2str(Count),'Color','y',...
        'FontSize',4,'FontWeight','bold');
    
    disp('===================================')
    disp(strcat(['Number of Object = ', num2str(Count)]))
    disp(strcat(['Area = ',num2str(area), ' pixel']))
   
   
end

if Point > 0 
    title (['There are ', num2str(numSpot), ' object COUNTED in image'])
end
hold off;