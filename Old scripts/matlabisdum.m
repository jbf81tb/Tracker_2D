
sames = [];
for i = 1:length(possb)
    for j = 1:length(possa)
        if abs(realspotsfirst(possb(i)).x - realspotssecond(possa(j)).x) < 2
            if abs(realspotsfirst(possb(i)).y - realspotssecond(possa(j)).y) < 2
                if abs(realspotsfirst(possb(i)).start-514 - realspotssecond(possa(j)).start) <= 2
                    if abs(realspotsfirst(possb(i)).end-514 - realspotssecond(possa(j)).end) <= 2
                        sames = [sames;possb(i), possa(j)];
                    end
                end
            end
        end
    end
end

%%
for i = 1:length(sames)
    slope(sames(i,2)) = 123456789;
end
%%
j = length(slope);
i = 0;
while i < j
    i = i+1;
    if slope(i) == 123456789;
        slope(i) = [];
        j = j-1;
        i = i-1;
    end
end
%%
cbinit = zeros(length(realspotsfirst)+length(realspotssecondtrim),1);
for i = 1:length(realspotsfirst)
    if isempty(realspotsfirst(i).start)
        continue
    end
    cbinit(i) = realspotsfirst(i).start*4;
end
for i = 1:length(realspotssecondtrim)
    if isempty(realspotssecondtrim(i).start)
        continue
    end
    cbinit(i+length(realspotsfirst)) = (realspotssecondtrim(i).start+514)*4;
end
%%
cblife = zeros(length(realspotsfirst)+length(realspotssecondtrim),1);
for i = 1:length(realspotsfirst)
    if isempty(realspotsfirst(i).start) || isempty(realspotsfirst(i).end)
        continue
    end
    cblife(i) = (realspotsfirst(i).end-realspotsfirst(i).start+1)*4;
end
for i = 1:length(realspotssecondtrim)
    if isempty(realspotssecondtrim(i).start) || isempty(realspotssecondtrim(i).end)
        continue
    end
    cblife(i+length(realspotsfirst)) = (realspotssecondtrim(i).end-realspotssecondtrim(i).start+1)*4;
end
%%
cbslope = zeros(length(realspotsfirst)+length(realspotssecondtrim),1);
for i = 1:length(slope)
    if slope(i) == 0 || isnan(slope(i))
        continue
    end
    cbslope(i) = slope(i);
end
%%
for i = 1:length(slope)
    if isnan(slope(i))
        continue
    end
    cbslope(i+2717) = slope(i);
end