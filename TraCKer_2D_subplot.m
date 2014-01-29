function TraCKer_2D_subplot(filename,frames,windowsize)
%Particle Tracker: Input filename, frames, and window size to get tracking.
%{
filname is the name of the tiff file (with extension) that you want to
analyze.
frames is the number of frames in the tiff file.
windowsize is the width of the analysis window.

Version 0.0 created by Comert Kural (kural.1@osu.edu)
Version 1.1 by Josh Ferguson (ferguson.621@osu.edu)
    -changed from a script to a function
    -added comments
    -added waitbars
    -improved menus
        >added close feature
    -cleaned up matlab warnings
        >prealocating arrays
        >cleaned up redundant variables
    -added 'save all' feature
    -allowed option for csv writing instead of xls
 TO DO
    -statistical selection of CCPs
    -statistical slection of frame threshold
    -domain analysis
    -movement prediction
    -fix tracing for inturrupted readings
    -use actual mexican hat filter
%}
windowsize = 2*floor((windowsize+1)/2) - 1;
PixelSize = 10; % nm
mex = -fspecial('log',15,1.5);
%Predefine matrices. J is dynamic, IMG is static.
ss = imread(filename);
s = size(ss);
J = zeros(s(1),s(2),frames,'uint16'); 
IMG = zeros(s(1),s(2),frames,'double');

h = waitbar(0,'Filtering images...');
bar_color_patch_handle = findobj(h,'Type','Patch');
set(bar_color_patch_handle,'EdgeColor','b','FaceColor','b');
for j=1:frames
    IMG(:,:,j) = imread(filename,'Index',j);
    J(:,:,j) = imfilter(IMG(:,:,j),mex,'symmetric');
    waitbar(j / frames)
end
close(h);

MEAN=mean(J,3);
SHOW = J(:,:,2);
Scale=(1:3000)';
colormap(gray);
subplot(1,7,1);
    imagesc(Scale);
    set(gca,'XTickLabel',[]);
    title('Select scaling');

%This section allows you to control the level of specificity that gets put
%into the selecting pit signals. Should eventually be automated for
%statistical selection.
k=0;
while k ~= 1
subplot(1,7,[2 3]);
    imagesc(SHOW);
    set(gca,'XTickLabel',[],'YTickLabel',[]);
subplot(1,7,1);
    if k==2; title('Try again'); end
    [~,Vy] = ginput(1);
    Coeff=Vy;
    imagesc(Scale);
    set(gca,'XTickLabel',[]);
    SHOWDiv=SHOW/Coeff;
subplot(1,7,[4 5]);
    imagesc(SHOWDiv);
    BWSHOW=imregionalmax(SHOWDiv, 4);
    set(gca,'XTickLabel',[],'YTickLabel',[]);
subplot(1,7,[6 7]);
    imagesc(BWSHOW);
    set(gca,'XTickLabel',[],'YTickLabel',[]);
subplot(1,7,1);
    line([.5 1.5],[Coeff Coeff],'Color','g');
    set(gca,'XTickLabel',[]);
k = menu('Do you want to keep this?','Yes','No') ;
end
close;

%Predefine matrix containing binary information of pits.
BW = zeros(s(1),s(2),frames);

h = waitbar(0,'Isolating CCPs...');
bar_color_patch_handle = findobj(h,'Type','Patch');
set(bar_color_patch_handle,'EdgeColor','b','FaceColor','b');
for k =1:frames
    BW(:,:,k) = imregionalmax(J(:,:,k)/Coeff, 8);
    waitbar(k / frames)
end
close(h);

%Predefine matrices for tracking CCPs. BACK and INT have arbitrary
%predefinition (will usually be too small).
B_sample = bwboundaries(BW(:,:,2),'noholes');
BACK = zeros(length(B_sample),frames);
INT = zeros(length(B_sample),frames);
Xc = zeros(frames,1);
Yc = zeros(frames,1);

h = waitbar(0,'Locating CCPs...');
bar_color_patch_handle = findobj(h,'Type','Patch');
set(bar_color_patch_handle,'EdgeColor','b','FaceColor','b');
for k=1:frames
    B = bwboundaries(BW(:,:,k),'noholes');
    q=0;
for m=1:length(B)
c=cell2mat(B(m));
    q=q+1;
Py=uint16(mean(c(:,1)));
Px=uint16(mean(c(:,2)));

bigwindowsize = windowsize + 4;
if (Px-(bigwindowsize+1)/2)<1
    Px=(bigwindowsize+1)/2;
end
if (Py-(bigwindowsize+1)/2)<1
    Py=(bigwindowsize+1)/2;
end
if (Px+(bigwindowsize+1)/2)>s(2)
    Px=s(2)-(bigwindowsize+1)/2;
end
if (Py+(bigwindowsize+1)/2)>s(1)
    Py=s(1)-(bigwindowsize+1)/2;
end

%DEFINE Window
Window = zeros(windowsize,windowsize);
for i=1:windowsize
    for j=1:windowsize
    Window(i,j)=IMG(Py-(windowsize+1)/2+i,Px-(windowsize+1)/2+j,k);
    end 
end

%DEFINE Big Window
BigWindow = zeros(bigwindowsize,bigwindowsize);
for i=1:bigwindowsize
    for j=1:bigwindowsize
    BigWindow(i,j)=IMG(Py-(bigwindowsize+1)/2+i,Px-(bigwindowsize+1)/2+j,k);
    end 
end

%Each particle is assigned a background intensity.
BACKmean=[min(mean(BigWindow,1)),min(mean(BigWindow,2))];
BACK(q,k)=min(BACKmean);

%FIND Total Intensity
INT(q,k)=sum(sum(Window))-BACK(q,k)*(windowsize)^2;

TopX=zeros(windowsize,1);
TopY=zeros(windowsize,1);
WSumX=0;
WSumY=0;

%Finding the center of intensity
for j=1:windowsize
   TopX(j)=sum(Window(:,j));
end
TopX=TopX-min(TopX);
TopRow=sum(TopX);

for j=1:windowsize
    WSumX=WSumX+j*TopX(j);
end

for i=1:windowsize
   TopY(i)=sum(Window(i,:));
end
TopY=TopY-min(TopY);
TopColum=sum(TopY);

for i=1:windowsize
    WSumY=WSumY+i*TopY(i);
end

Xc(k)=WSumX/TopRow;
Yc(k)=WSumY/TopColum;

%Using center of intensity to augment middle of the spot.
X(q,k)=double(Px)+Xc(k)-double((windowsize+1)/2); %#ok<AGROW>
Y(q,k)=double(Py)+Yc(k)-double((windowsize+1)/2); %#ok<AGROW>

end
waitbar(k / frames)
end
close(h)

[Boy,~]=size(X);
TraceX = zeros(Boy,frames);
TraceY = zeros(Boy,frames);
TraceINT = zeros(Boy,frames);

p=0;                          %trace number
dt = uint8((windowsize+1)/2); %distance threshold
ft = uint8(5);                %frame threshold (needs statistical definition)

h = waitbar(0,'Creating traces...');
bar_color_patch_handle = findobj(h,'Type','Patch');
set(bar_color_patch_handle,'EdgeColor','b','FaceColor','b');
for k=1:frames-1
    for m=1:Boy
        if X(m,k)>0
        if X(m,k)<s(2)
            tracex=zeros(1,frames);
            tracey=zeros(1,frames);
            traceint=zeros(1,frames);

        dif=Inf(Boy);
        difbin=zeros(Boy,frames-k+1,'uint8');
        
        for l=1:frames-k+1
            %create distance vector to find distance of all particles from
            %X(m,k), with the object of finding the closest
            for n=1:Boy
                dif(n)=sqrt((X(m,k)-X(n,k+l-1))^2+(Y(m,k)-Y(n,k+l-1))^2);
            end
            for n=1:Boy
                if dif(n)<dt
                    if dif(n)==min(dif(:))
                        if l>ft
                        %sets a frame threshold, where if we recieve no
                        %signal from this area, constrained by the distance
                        %threshold, for ft frames then it could just be a
                        %new particle taking its place in the same region
                        if sum(sum(difbin(:,l-ft:l-1))) == 0, break, end
                        end
                    %when closest point is found, mark it in difbin
                    difbin(n,l)=1;
                    break
                    end
                end
            end
        end
        
       
            %Load temporary trace vectors with x, y, and intensity data.
            for n=1:Boy
                for l=1:frames-k+1
                    if difbin(n,l)==1;
                        tracex(k+l-1)=X(n,k+l-1);
                        tracey(k+l-1)=Y(n,k+l-1);
                        traceint(k+l-1)=INT(n,k+l-1);
                        %Now that these points have appeared in a trace we
                        %have to make sure they no longer appear in any
                        %further traces, so we set them to infinity.
                        X(n,k+l-1)=Inf; %#ok<AGROW>
                        Y(n,k+l-1)=Inf; %#ok<AGROW>
                    end
                end
            end    
        
        %Loading a more permanent trace vector, filtering out traces which
        %are too short and that aren't made of consecutive points, also
        %creating a new numbering system.
        pos = [find(tracex) 0];
        num=numel(pos)-1;
        if num>ft
             son=zeros(1,num+1);
             son(2:num+1)=pos(1:num);
             fark=pos-son;
             if numel(find(fark==1))>(ft-1)
                p=p+1;
                TraceX(p,:)=tracex;
                TraceY(p,:)=tracey;
                TraceINT(p,:)=traceint;
             end
        end
        end
        end
    end
waitbar(k / (frames-1))
end
close(h);

[Boy2,~]=size(TraceX); %Boy2 is the number of traces.
%Makes a directory for csv files. If you have Excel, comment this out and
%use a single xls file with sheets. see line 395
foldername = sprintf('%s_%u',filename(1:length(filename)-5),uint16(Coeff));
mkdir(foldername);
%trace_filename=[filename, '.xls'];

l = menu('Would you like to...','Save all traces?','Manually choose a few?');

if l == 2
    h = msgbox('Creating image...'); %function modified from msgbox
        subplot(2,2,[1 3])
        imshow(-MEAN,[]);
        hold;
    colors='brgkycm';
    for i=1:Boy2
    j=mod(i,7);
    if j==0, j=7; end
    subplot(2,2,[1 3]) %make a big plot of all traces overlaying mean image
    plot(TraceX(i,TraceX(i,:)>0), TraceY(i,TraceY(i,:)>0), colors(j), 'linewidth', 2);
    hold on;
    end
    close(h)
end
Tx = 0;
Ty = 0;
k = uint8(0);
while k ~= 4 %4 menu options, and the last option closes
    if l == 2
        [Tx,Ty] = ginput(1); %click on a trace to see it in more detail
    end
    for m=1:Boy2
        MeanX=mean(TraceX(m,TraceX(m,:)>0));
        MeanY=mean(TraceY(m,TraceY(m,:)>0));
         if sqrt((MeanX-Tx)^2+(MeanY-Ty)^2)<windowsize || l == 1
             T=find(TraceX(m,:));
             if l == 2
                j=mod(m,7);
                if j==0, j=7; end  
                TX=TraceX(m,T);
                TY=TraceY(m,T);
                %here we plot the x-y details of the CCP
                subplot(2,2,2);
                plot(TX,s(1)-TY,colors(j),'LineWidth',3);
                %here we plot intensity data of what we know to be a CCP
                subplot(2,2,4);
                plot(find(TraceINT(m,:)>0),TraceINT(m,TraceINT(m,:)>0),'bo','LineWidth',3);
                hold;
             end
             %we have, however, left out all the stuff between what we know
             %is a CCP, so to do that we use the for loop below to add in
             %any missing intensity data
             for n=1:frames
                 if TraceX(m,n)==0
                     for j=1:numel(T)
                         %we want to use the window that worked for the
                         %closest reading of a CCP
                         if abs(n-T(j))==min(abs(n-T))
                             Px=uint16(TraceX(m,T(j)));
                             Py=uint16(TraceY(m,T(j)));

                             if (Px-(bigwindowsize+1)/2)<1
                                 Px=(bigwindowsize+1)/2;
                             end
                             if (Py-(bigwindowsize+1)/2)<1
                                 Py=(bigwindowsize+1)/2;
                             end
                             if (Px+(bigwindowsize+1)/2)>s(2)
                                 Px=s(2)-(bigwindowsize+1)/2;
                             end
                             if (Py+(bigwindowsize+1)/2)>s(1)
                                 Py=s(1)-(bigwindowsize+1)/2;
                             end

                             WindowIm = zeros(windowsize);
                             for a=1:windowsize
                                 for b=1:windowsize
                                     WindowIm(a,b)=IMG(Py-(windowsize+1)/2+a,Px-(windowsize+1)/2+b,n);
                                 end
                             end
                             BigWindowIm = zeros(bigwindowsize);
                             for a=1:bigwindowsize
                                 for b=1:bigwindowsize
                                     BigWindowIm(a,b)=IMG(Py-(bigwindowsize+1)/2+a,Px-(bigwindowsize+1)/2+b,n);
                                 end
                             end

                             INTIm=sum(sum(WindowIm))-min(mean(BigWindowIm))*(windowsize)^2;
                             TraceINT(m,n)=INTIm;
                             TraceX(m,n)=NaN; %we're just looking at a window so it
                             TraceY(m,n)=NaN; %makes no sense to record position data

                         end
                     end
                 end
             end
         if l == 2    
             %finish the plot
             subplot(2,2,4);
             plot(TraceINT(m,:),'r','LineWidth',3);
             hold;
  
             k = menu('Do you want to keep this?','Yes and Continue','No and Continue','Yes and Quit','No and Quit') ;
         end    
             %if the CCP is good then throw that data into a file or a sheet
              if (k == 1 || k == 3) || l == 1
                  Tr=NaN(frames,4);
                  Tr(:,1)=1:frames;   % Frame Num
                  Tr(:,2)=TraceX(m,:)*PixelSize;  % X
                  Tr(:,3)=TraceY(m,:)*PixelSize;  % Y
                  Tr(:,4)=TraceINT(m,:);  % INT
                 
                  index=find(TraceX(m,:)>0, 1 );
                  
                  %below is code to write to a folder of csv's, or an xls
                  %file with multiple sheets. see line 283
                  trace_filename = [int2str(uint16(Tr(index,2)/PixelSize)), '_', int2str(uint16(Tr(index,3)/PixelSize))];
                  trace_path = sprintf('%s\\%s.csv',foldername,trace_filename);
                  csvwrite(trace_path,Tr);
                  %sheetname=[int2str(uint16(Tr(index,2)/PixelSize)), '-', int2str(uint16(Tr(index,3)/PixelSize))];
                  %xlswrite(trace_filename, Tr, sheetname);
                  if k == 3, k=4; break; end
              end
              
              if k ==4, break; end
             
         end
    end
    if l == 1, k = 4; end
end
close;
end

function [ A ] = gen_mexi_2D( size )
%2D Mexi Hat: Generates a normalized 2D mexican hat filter
bound = 5; % boundary for mexican hat
size = floor(size/2)*2+1; % ensure we have odd number
max = ceil(size/2); % find mid point of odd number
scale = max/bound; % relate indexing to actual value
resolution = 100000; % resolution of function

% special mexihat_r function for 2D purposes
% altered to allow for laplacian in cylindrical coordinates
mexi = mexihat_r(0,bound*sqrt(2),floor(bound*resolution*sqrt(2)));
A = zeros(size,'double');
for i=1:size
    for j=1:size
        if (i == max && j == max), A(i,j) = mexi(1);
        else
            r = sqrt(((i-max)/scale)^2+((j-max)/scale)^2);
            A(i,j) = mexi(floor(r*resolution));
        end
    end
end
end

function [out1,out2] = mexihat_r(LB,UB,N)
%MEXIHAT_R Used for 2D Mexican hat wavelet.
%   [PSI,X] = MEXIHAT_R(LB,UB,N) returns values of 
%   the 2D Mexican hat wavelet on an N point regular
%   grid in the interval [LB,UB].
%   Output arguments are the wavelet function PSI
%   computed on the grid X.

% Compute values of the Mexican hat wavelet.
out2 = linspace(LB,UB,N);        % wavelet support.
out1 = out2.^2;
out1 = (2/(sqrt(3)*pi^0.25)) * exp(-out1/2) .* (2-out1);
end