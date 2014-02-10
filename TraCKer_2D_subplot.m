function TraCKer_2D_subplot(filename,frames, varargin)
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
    -began development branch in Git
    -all future changes will be recorded with Git
 TO DO
    -statistical slection of frame threshold
    -domain analysis
    -movement prediction
    -fix tracing for inturrupted readings
    -take all except
    -mark selected traces
%}
if nargin == 2
    windowsize = 5; filter = 'a';
elseif nargin == 3
    windowsize = varargin{1}; filter = 'a';
elseif nargin == 4
    windowsize = varargin{1}; filter = varargin{2};
else
    error('Too many input arguments');
end

windowsize = 2*floor((windowsize+1)/2) - 1;
PixelSize = 160; % nm
mex = -fspecial('log',13,1.5);
%Predefine matrices. J is dynamic, IMG is static.
ss = imread(filename);
s = size(ss);
J = zeros(s(1),s(2),frames,'uint16'); 
IMG = zeros(s(1),s(2),frames,'double');
scale = ones([1,frames],'double');

h = waitbar(0,'Filtering images...');
bar_color_patch_handle = findobj(h,'Type','Patch');
set(bar_color_patch_handle,'EdgeColor','b','FaceColor','b');
for j=1:frames
    IMG(:,:,j) = imread(filename,'Index',j);
    J(:,:,j) = imfilter(IMG(:,:,j),mex,'symmetric');
    if filter == 'a'
        [x,y] = create_histogram(J(:,:,j));
        scale(j) = best_fit_approx_n(x,y,5);
    end
    waitbar(j / frames)
end
close(h);

MEAN=mean(J,3);
if filter == 'm'
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
    
    for k = 1:frames
        scale(k) = Coeff;
    end
end

if (filter ~= 'm' || filter ~= 'a')
    for k = 1:frames
        scale(k) = filter;
    end
end

%Predefine matrix containing binary information of pits.
BW = zeros(s(1),s(2),frames);

h = waitbar(0,'Isolating CCPs...');
bar_color_patch_handle = findobj(h,'Type','Patch');
set(bar_color_patch_handle,'EdgeColor','b','FaceColor','b');
for k =1:frames
    BW(:,:,k) = imregionalmax(J(:,:,k)/scale(k), 8);
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
X(q,k)=double(Px)+Xc(k)-double((windowsize+1)/2); %#ok<*AGROW>
Y(q,k)=double(Py)+Yc(k)-double((windowsize+1)/2);

end
waitbar(k / frames)
end
close(h)

[Boy,~]=size(X);
for j = 1:frames
    for i = 1:Boy
        if X(i,j) == 0, X(i,j) = Inf; end
        if Y(i,j) == 0, Y(i,j) = Inf; end
    end
end
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
        if (X(m,k)>0 && X(m,k)<s(2))
            tracex=zeros(1,frames);
            tracey=zeros(1,frames);
            traceint=zeros(1,frames);

        dif=Inf([1,Boy]);
        check_dif=Inf([1,Boy]);
        check=zeros([1,frames],'uint16');
        dum_x = X(m,k);
        dum_y = Y(m,k);
        
        l = k;
        check(l) = m;
        while l <= frames - 1
            %create distance vector to find distance of all particles from
            %X(m,k), with the object of finding the closest
            for n=1:Boy
                dif(n)=sqrt((dum_x-X(n,l+1))^2+(dum_y-Y(n,l+1))^2);
            end
            check(l+1) = find(dif==min(dif));
            for n=1:Boy
                check_dif(n)=sqrt((X(check(l+1),l+1)-X(n,l))^2+(Y(check(l+1),l+1)-Y(n,l))^2);
            end
            if (find(check_dif==min(check_dif)) ~= check(l) || dif(check(l+1))>dt)
                check(l+1) = 0;
            else
                dum_x = X(check(l+1),l+1); dum_y = Y(check(l+1),l+1);
            end
                if (l-k)>ft
                        %sets a frame threshold, where if we recieve no
                        %signal from this area, constrained by the distance
                        %threshold, for ft frames then it could just be a
                        %new particle taking its place in the same region
                        if sum(check(l-ft:l)) == 0, break, end
                end
            l = l+1;
        end
        
       
            %Load temporary trace vectors with x, y, and intensity data.
            for l=k:frames
                if check(l) ~= 0;
                    tracex(l)=X(check(l),l);
                    tracey(l)=Y(check(l),l);
                    traceint(l)=INT(check(l),l);
                    %Now that these points have appeared in a trace we
                    %have to make sure they no longer appear in any
                    %further traces, so we set them to infinity.
                    X(check(l),l)=Inf;
                    Y(check(l),l)=Inf;
                end
            end
        
        %Loading a more permanent trace vector, filtering out traces which
        %are too short and that aren't made of consecutive points, also
        %creating a new numbering system.
        pos = [find(tracex) 0];
        num=numel(pos);
        if num>ft
             son=zeros(1,num);
             son(2:num)=pos(1:num-1);
             fark=pos-son;
             if numel(find(fark==1))>=ft
                p=p+1;
                TraceX(p,:)=tracex;
                TraceY(p,:)=tracey;
                TraceINT(p,:)=traceint;
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
foldername = sprintf('%s_%u',filename(1:length(filename)-4),max(scale));
mkdir(foldername);
%trace_filename=[filename, '.xls'];

l = menu('Would you like to...','Save all traces?','Manually choose a few?');

if l == 2
    h = msgbox('Creating image...'); %function modified from msgbox
        subplot(2,2,[1 3])
        imshow(-MEAN,[]);
        hold;
    colors='brgycm';
    for i=1:Boy2
    j=6-mod(i,6);
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
    if l == 2, [Tx,Ty] = ginput(1); end %click on a trace to see it in more detail
    for m=1:Boy2
        MeanX=mean(TraceX(m,TraceX(m,:)>0));
        MeanY=mean(TraceY(m,TraceY(m,:)>0));
         if (sqrt((MeanX-Tx)^2+(MeanY-Ty)^2)<windowsize || l == 1)
             T=find(TraceX(m,:));
             if l == 2
                j=6-mod(m,6);
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
             subplot(2,2,[1 3]);
             plot(TraceX(m,TraceX(m,:)>0), TraceY(m,TraceY(m,:)>0), 'k', 'linewidth', 2);
  
             k = menu('Do you want to keep this?','Yes and Continue','No and Continue','Yes and Quit','No and Quit') ;
         end    
             %if the CCP is good then throw that data into a file or a sheet
              if ((k == 1 || k == 3) || l == 1)
                  Tr=NaN(frames,4);
                  Tr(:,1)=1:frames;   % Frame Num
                  Tr(:,2)=TraceX(m,:)*PixelSize;  % X
                  Tr(:,3)=TraceY(m,:)*PixelSize;  % Y
                  Tr(:,4)=TraceINT(m,:);  % INT
                 
                  indexf=find(TraceX(m,:)>0, 1, 'first' );
                  indexl=find(TraceX(m,:)>0, 1, 'last' );
                  
                  %below is code to write to a folder of csv's, or an xls
                  %file with multiple sheets. see line 283
                  trace_filename = [int2str(uint16(Tr(indexf,1))), '_', int2str(uint16(Tr(indexf,2)/PixelSize)), 'x', int2str(uint16(Tr(indexf,3)/PixelSize)), 'y', '_to_',int2str(uint16(Tr(indexl,2)/PixelSize)), 'x', int2str(uint16(Tr(indexl,3)/PixelSize)), 'y'];
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
save('test.mat');
end

function [ x, y ] = create_histogram (J)
%Creating a log-scaled histogram of image intensities.
[why,ex] = hist(double(J(:)),single(max(max(J))));
y = why(2:length(why));
x = ex(2:length(ex));
y = log(y+1);
end

function [ scale ] = best_fit_approx_n( x, y, n )
%Smooth a function using straight line approximations.
%   Currently store a bunch of detailed variables, but 
%   I only need it for the x intercept.
w = 2*n+1;
xx = x(1);
for i = 1:(length(x)-1)
    if i <= n
        d = (x(i+1)-x(i))/(n+1-i);
    elseif i >= (length(x)-n)
        d = (x(i+1)-x(i))/(n-(length(x)-1-i));
    else
        d = 1;
    end
        
        xx = [xx (x(i)+d):d:x(i+1)];
end
yy = spline(x,y,xx);

new_y = zeros([1,length(y)]);
m = zeros([1,length(y)]);
x_int = zeros([1,length(y)]);
r = zeros([1,length(y)]);

new_y(1) = y(1);
new_y(length(y)) = y(length(y));


k = 1+n; i = 2;
while k<length(xx)
    xsum = 0; ysum = 0; xsum2 = 0; ysum2 = 0; xysum = 0;
    for j = (k-n):(k+n)
        xsum = xsum + xx(j);
        ysum = ysum + yy(j);
        xsum2 = xsum2 + xx(j)^2;
        ysum2 = ysum2 + yy(j)^2;
        xysum = xysum + xx(j)*yy(j);
    end
    
    if ysum2 == 0
        m(i)=0;new_y(i)=0;x_int(i)=0;r(i)=0;
    else
        sx = sqrt((xsum2-xsum^2/w)/(w-1));
        sy = sqrt((ysum2-ysum^2/w)/(w-1));
        m(i) = (w*xysum - xsum*ysum)/(w*xsum2-xsum^2);
        b = (ysum - m(i)*xsum)/w;
        new_y(i) = m(i)*xx(k)+b;
        x_int(i) = -b/m(i);
        r(i) = ((xysum-xsum*ysum/w)/((w-1)*sx*sy))^2;
    end
    
    if i < n
        k = k+1+n-i;
    elseif i > (length(x)-n)
        k = k+1+n-(length(x)-i);
    else
        k = k+1;
    end
    i=i+1;    
end
done = false; dum = false; i = 2;
while done ~= true
    dum = [dum r(i)>0.95];
    if (r(i)>0.95 && r(i+1)<0.95 && r(i+2)<0.95), done=true; end
    i=i+1;
end
scale = ceil(mean(x_int(dum)));
end