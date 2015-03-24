function [X, Y, Z, Coeff] = spotfinder_3D_by_z(filename,varargin)
%spotfinder: Input filename, frames, and window size to get tracking.
%{
filname is the name of the tiff file (with extension) that you want to
analyze.
folder of z slices must have same name as filename (minus .tif)
windowsize is the width of the analysis window.
%}
if nargin < 1
    input('Filename of max projection?: ', filename);
elseif nargin == 1
    windowsize = 5; filter = 'm';
elseif nargin == 2
    windowsize = varargin{1}; filter = 'm';
elseif nargin == 3
    if ischar(varargin{2}) && varargin{2} ~= 'm'
        error('Fourth argument must be ''m'' or a number.')
    else
        windowsize = varargin{1}; filter = varargin{2};
    end
else
    error('Too many input arguments');
end

windowsize = 2*floor((windowsize+1)/2) - 1;
mask = zeros(windowsize);
for i = 1:windowsize
    for j = 1:windowsize
        if (i-.5-windowsize/2)^2 + (j-.5-windowsize/2)^2 < (windowsize/2)^2
            mask(i,j) = 1;
        end
    end
end
bigwindowsize = windowsize + 4;
mex = -fspecial('log',9,1.5);
%Predefine matrices. J is dynamic, IMG is static.
ss = imread(filename);
s = size(ss);

% Find Z position
if strcmp(filename(end-3:end),'tiff')
    stackfol = filename(1:end-5);
    stackfiles = dir([stackfol '\*.tif*']);
elseif strcmp(filename(end-2:end),'tif')
    stackfol = filename(1:end-4);
    stackfiles = dir([stackfol '\*.tif*']);
end
if isempty(stackfiles), error('Wrong folder name'); end
zstacks = length(stackfiles);
Coeff = zeros(1,zstacks);
stack = cell(1,zstacks);
for l=1:zstacks
    stack{l}=imread(strcat(stackfol,'\',stackfiles(l).name));
end
    
for l=1:zstacks
    IMG = stack{l};
    J = imfilter(IMG,mex,'symmetric');
    
    if filter == 'm'
        Scale=(min(J(:)):max(J(:)))';
        figure('units','normalized','outerposition',[0 0 1 1]);
        subplot(1,7,1);
        imagesc(Scale);
        set(gca,'XTickLabel',[]);
        title('Select scaling');
        
        %This section allows you to control the level of specificity that gets put
        %into the selecting pit signals. Should eventually be automated for
        %statistical selection.
        men=0;
        while men ~= 1
            ax1 = subplot(1,7,[2 3]);
            imagesc(J);
            colormap(gray);
            set(ax1,'XTickLabel',[],'YTickLabel',[]);
            subplot(1,7,1);
            if men==2; title('Try again'); end
            [~,Vy] = ginput(1);
            Coeff(l)=Vy;
            imagesc(Scale);
            set(gca,'XTickLabel',[]);
            JDiv=J/Coeff(l);
            ax2 = subplot(1,7,[4 5]);
            imagesc(JDiv);
            BWJ=imregionalmax(JDiv, 4);
            [r, c] = find(BWJ);
            set(ax2,'XTickLabel',[],'YTickLabel',[]);
            ax3 = subplot(1,7,[6 7]);
            imagesc(BWJ);
            set(ax3,'XTickLabel',[],'YTickLabel',[]);
            set(ax1,'XLim',[min(c) max(c)], 'YLim',[min(r) max(r)]);
            set(ax2,'XLim',[min(c) max(c)], 'YLim',[min(r) max(r)]);
            set(ax3,'XLim',[min(c) max(c)], 'YLim',[min(r) max(r)]);
            subplot(1,7,1);
            line([.5 1.5],[Coeff(l) Coeff(l)],'Color','g');
            set(gca,'XTickLabel',[]);
            men = menu('Do you want to keep this?','Yes','No') ;
        end
        close;
    elseif ~ischar(filter)
        Coeff(l) = filter;
    end
    
    J = J/Coeff(l);
    J = im2bw(J,0);
    J = double(J).*double(IMG);
    
    
    BW = imregionalmax(floor(double(J)), 8);
    
    
    B = bwboundaries(BW,'noholes');
    k = 1;
    for m=1:length(B)
        c=cell2mat(B(m));
        Py=uint16(mean(c(:,1)));
        Px=uint16(mean(c(:,2)));
        
        if (Px-(bigwindowsize+1)/2)<1 || (Py-(bigwindowsize+1)/2)<1 || (Px+(bigwindowsize+1)/2)>s(2) || (Py+(bigwindowsize+1)/2)>s(1)
            [Window, BigWindow] = make_windows(Px,Py,windowsize,s,IMG);
        else
            Window = zeros(windowsize,windowsize);
            for i=1:windowsize
                for j=1:windowsize
                    Window(i,j)=IMG(Py-(windowsize+1)/2+i,Px-(windowsize+1)/2+j);
                end
            end
            if ~isempty(find(Window==0,1)), continue; end
            Window = Window.*mask;
            BigWindow = zeros(bigwindowsize,bigwindowsize);
            for i=1:bigwindowsize
                for j=1:bigwindowsize
                    BigWindow(i,j)=IMG(Py-(bigwindowsize+1)/2+i,Px-(bigwindowsize+1)/2+j);
                end
            end
        end
        
        %Each particle is assigned a background intensity.
        BACK(k)=min([min(mean(BigWindow,1)),min(mean(BigWindow,2))]);
        
        %FIND Total Intensity
        INT(k)=(sum(Window(:))/sum(mask(:))-BACK(k))*(windowsize)^2;
        
        TopX=zeros(windowsize,1);
        TopY=zeros(windowsize,1);
        WSumX=0;
        WSumY=0;
        
        %Finding the center of intensity
        for j=1:size(Window,2)
            TopX(j)=sum(Window(:,j));
        end
        TopX=TopX-min(TopX);
        TopRow=sum(TopX);
        
        for j=1:size(Window,2)
            WSumX=WSumX+j*TopX(j);
        end
        
        for i=1:size(Window,1)
            TopY(i)=sum(Window(i,:));
        end
        TopY=TopY-min(TopY);
        TopColum=sum(TopY);
        
        for i=1:size(Window,1)
            WSumY=WSumY+i*TopY(i);
        end
        
        Xc=WSumX/TopRow;
        Yc=WSumY/TopColum;
        
        %Using center of intensity to augment middle of the spot.
        X{l}(k)=double(Px)+Xc-double((windowsize+1)/2); %#ok<*AGROW>
        Y{l}(k)=double(Py)+Yc-double((windowsize+1)/2);
        
        TopZr = zeros(1,length(max(1,l-2):min(zstacks,l+2)));
        BACKZ = zeros(1,length(max(1,l-2):min(zstacks,l+2)));
        o = 1;
        for n = max(1,l-2):min(zstacks,l+2)
            
            if (Px-(bigwindowsize+1)/2)<1 || (Py-(bigwindowsize+1)/2)<1 || (Px+(bigwindowsize+1)/2)>s(2) || (Py+(bigwindowsize+1)/2)>s(1)
                [ZWindow, BigZWindow] = make_windows(Px,Py,windowsize,s,stack{n});
            else
                ZWindow = zeros(windowsize,windowsize);
                for i=1:windowsize
                    for j=1:windowsize
                        ZWindow(i,j)=stack{n}(Py-(windowsize+1)/2+i,Px-(windowsize+1)/2+j);
                    end
                end
                
                BigZWindow = zeros(bigwindowsize,bigwindowsize);
                for i=1:bigwindowsize
                    for j=1:bigwindowsize
                        BigZWindow(i,j)=stack{n}(Py-(bigwindowsize+1)/2+i,Px-(bigwindowsize+1)/2+j);
                    end
                end
            end
            
            %Each particle is assigned a background intensity.
            BACKZ(o)=min([min(mean(BigZWindow,1)),min(mean(BigZWindow,2))]);
            
            %FIND Total Intensity
            TopZr(o)=sum(sum(ZWindow-BACKZ(o)));
            o = o + 1;
        end
        TopZ=TopZr-min(TopZr);
        Z{l}(k)=sum((max(1,l-2):min(zstacks,l+2)).*TopZ)/sum(TopZ);
    k = k+1;
    end
end


%{
rgbIMG = repmat(uint8((2^(-8))*(IMG+1)-1),[1 1 3]);
for i = 1:length(X)
    rgbIMG(floor(Y(i)),floor(X(i)),1) = 255;
    rgbIMG(ceil(Y(i)),ceil(X(i)),1) = 255;
    rgbIMG(floor(Y(i)),floor(X(i)),2) = 0;
    rgbIMG(ceil(Y(i)),ceil(X(i)),2) = 0;
    rgbIMG(floor(Y(i)),floor(X(i)),3) = 0;
    rgbIMG(ceil(Y(i)),ceil(X(i)),3) = 0;
end
imwrite(rgbIMG,strcat(stackfol,'_overlay.tif'));
%}
end

function [Window, BigWindow] = make_windows(Px,Py,windowsize,s,IMG)
bigwindowsize = windowsize + 4;
Window = 0; BigWindow = 0;

if (Px-(bigwindowsize+1)/2)<1 && (Py-(bigwindowsize+1)/2)<1
    for i=1:(windowsize-1)/2-Py
        for j=1:(windowsize-1)/2-Px
            Window(i,j)=IMG(i,j);
        end
    end
    
    for i=1:(bigwindowsize-1)/2-Py
        for j=1:(bigwindowsize-1)/2-Px
            BigWindow(i,j)=IMG(i,j);
        end
    end
    
elseif (Px-(bigwindowsize+1)/2)<1 && (Py+(bigwindowsize+1)/2)>s(1)
    for i=(Py-(windowsize-1)/2):s(1)
        for j=1:(windowsize-1)/2-Px
            Window(i+1-(Py-(windowsize-1)/2),j)=IMG(i,j);
        end
    end
    
    for i=(Py-(bigwindowsize-1)/2):s(1)
        for j=1:(bigwindowsize-1)/2-Px
            BigWindow(i+1-(Py-(bigwindowsize-1)/2),j)=IMG(i,j);
        end
    end
    
    
    
elseif (Px+(bigwindowsize+1)/2)>s(2) && (Py-(bigwindowsize+1)/2)<1
    for i=1:(windowsize-1)/2-Py
        for j=(Px-(windowsize-1)/2):s(2)
            Window(i,j+1-(Px-(windowsize-1)/2))=IMG(i,j);
        end
    end
    
    for i=1:(bigwindowsize-1)/2-Py
        for j=(Px-(bigwindowsize-1)/2):s(2)
            BigWindow(i,j+1-(Px-(bigwindowsize-1)/2))=IMG(i,j);
        end
    end
    
elseif (Px+(bigwindowsize+1)/2)>s(2) && (Py+(bigwindowsize+1)/2)>s(1)
    for i=(Py-(windowsize-1)/2):s(1)
        for j=(Px-(windowsize-1)/2):s(2)
            Window(i+1-(Py-(windowsize-1)/2),j+1-(Px-(windowsize-1)/2))=IMG(i,j);
        end
    end
    
    for i=(Py-(bigwindowsize-1)/2):s(1)
        for j=(Px-(bigwindowsize-1)/2):s(2)
            BigWindow(i+1-(Py-(bigwindowsize-1)/2),j+1-(Px-(bigwindowsize-1)/2))=IMG(i,j);
        end
    end
    
elseif (Px-(bigwindowsize+1)/2)<1 && (Py-(bigwindowsize+1)/2)>=1 && (Py+(bigwindowsize+1)/2)<=s(1)
    for i=1:windowsize
        for j=1:(windowsize-1)/2-Px
            Window(i,j)=IMG(Py-(windowsize+1)/2+i,j);
        end
    end
    
    for i=1:bigwindowsize
        for j=1:(bigwindowsize-1)/2-Px
            BigWindow(i,j)=IMG(Py-(bigwindowsize+1)/2+i,j);
        end
    end
    
elseif (Px+(bigwindowsize+1)/2)>s(2) && (Py-(bigwindowsize+1)/2)>=1 && (Py+(bigwindowsize+1)/2)<=s(1)
    for i=1:windowsize
        for j=(Px-(windowsize-1)/2):s(2)
            Window(i,j+1-(Px-(windowsize-1)/2))=IMG(Py-(windowsize+1)/2+i,j);
        end
    end
    
    for i=1:bigwindowsize
        for j=(Px-(bigwindowsize-1)/2):s(2)
            BigWindow(i,j+1-(Px-(bigwindowsize-1)/2))=IMG(Py-(bigwindowsize+1)/2+i,j);
        end
    end
    
elseif (Py-(bigwindowsize+1)/2)<1 && (Px-(bigwindowsize+1)/2)>=1 && (Px+(bigwindowsize+1)/2)<=s(2)
    for i=1:(windowsize-1)/2-Py
        for j=1:windowsize
            Window(i,j)=IMG(i,Px-(windowsize+1)/2+j);
        end
    end
    
    for i=1:(bigwindowsize-1)/2-Py
        for j=1:bigwindowsize
            BigWindow(i,j)=IMG(i,Px-(bigwindowsize+1)/2+j);
        end
    end
    
elseif (Py+(bigwindowsize+1)/2)>s(1) && (Px-(bigwindowsize+1)/2)>=1 && (Px+(bigwindowsize+1)/2)<=s(2)
    for i=(Py-(windowsize-1)/2):s(1)
        for j=1:windowsize
            Window(i+1-(Py-(windowsize-1)/2),j)=IMG(i,Px-(windowsize+1)/2+j);
        end
    end
    
    for i=(Py-(bigwindowsize-1)/2):s(1)
        for j=1:bigwindowsize
            BigWindow(i+1-(Py-(bigwindowsize-1)/2),j)=IMG(i,Px-(bigwindowsize+1)/2+j);
        end
    end
end
end