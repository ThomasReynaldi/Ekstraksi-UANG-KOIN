function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 28-May-2022 17:23:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
[filename,pathname] = uigetfile('*.jpg*.jpeg');
if ~isequal(filename,0)
    set(handles.pushbutton4,'Enable','on')
    set(handles.uitable1,'Data',[])
    axes(handles.axes1)
    cla reset
    set(gca,'XTick',[])
    set(gca,'YTick',[])
    axes(handles.axes2)
    cla reset
    set(gca,'XTick',[])
    set(gca,'YTick',[])
    Img = imread(fullfile(pathname,filename));
    axes(handles.axes1)
    imshow(Img)
    title('Ekstraksi Citra Uang Koin','FontName','Comic Sans MS')
    handles.Img = Img;
    guidata(hObject, handles)
else
    return
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Img = handles.Img;
Img_gray = rgb2gray(Img);
bw = im2bw(Img_gray,graythresh(Img_gray));
bw = imcomplement(bw);
axes(handles.axes3)
imshow(bw);
title('Hasil','FontName','Comic Sans MS')
bw = bwareaopen(bw,100);
bw = imfill(bw,'holes');
str = strel('disk',5);
bw = imclose(bw,str);
bw = imclearborder(bw);
axes(handles.axes4)
imshow(bw);
title('Hasil','FontName','Comic Sans MS')
[B,L] = bwlabel(bw);
stats = regionprops(B,'All');
YCbCr = rgb2ycbcr(Img);
Cb = YCbCr (:,:,2);
axes(handles.axes2)
imshow(Img);
title('Hasil','FontName','Comic Sans MS')
hold on
 
val1 = get(handles.checkbox4,'Value');

if val1==1
    set(handles.pushbutton4,'Enable','on')
    data_koin = zeros(L,1);
    Boundaries = bwboundaries(bw,'noholes');
    for n = 1:L
        boundary = Boundaries(n);
    bw_label = (B==n);
    Cb_label = immultiply(Cb,bw_label);
    Cb_label = (sum(sum(Cb_label)))/(sum(sum(bw_label)));
    
    Area = stats(n).Area;
    centroid = stats(n).Centroid;
    if Cb_label>120
            if Area<45000
                nilai = 100;
            elseif Area<50000 nilai = 200;
            else
                nilai = 500;
            end
            plot(boundary(:,2), boundary(:,1), 'y','LineWidth', 4)          
            text(centroid(1)-50,centroid(2),num2str(nilai),...
                'Color','y','FontSize',20,'FontWeight','bold');
        else
            if Area<50000 nilai=500;
            else
                nilai = 1000;
            end
            plot(boundary(:,2), boundary(:,1), 'c','LineWidth',4)
            text(centroid(1)-50,centroid(2),num2str(nilai),...
                'Color','c','FontSize',20,'FontWeight','bold');
        end
        data_koin(n) = nilai;
    end
    [~,n_100] = find(data_koin==100);
    nilai_100 = numel(n_100);
    [~,n_200] = find(data_koin==200);
    nilai_200 = numel(n_200);
    [~,n_500] = find(data_koin==500);
    nilai_500 = numel(n_500);
    [~,n_1000] = find(data_koin==1000);
    nilai_1000 = numel(n_1000);
    
    nilai_total = nilai_100+nilai_200+nilai_500+nilai_1000;
    
    jumlah_100 = nilai_100*100;
    jumlah_200 = nilai_200*200;
    jumlah_500 = nilai_500*500;
    jumlah_1000 = nilai_1000*1000;
    jumlah_total = jumlah_100+jumlah_200+jumlah_500+jumlah_1000;
    
    cell_koin = cell(5,3);
    
    cell_koin(1,1) = ('Rp. 100');
    cell_koin(2,1) = ('Rp. 200');
    cell_koin(3,1) = ('Rp. 500');
    cell_koin(4,1) = ('Rp. 1000');
    cell_koin(5,1) = 'Total';
    
    cell_koin(1,2) = num2str(nilai_100);
    cell_koin(2,2) = num2str(nilai_200);
    cell_koin(3,2) = num2str(nilai_500);
    cell_koin(4,2) = num2str(nilai_1000);
    cell_koin(5,2) = num2str(nilai_total);
    
    cell_koin(1,3) = ['Rp. ',num2str(jumlah_100)];
    cell_koin(2,3) = ['Rp. ',num2str(jumlah_200)];
    cell_koin(3,3) = ['Rp. ',num2str(jumlah_500)];
    cell_koin(4,3) = ['Rp. ',num2str(jumlah_1000)];
    cell_koin(5,3) = ['Rp. ',num2str(jumlah_total)];
        
    set(handles.uitable1,'Data',cell_koin,...
    'RowName',1:4)
    
    end
    
    
    
   
    
    
    


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4
