function varargout = BoneScan_Predictor02(varargin)
% BONESCAN_PREDICTOR02 MATLAB code for BoneScan_Predictor02.fig
%      BONESCAN_PREDICTOR02, by itself, creates a new BONESCAN_PREDICTOR02 or raises the existing
%      singleton*.
%
%      H = BONESCAN_PREDICTOR02 returns the handle to a new BONESCAN_PREDICTOR02 or the handle to
%      the existing singleton*.
%
%      BONESCAN_PREDICTOR02('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BONESCAN_PREDICTOR02.M with the given input arguments.
%
%      BONESCAN_PREDICTOR02('Property','Value',...) creates a new BONESCAN_PREDICTOR02 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BoneScan_Predictor02_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BoneScan_Predictor02_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BoneScan_Predictor02

% Last Modified by GUIDE v2.5 28-Jun-2019 18:06:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BoneScan_Predictor02_OpeningFcn, ...
                   'gui_OutputFcn',  @BoneScan_Predictor02_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before BoneScan_Predictor02 is made visible.
function BoneScan_Predictor02_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BoneScan_Predictor02 (see VARARGIN)

% Choose default command line output for BoneScan_Predictor02
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BoneScan_Predictor02 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BoneScan_Predictor02_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- This for load image (open DICOM file image from computer)

global BS_Image BS_Im1 BS_Im2 BS_fuse BS_adapthisteq
[path, user_cance] = imgetfile();
if user_cance
    msgbox(sprintf('Error'), 'Error', 'Error');
    return
end

% --- STEP 1

BS_Image = dicomread (path);
BS_Im1 = BS_Image(:,:,1);
BS_Im2 = BS_Image(:,:,2);
BS_fuse = imfuse(BS_Im1, BS_Im2, 'montage');
BS_adapthisteq = adapthisteq(BS_fuse);

axes(handles.axes1);
imshow(BS_adapthisteq);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- This for reset to show original image

% Additional STEP

global BS_adapthisteq
axes(handles.axes1);
imshow(BS_adapthisteq);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- This for complementing image (enhance contrass and change to black
% and white)

% --- STEP 2

global BS_fuse BS_adapthisteq BS_com
BS_adapthisteq = adapthisteq (BS_fuse);
BS_com = imcomplement(BS_adapthisteq);

axes(handles.axes1);
imshow(BS_com);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- This for show prediction processing

% --- STEP 3 to 5
% Thresholding image

global BS_fuse BS_upcont BS_bw SE BS_Read 

BS_upcont = imadjust(BS_fuse);
BS_bw = im2bw(BS_upcont);
SE = strel('disk', 2);
BS_Read = imopen(BS_bw,SE);

% --- STEP 6
% Make ROI
 
global BS_adapthisteq markSpot_image labeled numSpot spot object Spot_number
global spotDefects

markSpot_image = regionprops(BS_Read,'centroid');
[labeled,numSpot] = bwlabel(BS_Read,4);
spot = regionprops(labeled,'Area','BoundingBox');
object = [spot.Area];

Spot_number = find(object > 50 & object < 3000);
spotDefects = spot(Spot_number);

axes(handles.axes1);
imshow(BS_adapthisteq)
hold on;

global Point ROI Count area nometa centroid
for Point = 1 : length(Spot_number)
    ROI = rectangle('Position', spotDefects(Point).BoundingBox);
    set(ROI, 'EdgeColor', [.55 0 0]);
    hold on;
end

% --- STEP 7
% Numbering

for Count = 1:length(object)
    area = spot(Count).Area;
    centroid = spot(Count).BoundingBox;
    nometa = Count - Point;
    
    text(centroid(1),centroid(2),num2str(Count),'Color','y',...
        'FontSize',4,'FontWeight','bold');
    
    disp('===================================')
    disp(strcat(['Number of Objects = ', num2str(Count)]))
    disp(strcat(['Area = ',num2str(area), ' pixels']))
end

if Point > 1
    title (['There are ', num2str(numSpot), ' objects COUNTED in image'])
end
hold off;

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

% This for show index menu

% Additional STEP
global BS_upcont BS_idx BS_bw SE BS_Read markSpot_image contents
global labeled numSpot spot object Spot_number spotDefects 
global Point ROI Count centroid area index 

contents = get(hObject, 'Value');

switch contents;
    case 3
        BS_idx = imcrop (BS_upcont, [22 140 60 300]);
        BS_bw = im2bw(BS_idx);
        
        SE = strel('disk', 2);
        BS_Read = imopen(BS_bw,SE); 
        markSpot_image = regionprops(BS_Read,'centroid');
        [labeled,numSpot] = bwlabel(BS_Read,4);
        spot = regionprops(labeled,'Area','BoundingBox');
        object = [spot.Area];

        Spot_number = find(object > 50 & object < 3000); 
        spotDefects = spot(Spot_number);
        
        axes(handles.axes2);
        imshow(BS_idx);
        hold on;
        
        for Point = 1 : length(Spot_number)
            ROI = rectangle('Position', spotDefects(Point).BoundingBox);
            set(ROI, 'EdgeColor', [.9 0 0]);
            hold on;
        end
        for Count = 1:length(object)
            area = spot(Count).Area;
            centroid = spot(Count).BoundingBox;
            
            text(centroid(1),centroid(2),num2str(Count),'Color','y',...
                'FontSize',10,'FontWeight','bold');
            
            disp('===================================')
            disp(strcat(['Number of Objects = ', num2str(Count)]))
            disp(strcat(['Area = ',num2str(area), ' pixels']))
        end
        if Count > 0
            title (['There are ', num2str(numSpot), ' objects'])
        end
        
        index = {('====================='), ['Number of Objects = ', num2str(Count)], ['Area = ', num2str(area), ' pixels']}
        set(handles.listbox1, 'String', index)
        hold off;
   
    case 4
        BS_idx = imcrop (BS_upcont, [185 140 60 300]);
        BS_bw = im2bw(BS_idx);
        
        SE = strel('disk', 2);
        BS_Read = imopen(BS_bw,SE); 
        markSpot_image = regionprops(BS_Read,'centroid');
        [labeled,numSpot] = bwlabel(BS_Read,4);
        spot = regionprops(labeled,'Area','BoundingBox');
        object = [spot.Area];

        Spot_number = find(object > 50 & object < 3000); 
        spotDefects = spot(Spot_number);
        
        axes(handles.axes2)
        imshow(BS_idx);
        hold on;
        
        for Point = 1 : length(Spot_number)
            ROI = rectangle('Position', spotDefects(Point).BoundingBox);
            set(ROI, 'EdgeColor', [.9 0 0]);
            hold on;
        end
        for Count = 1:length(object)
            area = spot(Count).Area;
            centroid = spot(Count).BoundingBox;
      
            text(centroid(1),centroid(2),num2str(Count),'Color','y',...
                'FontSize',10,'FontWeight','bold');
            
            disp('===================================')
            disp(strcat(['Number of Objects = ', num2str(Count)]))
            disp(strcat(['Area = ',num2str(area), ' pixels']))
        end
        if Count > 0
            title (['There are ', num2str(numSpot), ' objects'])
        end
        index = {('====================='), ['Number of Objects = ', num2str(Count)], ['Area = ', num2str(area), ' pixels']}
        set(handles.listbox1, 'String', index)
        hold off;
        
    case 5
        BS_idx = imcrop (BS_upcont, [68 380 65 360]);
        BS_bw = im2bw(BS_idx);
        
        SE = strel('disk', 2);
        BS_Read = imopen(BS_bw,SE); 
        markSpot_image = regionprops(BS_Read,'centroid');
        [labeled,numSpot] = bwlabel(BS_Read,4);
        spot = regionprops(labeled,'Area','BoundingBox');
        object = [spot.Area];

        Spot_number = find(object > 50 & object < 3000); 
        spotDefects = spot(Spot_number);
        
        axes(handles.axes2)
        imshow(BS_idx);
        hold on;
        
        for Point = 1 : length(Spot_number)
            ROI = rectangle('Position', spotDefects(Point).BoundingBox);
            set(ROI, 'EdgeColor', [.9 0 0]);
            hold on;
        end
        for Count = 1:length(object)
            area = spot(Count).Area;
            centroid = spot(Count).BoundingBox;
      
            text(centroid(1),centroid(2),num2str(Count),'Color','y',...
                'FontSize',10,'FontWeight','bold');
            
            disp('===================================')
            disp(strcat(['Number of Objects = ', num2str(Count)]))
            disp(strcat(['Area = ',num2str(area), ' pixels']))
        end
        if Count > 0
            title (['There are ', num2str(numSpot), ' objects'])

        end
        index = {('====================='), ['Number of Objects = ', num2str(Count)], ['Area = ', num2str(area), ' pixels']}
        set(handles.listbox1, 'String', index)
        hold off;
        
    case 6
        BS_idx = imcrop (BS_upcont, [130 380 65 360]);
        BS_bw = im2bw(BS_idx);
        
        SE = strel('disk', 2);
        BS_Read = imopen(BS_bw,SE); 
        markSpot_image = regionprops(BS_Read,'centroid');
        [labeled,numSpot] = bwlabel(BS_Read,4);
        spot = regionprops(labeled,'Area','BoundingBox');
        object = [spot.Area];

        Spot_number = find(object > 50 & object < 3000); 
        spotDefects = spot(Spot_number);
        
        axes(handles.axes2)
        imshow(BS_idx);
        hold on;
        
        for Point = 1 : length(Spot_number)
            ROI = rectangle('Position', spotDefects(Point).BoundingBox);
            set(ROI, 'EdgeColor', [.9 0 0]);
            hold on;
        end
        for Count = 1:length(object)
            area = spot(Count).Area;
            centroid = spot(Count).BoundingBox;
      
            text(centroid(1),centroid(2),num2str(Count),'Color','y',...
                'FontSize',10,'FontWeight','bold');
            
            disp('===================================')
            disp(strcat(['Number of Objects = ', num2str(Count)]))
            disp(strcat(['Area = ',num2str(area), ' pixels']))
        end
        if Count > 0
            title (['There are ', num2str(numSpot), ' objects'])

        end
        index = {('====================='), ['Number of Objects = ', num2str(Count)], ['Area = ', num2str(area), ' pixels']}
        set(handles.listbox1, 'String', index)
        hold off;
        
    case 7
        BS_idx = imcrop (BS_upcont, [72 144 50 150]);
        BS_bw = im2bw(BS_idx);
        
        SE = strel('disk', 2);
        BS_Read = imopen(BS_bw,SE); 
        markSpot_image = regionprops(BS_Read,'centroid');
        [labeled,numSpot] = bwlabel(BS_Read,4);
        spot = regionprops(labeled,'Area','BoundingBox');
        object = [spot.Area];

        Spot_number = find(object > 50 & object < 3000); 
        spotDefects = spot(Spot_number);
        
        axes(handles.axes2)
        imshow(BS_idx);
        hold on;
        
        for Point = 1 : length(Spot_number)
            ROI = rectangle('Position', spotDefects(Point).BoundingBox);
            set(ROI, 'EdgeColor', [.9 0 0]);
            hold on;
        end
        for Count = 1:length(object)
            area = spot(Count).Area;
            centroid = spot(Count).BoundingBox;
      
            text(centroid(1),centroid(2),num2str(Count),'Color','y',...
                'FontSize',10,'FontWeight','bold');
            
            disp('===================================')
            disp(strcat(['Number of Objects = ', num2str(Count)]))
            disp(strcat(['Area = ',num2str(area), ' pixels']))
        end
        if Count > 0
            title (['There are ', num2str(numSpot), ' objects'])

        end
        index = {('====================='), ['Number of Objects = ', num2str(Count)], ['Area = ', num2str(area), ' pixels']}
        set(handles.listbox1, 'String', index)
        hold off;
        
    case 8
        BS_idx = imcrop (BS_upcont, [152 144 50 150]);
        BS_bw = im2bw(BS_idx);
        
        SE = strel('disk', 2);
        BS_Read = imopen(BS_bw,SE); 
        markSpot_image = regionprops(BS_Read,'centroid');
        [labeled,numSpot] = bwlabel(BS_Read,4);
        spot = regionprops(labeled,'Area','BoundingBox');
        object = [spot.Area];

        Spot_number = find(object > 50 & object < 3000); 
        spotDefects = spot(Spot_number);
        
        axes(handles.axes2)
        imshow(BS_idx);
        hold on;
        
        for Point = 1 : length(Spot_number)
            ROI = rectangle('Position', spotDefects(Point).BoundingBox);
            set(ROI, 'EdgeColor', [.9 0 0]);
            hold on;
        end
        for Count = 1:length(object)
            area = spot(Count).Area;
            centroid = spot(Count).BoundingBox;
      
            text(centroid(1),centroid(2),num2str(Count),'Color','y',...
                'FontSize',10,'FontWeight','bold');
            
            disp('===================================')
            disp(strcat(['Number of Objects = ', num2str(Count)]))
            disp(strcat(['Area = ',num2str(area), ' pixels']))
        end
        if Count > 0
            title (['There are ', num2str(numSpot), ' objects'])

        end
        index = {('====================='), ['Number of Objects = ', num2str(Count)], ['Area = ', num2str(area), ' pixels']}
        set(handles.listbox1, 'String', index)
        hold off;
        
    case 9
        BS_idx = imcrop (BS_upcont, [112 150 50 170]);
        BS_bw = im2bw(BS_idx);
        
        SE = strel('disk', 2);
        BS_Read = imopen(BS_bw,SE); 
        markSpot_image = regionprops(BS_Read,'centroid');
        [labeled,numSpot] = bwlabel(BS_Read,4);
        spot = regionprops(labeled,'Area','BoundingBox');
        object = [spot.Area];

        Spot_number = find(object > 50 & object < 3000); 
        spotDefects = spot(Spot_number);
        
        axes(handles.axes2)
        imshow(BS_idx);
        hold on;
        
        for Point = 1 : length(Spot_number)
            ROI = rectangle('Position', spotDefects(Point).BoundingBox);
            set(ROI, 'EdgeColor', [.9 0 0]);
            hold on;
        end
        for Count = 1:length(object)
            area = spot(Count).Area;
            centroid = spot(Count).BoundingBox;
      
            text(centroid(1),centroid(2),num2str(Count),'Color','y',...
                'FontSize',10,'FontWeight','bold');
            
            disp('===================================')
            disp(strcat(['Number of Objects = ', num2str(Count)]))
            disp(strcat(['Area = ',num2str(area), ' pixels']))
        end
        if Count > 0
            title (['There are ', num2str(numSpot), ' objects'])

        end
        index = {('====================='), ['Number of Objects = ', num2str(Count)], ['Area = ', num2str(area), ' pixels']}
        set(handles.listbox1, 'String', index)
        hold off;
        
    case 10
        BS_idx = imcrop (BS_upcont, [72 308 110 60]);
        BS_bw = im2bw(BS_idx);
        
        SE = strel('disk', 2);
        BS_Read = imopen(BS_bw,SE); 
        markSpot_image = regionprops(BS_Read,'centroid');
        [labeled,numSpot] = bwlabel(BS_Read,4);
        spot = regionprops(labeled,'Area','BoundingBox');
        object = [spot.Area];

        Spot_number = find(object > 50 & object < 3000); 
        spotDefects = spot(Spot_number);
        
        axes(handles.axes2)
        imshow(BS_idx);
        hold on;
        
        for Point = 1 : length(Spot_number)
            ROI = rectangle('Position', spotDefects(Point).BoundingBox);
            set(ROI, 'EdgeColor', [.9 0 0]);
            hold on;
        end
        for Count = 1:length(object)
            area = spot(Count).Area;
            centroid = spot(Count).BoundingBox;
      
            text(centroid(1),centroid(2),num2str(Count),'Color','y',...
                'FontSize',10,'FontWeight','bold');
            
            disp('===================================')
            disp(strcat(['Number of Objects = ', num2str(Count)]))
            disp(strcat(['Area = ',num2str(area), ' pixels']))
        end
        if Count > 0
            title (['There are ', num2str(numSpot), ' objects'])

        end
        index = {('====================='), ['Number of Objects = ', num2str(Count)], ['Area = ', num2str(area), ' pixels']}
        set(handles.listbox1, 'String', index)
        hold off;
        
    case 11
        BS_idx = imcrop (BS_upcont, [90 46 90 90]);
        BS_bw = im2bw(BS_idx);
        
        SE = strel('disk', 2);
        BS_Read = imopen(BS_bw,SE); 
        markSpot_image = regionprops(BS_Read,'centroid');
        [labeled,numSpot] = bwlabel(BS_Read,4);
        spot = regionprops(labeled,'Area','BoundingBox');
        object = [spot.Area];

        Spot_number = find(object > 50 & object < 3000); 
        spotDefects = spot(Spot_number);
        
        axes(handles.axes2);
        imshow(BS_idx);
        hold on;
        
        for Point = 1 : length(Spot_number)
            ROI = rectangle('Position', spotDefects(Point).BoundingBox);
            set(ROI, 'EdgeColor', [.9 0 0]);
            hold on;
        end
        for Count = 1:length(object)
            area = spot(Count).Area;
            centroid = spot(Count).BoundingBox;
            
            text(centroid(1),centroid(2),num2str(Count),'Color','y',...
                'FontSize',10,'FontWeight','bold');
            
            disp('===================================')
            disp(strcat(['Number of Objects = ', num2str(Count)]))
            disp(strcat(['Area = ',num2str(area), ' pixels']))
        end
        if Count > 0
            title (['There are ', num2str(numSpot), ' objects'])
        end
        
        index = {('====================='), ['Number of Objects = ', num2str(Count)], ['Area = ', num2str(area), ' pixels']}
        set(handles.listbox1, 'String', index)
        hold off;
        
    case 13
        BS_idx = imcrop (BS_upcont, [274 140 60 300]);
        BS_bw = im2bw(BS_idx);
        
        SE = strel('disk', 2);
        BS_Read = imopen(BS_bw,SE); 
        markSpot_image = regionprops(BS_Read,'centroid');
        [labeled,numSpot] = bwlabel(BS_Read,4);
        spot = regionprops(labeled,'Area','BoundingBox');
        object = [spot.Area];

        Spot_number = find(object > 50 & object < 3000); 
        spotDefects = spot(Spot_number);
        
        axes(handles.axes2)
        imshow(BS_idx);
        hold on;
        
        for Point = 1 : length(Spot_number)
            ROI = rectangle('Position', spotDefects(Point).BoundingBox);
            set(ROI, 'EdgeColor', [.9 0 0]);
            hold on;
        end
        for Count = 1:length(object)
            area = spot(Count).Area;
            centroid = spot(Count).BoundingBox;
      
            text(centroid(1),centroid(2),num2str(Count),'Color','y',...
                'FontSize',10,'FontWeight','bold');
            
            disp('===================================')
            disp(strcat(['Number of Objects = ', num2str(Count)]))
            disp(strcat(['Area = ',num2str(area), ' pixels']))
        end
        if Count > 0
            title (['There are ', num2str(numSpot), ' objects'])

        end
        index = {('====================='), ['Number of Objects = ', num2str(Count)], ['Area = ', num2str(area), ' pixels']}
        set(handles.listbox1, 'String', index)
        hold off;
        
   case 14
        BS_idx = imcrop (BS_upcont, [430 140 60 300]);
        BS_bw = im2bw(BS_idx);
        
        SE = strel('disk', 2);
        BS_Read = imopen(BS_bw,SE); 
        markSpot_image = regionprops(BS_Read,'centroid');
        [labeled,numSpot] = bwlabel(BS_Read,4);
        spot = regionprops(labeled,'Area','BoundingBox');
        object = [spot.Area];

        Spot_number = find(object > 50 & object < 3000); 
        spotDefects = spot(Spot_number);
        
        axes(handles.axes2)
        imshow(BS_idx);
        hold on;
        
        for Point = 1 : length(Spot_number)
            ROI = rectangle('Position', spotDefects(Point).BoundingBox);
            set(ROI, 'EdgeColor', [.9 0 0]);
            hold on;
        end
        for Count = 1:length(object)
            area = spot(Count).Area;
            centroid = spot(Count).BoundingBox;
      
            text(centroid(1),centroid(2),num2str(Count),'Color','y',...
                'FontSize',10,'FontWeight','bold');
            
            disp('===================================')
            disp(strcat(['Number of Objects = ', num2str(Count)]))
            disp(strcat(['Area = ',num2str(area), ' pixels']))
        end
        if Count > 0
            title (['There are ', num2str(numSpot), ' objects'])

        end
        index = {('====================='), ['Number of Objects = ', num2str(Count)], ['Area = ', num2str(area), ' pixels']}
        set(handles.listbox1, 'String', index)
        hold off;
        
    case 15
        BS_idx = imcrop (BS_upcont, [315 380 65 360]);
        BS_bw = im2bw(BS_idx);
        
        SE = strel('disk', 2);
        BS_Read = imopen(BS_bw,SE); 
        markSpot_image = regionprops(BS_Read,'centroid');
        [labeled,numSpot] = bwlabel(BS_Read,4);
        spot = regionprops(labeled,'Area','BoundingBox');
        object = [spot.Area];

        Spot_number = find(object > 50 & object < 3000); 
        spotDefects = spot(Spot_number);
        
        axes(handles.axes2)
        imshow(BS_idx);
        hold on;
        
        for Point = 1 : length(Spot_number)
            ROI = rectangle('Position', spotDefects(Point).BoundingBox);
            set(ROI, 'EdgeColor', [.9 0 0]);
            hold on;
        end
        for Count = 1:length(object)
            area = spot(Count).Area;
            centroid = spot(Count).BoundingBox;
      
            text(centroid(1),centroid(2),num2str(Count),'Color','y',...
                'FontSize',10,'FontWeight','bold');
            
            disp('===================================')
            disp(strcat(['Number of Objects = ', num2str(Count)]))
            disp(strcat(['Area = ',num2str(area), ' pixels']))
        end
        if Count > 0
            title (['There are ', num2str(numSpot), ' objects'])

        end
        index = {('====================='), ['Number of Objects = ', num2str(Count)], ['Area = ', num2str(area), ' pixels']}
        set(handles.listbox1, 'String', index)
        hold off;
        
    case 16
        BS_idx = imcrop (BS_upcont, [386 380 65 360]);
        BS_bw = im2bw(BS_idx);
        
        SE = strel('disk', 2);
        BS_Read = imopen(BS_bw,SE); 
        markSpot_image = regionprops(BS_Read,'centroid');
        [labeled,numSpot] = bwlabel(BS_Read,4);
        spot = regionprops(labeled,'Area','BoundingBox');
        object = [spot.Area];

        Spot_number = find(object > 50 & object < 3000); 
        spotDefects = spot(Spot_number);
        
        axes(handles.axes2)
        imshow(BS_idx);
        hold on;
        
        for Point = 1 : length(Spot_number)
            ROI = rectangle('Position', spotDefects(Point).BoundingBox);
            set(ROI, 'EdgeColor', [.9 0 0]);
            hold on;
        end
        for Count = 1:length(object)
            area = spot(Count).Area;
            centroid = spot(Count).BoundingBox;
      
            text(centroid(1),centroid(2),num2str(Count),'Color','y',...
                'FontSize',10,'FontWeight','bold');
            
            disp('===================================')
            disp(strcat(['Number of Objects = ', num2str(Count)]))
            disp(strcat(['Area = ',num2str(area), ' pixels']))
        end
        if Count > 0
            title (['There are ', num2str(numSpot), ' objects'])

        end
        index = {('====================='), ['Number of Objects = ', num2str(Count)], ['Area = ', num2str(area), ' pixels']}
        set(handles.listbox1, 'String', index)
        hold off;
        
    case 17
        BS_idx = imcrop (BS_upcont, [324 140 45 150]);
        BS_bw = im2bw(BS_idx);
        
        SE = strel('disk', 2);
        BS_Read = imopen(BS_bw,SE); 
        markSpot_image = regionprops(BS_Read,'centroid');
        [labeled,numSpot] = bwlabel(BS_Read,4);
        spot = regionprops(labeled,'Area','BoundingBox');
        object = [spot.Area];

        Spot_number = find(object > 50 & object < 3000); 
        spotDefects = spot(Spot_number);
        
        axes(handles.axes2)
        imshow(BS_idx);
        hold on;
        
        for Point = 1 : length(Spot_number)
            ROI = rectangle('Position', spotDefects(Point).BoundingBox);
            set(ROI, 'EdgeColor', [.9 0 0]);
            hold on;
        end
        for Count = 1:length(object)
            area = spot(Count).Area;
            centroid = spot(Count).BoundingBox;
      
            text(centroid(1),centroid(2),num2str(Count),'Color','y',...
                'FontSize',10,'FontWeight','bold');
            
            disp('===================================')
            disp(strcat(['Number of Objects = ', num2str(Count)]))
            disp(strcat(['Area = ',num2str(area), ' pixels']))
        end
        if Count > 0
            title (['There are ', num2str(numSpot), ' objects'])

        end
        index = {('====================='), ['Number of Objects = ', num2str(Count)], ['Area = ', num2str(area), ' pixels']}
        set(handles.listbox1, 'String', index)
        hold off;
        
    case 18
        BS_idx = imcrop (BS_upcont, [400 140 45 150]);
        BS_bw = im2bw(BS_idx);
        
        SE = strel('disk', 2);
        BS_Read = imopen(BS_bw,SE); 
        markSpot_image = regionprops(BS_Read,'centroid');
        [labeled,numSpot] = bwlabel(BS_Read,4);
        spot = regionprops(labeled,'Area','BoundingBox');
        object = [spot.Area];

        Spot_number = find(object > 50 & object < 3000); 
        spotDefects = spot(Spot_number);
        
        axes(handles.axes2)
        imshow(BS_idx);
        hold on;
        
        for Point = 1 : length(Spot_number)
            ROI = rectangle('Position', spotDefects(Point).BoundingBox);
            set(ROI, 'EdgeColor', [.9 0 0]);
            hold on;
        end
        for Count = 1:length(object)
            area = spot(Count).Area;
            centroid = spot(Count).BoundingBox;
      
            text(centroid(1),centroid(2),num2str(Count),'Color','y',...
                'FontSize',10,'FontWeight','bold');
            
            disp('===================================')
            disp(strcat(['Number of Objects = ', num2str(Count)]))
            disp(strcat(['Area = ',num2str(area), ' pixels']))
        end
        if Count > 0
            title (['There are ', num2str(numSpot), ' objects'])

        end
        index = {('====================='), ['Number of Objects = ', num2str(Count)], ['Area = ', num2str(area), ' pixels']}
        set(handles.listbox1, 'String', index)
        hold off;
        
   case 19
        BS_idx = imcrop (BS_upcont, [365 150 50 170]);
        BS_bw = im2bw(BS_idx);
        
        SE = strel('disk', 2);
        BS_Read = imopen(BS_bw,SE); 
        markSpot_image = regionprops(BS_Read,'centroid');
        [labeled,numSpot] = bwlabel(BS_Read,4);
        spot = regionprops(labeled,'Area','BoundingBox');
        object = [spot.Area];

        Spot_number = find(object > 50 & object < 3000); 
        spotDefects = spot(Spot_number);
        
        axes(handles.axes2)
        imshow(BS_idx);
        hold on;
        
        for Point = 1 : length(Spot_number)
            ROI = rectangle('Position', spotDefects(Point).BoundingBox);
            set(ROI, 'EdgeColor', [.9 0 0]);
            hold on;
        end
        for Count = 1:length(object)
            area = spot(Count).Area;
            centroid = spot(Count).BoundingBox;
      
            text(centroid(1),centroid(2),num2str(Count),'Color','y',...
                'FontSize',10,'FontWeight','bold');
            
            disp('===================================')
            disp(strcat(['Number of Objects = ', num2str(Count)]))
            disp(strcat(['Area = ',num2str(area), ' pixels']))
        end
        if Count > 0
            title (['There are ', num2str(numSpot), ' objects'])

        end
        index = {('====================='), ['Number of Objects = ', num2str(Count)], ['Area = ', num2str(area), ' pixels']}
        set(handles.listbox1, 'String', index)
        hold off;
        
   case 20
        BS_idx = imcrop (BS_upcont, [324 308 110 60]);
        BS_bw = im2bw(BS_idx);
        
        SE = strel('disk', 2);
        BS_Read = imopen(BS_bw,SE); 
        markSpot_image = regionprops(BS_Read,'centroid');
        [labeled,numSpot] = bwlabel(BS_Read,4);
        spot = regionprops(labeled,'Area','BoundingBox');
        object = [spot.Area];

        Spot_number = find(object > 50 & object < 3000); 
        spotDefects = spot(Spot_number);
        
        axes(handles.axes2)
        imshow(BS_idx);
        hold on;
        
        for Point = 1 : length(Spot_number)
            ROI = rectangle('Position', spotDefects(Point).BoundingBox);
            set(ROI, 'EdgeColor', [.9 0 0]);
            hold on;
        end
        for Count = 1:length(object)
            area = spot(Count).Area;
            centroid = spot(Count).BoundingBox;
      
            text(centroid(1),centroid(2),num2str(Count),'Color','y',...
                'FontSize',10,'FontWeight','bold');
            
            disp('===================================')
            disp(strcat(['Number of Objects = ', num2str(Count)]))
            disp(strcat(['Area = ',num2str(area), ' pixels']))
        end
        if Count > 0
            title (['There are ', num2str(numSpot), ' objects'])

        end       
        index = {('====================='), ['Number of Objects = ', num2str(Count)], ['Area = ', num2str(area), ' pixels']}
        set(handles.listbox1, 'String', index)
        hold off;
        
    case 21
        BS_idx = imcrop (BS_upcont, [335 46 90 90]);
        BS_bw = im2bw(BS_idx);
        
        SE = strel('disk', 2);
        BS_Read = imopen(BS_bw,SE); 
        markSpot_image = regionprops(BS_Read,'centroid');
        [labeled,numSpot] = bwlabel(BS_Read,4);
        spot = regionprops(labeled,'Area','BoundingBox');
        object = [spot.Area];

        Spot_number = find(object > 50 & object < 3000); 
        spotDefects = spot(Spot_number);
        
        axes(handles.axes2);
        imshow(BS_idx);
        hold on;
        
        for Point = 1 : length(Spot_number)
            ROI = rectangle('Position', spotDefects(Point).BoundingBox);
            set(ROI, 'EdgeColor', [.9 0 0]);
            hold on;
        end
        for Count = 1:length(object)
            area = spot(Count).Area;
            centroid = spot(Count).BoundingBox;
            
            text(centroid(1),centroid(2),num2str(Count),'Color','y',...
                'FontSize',10,'FontWeight','bold');
            
            disp('===================================')
            disp(strcat(['Number of Object = ', num2str(Count)]))
            disp(strcat(['Area = ',num2str(area), ' pixel']))
        end
        if Count > 0
            title (['There are ', num2str(numSpot), ' objects'])
        end
        
        index = {('====================='), ['Number of Objects = ', num2str(Count)], ['Area = ', num2str(area), ' pixels']}
        set(handles.listbox1, 'String', index)
        hold off;
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
