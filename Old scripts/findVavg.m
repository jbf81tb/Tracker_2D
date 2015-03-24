load('traces.mat');
[Boy2,~]=size(TraceX);
for i = 1:Boy2
    T = find(TraceX(i,:));
    TX = TraceX(i,T);
    TY = s(1)-TraceY(i,T);
    TXavg(i) = mean(TX);
    TYavg(i) = mean(TY);
    for j=1:length(TX)-1
        VX(i,j) = TX(j+1)-TX(j);
        VY(i,j) = TY(j+1)-TY(j);
        V(i,j) = sqrt(VX(i,j)^2+VY(i,j)^2);
    end
    Vavg(i) = mean(V(i,:));
    Vrange(i) = max(V(i,:))-min(V(i,:));
    Vstd(i) = std(V(i,:));
end