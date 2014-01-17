clear;
%READ the ORIGINAL file
reply = input('Enter the name of the ORIGINAL file you wanna analyze (with the extension)   ', 's');
[Boy1,En1]=size(imread(reply));

%READ Number of Frames
Frames = input('Enter the number of Frames   ');

%READ Window Size
WindowSize = input('Enter the Window Size (pixels)   ');
BigWindowSize=WindowSize+4;

%READ Pixel Size
PixelSize= input('Enter the Pixel Size (nanometers)   ');

%%
gaus=fspecial('gaussian', 5, 1.5);
lap=[-1,-1,-1;-1,8,-1;-1,-1,-1];

for j=1:Frames
    J(:,:,j) = imread(reply,j);
    J(:,:,j) = imfilter(J(:,:,j),gaus,'symmetric');
    J(:,:,j) = imfilter(J(:,:,j),lap,'symmetric');
end
 
% for j=2:Frames-1
%     J(:,:,j)=(J(:,:,j-1)+J(:,:,j)+J(:,:,j+1))/3;
% end

MEAN=mean(J,3);

J=uint16(J);

SHOW = J(:,:,2);
SHOW=uint16(SHOW);
Scale=[1:1:3000];

subplot(1,7,1);
imagesc(Scale');

for i=1:1000
subplot(1,7,[2 3]);
imagesc(SHOW);
[Vx,Vy] = ginput(1);
    Coeff=Vy;
    SHOWDiv=SHOW/Coeff;
subplot(1,7,[4 5]);
imagesc(SHOWDiv);
    BWSHOW=imregionalmax(SHOWDiv, 4);
subplot(1,7,[6 7]);
imagesc(BWSHOW);
colormap(pink);

k = menu('Do you want to keep this?','Yes','No') ;
    if k==1, break, end
end

close;
for i=1:WindowSize
    x(i)=i;
end

for j=1:WindowSize
    n(j)=j;
end

x=x';
n=n';

for k=1:Frames
%     I = imread(reply1,k);
    I = J(:,:,k);
    I=uint16(I);
    N = I/Coeff; 

    BW = imregionalmax(N, 8);
    bw(:,:,k)=BW;
    [B,L] = bwboundaries(BW,'noholes');
    IMG=imread(reply,k);
    IMG=double(IMG);
    
q=0;
%DEFINE Size
%[En,Boy]=size(IMG);
    
for m=1:length(B)
c=cell2mat(B(m));

%csize=(max(c(:,1))-min(c(:,1)))*(max(c(:,2))-min(c(:,2)));

    q=q+1;
Py=uint16(mean(c(:,1)));
Px=uint16(mean(c(:,2)));


if (Px-(BigWindowSize+1)/2)<1
    Px=(BigWindowSize+1)/2;
end
if (Py-(BigWindowSize+1)/2)<1
    Py=(BigWindowSize+1)/2;
end
if (Px+(BigWindowSize+1)/2)>En1
    Px=En1-(BigWindowSize+1)/2;
end
if (Py+(BigWindowSize+1)/2)>Boy1
    Py=Boy1-(BigWindowSize+1)/2;
end

%DEFINE Window
for i=1:WindowSize
    for j=1:WindowSize
    Window(i,j)=IMG(Py-(WindowSize+1)/2+i,Px-(WindowSize+1)/2+j);
    end 
end


%DEFINE Big Window
for i=1:BigWindowSize
    for j=1:BigWindowSize
    BigWindow(i,j)=IMG(Py-(BigWindowSize+1)/2+i,Px-(BigWindowSize+1)/2+j);
    end 
end

BACKmean=[min(mean(BigWindow,1)),min(mean(BigWindow,2))];
BACK(q,k)=min(BACKmean);

%FIND Total Intensity
INT(q,k)=sum(sum(Window))-BACK(q,k)*(WindowSize)^2;

TopX=0;
TopY=0;
TopColum=0;
TopRow=0;
WSumX=0;
WSumY=0;

for j=1:WindowSize
   TopX(j)=sum(Window(:,j));
end
TopX=TopX-min(TopX);
TopRow=sum(TopX);

for j=1:WindowSize
    WSumX=WSumX+j*TopX(j);
end

for i=1:WindowSize
   TopY(i)=sum(Window(i,:));
end
TopY=TopY-min(TopY);
TopColum=sum(TopY);

for i=1:WindowSize
    WSumY=WSumY+i*TopY(i);
end

Xc(k)=WSumX/TopRow;
Yc(k)=WSumY/TopColum;

PXc=uint8(Xc(k));
PYc=uint8(Yc(k));


X(q,k)=double(Px)+Xc(k)-double((WindowSize+1)/2);
Y(q,k)=double(Py)+Yc(k)-double((WindowSize+1)/2);


Px=uint16(X(q,k));
Py=uint16(Y(q,k));

%Inten(Py,Px)=INT(k);

Wx(k)=Px;
Wy(k)=Py;
                    
    
end

end


Xilk=X;
Yilk=Y;
[Boy,Frames]=size(X);

p=0;
f=0;
for k=1:Frames-1
    for m=1:Boy
        if X(m,k)>0
        if X(m,k)<En1
            tracex=zeros(1,Frames);
            tracey=zeros(1,Frames);
            traceint=zeros(1,Frames);
            
            
        dif=Inf(Boy,Frames-k+1);   
        difbin=zeros(Boy,Frames-k+1);
        AslX=X(m,k);
        AslY=Y(m,k);
        
        for l=1:Frames-k+1
        for n=1:Boy
            dif(n,l)=sqrt((X(m,k)-X(n,k+l-1))^2+(Y(m,k)-Y(n,k+l-1))^2);
        end
        for n=1:Boy
            if sqrt((AslX-X(n,k+l-1))^2+(AslY-Y(n,k+l-1))^2)<4
                if dif(n,l)==min(dif(:,l))
                    
                    if l>5
                    if sum(sum(difbin(:,l-4:l-1))) == 0, break, end
                    end
                    
                difbin(n,l)=1;
                AslX=Xilk(n,k+l-1);
                AslY=Yilk(n,k+l-1);
                break
                end
            end
        end
        end
        
       

        for n=1:Boy
        for l=1:Frames-k+1
            if difbin(n,l)==1;
                tracex(1,k+l-1)=Xilk(n,k+l-1);
                tracey(1,k+l-1)=Yilk(n,k+l-1);
                traceint(1,k+l-1)=INT(n,k+l-1);
                X(n,k+l-1)=Inf;
                Y(n,k+l-1)=Inf;
            end
        end
        end    
        
        num=numel(find(tracex>0));
        if num>5
             pos=find(tracex>0);
             ilk=zeros(1,num+1);
             son=zeros(1,num+1);
             ilk(1:1:num)=pos(1:1:num);
             son(2:1:num+1)=pos(1:1:num);
             fark=ilk-son;
             if numel(find(fark==1))>4
            p=p+1;
            TraceX(p,:)=tracex;
            TraceY(p,:)=tracey;
            TraceINT(p,:)=traceint;
            b=find(tracex>0);                    
             end
        end
        end
        end
    end
end

[Boy2,Frames]=size(TraceX);
[Boy2,En]=size(TraceX);

limx=[1 En1];
limy=[1 Boy1];

    subplot(2,2,[1 3])
    imshow(-MEAN,[]);
    hold
colors='brgkycm';


for i=1:Boy2
j=mod(i,7);
if j==0, j=7;, end    
subplot(2,2,[1 3])
%plot(TraceX(i,find(TraceX(i,:)>0)), TraceY(i,find(TraceY(i,:)>0)),'r','Linewidth',2);
plot(TraceX(i,find(TraceX(i,:)>0)), TraceY(i,find(TraceY(i,:)>0)), colors(j), 'linewidth',2);
%set(gca,'Xlim',limx,'Ylim',limy);
xlim([1 En1]);
ylim([1 Boy1]);
hold on
end

filename=[reply, '.xls']
%NumTrace = input('How many traces do you want to analyze?     ');
NumTrace = 1000;
%[Tx,Ty] = ginput(NumTrace);
%Ty=Boy1-Ty;
%hold;
for i=1:NumTrace
[Tx,Ty] = ginput(1);
Ty=Ty;
    for m=1:Boy2
    MeanX=mean(TraceX(m,find(TraceX(m,:)>0)));
    MeanY=mean(TraceY(m,find(TraceY(m,:)>0)));
         if sqrt((MeanX-Tx)^2+(MeanY-Ty)^2)<WindowSize
             j=mod(m,7);
             if j==0, j=7;, end  
             T=find(TraceX(m,:)>0);
             TX=TraceX(m,T);
             TY=TraceY(m,T);
             TINT=TraceINT(m,T);
             subplot(2,2,2);
             plot(TX,Boy1-TY,colors(j),'LineWidth',3);
             subplot(2,2,4);
             plot(find(TraceINT(m,:)>0),TraceINT(m,TraceINT(m,:)>0),'o','LineWidth',3);
             hold;
         
           
             for n=1:Frames
                 if TraceX(m,n)==0
                     NonZero=find(TraceX(m,:)>0);

                     for j=1:numel(NonZero)
                         if abs(n-NonZero(j))==min(abs(n-NonZero))
                             Px=uint16(TraceX(m,NonZero(j)));
                             Py=uint16(TraceY(m,NonZero(j)));

                             if (Px-(BigWindowSize+1)/2)<1
                                 Px=(BigWindowSize+1)/2;
                             end
                             if (Py-(BigWindowSize+1)/2)<1
                                 Py=(BigWindowSize+1)/2;
                             end
                             if (Px+(BigWindowSize+1)/2)>En1
                                 Px=En1-(BigWindowSize+1)/2;
                             end
                             if (Py+(BigWindowSize+1)/2)>Boy1
                                 Py=Boy1-(BigWindowSize+1)/2;
                             end

                             IMG=imread(reply,n);
                             IMG=double(IMG);

                             for l=1:WindowSize
                                 for j=1:WindowSize
                                     WindowIm(l,j)=IMG(Py-(WindowSize+1)/2+l,Px-(WindowSize+1)/2+j);
                                 end
                             end

                             for l=1:BigWindowSize
                                 for j=1:BigWindowSize
                                     BigWindowIm(l,j)=IMG(Py-(BigWindowSize+1)/2+l,Px-(BigWindowSize+1)/2+j);
                                 end
                             end

                             INTIm=sum(sum(WindowIm))-min(mean(BigWindowIm))*(WindowSize)^2;
                             TraceINT(m,n)=INTIm;
                             TraceX(m,n)=NaN;
                             TraceY(m,n)=NaN;

                         end
                     end
                 end
             end
                             
             subplot(2,2,4);
             plot(TraceINT(m,:),'r','LineWidth',3);
             hold;
  
             k = menu('Do you want to keep this?','Yes','No') ;

              if k==1
                 
                  Tr=NaN(Frames,4);
                  Tr(:,1)=[1:Frames];   % Frame Num
                  Tr(:,2)=TraceX(m,:)*PixelSize;  % X
                  Tr(:,3)=TraceY(m,:)*PixelSize;  % Y
                  Tr(:,4)=TraceINT(m,:);  % INT
                  
                  index=min(find(TraceX(m,:)>0));

                  sheetname=[int2str(uint16(Tr(index,2)/PixelSize)), '-', int2str(uint16(Tr(index,3)/PixelSize))]
                  xlswrite(filename, Tr, sheetname);
              end
             
         end
    end

end