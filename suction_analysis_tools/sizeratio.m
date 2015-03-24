absa = [absizea1, absizea2, absizea3, absizea4];
absb = [absizeb1, absizeb2, absizeb3, absizeb4];
absaz = [absizea1z, absizea2z, absizea3z, absizea4z];
absbz = [absizeb1z, absizeb2z, absizeb3z, absizeb4z];
rsa = [sizea1, sizea2, sizea3, sizea4];
rsb = [sizeb1, sizeb2, sizeb3, sizeb4];
rsaz = [sizea1z, sizea2z, sizea3z, sizea4z];
rsbz = [sizeb1z, sizeb2z, sizeb3z, sizeb4z];

abr = [absa, absaz]./[absb, absbz];
r = [rsa, rsaz]./[rsb, rsbz];
ar = [absa, absaz]./[rsa, rsaz];
br = [absb, absbz]./[rsb, rsbz];

sabr = sum([absa, absaz])./sum([absb, absbz]);
sr = sum([rsa, rsaz])./sum([rsb, rsbz]);
sar = sum([absa, absaz])./sum([rsa, rsaz]);
sbr = sum([absb, absbz])./sum([rsb, rsbz]);


subplot(2,2,1)
plot(r)
refline(0,sr);
subplot(2,2,3)
plot(abr)
refline(0,sabr);
subplot(2,2,2)
plot(ar)
refline(0,sar);
subplot(2,2,4)
plot(br)
refline(0,sbr);