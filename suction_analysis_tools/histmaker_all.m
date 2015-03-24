load('a1/Cell1_4s/TempTraces.mat')
real = Threshfxyc(1,4,:)==3;
inits = Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==1|Threshfxyc(1,4,:)==5;
qr = squeeze(Threshfxyc(:,1,real));
qi = squeeze(Threshfxyc(:,1,inits));
length = size(qi,1)+1;
binsize = 2*ceil(length/80);
[ya1z,xa1z] = hist(qi(1,:),binsize/2:binsize:length-binsize/2);
sizea1z = size(qr,2);
ya1z = ya1z/sizea1z;
la1z = zeros(sizea1z,2);
for i = 1:sizea1z
    la1z(i,1) = qr(1,i);
    la1z(i,2) = find(qr(:,i),1,'last') - 1;
end
mla1z = NaN(length,1);
for i=min(la1z(:,1)):max(la1z(:,1))
    dum1 = la1z(:,1) == i;
    dum2 = la1z(dum1,2);
    if isempty(dum2), dum2 = NaN; end
    mla1z(i) = mean(dum2);
end
load('a2/Cell1_4s/TempTraces.mat')
real = Threshfxyc(1,4,:)==3;
inits = Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==1|Threshfxyc(1,4,:)==5;
qr = squeeze(Threshfxyc(:,1,real));
qi = squeeze(Threshfxyc(:,1,inits));
length = size(qi,1)+1;
binsize = 2*ceil(length/80);
[ya2z,xa2z] = hist(qi(1,:),binsize/2:binsize:length-binsize/2);
sizea2z = size(qr,2);
ya2z = ya2z/sizea2z;
la2z = zeros(sizea2z,2);
for i = 1:sizea2z
    la2z(i,1) = qr(1,i);
    la2z(i,2) = find(qr(:,i),1,'last') - 1;
end
mla2z = NaN(length,1);
for i=min(la2z(:,1)):max(la2z(:,1))
    dum1 = la2z(:,1) == i;
    dum2 = la2z(dum1,2);
    if isempty(dum2), dum2 = NaN; end
    mla2z(i) = mean(dum2);
end
load('a3/Cell1_4s/TempTraces.mat')
real = Threshfxyc(1,4,:)==3;
inits = Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==1|Threshfxyc(1,4,:)==5;
qr = squeeze(Threshfxyc(:,1,real));
qi = squeeze(Threshfxyc(:,1,inits));
length = size(qi,1)+1;
binsize = 2*ceil(length/80);
[ya3z,xa3z] = hist(qi(1,:),binsize/2:binsize:length-binsize/2);
sizea3z = size(qr,2);
ya3z = ya3z/sizea3z;
la3z = zeros(sizea3z,2);
for i = 1:sizea3z
    la3z(i,1) = qr(1,i);
    la3z(i,2) = find(qr(:,i),1,'last') - 1;
end
mla3z = NaN(length,1);
for i=min(la3z(:,1)):max(la3z(:,1))
    dum1 = la3z(:,1) == i;
    dum2 = la3z(dum1,2);
    if isempty(dum2), dum2 = NaN; end
    mla3z(i) = mean(dum2);
end
load('a4/Cell1_4s/TempTraces.mat')
real = Threshfxyc(1,4,:)==3;
inits = Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==1|Threshfxyc(1,4,:)==5;
qr = squeeze(Threshfxyc(:,1,real));
qi = squeeze(Threshfxyc(:,1,inits));
length = size(qi,1)+1;
binsize = 2*ceil(length/80);
[ya4z,xa4z] = hist(qi(1,:),binsize/2:binsize:length-binsize/2);
sizea4z = size(qr,2);
ya4z = ya4z/sizea4z;
la4z = zeros(sizea4z,2);
for i = 1:sizea4z
    la4z(i,1) = qr(1,i);
    la4z(i,2) = find(qr(:,i),1,'last') - 1;
end
mla4z = NaN(length,1);
for i=min(la4z(:,1)):max(la4z(:,1))
    dum1 = la4z(:,1) == i;
    dum2 = la4z(dum1,2);
    if isempty(dum2), dum2 = NaN; end
    mla4z(i) = mean(dum2);
end
load('a001/Cell1_2s/TempTraces.mat')
real = Threshfxyc(1,4,:)==3;
inits = Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==1|Threshfxyc(1,4,:)==5;
qr = squeeze(Threshfxyc(:,1,real));
qi = squeeze(Threshfxyc(:,1,inits));
length = size(qi,1)+1;
binsize = 2*ceil(length/40);
[ya1,xa1] = hist(qi(1,:),binsize/2:binsize:length-binsize/2);
sizea1 = size(qr,2);
ya1 = ya1/sizea1;
la1 = zeros(sizea1,2);
for i = 1:sizea1
    la1(i,1) = qr(1,i);
    la1(i,2) = find(qr(:,i),1,'last') - 1;
end
mla1 = NaN(length,1);
for i=min(la1(:,1)):max(la1(:,1))
    dum1 = la1(:,1) == i;
    dum2 = la1(dum1,2);
    if isempty(dum2), dum2 = NaN; end
    mla1(i) = mean(dum2);
end
load('a002/Cell1_2s/TempTraces.mat')
real = Threshfxyc(1,4,:)==3;
inits = Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==1|Threshfxyc(1,4,:)==5;
qr = squeeze(Threshfxyc(:,1,real));
qi = squeeze(Threshfxyc(:,1,inits));
length = size(qi,1)+1;
binsize = 2*ceil(length/40);
[ya2,xa2] = hist(qi(1,:),binsize/2:binsize:length-binsize/2);
sizea2 = size(qr,2);
ya2 = ya2/sizea2;
la2 = zeros(sizea2,2);
for i = 1:sizea2
    la2(i,1) = qr(1,i);
    la2(i,2) = find(qr(:,i),1,'last') - 1;
end
mla2 = NaN(length,1);
for i=min(la2(:,1)):max(la2(:,1))
    dum1 = la2(:,1) == i;
    dum2 = la2(dum1,2);
    if isempty(dum2), dum2 = NaN; end
    mla2(i) = mean(dum2);
end
load('a003/Cell1_2s/TempTraces.mat')
real = Threshfxyc(1,4,:)==3;
inits = Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==1|Threshfxyc(1,4,:)==5;
qr = squeeze(Threshfxyc(:,1,real));
qi = squeeze(Threshfxyc(:,1,inits));
length = size(qi,1)+1;
binsize = 2*ceil(length/40);
[ya3,xa3] = hist(qi(1,:),binsize/2:binsize:length-binsize/2);
sizea3 = size(qr,2);
ya3 = ya3/sizea3;
la3 = zeros(sizea3,2);
for i = 1:sizea3
    la3(i,1) = qr(1,i);
    la3(i,2) = find(qr(:,i),1,'last') - 1;
end
mla3 = NaN(length,1);
for i=min(la3(:,1)):max(la3(:,1))
    dum1 = la3(:,1) == i;
    dum2 = la3(dum1,2);
    if isempty(dum2), dum2 = NaN; end
    mla3(i) = mean(dum2);
end
load('a004/Cell1_2s/TempTraces.mat')
real = Threshfxyc(1,4,:)==3;
inits = Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==1|Threshfxyc(1,4,:)==5;
qr = squeeze(Threshfxyc(:,1,real));
qi = squeeze(Threshfxyc(:,1,inits));
length = size(qi,1)+1;
binsize = 2*ceil(length/40);
[ya4,xa4] = hist(qi(1,:),binsize/2:binsize:length-binsize/2);
sizea4 = size(qr,2);
ya4 = ya4/sizea4;
la4 = zeros(sizea4,2);
for i = 1:sizea4
    la4(i,1) = qr(1,i);
    la4(i,2) = find(qr(:,i),1,'last') - 1;
end
mla4 = NaN(length,1);
for i=min(la4(:,1)):max(la4(:,1))
    dum1 = la4(:,1) == i;
    dum2 = la4(dum1,2);
    if isempty(dum2), dum2 = NaN; end
    mla4(i) = mean(dum2);
end
load('b1/Cell1_4s/TempTraces.mat')
real = Threshfxyc(1,4,:)==3;
inits = Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==1|Threshfxyc(1,4,:)==5;
qr = squeeze(Threshfxyc(:,1,real));
qi = squeeze(Threshfxyc(:,1,inits));
length = size(qi,1)+1;
binsize = 2*ceil(length/80);
[yb1z,xb1z] = hist(qi(1,:),binsize/2:binsize:length-binsize/2);
sizeb1z = size(qr,2);
yb1z = yb1z/sizeb1z;
lb1z = zeros(sizeb1z,2);
for i = 1:sizeb1z
    lb1z(i,1) = qr(1,i);
    lb1z(i,2) = find(qr(:,i),1,'last') - 1;
end
mlb1z = NaN(length,1);
for i=min(lb1z(:,1)):max(lb1z(:,1))
    dum1 = lb1z(:,1) == i;
    dum2 = lb1z(dum1,2);
    if isempty(dum2), dum2 = NaN; end
    mlb1z(i) = mean(dum2);
end
load('b2/Cell1_4s/TempTraces.mat')
real = Threshfxyc(1,4,:)==3;
inits = Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==1|Threshfxyc(1,4,:)==5;
qr = squeeze(Threshfxyc(:,1,real));
qi = squeeze(Threshfxyc(:,1,inits));
length = size(qi,1)+1;
binsize = 2*ceil(length/80);
[yb2z,xb2z] = hist(qi(1,:),binsize/2:binsize:length-binsize/2);
sizeb2z = size(qr,2);
yb2z = yb2z/sizeb2z;
lb2z = zeros(sizeb2z,2);
for i = 1:sizeb2z
    lb2z(i,1) = qr(1,i);
    lb2z(i,2) = find(qr(:,i),1,'last') - 1;
end
mlb2z = NaN(length,1);
for i=min(lb2z(:,1)):max(lb2z(:,1))
    dum1 = lb2z(:,1) == i;
    dum2 = lb2z(dum1,2);
    if isempty(dum2), dum2 = NaN; end
    mlb2z(i) = mean(dum2);
end
load('b3/Cell1_4s/TempTraces.mat')
real = Threshfxyc(1,4,:)==3;
inits = Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==1|Threshfxyc(1,4,:)==5;
qr = squeeze(Threshfxyc(:,1,real));
qi = squeeze(Threshfxyc(:,1,inits));
length = size(qi,1)+1;
binsize = 2*ceil(length/80);
[yb3z,xb3z] = hist(qi(1,:),binsize/2:binsize:length-binsize/2);
sizeb3z = size(qr,2);
yb3z = yb3z/sizeb3z;
lb3z = zeros(sizeb3z,2);
for i = 1:sizeb3z
    lb3z(i,1) = qr(1,i);
    lb3z(i,2) = find(qr(:,i),1,'last') - 1;
end
mlb3z = NaN(length,1);
for i=min(lb3z(:,1)):max(lb3z(:,1))
    dum1 = lb3z(:,1) == i;
    dum2 = lb3z(dum1,2);
    if isempty(dum2), dum2 = NaN; end
    mlb3z(i) = mean(dum2);
end
load('b4/Cell1_4s/TempTraces.mat')
real = Threshfxyc(1,4,:)==3;
inits = Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==1|Threshfxyc(1,4,:)==5;
qr = squeeze(Threshfxyc(:,1,real));
qi = squeeze(Threshfxyc(:,1,inits));
length = size(qi,1)+1;
binsize = 2*ceil(length/80);
[yb4z,xb4z] = hist(qi(1,:),binsize/2:binsize:length-binsize/2);
sizeb4z = size(qr,2);
yb4z = yb4z/sizeb4z;
lb4z = zeros(sizeb4z,2);
for i = 1:sizeb4z
    lb4z(i,1) = qr(1,i);
    lb4z(i,2) = find(qr(:,i),1,'last') - 1;
end
mlb4z = NaN(length,1);
for i=min(lb4z(:,1)):max(lb4z(:,1))
    dum1 = lb4z(:,1) == i;
    dum2 = lb4z(dum1,2);
    if isempty(dum2), dum2 = NaN; end
    mlb4z(i) = mean(dum2);
end
load('b001/Cell1_2s/TempTraces.mat')
real = Threshfxyc(1,4,:)==3;
inits = Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==1|Threshfxyc(1,4,:)==5;
qr = squeeze(Threshfxyc(:,1,real));
qi = squeeze(Threshfxyc(:,1,inits));
length = size(qi,1)+1;
binsize = 2*ceil(length/40);
[yb1,xb1] = hist(qi(1,:),binsize/2:binsize:length-binsize/2);
sizeb1 = size(qr,2);
yb1 = yb1/sizeb1;
lb1 = zeros(sizeb1,2);
for i = 1:sizeb1
    lb1(i,1) = qr(1,i);
    lb1(i,2) = find(qr(:,i),1,'last') - 1;
end
mlb1 = NaN(length,1);
for i=min(lb1(:,1)):max(lb1(:,1))
    dum1 = lb1(:,1) == i;
    dum2 = lb1(dum1,2);
    if isempty(dum2), dum2 = NaN; end
    mlb1(i) = mean(dum2);
end
load('b002/Cell1_2s/TempTraces.mat')
real = Threshfxyc(1,4,:)==3;
inits = Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==1|Threshfxyc(1,4,:)==5;
qr = squeeze(Threshfxyc(:,1,real));
qi = squeeze(Threshfxyc(:,1,inits));
length = size(qi,1)+1;
binsize = 2*ceil(length/40);
[yb2,xb2] = hist(qi(1,:),binsize/2:binsize:length-binsize/2);
sizeb2 = size(qr,2);
yb2 = yb2/sizeb2;
lb2 = zeros(sizeb2,2);
for i = 1:sizeb2
    lb2(i,1) = qr(1,i);
    lb2(i,2) = find(qr(:,i),1,'last') - 1;
end
mlb2 = NaN(length,1);
for i=min(lb2(:,1)):max(lb2(:,1))
    dum1 = lb2(:,1) == i;
    dum2 = lb2(dum1,2);
    if isempty(dum2), dum2 = NaN; end
    mlb2(i) = mean(dum2);
end
load('b003/Cell1_2s/TempTraces.mat')
real = Threshfxyc(1,4,:)==3;
inits = Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==1|Threshfxyc(1,4,:)==5;
qr = squeeze(Threshfxyc(:,1,real));
qi = squeeze(Threshfxyc(:,1,inits));
length = size(qi,1)+1;
binsize = 2*ceil(length/40);
[yb3,xb3] = hist(qi(1,:),binsize/2:binsize:length-binsize/2);
sizeb3 = size(qr,2);
yb3 = yb3/sizeb3;
lb3 = zeros(sizeb3,2);
for i = 1:sizeb3
    lb3(i,1) = qr(1,i);
    lb3(i,2) = find(qr(:,i),1,'last') - 1;
end
mlb3 = NaN(length,1);
for i=min(lb3(:,1)):max(lb3(:,1))
    dum1 = lb3(:,1) == i;
    dum2 = lb3(dum1,2);
    if isempty(dum2), dum2 = NaN; end
    mlb3(i) = mean(dum2);
end
load('b004/Cell1_2s/TempTraces.mat')
real = Threshfxyc(1,4,:)==3;
inits = Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==1|Threshfxyc(1,4,:)==5;
qr = squeeze(Threshfxyc(:,1,real));
qi = squeeze(Threshfxyc(:,1,inits));
length = size(qi,1)+1;
binsize = 2*ceil(length/40);
[yb4,xb4] = hist(qi(1,:),binsize/2:binsize:length-binsize/2);
sizeb4 = size(qr,2);
yb4 = yb4/sizeb4;
lb4 = zeros(sizeb4,2);
for i = 1:sizeb4
    lb4(i,1) = qr(1,i);
    lb4(i,2) = find(qr(:,i),1,'last') - 1;
end
mlb4 = NaN(length,1);
for i=min(lb4(:,1)):max(lb4(:,1))
    dum1 = lb4(:,1) == i;
    dum2 = lb4(dum1,2);
    if isempty(dum2), dum2 = NaN; end
    mlb4(i) = mean(dum2);
end